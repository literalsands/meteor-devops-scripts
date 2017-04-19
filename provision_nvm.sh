#!/bin/bash
# Install NVM
NVM_VERSION=0.33.1
NODE_VERSION=6.10.2
NVM_DIR=/usr/local/nvm
touch $HOME/.profile
curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash
npm install pm2
