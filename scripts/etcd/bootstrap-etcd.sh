#!/bin/bash

bootstrap_etcd () {
    for instance in k8s-controller-0 k8s-controller-1 k8s-controller-2; do

        # this executes the script on each node by first ssh-ing into it
        cat commands-to-execute-remotely.sh | gcloud compute ssh ${instance} 

    done
}

bootstrap_etcd

### VERIFICATION 

# from within each controller run
# command:

#     sudo ETCDCTL_API=3 etcdctl member list \
#   --endpoints=https://127.0.0.1:2379 \
#   --cacert=/etc/etcd/ca.pem \
#   --cert=/etc/etcd/kubernetes.pem \
#   --key=/etc/etcd/kubernetes-key.pem

# response:

    # 3a57933972cb5131, started, controller-2, https://10.240.0.12:2380, https://10.240.0.12:2379, false
    # f98dc20bce6225a0, started, controller-0, https://10.240.0.10:2380, https://10.240.0.10:2379, false
    # ffed16798470cab5, started, controller-1, https://10.240.0.11:2380, https://10.240.0.11:2379, false