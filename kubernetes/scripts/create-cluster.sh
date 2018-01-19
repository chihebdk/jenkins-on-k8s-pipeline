#!/bin/bash

set -x



#Delete kops user and group
if [ `aws iam list-users  | jq .[][].UserName |  sed 's/\"//g' | grep -w kops` == "kops" ]; then
    aws iam  list-access-keys  --user-name kops | jq .[][].AccessKeyId | sed 's/\"//g' | xargs -L1 aws iam delete-access-key --user-name kops --access-key-id
    aws iam remove-user-from-group --user-name kops --group-name kops
    aws iam delete-user --user-name kops
    aws iam list-attached-group-policies --group-name kops | jq .[][].PolicyArn | sed 's/\"//g' | xargs -L1 aws iam detach-group-policy --group-name kops --policy-arn
    aws iam delete-group --group-name kops
fi
sleep 30
#create kops user and group
aws iam create-group --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
aws iam create-user --user-name kops
aws iam add-user-to-group --user-name kops --group-name kops
aws iam create-access-key --user-name kops


#Recreate s3 bucket
if [ $(aws s3api list-buckets | jq .Buckets[].Name | grep -w \"prefix-chiheb-dkhil-state-store\") == "\"prefix-chiheb-dkhil-state-store\""] ; then
    aws s3 rb s3://prefix-chiheb-dkhil-state-store --force  
fi
aws s3api create-bucket  --bucket prefix-chiheb-dkhil-state-store --region us-east-1

#Recreate key-pair
aws ec2 delete-key-pair --key-name kops
sleep 30
aws ec2 create-key-pair --key-name kops --query 'KeyMaterial' --output text > kops.pem
mkdir -p ~/.ssh
mv kops.pem  ~/.ssh/id_rsa
chmod 400  ~/.ssh/id_rsa
ssh-keygen -y -f  ~/.ssh/id_rsa >  ~/.ssh/id_rsa.pub

kops create cluster --zones us-east-1a ${CLUSTER_NAME}
kops delete secret
sleep 30
kops create secret --name ${CLUSTER_NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub
kops update cluster ${CLUSTER_NAME} --yes


sleep 300
kubectl get nodes
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

helm init

cp -rf /root/.kube output/
cp -rf /root/.helm output/
