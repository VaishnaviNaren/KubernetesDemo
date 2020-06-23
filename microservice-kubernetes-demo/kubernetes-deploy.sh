#!/bin/sh
if [ -z "$DOCKER_ACCOUNT" ]; then
    DOCKER_ACCOUNT=ewolff
fi;
kubectl run apache --image=docker.io/$DOCKER_ACCOUNT/microservice-kubernetes-demo-apache:$VERSION_TAG --port=80
kubectl expose deployment/apache --type="LoadBalancer" --port 80
kubectl run catalog --image=docker.io/$DOCKER_ACCOUNT/microservice-kubernetes-demo-catalog:$VERSION_TAG --port=8080
kubectl expose deployment/catalog --type="LoadBalancer" --port 8080
kubectl run customer --image=docker.io/$DOCKER_ACCOUNT/microservice-kubernetes-demo-customer:$VERSION_TAG --port=8080
kubectl expose deployment/customer --type="LoadBalancer" --port 8080
kubectl run order --image=docker.io/$DOCKER_ACCOUNT/microservice-kubernetes-demo-order:$VERSION_TAG --port=8080
kubectl expose deployment/order --type="LoadBalancer" --port 8080
