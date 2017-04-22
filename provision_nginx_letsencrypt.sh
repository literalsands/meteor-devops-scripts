#!/bin/bash

# Remove default server if applicable.
rm -f /etc/nginx/sites-enabled/default
# Deploy location .well-known script.
ln -sf /etc/nginx/sites-available/letsencrypt /etc/nginx/sites-enabled/
# Check nginx configuration and restart the server.
nginx -t && systemctl restart nginx
# Run letsencrypt with email address and accept license.
echo " letsencrypt certonly -a webroot --webroot-path=/var/www/html/ -d $DOMAIN -d www.$DOMAIN --agree-tos --email $EMAIL "
letsencrypt certonly -a webroot --webroot-path=/var/www/html/ -d $DOMAIN -d www.$DOMAIN --agree-tos --email $EMAIL

# Create dhparam if it doesn't alrady exist.
if ! [ -f /etc/ssl/certs/dhparam.pem ]; then
  sudo -S openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
fi

# Create a configuration snippet for the website name.
if ! [ -f /etc/nginx/snippets/ssl-$DOMAIN.conf ]; then
  SSL_SNIPPET = "
ssl on;
ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
"
  echo $SSL_SNIPPET > /etc/nginx/snippets/ssl-$DOMAIN.conf
  # Restart the nginx server.
  nginx -t && systemctl restart nginx
fi

