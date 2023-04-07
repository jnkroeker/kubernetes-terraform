SHELL:=/bin/bash
.ONESHELL:

# DONOT RUN k8s-up becuase config command requires manual intervention
#
# Execute only one at a time
k8s-up: form certificates config encrypt etcd ctrl-plane workers kubectl pod-network dns

k8s-down:
		./scripts/wrap-up/tear-down-cluster.sh
		terraform destroy
# add something do delete all from the certs sub-directories, data-encryption and kubeconfig

form:
		terraform apply

certificates:
		./scripts/certificates/create-ca.sh
		./scripts/certificates/gen-certs.sh
		./scripts/certificates/distribute-certs.sh

config:
		./scripts/kubeconfig/gen-kubeconfigs.sh
		./scripts/kubeconfig/distribute-kubeconfigs.sh
# ^^^^^
# 01-02-23: the following may be obselete after discovering a bug today, but verify a few times before deleting
#
# config errors on creating default context for kube-proxy.kubeconfig
# manually ssh into each k8s-worker-{0,1,2} node and edit kube-proxy.kubeconfig with
# contexts: 
# - context:
#     cluster: kubernetes-cluster
#     user: system:kube-proxy
#   name: default
# current-context: default
# 
# occasionally errors creating clusters in k8s-worker{0,1,2}.kubeconfig
# just verify all kubeconfig files before proceeding

encrypt:
		./scripts/data-encryption/gen-data-encryption.sh
		./scripts/data-encryption/distribute-data-encryption.sh

etcd:
		./scripts/etcd/bootstrap-etcd.sh

ctrl-plane:
		./scripts/control-plane/bootstrap-control-plane.sh
		./scripts/control-plane/bootstrap-rbac.sh
		./scripts/control-plane/bootstrap-front-end-lb.sh

workers:
		./scripts/workers/provision-workers.sh

kubectl:
		./scripts/kubeconfig/gen-kubectl-kubeconfig.sh

pod-network:
		./scripts/pod-network/provision-pod-network.sh

dns:
		./scripts/dns/deploy-coredns.sh
# ^^^^^
# 04-07-23: deploy-coredns.sh does not execute properly; no terminal output on `make dns`
# 
# execute the kubectl command in deploy-coredns.sh manually from the terminal

# -----------------------------------

# check each worker node that systemd services are up
# sudo systemctl status containerd 
# sudo systemctl status kubelet 
# sudo systemctl status kube-proxy
# ^^^ kubelet has a tendency to not work
#
# Verify kubelet is working with command: `kubectl get nodes` on each worker.
# If it does not find other nodes then the kubelet service requires a restart.
# Check that <k8s-worker-#>-key.pem <k8s-worker-#>.pem made it to /var/lib/kubelet/
# and that ca.pem made it to /var/lib/kubernetes/
# then run `sudo systemctl restart kubelet`.
# Rerun `kubectl get nodes` on each worker
#
# check each controller node that systemd services are up
# sudo systemctl status kube-apiserver 
# sudo systemctl status kube-controller-manager 
# sudo systemctl status kube-scheduler

# Verify cluster by making a deployment:
# `kubectl create deployment nginx --image=nginx`
#
# `kubectl get pods -l app=nginx` should show
# nginx-6799fc88d8-p5f27   1/1     Running   0          17s