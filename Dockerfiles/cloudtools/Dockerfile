FROM ubuntu:16.04

  RUN \
    apt-get update -y && \
    apt-get install python -y && \
    apt-get install curl -y  && \
    ### KBCTL ###
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl > /dev/null 2>&1 && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl  && \
    ### HELM ###
    curl https://kubernetes-helm.storage.googleapis.com/helm-v2.7.2-linux-amd64.tar.gz -o helm-v2.7.2-linux-amd64.tar.gz > /dev/null 2>&1  && \
    tar xvfz helm-v2.7.2-linux-amd64.tar.gz  && \
    chmod +x linux-amd64/helm  && \
    mv linux-amd64/helm /usr/local/bin/helm  && \
    ### PIP ###
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py > /dev/null 2>&1  && \
    python get-pip.py  && \
    ### AWS ###
    pip install awscli  && \
    ### KOPS ###
    curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 > /dev/null 2>&1  && \
    chmod +x kops-linux-amd64  && \
    mv kops-linux-amd64 /usr/local/bin/kops  && \
    ### jq ###
    curl -LO  https://github.com/stedolan/jq/releases/download/$(curl -s  https://github.com/stedolan/jq/releases/latest | grep -P '(?<=(/tag/))(.*)(?=\")' -o)/jq-linux64 > /dev/null 2>&1  && \
    chmod +x jq-linux64  && \
    mv jq-linux64 /usr/local/bin/jq