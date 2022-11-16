# Terraform a Kubernetes Cluster

## Using makefile

1. Execute `make k8s-up`

### Once the cluster is up, perform a smoke test

https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/13-smoke-test.md

2. When finished exexute `make k8s-down`

---

## Manual script execution

1. Execute `terraform plan` to see what GCP resources will be provisioned and `terraform apply` to realize the plan.

2. create /certs sub-directories: admin, certificate-authority, controller-manager, kube-api-server, 
kube-proxy, kube-scheduler, kubelet-client, service-account

3. Execute `./create-ca.sh` from within scripts/certificates directory to create a Certificate  Authority. The CA will be used to generate addional TLS certificates.

4. Execute `./gen-certs.sh` from within scripts/certificates directory to generate all necessary certificates for k8s from the Certificate Authority.

5. Execute `./distribute-certs.sh` from within scripts/certificates directory to move all the correct keys and certificates to the compute resources.

6. Execute `./gen-kubeconfigs.sh` from within scripts/kubeconfig directory to create worker and controller kubeconfig files.

7. Execute `./distribute-kubeconfigs.sh` from within scripts/kubeconfig directory to distribute the kubeconfig files.

8. Execute `./gen-data-encryption.sh` from within scripts/data-encryption directory to create data encryption key and configuration file.

9. Execute `./distribute-data-encryption.sh` from within scripts/data-encryption directory to distribute the encryption config file to conroller nodes.

10. Execute `./bootstrap-etcd.sh` from within scripts/etcd directory to ssh into each controller, download etcd and configure a systemd service for etcd

11. Execute `./bootstrap-control-plane.sh` from within scripts/control-plane directory to configure kube API server, Controller Manager and Kube Scheduler on each controller node.

12. Execute `./bootstrap-rbac.sh` from within scripts/control-plane directory

13. Execute `./bootstrap-front-end-lb.sh` from within scripts/control-plane directory

14. Execute `./provision-workers.sh` from within scripts/workers directory

15. Execute `./gen-kubectl-kubeconfig.sh` from within scripts/kubeconfig directory

16. Execute `./provision-pod-network.sh` from within scripts/pod-network

17. Execute `./deploy-coredns.sh` from within scripts/dns directory

### Tear everything down when finished, or else you will have trouble starting another cluster

Execute `./tear-down-cluster.sh` in scripts/wrap-up then 

Execute `terraform destroy` from project root (/kubernetes-terraform/)

# Run Apache Spark on the cluster with spark-on-k8s-operator

1. Install Helm if it is not already (verify with `helm help` command)

2. Add the operator to your Helm repository

    `helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator`

3. Install a release of your choice in the spark-operator namespace of the running cluster

    `helm install <release> spark-operator/spark-operator --namespace spark-operator --create-namespace`

4. Run example jobs from https://github.com/GoogleCloudPlatform/spark-on-k8s-operator &
    
    read the Quick Start Guide available in this repository