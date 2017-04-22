#!/bin/bash

# Check that nginx, letsencrypt, and openssl are installed and up to date.
apt -y --force-yes update
apt -y --force-yes upgrade
apt -y --force-yes install nginx letsencrypt openssl
