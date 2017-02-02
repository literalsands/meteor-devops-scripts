#!/bin/bash
cd $HOME/space/$APP
export CUR_DEPLOY=$(git rev-parse --verify HEAD)
mkdir -p $HOME/.bundles
export DEPLOY_DIR=$HOME/.bundles/$APP-$CUR_DEPLOY
export BUILD_OUTPUT_FILE=$HOME/.meteor_build_output.txt
[ -f $DEPLOY_DIR.tar.gz ] ||\
  meteor build --directory $DEPLOY_DIR > $BUILD_OUTPUT_FILE &&\
  tar -czf $DEPLOY_DIR.tar.gz -C $DEPLOY_DIR bundle &&\
  rm -rf $DEPLOY_DIR
echo $CUR_DEPLOY
