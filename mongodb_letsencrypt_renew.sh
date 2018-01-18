#!/bin/bash

# Run the letsencrypt renewal process.
/opt/letsencrypt/letsencrypt-auto certonly --standalone --agree-tos -m $EMAIL -d $(hostname) -n
# Create the key.
cd /etc/letsencrypt/live/$(hostname)
cat privkey.pem cert.pem > /etc/ssl/mongodb.pem
# Set key permissions.
chmod 600 /etc/ssl/mongodb.pem
chown -R mongodb:mongodb /etc/ssl/mongodb.pem
# Restart mongodb server and print status.
systemctl restart mongod
systemctl status mongod

