#!/bin/bash

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

SHORT=pf:a:e:
LONG=sudo,file:,options:,environment:

# -temporarily store output to be able to check for errors
# -activate advanced mode getopt quoting e.g. via “--options”
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    echo "Bad arguments"
    exit 2
fi
# use eval with "$PARSED" to properly handle the quoting
eval set -- "$PARSED"

#echo $f
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -e|--environment)
            e=$2
            shift 2
            ;;
        -p|--sudo)
            p=1
            shift
            ;;
        -f|--file)
            f=$2
            shift 2
            ;;
        -a|--options)
            a=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [ $# -lt 1 ]; then
    echo "$0: A remote host is required."
    exit 4
fi

while [ $# -gt 0 ]; do
  echo "$1:$([ "${p:-0}" -eq 1 ] && echo " sudo") $f $a $e"
  COMMAND=$(base64 -w0 $f)
  if [ "${p:-0}" -eq 1 ]; then
    stty -echo; ssh -t $1 "(export $e > /dev/null; echo $COMMAND | base64 -d | sudo -E bash -s \"$a\")"
  else
    ssh $1 "(export $e > /dev/null; echo $COMMAND | base64 -d | bash -s \"$a\")"
  fi
  shift
done
