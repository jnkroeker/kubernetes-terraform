#!/bin/bash

distribute_encryption_config () {

    for instance in k8s-controller-0 k8s-controller-1 k8s-controller-2; do
        gcloud compute scp ../../data-encryption/encryption-config.yaml ${instance}:~/
    done

}

distribute_encryption_config