#!/bin/bash
# Generate keys and certificates used by MDS
if [ \! -e /data/keypair/keypair.pem ]; then
    echo -e "Generate keys and certificates used for MDS"

    openssl genrsa -out /data/keypair.pem 2048; openssl rsa -in /data/keypair.pem -outform PEM -pubout -out /data/public.pem
    chmod 644 /data/keypair.pem /data/public.pem
fi
