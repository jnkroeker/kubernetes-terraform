# Terraform a Kubernetes Cluster

## Using makefile

### Manual script execution

1. Execute `make form` to see what GCP resources will be provisioned and realize the plan.

2. Execute `make certificates` to create a Certificate Authority, generate all necessary certificates for k8s from the Certificate Authority, and distribute the keys and certificates to the compute resources. The CA will be used to generate addional TLS certificates.

3. Execute `make config` to create worker and controller kubeconfig files. 

#### make config does not work quite right, see makefile for manual remedial steps

4. Execute `make encrypt` to create data encryption key and configuration file, then distribute the encryption config file to conroller nodes.

5. Execute `make etcd` to ssh into each controller, download etcd and configure a systemd service for etcd

6. Execute `make ctrl-plane` to configure kube API server, Controller Manager and Kube Scheduler on each controller node, bootstrap RBAC and bootstrap a frontend load balancer.

7. Execute `make workers` to provision the worker nodes.

8. Execute `make kubectl` to create kubectl kubeconfig

9. Execute `make pod-network` 

10. Execute `make dns` 

### Tear everything down when finished, or else you will have trouble starting another cluster

Execute `make k8s-down`

### Helpful debug commands to ensure all services running

`kubectl get all -A`

`kubectl get events -w`

`kubectl get componentstatuses`

`kubectl get nodes`

`kubectl auth can-i <verb> <resource>` (ie ... create service monitor) `--as=system:serviceaccount:<namespace>:<serviceaccountname> [-n <namespace>]`

# Run Apache Spark on the cluster with spark-on-k8s-operator

#### Requires Spark >= v3.2 :  v3.3 installed on laptop in /opt/spark/

1. Install Helm if it is not already (verify installation with `helm help` command)

2. Add the operator to your Helm repository

    `helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator`

3. See what charts you can install from spark-operator repo

    `helm search repo spark-operator`

4. Install a release of your naming in the spark-operator namespace of the running cluster

    this works ->

    `helm install my-release spark-operator/spark-operator --namespace spark-operator --create-namespace`

    this doesnt ->
    
    `helm install --replace <choose any release name> spark-operator/spark-operator --namespace spark-operator --create-namespace --set sparkJobNamespace=spark-jobs --set webhook.enable=true`

    b. this creates a ServiceAccount in spark-operator namespace called my-release-spark

5. Show status of deployment

    `$ helm status --namespace spark-operator my-release`

6. Clone https://github.com/GoogleCloudPlatform/spark-on-k8s-operator

7. Run example jobs from https://github.com/GoogleCloudPlatform/spark-on-k8s-operator &
    
    read the Quick Start Guide available in this repository

### see documentation.txt for more information on working with this cluster