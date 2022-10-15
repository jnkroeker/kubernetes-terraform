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

create_ca_config () {

    if [ ! \( -f "../../certs/certificate-authority/ca-config.json" -a -f "../../certs/certificate-authority/ca-csr.json" \) ]; then

cat > ../../certs/certificate-authority/ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ../../certs/certificate-authority/ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Reston",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Virginia"
    }
  ]
}
EOF

    fi
}

gen_ca_cert () {
    cfssl gencert -initca ../../certs/certificate-authority/ca-csr.json | cfssljson -bare ../../certs/certificate-authority/ca
}

check_prereqs
create_ca_config
gen_ca_cert