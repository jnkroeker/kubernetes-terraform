# Coinfigure RBAC to allow API Server to access Kubelet API on each worker node.
# Kubelet API provides metrics, logs and allows execution of commands in pods.

#!/bin/bash

bootstrap_rbac () {

    # this executes the script on the first controller node by first ssh-ing into it
    # command only needs to execute on one controller to effect the whole cluster
    cat ./scripts/control-plane/rbac-configuration.sh | gcloud compute ssh k8s-controller-0

}

bootstrap_rbac