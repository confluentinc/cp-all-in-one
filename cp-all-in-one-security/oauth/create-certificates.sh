#!/bin/bash

create_certificates(){
  # Generate keys and certificates used by MDS

  echo -e "Generate keys and certificates used for MDS"
  mkdir -p /tmp/conf

  openssl genrsa -out /tmp/conf/keypair.pem 2048; openssl rsa -in /tmp/conf/keypair.pem -outform PEM -pubout -out /tmp/conf/public.pem
}

create_certificates
