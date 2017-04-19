#!/bin/bash

DYNHOST=$1
DYNHOST=${DYNHOST:0:28}
DYNIP=$(host $DYNHOST | grep -iE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" |cut -f4 -d' '|head -n 1)

# Exit if invalid IP address is returned
case $DYNIP in
  0.0.0.0 )
    exit 1 ;;
  255.255.255.255 )
    exit 1 ;;
esac

# Exit if IP address not in proper format
if ! [[ $DYNIP =~ (([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]) ]]; then
  exit 1
fi

# If chain for remote doesn't exist, create it
if ! /sbin/iptables -L $DYNHOST -n >/dev/null 2>&1 ; then
  /sbin/iptables -N $DYNHOST >/dev/null 2>&1
fi

# Check IP address to see if the chain matches first; skip rest of script if update is not needed
if ! /sbin/iptables -n -L $DYNHOST | grep -iE " $DYNIP " >/dev/null 2>&1 ; then

  # Flush old rules, and add new
  /sbin/iptables -F $DYNHOST >/dev/null 2>&1
  /sbin/iptables -I $DYNHOST -s $DYNIP -j ACCEPT

  # Add chain to INPUT filter if it doesn't exist
  if ! /sbin/iptables -C INPUT -t filter -j $DYNHOST >/dev/null 2>&1 ; then
    /sbin/iptables -t filter -I INPUT -j $DYNHOST
  fi

fi
