#!/bin/bash

# Configure kubectl for remote access to the cluster
# Generate a kubeconfig file suitable for authentication as the admin user

gen_kubectl_kubeconfig () {
    KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-static-ip \
        --region $(gcloud config get-value compute/region) \
        --format 'value(address)')

    kubectl config set-cluster kubernetes-cluster \
        --certificate-authority=../../certs/certificate-authority/ca.pem \
        --embed-certs=true \
        --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

    kubectl config set-credentials admin \
        --client-certificate=../../certs/admin/admin.pem \
        --client-key=../../certs/admin/admin-key.pem

    kubectl config set-context k8s-context \
        --cluster=kubernetes-cluster \
        --user=admin

    kubectl config use-context k8s-context
}

gen_kubectl_kubeconfig


### VERIFICATION 

# command:

#     kubectl version

# output:

#     Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.0", GitCommit:"cb303e613a121a29364f75cc67d3d580833a7479", GitTreeState:"clean", BuildDate:"2021-04-08T16:31:21Z", GoVersion:"go1.16.1", Compiler:"gc", Platform:"linux/amd64"}
#     Server Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.0", GitCommit:"cb303e613a121a29364f75cc67d3d580833a7479", GitTreeState:"clean", BuildDate:"2021-04-08T16:25:06Z", GoVersion:"go1.16.1", Compiler:"gc", Platform:"linux/amd64"}

# command: 

#     kubectl get nodes

# output:

# NAME       STATUS   ROLES    AGE     VERSION
# worker-0   Ready    <none>   2m35s   v1.21.0
# worker-1   Ready    <none>   2m35s   v1.21.0
# worker-2   Ready    <none>   2m35s   v1.21.0