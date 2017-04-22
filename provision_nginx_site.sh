#!/bin/bash

#if ! [ -f /etc/nginx/sites-enabled/$DOMAIN ]; then
  # Replace example.com with 
  sed "s/example.com/$DOMAIN/;s/appservers/$APP/" /etc/nginx/sites-available/example.com > /etc/nginx/sites-available/$DOMAIN
  rm -f /etc/nginx/sites-enabled/$DOMAIN
  ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled
  nginx -t && systemctl restart nginx
#fi

