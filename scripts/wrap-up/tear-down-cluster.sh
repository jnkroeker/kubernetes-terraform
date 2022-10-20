#!/bin/bash

tear_down() {

    gcloud compute http-health-checks delete kubernetes

    gcloud compute forwarding-rules delete kubernetes-forwarding-rule

    gcloud compute target-pools delete kubernetes-target-pool
}

tear_down