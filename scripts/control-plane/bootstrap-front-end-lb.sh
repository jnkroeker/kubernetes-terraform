#!/bin/bash

provision_network_load_balancer () {
    {
        KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
            --region $(gcloud config get-value compute/region) \
            --format 'value(address)')

        gcloud compute http-health-checks create kubernetes \
            --description "Kubernetes Health Check" \
            --host "kubernetes.default.svc.cluster.local" \
            --request-path "/healthz"

        gcloud compute firewall-rules create kubernetes-the-hard-way-allow-health-check \
            --network kubernetes-the-hard-way \
            --source-ranges 209.85.152.0/22,209.85.204.0/22,35.191.0.0/16 \
            --allow tcp

        gcloud compute target-pools create kubernetes-target-pool \
            --http-health-check kubernetes

        gcloud compute target-pools add-instances kubernetes-target-pool \
        --instances controller-0,controller-1,controller-2

        gcloud compute forwarding-rules create kubernetes-forwarding-rule \
            --address ${KUBERNETES_PUBLIC_ADDRESS} \
            --ports 6443 \
            --region $(gcloud config get-value compute/region) \
            --target-pool kubernetes-target-pool
    }
}

provision_network_load_balancer

### VERIFICATION 

# KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
#   --region $(gcloud config get-value compute/region) \
#   --format 'value(address)')

# command:

#     curl --cacert ca.pem https://${KUBERNETES_PUBLIC_ADDRESS}:6443/version

# output:

#     {
#     "major": "1",
#     "minor": "21",
#     "gitVersion": "v1.21.0",
#     "gitCommit": "cb303e613a121a29364f75cc67d3d580833a7479",
#     "gitTreeState": "clean",
#     "buildDate": "2021-04-08T16:25:06Z",
#     "goVersion": "go1.16.1",
#     "compiler": "gc",
#     "platform": "linux/amd64"
#     }