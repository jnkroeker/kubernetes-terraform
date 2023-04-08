#!/bin/bash

tear_down() {

    gcloud compute forwarding-rules delete kubernetes-forwarding-rule

    gcloud compute forwarding-rules delete khyme-forwarding-rule

    gcloud compute target-pools delete kubernetes-target-pool

    gcloud compute target-pools delete khyme-resources

    gcloud compute http-health-checks delete kubernetes

    gcloud compute http-health-checks delete basic-check

    gcloud compute firewall-rules delete kubernetes-allow-health-check

    gcloud compute firewall-rules delete kubernetes-the-hard-way-allow-nginx-service

    gcloud compute firewall-rules delete khyme-api-external-access

    gcloud compute addresses delete khyme-static-ip

    gcloud compute routes delete kubernetes-route-10-200-0-0-24

    gcloud compute routes delete kubernetes-route-10-200-1-0-24

    gcloud compute routes delete kubernetes-route-10-200-2-0-24

    # delete certs, kubeconfigs
    rm *.pem *.csr *.kubeconfig *.json *.yaml
}

tear_down