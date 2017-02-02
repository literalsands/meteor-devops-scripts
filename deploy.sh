#!/bin/bash
# Make sure the remote folder is ready.
# {} weren't were being escaped so I made this straight forward.
ssh $REMOTE "mkdir -p ~/bundles && mkdir -p ~/bundles/$DEPLOY"
# Send zipped file over.
rsync $HOME/.bundles/$APP-$DEPLOY.tar.gz $REMOTE:~/bundles/$DEPLOY.tar.gz
# Unzip and build the bundle.
ssh $REMOTE "tar -xzf ~/bundles/$DEPLOY.tar.gz -C ~/bundles/$DEPLOY && rm -f ~/bundle && ln -s ~/bundles/$DEPLOY/bundle ~ && cd ~/bundle/programs/server && npm install fibers && npm install"
