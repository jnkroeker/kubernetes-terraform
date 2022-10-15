#!/bin/bash

bootstrap_etcd () {
    for instance in k8s-controller-0 k8s-controller-1 k8s-controller-2; do

        cat commands-to-execute-remotely.sh | gcloud compute ssh ${instance} 

    done
}

bootstrap_etcd