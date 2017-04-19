#!/bin/bash
# Send zipped file over.
rsync $HOME/.bundles/$APP-$DEPLOY.tar.gz $REMOTE_USER@$REMOTE:~/bundles/$APP-$DEPLOY.tar.gz
# Unzip and build the bundle.
ssh $REMOTE_USER@$REMOTE "\
  rm -rf /var/opt/node/$APP &&\
  mkdir -p /var/opt/node/$APP &&\
  tar -xzf ~/bundles/$APP-$DEPLOY.tar.gz -C /var/opt/node/$APP"
