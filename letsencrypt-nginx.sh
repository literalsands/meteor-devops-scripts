#!/bin/bash

# Check that nginx, letsencrypt, and openssl are installed and up to date.
rsync -au /etc/nginx/snippets/ $REMOTE:/etc/nginx/
rsync -au /etc/nginx/sites-available/ $REMOTE:/etc/nginx/
./remote.sh $REMOTE -f provision_nginx.sh
# Copy over letsencrypt certificates if they've already been created.
# Else run letsencrypt.
./remote.sh $REMOTE -f provision_nginx_letsencrypt.sh -e "DOMAIN=$DOMAIN EMAIL=$EMAIL"
./remote.sh $REMOTE -f provision_nginx_site.sh -e "DOMAIN=$DOMAIN APP=$DOMAIN"
./remote.sh $REMOTE -f provision_nginx_ufw.sh

