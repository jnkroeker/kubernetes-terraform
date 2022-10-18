# Terraform a Kubernetes Cluster

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