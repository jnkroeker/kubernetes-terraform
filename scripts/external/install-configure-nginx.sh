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

        INTERNAL_IP=$(gcloud compute instances describe ${instance} \
        --format 'value(networkInterfaces[0].networkIP)')

        gcloud compute ssh ${instance}

cat > kubernetes.default.svc.cluster.local <<EOF
server {
    listen 80;

    server_name ${KHYME_STATIC_IP};

    location / {
        proxy_pass  http://${INTERNAL_IP}:30080/status;
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
# THIS NEVER WORKS, MUST ENTER NGINX CONFIG MANUALLY: starting with sudo apt-get update
#
# I struggled for days to get the nginx config correct. 
# It should look something like the below.
# The 10.32.0.64 is the internal IP of the phaction-service
# The server_name is the static ip for loadbalancing the application

# server {
#     listen 80;

#     server_name 34.145.247.222;

#     location /status {
#         proxy_pass http://10.32.0.64:30080/status;
#     }
# }

#  proxy_pass endpoint must match the port number exposed by the service NodePort
#
#  server_name is used by NGINX to direct incoming requests by the HOST header
#  in browsers, you can't override the HOST header; it will always be set to the URL requested, KHYME_STATIC_IP in this case

#
# Verification
#
# gcloud compute ssh into each worker node, execute sudo systemctl status nginx, examine kubernetes.default.svc.cluster.local file
#