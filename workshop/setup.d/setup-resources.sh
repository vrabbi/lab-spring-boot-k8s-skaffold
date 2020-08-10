#!/bin/bash

envsubst < ~/exercises/demo/src/k8s/deployment.yaml > tmp.yaml && mv tmp.yaml ~/exercises/demo/src/k8s/deployment.yaml