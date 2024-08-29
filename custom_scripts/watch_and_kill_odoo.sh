#!/bin/bash

# Path to the Odoo log file
LOG_FILE="odoo.log"

# Ensure Odoo is not already running on port 8069
PORT_IN_USE=$(lsof -i :8069 -sTCP:LISTEN -t)

if [ -n "$PORT_IN_USE" ]; then
    # Check if the process using the port is an Odoo instance
    PROCESS_NAME=$(ps -p $PORT_IN_USE -o comm=)

    if [[ "$PROCESS_NAME" == "odoo-bin" || "$PROCESS_NAME" == "python" || "$PROCESS_NAME" == "python3" ]]; then
        echo "Port 8069 is in use by an Odoo process (PID: $PORT_IN_USE). Killing the process..."
        kill -SIGTERM $PORT_IN_USE
        sleep 5  # Wait for the process to terminate
        if ps -p $PORT_IN_USE > /dev/null; then
            echo "Process did not terminate. Force killing..."
            kill -SIGKILL $PORT_IN_USE
        fi
        echo "Process $PORT_IN_USE killed."
    else
        echo "Port 8069 is in use by another process ($PROCESS_NAME with PID: $PORT_IN_USE). Not killing the process."
        exit 1
    fi
fi

# Function to handle SIGINT (Ctrl+C)
function handle_sigint() {
    if [ -n "$ODOO_PID" ]; then
        echo "SIGINT received. Attempting to gracefully shut down Odoo (PID: $ODOO_PID)..."
        kill -SIGTERM $ODOO_PID

        # Wait for the Odoo process to terminate
        sleep 1

        # Check if Odoo is still running
        if ps -p $ODOO_PID > /dev/null; then
            echo "Odoo did not terminate gracefully. Forcefully terminating..."
            kill -SIGKILL $ODOO_PID
        fi
        echo "Odoo process terminated."
    else
        echo "Odoo process not running."
    fi
    exit 0
}

# Trap SIGINT (Ctrl+C)
trap handle_sigint SIGINT

# Start Odoo and capture its PID
./odoo-bin --addons-path="addons/, tutorials/" -d rd-demo -u real_estate,real_estate_account --dev=real_estate,real_estate_account --update=real_estate,real_estate_account --dev xml --log-level="debug" --config=./debian/odoo.conf > "$LOG_FILE" 2>&1 &
ODOO_PID=$!

# Tail the log file and output it to the terminal using -F
# Start the tail process in the background
tail -F "$LOG_FILE" & TAIL_PID=$!

# Wait for the Odoo process to terminate
wait $ODOO_PID

# Kill the tail process
kill $TAIL_PID

# Cleanup
echo "Cleaning up..."
