# Coinfigure RBAC to allow API Server to access Kubelet API on each worker node.
# Kubelet API provides metrics, logs and allows execution of commands in pods.

#!/bin/bash

bootstrap_rbac () {

    # this executes the script on the first controller node by first ssh-ing into it
    cat rbac-configuration.sh | gcloud compute ssh controller-0

}

bootstrap_rbac