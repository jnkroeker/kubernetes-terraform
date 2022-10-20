#!/bin/bash

# we know the internal IP and Pod CIDR for each worker because we set them in compute.tf
# but here is how to see them again registered in the Routing Table

# gcloud compute instances describe k8s-worker-{#} --format 'value[separator=" "] \
# (networkInterfaces[0].networkIP, metadata.items[0].value)'

create_worker_network_routes() {
    for i in 0 1 2; do
        gcloud compute routes create kubernetes-route-10-200-${i}-0-24 \
            --network k8s-network \
            --next-hop-address 10.240.0.2${i} \
            --destination-range 10.200.${i}.0/24
    done

}

create_worker_network_routes

### Verification

# list routes in the 'k8s-network' VPC network

# command:
# gcloud compute routes list --filter "network: k8s-network"

# response:

# NAME                            NETWORK                  DEST_RANGE     NEXT_HOP                  PRIORITY
# default-route-1606ba68df692422  kubernetes-the-hard-way  10.240.0.0/24  kubernetes-the-hard-way   0
# default-route-615e3652a8b74e4d  kubernetes-the-hard-way  0.0.0.0/0      default-internet-gateway  1000
# kubernetes-route-10-200-0-0-24  kubernetes-the-hard-way  10.200.0.0/24  10.240.0.20               1000
# kubernetes-route-10-200-1-0-24  kubernetes-the-hard-way  10.200.1.0/24  10.240.0.21               1000
# kubernetes-route-10-200-2-0-24  kubernetes-the-hard-way  10.200.2.0/24  10.240.0.22               1000
