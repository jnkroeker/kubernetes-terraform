#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-static-ip \
--region $(gcloud config get-value compute/region) \
--format 'value(address)')

gen_worker_kubeconfigs () {
    
    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do 

        if [ ! -f "${instance}.kubeconfig" ]; then

        kubectl config set-cluster kubernetes-cluster \
        --certificate-authority=ca.pem \
        --embed-certs=true \
        --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
        --kubeconfig=${instance}.kubeconfig

        kubectl config set-credentials system:node:${instance} \
        --client-certificate=${instance}.pem \
        --client-key=${instance}-key.pem \
        --embed-certs=true \
        --kubeconfig=${instance}.kubeconfig

        kubectl config set-context default \
        --cluster=kubernetes-cluster \
        --user=system:node:${instance} \
        --kubeconfig=${instance}.kubeconfig 

        kubectl config use-context default --kubeconfig=${instance}.kubeconfig
        fi

    done
}

gen_kube_proxy_kubeconfig() {

    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig 

    kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

    kubectl config set-context default \
    --cluster=kubernetes-cluster \ 
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

    kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}

gen_kube_controller_manager_kubeconfig() {

    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

    kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig 

    kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig 

    kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig

}

# kubeconfig file for kube-scheduler service 

gen_kube_scheduler_kubeconfig() {

    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

    kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

    kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

    kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig

}

# kubeconfig for admin user. to be placed on each controller node.

gen_admin_kubeconfig() {

    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

    kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

    kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=admin \
    --kubeconfig=admin.kubeconfig

    kubectl config use-context default --kubeconfig=admin.kubeconfig

}

gen_worker_kubeconfigs
gen_kube_proxy_kubeconfig
gen_kube_controller_manager_kubeconfig
gen_kube_scheduler_kubeconfig
gen_admin_kubeconfig