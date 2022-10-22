#!/bin/bash

tear_down() {

    gcloud compute target-pools delete kubernetes-target-pool

    gcloud compute http-health-checks delete kubernetes

    gcloud compute firewall-rules delete kubernetes-allow-health-check

    gcloud compute forwarding-rules delete kubernetes-forwarding-rule

    gcloud compute routes delete kubernetes-route-10-200-0-0-24

    gcloud compute routes delete kubernetes-route-10-200-1-0-24

    gcloud compute routes delete kubernetes-route-10-200-2-0-24
}

tear_down