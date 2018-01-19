#!/bin/bash


export NAME=myfirstcluster.k8s.local
export KOPS_STATE_STORE=s3://prefix-chiheb-dkhil-state-store

cp -rf output/.kube /root/
cp -rf output/.helm /root/

sleep 20
kops delete cluster --name ${NAME} --yes
sleep 100