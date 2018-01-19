#!/bin/bash

set -x


cp -rf output/.kube /root/
cp -rf output/.helm /root/

kops delete cluster --name ${CLUSTER_NAME} --yes
sleep 100