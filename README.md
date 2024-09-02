# Custom Odoo Installation
## Pre-requisites
- PostgreSQL
- Python 3
- logrotate (optional)

Follow the instructions in the [official documentation](https://www.odoo.com/documentation/17.0/administration/install/install.html) to install the required dependencies.

## Installation
1. Clone the repository recursively:
```bash
git clone https://github.com/He-Is-HaZaRdOuS/odoo.git --recurse-submodules
```
2. Run the following commands:
```bash
cd odoo
./odoo-bin --addons-path="addons/, tutorials/" -d rd-demo --config=./debian/odoo.conf -s
```

## Usage
1. Start the Odoo server:
```bash
./odoo-bin --addons-path="addons/, tutorials/" -d rd-demo --config=./debian/odoo.conf
```
2. Open the browser and navigate to `http://localhost:8069`
3. Log in using admin as username and password
4. Start using Odoo
5. Optionally install Real Estate and Real Estate Account modules

## Log Files
To keep the log files in the default location, create the log file manually:
```bash
touch /var/log/odoo/odoo.log
```
And update the `logfile` parameter in `/debian/odoo.conf` file to `/var/log/odoo/odoo.log`.
If you want to change the log file location, edit the `logfile` parameter in `/debian/odoo.conf` and create the log file manually in the new location.
If you want to set up log rotation using logrotate, create a new configuration file in `/etc/logrotate.d/odoo` with the content from /custom_logrotate/logrotate.template:
```bash
sudo nano /etc/logrotate.d/odoo
```
Make sure to update USER_PLACEHOLDER and GROUP_PLACEHOLDER in the file with the appropriate values so that the odoo server can access the log file.

## Development
You may use the `/tutorials` directory to store your custom modules. The `/addons` directory is reserved for the official Odoo modules.
You may also use the scripts inside the `/custom_scripts` directory to manage git submodules and launching the odoo server.
If you decide to use the `watch_and_kill_odoo.sh` script, make sure to temporarily remove the `logfile` parameter from the `/debian/odoo.conf` file, so that you can view the logs in your terminal directly.

# Original README.md

[![Build Status](https://runbot.odoo.com/runbot/badge/flat/1/master.svg)](https://runbot.odoo.com/runbot)
[![Tech Doc](https://img.shields.io/badge/master-docs-875A7B.svg?style=flat&colorA=8F8F8F)](https://www.odoo.com/documentation/17.0)
[![Help](https://img.shields.io/badge/master-help-875A7B.svg?style=flat&colorA=8F8F8F)](https://www.odoo.com/forum/help-1)
[![Nightly Builds](https://img.shields.io/badge/master-nightly-875A7B.svg?style=flat&colorA=8F8F8F)](https://nightly.odoo.com/)

Odoo
----

Odoo is a suite of web based open source business apps.

The main Odoo Apps include an <a href="https://www.odoo.com/page/crm">Open Source CRM</a>,
<a href="https://www.odoo.com/app/website">Website Builder</a>,
<a href="https://www.odoo.com/app/ecommerce">eCommerce</a>,
<a href="https://www.odoo.com/app/inventory">Warehouse Management</a>,
<a href="https://www.odoo.com/app/project">Project Management</a>,
<a href="https://www.odoo.com/app/accounting">Billing &amp; Accounting</a>,
<a href="https://www.odoo.com/app/point-of-sale-shop">Point of Sale</a>,
<a href="https://www.odoo.com/app/employees">Human Resources</a>,
<a href="https://www.odoo.com/app/social-marketing">Marketing</a>,
<a href="https://www.odoo.com/app/manufacturing">Manufacturing</a>,
<a href="https://www.odoo.com/">...</a>

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get
a full-featured <a href="https://www.odoo.com">Open Source ERP</a> when you install several Apps.

Getting started with Odoo
-------------------------

For a standard installation please follow the <a href="https://www.odoo.com/documentation/17.0/administration/install/install.html">Setup instructions</a>
from the documentation.

To learn the software, we recommend the <a href="https://www.odoo.com/slides">Odoo eLearning</a>, or <a href="https://www.odoo.com/page/scale-up-business-game">Scale-up</a>, the <a href="https://www.odoo.com/page/scale-up-business-game">business game</a>. Developers can start with <a href="https://www.odoo.com/documentation/17.0/developer/howtos.html">the developer tutorials</a>
