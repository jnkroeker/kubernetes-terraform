#!/bin/bash

provision () {
    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do

        # this executes the script on each node by first ssh-ing into it
        cat ./scripts/workers/commands-to-execute-remotely.sh | gcloud compute ssh ${instance} 

    done
}

provision

### VERIFICATION 

# run the following commands from outside the worker nodes
# command:

#     gcloud compute ssh k8s-controller-0 --command "kubectl get nodes --kubeconfig admin.kubeconfig"

# response:

#     NAME       STATUS   ROLES    AGE   VERSION
#     worker-0   Ready    <none>   22s   v1.21.0
#     worker-1   Ready    <none>   22s   v1.21.0
#     worker-2   Ready    <none>   22s   v1.21.0