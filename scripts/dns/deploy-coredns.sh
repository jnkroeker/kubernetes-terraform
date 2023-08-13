#!/bin/bash

deploy_core_dns () {
    kubectl apply -f https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/deployments/coredns-1.7.0.yaml
}

# Verification

# kubectl get pods -l k8s-app=kube-dns -n kube-system

# Create a busybox deployment

# kubectl run busybox --image=busybox:1.28 --command -- sleep 3600

# List pod created by the busybox deployment

# kubectl get pods -l run=busybox

# Retrieve the full name of the busybox pod

# POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")

# execute DNS lookup for the kubernetes service inside busybox

# kubectl exec -ti $POD_NAME -- nslookup kubernetes