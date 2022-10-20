#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-static-ip \
--region $(gcloud config get-value compute/region) \
--format 'value(address)')

gen_worker_kubeconfigs () {
    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do 

        if [ ! -f "../kubeconfig/${instance}.kubeconfig" ]; then

        kubectl config set-cluster kubernetes-cluster \
        --certificate-authority=../../certs/certificate-authority/ca.pem \
        --embed-certs=true \
        --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
        --kubeconfig=../../kubeconfig/${instance}.kubeconfig

        kubectl config set-credentials system:node:${instance} \
        --client-certificate=../../certs/kubelet-client/${instance}.pem \
        --client-key=../../certs/kubelet-client/${instance}-key.pem \
        --embed-certs=true \
        --kubeconfig=../../kubeconfig/${instance}.kubeconfig

        kubectl config set-context default \
        --cluster=kubernetes-cluster \
        --user=system:node:${instance} \
        --kubeconfig=../../kubeconfig/${instance}.kubeconfig 

        kubectl config use-context default --kubeconfig=../../kubeconfig/${instance}.kubeconfig
        fi
    done
}

gen_kube_proxy_kubeconfig() {
    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=../../certs/certificate-authority/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=../../kubeconfig/kube-proxy.kubeconfig 

    kubectl config set-credentials system:kube-proxy \
    --client-certificate=../../certs/kube-proxy/kube-proxy.pem \
    --client-key=../../certs/kube-proxy/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=../../kubeconfig/kube-proxy.kubeconfig

    kubectl config set-context default \
    --cluster=kubernetes-cluster \ 
    --user=system:kube-proxy \
    --kubeconfig=../../kubeconfig/kube-proxy.kubeconfig

    kubectl config use-context default --kubeconfig=../../kubeconfig/kube-proxy.kubeconfig
}

gen_kube_controller_manager_kubeconfig() {
    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=../../certs/certificate-authority/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=../../kubeconfig/kube-controller-manager.kubeconfig

    kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=../../certs/controller-manager/kube-controller-manager.pem \
    --client-key=../../certs/controller-manager/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=../../kubeconfig/kube-controller-manager.kubeconfig 

    kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=system:kube-controller-manager \
    --kubeconfig=../../kubeconfig/kube-controller-manager.kubeconfig 

    kubectl config use-context default --kubeconfig=../../kubeconfig/kube-controller-manager.kubeconfig

}

# kubeconfig file for kube-scheduler service 

gen_kube_scheduler_kubeconfig() {
    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=../../certs/certificate-authority/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=../../kubeconfig/kube-scheduler.kubeconfig

    kubectl config set-credentials system:kube-scheduler \
    --client-certificate=../../certs/kube-scheduler/kube-scheduler.pem \
    --client-key=../../certs/kube-scheduler/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=../../kubeconfig/kube-scheduler.kubeconfig

    kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=system:kube-scheduler \
    --kubeconfig=../../kubeconfig/kube-scheduler.kubeconfig

    kubectl config use-context default --kubeconfig=../../kubeconfig/kube-scheduler.kubeconfig
}

# kubeconfig for admin user. to be placed on each controller node.

gen_admin_kubeconfig() {
    kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=../../certs/certificate-authority/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=../../kubeconfig/admin.kubeconfig

    kubectl config set-credentials admin \
    --client-certificate=../../certs/admin/admin.pem \
    --client-key=../../certs/admin/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=../../kubeconfig/admin.kubeconfig

    kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=admin \
    --kubeconfig=../../kubeconfig/admin.kubeconfig

    kubectl config use-context default --kubeconfig=../../kubeconfig/admin.kubeconfig
}

gen_worker_kubeconfigs
gen_kube_proxy_kubeconfig
gen_kube_controller_manager_kubeconfig
gen_kube_scheduler_kubeconfig
gen_admin_kubeconfig