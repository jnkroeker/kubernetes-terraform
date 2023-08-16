#!/bin/bash

provision_ip_lb () {

    gcloud compute addresses create khyme-static-ip --region=us-east4

    KHYME_STATIC_IP=$(gcloud compute addresses describe khyme-static-ip --region us-east4 --format 'value(address)')

    gcloud compute firewall-rules create khyme-api-external-access --allow tcp:80 --network k8s-network --source-ranges 0.0.0.0/0

    gcloud compute http-health-checks create basic-check

    gcloud compute target-pools create khyme-resources --http-health-check basic-check

    gcloud compute target-pools add-instances khyme-resources --instances k8s-worker-0,k8s-worker-1,k8s-worker-2

    gcloud compute forwarding-rules create khyme-forwarding-rule --address $KHYME_STATIC_IP --ports 80 --region us-east4 --target-pool khyme-resources
    
}

provision_ip_lb