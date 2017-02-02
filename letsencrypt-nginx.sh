#!/bin/bash

# Check that nginx, letsencrypt, and openssl are installed and up to date.
stty -echo; ssh $REMOTE "sudo -S sh -c \"\
  apt -y --force-yes update &&\
  apt -y --force-yes upgrade &&\
  apt -y --force-yes install nginx letsencrypt openssl\
  \""

# Copy over all the nginx scripts.
ssh $REMOTE "mkdir -p $HOME/nginx"
rsync -au /etc/nginx/snippets/ $REMOTE:$HOME/nginx/snippets &&\
  rsync -au /etc/nginx/sites-available/ $REMOTE:$HOME/nginx/sites-available &&\
  stty -echo; ssh $REMOTE "\
    sudo -S sh -c \"\
    ln -sf $HOME/nginx/snippets/ssl-params.conf /etc/nginx/snippets/ &&\
    ln -sf $HOME/nginx/snippets/gzip.conf /etc/nginx/snippets/ &&\
    ln -sf $HOME/nginx/sites-available/letsencrypt /etc/nginx/sites-available/ &&\
    ln -sf $HOME/nginx/sites-available/example.com /etc/nginx/sites-available/\""

# Copy over letsencrypt certificates if they've already been created.

# Deploy location .well-known script.
# Remove default server if applicable.
# Check nginx configuration and restart the server.
# Run letsencrypt with email address and accept license.
stty -echo; ssh $REMOTE "\
  sudo -S sh -c \"ln -sf /etc/nginx/sites-available/letsencrypt /etc/nginx/sites-enabled/ &&\
  rm -f /etc/nginx/sites-enabled/default &&\
  nginx -t && sudo systemctl restart nginx &&\
  letsencrypt certonly -a webroot --webroot-path=/var/www/html/ -d $REMOTE --agree-tos --agree-dev-preview --email $EMAIL\""

# Let's copy the certificates to the local machine to install across multiple servers.

# Create dhparam if it doesn't alrady exist.
stty -echo; ssh $REMOTE "[ -f /etc/ssl/certs/dhparam.pem ] ||\
  sudo -S openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048"

# Create a configuration snippet for the website name.
# Copy the websites configuration over.
stty -echo; ssh $REMOTE "[ -f /etc/nginx/snippets/ssl-$REMOTE.conf ] ||\
  sudo -S sh -c \"sed 's/example.com/$REMOTE/;s/appservers/$APP/' /etc/nginx/sites-available/example.com > /etc/nginx/sites-available/$REMOTE &&\
  ln -sf /etc/nginx/sites-available/$REMOTE /etc/nginx/sites-enabled &&\
  echo '
ssl on;
ssl_certificate /etc/letsencrypt/live/$REMOTE/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/$REMOTE/privkey.pem;
' > /etc/nginx/snippets/ssl-$REMOTE.conf\""

# Restart the nginx server.
stty -echo; ssh $REMOTE "sudo -S nginx -t && sudo systemctl restart nginx"
