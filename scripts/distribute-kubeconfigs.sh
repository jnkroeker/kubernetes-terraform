#!/bin/bash

distribute_worker_and_controller_kubeconfigs() {
    for instance in worker-0 worker-1 worker-2; do
        gcloud compute scp \
        ../kubeconfig/${instance}.kubeconfig \
        ../kubeconfig/kube-proxy.kubeconfig \
        ${instance}:~/
    done

    for instance in controller-0 controller-1 controller-2; do
        gcloud compute scp \
        ../kubeconfig/admin.kubeconfig \
        ../kubeconfig/kube-controller-manager.kubeconfig \
        ../kubeconfig/kube-scheduler.kubeconfig \
        ${instance}:~/
    done
}

distribute_worker_and_controller_kubeconfigs