# Terraform a Kubernetes Cluster

1. Execute `terraform plan` to see what GCP resources will be provisioned and `terraform apply` to realize the plan.

2. create /certs sub-directories: admin, certificate-authority, controller-manager, kube-api-server, 
kube-proxy, kube-scheduler, kubelet-client, service-account

2. Execute `./create-ca.sh` in scripts directory to create a Certificate  Authority. The CA will be used to generate addional TLS certificates.

3. Execute `./gen-certs.sh` in scripts directory to generate all necessary certificates for k8s from the Certificate Authority.

4. Execute `./distribute-certs.sh` to move all the correct keys and certificates to the compute resources

5. Execute `./gen-kubeconfigs.sh` to create worker and controller kubeconfig files

6. Execute `./distribute-kubeconfigs.sh` to distribute the kubeconfig files 