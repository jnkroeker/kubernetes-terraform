#!/bin/bash

# Kubernetes stores a variety of data including cluster state, application configurations and secrets.
# Kubernetes supports the ability to encrypt cluster data at rest.
# Here we generate an encryption key and encryption config suitable for encrypting Kubernetes Secrets.

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

gen_encryption_config () {

  # if [ ! \( -f "../../data-encryption/encryption-config.yaml" \) ]; then
  if [ ! \( -f "encryption-config.yaml" \) ]; then

cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources: 
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
    fi
}

gen_encryption_config