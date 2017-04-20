#!/bin/bash

# Make a new user and group, node.
getent group node || groupadd node
id -u node &>/dev/null || useradd node -g node -r

# Own node application folder.
mkdir -p /var/opt/node
chown -R node:node /var/opt/node
chmod -R 775 /var/opt/

# Own global NPM modules.
mkdir -p /usr/local/lib/node_modules
chown -R node:node /usr/local/lib/node_modules
chmod -R 775 /usr/local/lib/node_modules

# Own NVM folder.
mkdir -p /usr/local/nvm
chown -R node:node /usr/local/nvm
chmod -R 775 /usr/local/nvm
