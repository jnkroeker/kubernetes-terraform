# install nginx and configure it to accept HTTP health checks on port 80 
# and proxy the connections to the API server on https://127.0.0.1:6443/healthz

# the Google Network LB used to distribute traffic across API servers only supports http
# meaning the https endpoint exposed by API Server needs to be reached by proxy.

sudo apt-get update
sudo apt-get install -y nginx

cat > kubernetes.default.svc.cluster.local <<EOF
server {
  listen      80;
  server_name kubernetes.default.svc.cluster.local;

  location /healthz {
     proxy_pass                    https://127.0.0.1:6443/healthz;
     proxy_ssl_trusted_certificate /var/lib/kubernetes/ca.pem;
  }
}
EOF

{
  sudo mv kubernetes.default.svc.cluster.local \
    /etc/nginx/sites-available/kubernetes.default.svc.cluster.local

  sudo ln -s /etc/nginx/sites-available/kubernetes.default.svc.cluster.local /etc/nginx/sites-enabled/
}

sudo systemctl restart nginx

sudo systemctl enable nginx