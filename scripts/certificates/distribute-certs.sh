#!/bin/bash

distribute_certs_and_keys () {

    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do
        gcloud compute scp \
        ca.pem \
        ${instance}-key.pem \
        ${instance}.pem \
        ${instance}:~/
    done

    for instance in k8s-controller-0 k8s-controller-1 k8s-controller-2; do
        gcloud compute scp \
        ca.pem \
        ca-key.pem \
        kubernetes-key.pem \
        kubernetes.pem \
        service-account-key.pem \
        service-account.pem \
        ${instance}:~/
    done

    # for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do
    #     gcloud compute scp \
    #     ../../certs/certificate-authority/ca.pem \
    #     ../../certs/kubelet-client/${instance}-key.pem \
    #     ../../certs/kubelet-client/${instance}.pem \
    #     ${instance}:~/
    # done

    # for instance in k8s-controller-0 k8s-controller-1 k8s-controller-2; do
    #     gcloud compute scp \
    #     ../../certs/certificate-authority/ca.pem \
    #     ../../certs/certificate-authority/ca-key.pem \
    #     ../../certs/kube-api-server/kubernetes-key.pem \
    #     ../../certs/kube-api-server/kubernetes.pem \
    #     ../../certs/service-account/service-account-key.pem \
    #     ../../certs/service-account/service-account.pem \
    #     ${instance}:~/
    # done
}

distribute_certs_and_keys

# verify all certs were distributed to the correct nodes with `gcloud compute ssh ${instance}`