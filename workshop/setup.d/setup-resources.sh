#!/bin/bash

kubectl create secret generic registry-credentials --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
envsubst < demo/src/k8s/deployment.yaml > demo/src/k8s/deployment.yaml