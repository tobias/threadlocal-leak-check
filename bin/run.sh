#!/bin/bash

TOMCAT_URL="http://www.eng.lsu.edu/mirrors/apache/tomcat/tomcat-7/v7.0.41/bin/apache-tomcat-7.0.41.zip"

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
TARGET_DIR="$BASE_DIR/target"
DEPLOY_DIR="$TARGET_DIR/tomcat/webapps"

if [ ! -d "$TARGET_DIR/tomcat" ]; then
    mkdir -p $TARGET_DIR
    cd $TARGET_DIR

    wget $TOMCAT_URL
    unzip apache-tomcat-*.zip
    ln -s apache-tomcat-7.0.41 tomcat
    chmod +x tomcat/bin/*.sh
    rm -rf tomcat/webapps/*
    cd -
fi

startup() {
    echo "Starting tomcat"
    export CATALINA_OPTS="-XX:MaxPermSize=40m"
    $TARGET_DIR/tomcat/bin/startup.sh
}

shutdown() {
    echo "Shutting down tomcat"
    $TARGET_DIR/tomcat/bin/shutdown.sh
    exit 1
}

trap shutdown SIGINT
startup

cd $BASE_DIR
rm -rf $DEPLOY_DIR/*
rm -rf $TARGET_DIR/classes
if [ -z "$1" ]; then
    lein ring uberwar leak.war
    WAR_PATH="$TARGET_DIR/leak.war"
else
    lein with-profile $1 ring uberwar leak.war
    WAR_PATH="$TARGET_DIR/leak.war"
fi

i=1
while true; do
  echo
  echo "Deployment count: $i"
  echo
  i=$[$i+1]
  cp $WAR_PATH $DEPLOY_DIR
  sleep 10
  curl http://localhost:8080/leak
  rm -f $DEPLOY_DIR/leak.war
  sleep 10
done

