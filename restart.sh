#!/bin/bash
ssh $REMOTE "source $HOME/server.env && pm2 reload $HOME/bundle/main.js"
