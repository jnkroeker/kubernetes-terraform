SHELL:=/bin/bash
.ONESHELL:

k8s-up: 
		terraform apply
		./scripts/certificates/create-ca.sh
		./scripts/certificates/gen-certs.sh
		./scripts/certificates/distribute-certs.sh
		./scripts/kubeconfig/gen-kubeconfigs.sh
		./scripts/kubeconfig/distribute-kubeconfigs.sh
		./scripts/data-encryption/gen-data-encryption.sh
		./scripts/data-encryption/distribute-data-encryption.sh
		./scripts/etcd/bootstrap-etcd.sh
		./scripts/control-plane/bootstrap-control-plane.sh
		./scripts/control-plane/bootstrap-rbac.sh
		./scripts/control-plane/bootstrap-front-end-lb.sh
		./scripts/workers/provision-workers.sh
		./scripts/kubeconfig/gen-kubectl-kubeconfig.sh
		./scripts/pod-network/provision-pod-network.sh
		./scripts/dns/deploy-coredns.sh

k8s-down:
		./scripts/wrap-up/tear-down-cluster.sh
		terraform destroy
		# add something do delete all from the certs sub-directories, data-encryption and kubeconfig