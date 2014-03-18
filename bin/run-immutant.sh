#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
echo "basedir: $BASE_DIR"
DEPLOY_DIR=`lein immutant env jboss-home`/standalone/deployments

startup() {
    echo "Starting Immutant"
    `lein immutant run`
}

#startup

cd $BASE_DIR
lein immutant undeploy \*

i=1
while true; do
  echo
  echo "Deployment count: $i"
  echo
  i=$[$i+1]
  lein with-profile rc1 immutant deploy
  sleep 10
  curl http://localhost:8080/leak
  lein immutant undeploy \*
  sleep 10
done

