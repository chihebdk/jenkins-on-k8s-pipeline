#!/bin/bash

cp -rf outpout/* /root/


sleep 240
kops delete cluster --name ${NAME} --yes
sleep 100