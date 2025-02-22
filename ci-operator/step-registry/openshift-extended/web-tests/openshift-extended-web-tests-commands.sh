#!/bin/bash

if [ -f "${SHARED_DIR}/proxy-conf.sh" ] ; then
    source "${SHARED_DIR}/proxy-conf.sh"
fi

pwd && ls -ltr
cd frontend || exit 0
pwd && ls -ltr
ret=0
oc get co console --kubeconfig=${KUBECONFIG} || ret=$?
if [ $ret -ne 0 ]; then
  echo "console is not installed, skipping all console tests."
  exit 0
fi
res=0
oc get node --kubeconfig=${KUBECONFIG} | grep master || res=$?
if [ $res -eq 0 ]; then
  echo "Testing on normal cluster"
  ./console-test-frontend.sh || exit 0
else
  echo "Testing on hypershift guest cluster"
  ./console-test-frontend-hypershift.sh || exit 0
fi
