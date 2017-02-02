#!/bin/bash

# Create a user.
# Ask to create a password for that user.
# Copy authorized keys in root user to new user.
stty -echo; ssh root@$REMOTE "\
  useradd -G sudo -m -d $HOME $USER &&\
  passwd $USER &&\
  rsync --chown=$USER:$USER .ssh $HOME"
