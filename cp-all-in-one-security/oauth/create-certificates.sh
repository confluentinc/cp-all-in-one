#!/bin/bash

create_certificates(){
  # Generate keys and certificates used by MDS

  echo -e "Generate keys and certificates used for MDS"
  rm -rf ./keypair/keypair.pem ./keypair/public.pem
  mkdir -p ./keypair

  openssl genrsa -out ./keypair/keypair.pem 2048; openssl rsa -in ./keypair/keypair.pem -outform PEM -pubout -out ./keypair/public.pem
}

create_certificates
