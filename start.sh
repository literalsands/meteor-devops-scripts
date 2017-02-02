source $HOME/server.env
pm2 stop $HOME/bundle/main.js
pm2 start $HOME/bundle/main.js
