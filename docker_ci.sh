#!/bin/sh

docker build -t container-registry.k8s.kdm.wcss.pl/jhub-notebook-s3:v0.2 .
docker push container-registry.k8s.kdm.wcss.pl/jhub-notebook-s3:v0.2
