#!/bin/bash

distribute_worker_and_controller_kubeconfigs() {
    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do
        gcloud compute scp \
        ../../kubeconfig/${instance}.kubeconfig \
        ../../kubeconfig/kube-proxy.kubeconfig \
        ${instance}:~/
    done

    for instance in k8s-controller-0 k8s-controller-1 k8s-controller-2; do
        gcloud compute scp \
        ../../kubeconfig/admin.kubeconfig \
        ../../kubeconfig/kube-controller-manager.kubeconfig \
        ../../kubeconfig/kube-scheduler.kubeconfig \
        ${instance}:~/
    done
}

distribute_worker_and_controller_kubeconfigs