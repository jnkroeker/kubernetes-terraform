#!/bin/bash

check_prereqs () {
    declare -a required_programs=("cfssl" "cfssljson")

    for prog in "${required_programs[@]}"
    do
        if ! which "${prog}" > /dev/null 2>&1; then
            echo "${prog} not installed. Please install it then rerun this script."
            exit 1
        fi
    done
}

gen_admin_client_cert () {

    # if [ ! -f "../../certs/admin/ca-csr.json" ]; then
    if [ ! -f "ca-csr.json" ]; then

# cat > ../../certs/admin/admin-csr.json <<EOF
cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi

	# cfssl gencert \
	#     -ca=../../certs/certificate-authority/ca.pem \
	#     -ca-key=../../certs/certificate-authority/ca-key.pem \
	#     -config=../../certs/certificate-authority/ca-config.json \
	#     -profile=kubernetes \
	#     ../../certs/admin/admin-csr.json | cfssljson -bare ../../certs/admin/admin

  cfssl gencert \
	    -ca=ca.pem \
	    -ca-key=ca-key.pem \
	    -config=ca-config.json \
	    -profile=kubernetes \
	    admin-csr.json | cfssljson -bare admin
}

gen_kubelet_client_certs () {
    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do 

    # if [ ! -f "../../certs/kubelet-client/${instance}-csr.json" ]; then
    if [ ! -f "${instance}-csr.json" ]; then

# cat > ../../certs/kubelet-client/${instance}-csr.json <<EOF
cat > ${instance}-csr.json <<EOF

{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi

    EXTERNAL_IP=$(gcloud compute instances describe ${instance} \
    --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')

    INTERNAL_IP=$(gcloud compute instances describe ${instance} \
    --format 'value(networkInterfaces[0].networkIP)')

    # cfssl gencert \
    #     -ca=../../certs/certificate-authority/ca.pem \
    #     -ca-key=../../certs/certificate-authority/ca-key.pem \
    #     -config=../../certs/certificate-authority/ca-config.json \
    #     -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
    #     -profile=kubernetes \
    #     ../../certs/kubelet-client/${instance}-csr.json | cfssljson -bare ../../certs/kubelet-client/${instance}

    cfssl gencert \
        -ca=ca.pem \
        -ca-key=ca-key.pem \
        -config=ca-config.json \
        -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
        -profile=kubernetes \
        ${instance}-csr.json | cfssljson -bare ${instance}

    done
}

gen_controller_manager_client_cert () {

    # if [ ! -f "../../certs/controller-manager/kube-controller-manager-csr.json" ]; then
    if [ ! -f "kube-controller-manager-csr.json" ]; then

# cat > ../../certs/controller-manager/kube-controller-manager-csr.json <<EOF
cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi

    # cfssl gencert \
    #     -ca=../../certs/certificate-authority/ca.pem \
    #     -ca-key=../../certs/certificate-authority/ca-key.pem \
    #     -config=../../certs/certificate-authority/ca-config.json \
    #     -profile=kubernetes \
    #     ../../certs/controller-manager/kube-controller-manager-csr.json | cfssljson -bare ../../certs/controller-manager/kube-controller-manager

    cfssl gencert \
        -ca=ca.pem \
        -ca-key=ca-key.pem \
        -config=ca-config.json \
        -profile=kubernetes \
        kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
}

gen_kube_proxy_client_cert () {

    # if [ ! -f "../../certs/kube-proxy/kube-proxy-csr.json" ]; then 
    if [ ! -f "kube-proxy-csr.json" ]; then 

# cat > ../../certs/kube-proxy/kube-proxy-csr.json <<EOF
cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi

    # cfssl gencert \
    #     -ca=../../certs/certificate-authority/ca.pem \
    #     -ca-key=../../certs/certificate-authority/ca-key.pem \
    #     -config=../../certs/certificate-authority/ca-config.json \
    #     -profile=kubernetes \
    #     ../../certs/kube-proxy/kube-proxy-csr.json | cfssljson -bare ../../certs/kube-proxy/kube-proxy

    cfssl gencert \
      -ca=ca.pem \
      -ca-key=ca-key.pem \
      -config=ca-config.json \
      -profile=kubernetes \
      kube-proxy-csr.json | cfssljson -bare kube-proxy
}

gen_kube_scheduler_client_cert () {

    # if [ ! -f "../../certs/kube-scheduler/kube-scheduler-csr.json" ]; then
    if [ ! -f "kube-scheduler-csr.json" ]; then

# cat > ../../certs/kube-scheduler/kube-scheduler-csr.json <<EOF
cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi

    # cfssl gencert \
    #     -ca=../../certs/certificate-authority/ca.pem \
    #     -ca-key=../../certs/certificate-authority/ca-key.pem \
    #     -config=../../certs/certificate-authority/ca-config.json \
    #     -profile=kubernetes \
    #     ../../certs/kube-scheduler/kube-scheduler-csr.json | cfssljson -bare ../../certs/kube-scheduler/kube-scheduler

        cfssl gencert \
        -ca=ca.pem \
        -ca-key=ca-key.pem \
        -config=ca-config.json \
        -profile=kubernetes \
        kube-scheduler-csr.json | cfssljson -bare kube-scheduler
}

gen_kubernetes_api_server_cert () {

    KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-static-ip \
    --region $(gcloud config get-value compute/region) \
    --format 'value(address)')

    KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

    # if [ ! -f "../../certs/kube-api-server/kubernetes-csr.json" ]; then
    if [ ! -f "kubernetes-csr.json" ]; then

# cat > ../../certs/kube-api-server/kubernetes-csr.json <<EOF
cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi

    # cfssl gencert \
    #     -ca=../../certs/certificate-authority/ca.pem \
    #     -ca-key=../../certs/certificate-authority/ca-key.pem \
    #     -config=../../certs/certificate-authority/ca-config.json \
    #     -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
    #     -profile=kubernetes \
    #     ../../certs/kube-api-server/kubernetes-csr.json | cfssljson -bare ../../certs/kube-api-server/kubernetes

    cfssl gencert \
        -ca=ca.pem \
        -ca-key=ca-key.pem \
        -config=ca-config.json \
        -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
        -profile=kubernetes \
        kubernetes-csr.json | cfssljson -bare kubernetes
}

gen_service_account_key_pair () {

    # if [ ! -f "../../certs/service-account/service-account-csr.json" ]; then
    if [ ! -f "service-account-csr.json" ]; then

# cat > ../../certs/service-account/service-account-csr.json <<EOF
cat > service-account-csr.json <<EOF

{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi

    # cfssl gencert \
    #     -ca=../../certs/certificate-authority/ca.pem \
    #     -ca-key=../../certs/certificate-authority/ca-key.pem \
    #     -config=../../certs/certificate-authority/ca-config.json \
    #     -profile=kubernetes \
    #     ../../certs/service-account/service-account-csr.json | cfssljson -bare ../../certs/service-account/service-account

    cfssl gencert \
      -ca=ca.pem \
      -ca-key=ca-key.pem \
      -config=ca-config.json \
      -profile=kubernetes \
      service-account-csr.json | cfssljson -bare service-account
}

gen_admin_client_cert
gen_kubelet_client_certs
gen_controller_manager_client_cert
gen_kube_proxy_client_cert
gen_kube_scheduler_client_cert
gen_kubernetes_api_server_cert
gen_service_account_key_pair