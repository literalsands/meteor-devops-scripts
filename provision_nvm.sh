#!/bin/bash
# Install NVM
export NVM_VERSION=0.33.1
export NODE_VERSION=6.10
export NVM_DIR="/usr/local/nvm"
touch $HOME/.profile
curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash
#NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install $NODE_VERSION
npm install pm2
