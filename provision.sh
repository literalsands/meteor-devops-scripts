#!/bin/bash

# Install Node, Git, and an Editor (VIM).
# Install NPM (nosudo) and required global packages.
# Install Node Version 4.4 (or required)
stty -echo; ssh $USER@$REMOTE "sudo -S sh -c \"\
  apt -y --force-yes update &&\
  apt -y --force-yes upgrade &&\
  apt -y --force-yes install vim npm nodejs nodejs-legacy git &&\
  npm install -g pm2 n &&\
  n 4.* && n 6.* && n 0.10 && n 0.12\""

# Setup public key only login?
# Setup firewall?
# Setup users for things?
