#!/bin/bash
ssh $USER@$REMOTE "source $HOME/server.env && pm2 reload $HOME/bundle/main.js"
