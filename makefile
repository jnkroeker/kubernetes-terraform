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
# config errors on creating default context for kube-proxy.kubeconfig
# manually ssh into each k8s-worker-{1,2,3} node and edit kube-proxy.kubeconfig with
# contexts: 
# - context:
#     cluster: kubernetes-cluster
#     user: system:kube-proxy
#   name: default
# current-context: default

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

external-access:

		./scripts/external/provision-ip-lb.sh
		./scripts/external/install-configure-nginx.sh