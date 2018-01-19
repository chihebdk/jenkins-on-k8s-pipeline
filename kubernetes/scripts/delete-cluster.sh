#!/bin/bash

set -x


kops delete cluster --name ${CLUSTER_NAME} --yes
sleep 100