#!/bin/bash

KHYME_STATIC_IP=$(gcloud compute addresses describe khyme-static-ip --region us-east4 --format 'value(address)')

install_nginx () {

    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do
        gcloud compute ssh ${instance}

        sudo apt-get update
        sudo apt-get install -y nginx
    done
}

configure_nginx () {

    for instance in k8s-worker-0 k8s-worker-1 k8s-worker-2; do

    gcloud compute ssh ${instance}

cat > kubernetes.default.svc.cluster.local <<EOF
server {
    listen 80;

    server_name ${KHYME_STATIC_IP}

    location / {
        proxy_pass  http://0.0.0.0:3000/status
    }
}
EOF

    sudo mv kubernetes.default.svc.cluster.local /etc/nginx/sites-available/kubernetes.default.svc.cluster.local 

    sudo ln -s /etc/nginx/sites-available/kubernetes.default.svc.cluster.local /etc/nginx/sites-enabled/

    sudo systemctl restart nginx

    sudo systemctl enable nginx

    done
}

install_nginx
configure_nginx

#
#  proxy_pass endpoint must match the port number exposed by the tasker-service NodePort
#
#  server_name is used by NGINX to direct incoming requests by the HOST header
#  in browsers, you can't override the HOST header; it will always be set to the URL requested, KHYME_STATIC_IP in this case

#
# Verification
#
# gcloud compute ssh into each worker node, execute sudo systemctl status nginx, examine kubernetes.default.svc.cluster.local file
#