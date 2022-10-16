#!/bin/bash

bootstrap_control_plane () {

    for instance in k8s-controller-0 k8s-controller-1 k8s-controller-2; do

        # this executes the script on each node by first ssh-ing into it
        cat commands-to-execute-remotely.sh | gcloud compute ssh ${instance} 

        cat enable-health-checks.sh | gcloud compute ssh ${instance}

    done

}

bootstrap_control_plane

### Verification 

# command:
#     kubectl cluster-info --kubeconfig admin.kubeconfig

# output:
#     Kubernetes control plane is running at https://127.0.0.1:6443

# command:
#     curl -H "Host: kubernetes.default.svc.cluster.local" -i http://127.0.0.1/healthz

# output:

#     HTTP/1.1 200 OK
#     Server: nginx/1.18.0 (Ubuntu)
#     Date: Sun, 02 May 2021 04:19:29 GMT
#     Content-Type: text/plain; charset=utf-8
#     Content-Length: 2
#     Connection: keep-alive
#     Cache-Control: no-cache, private
#     X-Content-Type-Options: nosniff
#     X-Kubernetes-Pf-Flowschema-Uid: c43f32eb-e038-457f-9474-571d43e5c325
#     X-Kubernetes-Pf-Prioritylevel-Uid: 8ba5908f-5569-4330-80fd-c643e7512366

#     ok