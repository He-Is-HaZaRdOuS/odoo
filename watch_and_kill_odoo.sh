#!/bin/bash

# Ensure 'unbuffer' is installed
if ! command -v unbuffer &> /dev/null; then
    echo "'unbuffer' could not be found. Please install the 'expect' package to use unbuffer."
    exit 1
fi

# Variables to track SIGINT handling
SIGINT_RECEIVED=false
FORCE_TERMINATE=false

# Function to handle SIGINT (Ctrl+C)
function handle_sigint() {
    if [ "$SIGINT_RECEIVED" = false ]; then
        SIGINT_RECEIVED=true
        echo "SIGINT received. Attempting to gracefully shut down Odoo (PID: $ODOO_PID)..."
        kill -SIGINT $ODOO_PID

        # Wait for up to 10 seconds for Odoo to shut down gracefully
        for i in {1..10}; do
            if ! ps -p $ODOO_PID > /dev/null; then
                echo "Odoo process terminated gracefully."
                exit 0
            fi
            sleep 1
        done

        echo "Odoo did not shut down gracefully."
        echo "Press Ctrl+C again within 10 seconds to forcefully terminate, or wait for automatic termination."

        # Wait for user to press Ctrl+C again or timeout after 10 seconds
        read -t 10 -n 1
        if [ $? -eq 0 ]; then
            echo "Force termination requested. Killing Odoo process (PID: $ODOO_PID)..."
            kill -9 $ODOO_PID
            echo "Odoo process forcefully terminated."
            exit 1
        else
            echo "Automatic termination in progress..."
            kill -9 $ODOO_PID
            echo "Odoo process forcefully terminated."
            exit 1
        fi
    elif [ "$FORCE_TERMINATE" = false ]; then
        FORCE_TERMINATE=true
        echo "Force termination requested. Killing Odoo process (PID: $ODOO_PID)..."
        kill -9 $ODOO_PID
        echo "Odoo process forcefully terminated."
        exit 1
    fi
}

# Trap SIGINT (Ctrl+C) to allow graceful shutdown
trap handle_sigint SIGINT

# Check if port 8069 is already in use
PORT_IN_USE=$(lsof -i :8069 -sTCP:LISTEN -t)

if [ -n "$PORT_IN_USE" ]; then
    # Check if the process using the port is an Odoo instance
    PROCESS_NAME=$(ps -p $PORT_IN_USE -o comm=)

    if [[ "$PROCESS_NAME" == "odoo-bin" || "$PROCESS_NAME" == "python" || "$PROCESS_NAME" == "python3" ]]; then
        echo "Port 8069 is in use by an Odoo process (PID: $PORT_IN_USE). Killing the process..."
        kill -9 $PORT_IN_USE
        echo "Process $PORT_IN_USE killed."
    else
        echo "Port 8069 is in use by another process ($PROCESS_NAME with PID: $PORT_IN_USE). Not killing the process."
        exit 1
    fi
fi

# Start Odoo in the background and capture its PID
unbuffer ./odoo-bin --addons-path="addons/, tutorials/" -d rd-demo -u real_estate,real_estate_account --dev=real_estate,real_estate_account --update=real_estate,real_estate_account --dev xml > odoo.log 2>&1 &
ODOO_PID=$!

echo "Odoo started with PID: $ODOO_PID"

# Use tail to display logs in real-time
unbuffer tail -f odoo.log | tee /dev/tty | while read LINE
do
    # Check if the specific error message is present in the logs
    echo "$LINE" | grep -q "Port 8069 is in use by another program"
    if [ $? -eq 0 ]; then
        echo "Port 8069 is already in use! Terminating Odoo process..."
        kill $ODOO_PID
        exit 1
    fi
done
