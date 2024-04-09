#!/bin/bash

REPONAME=thecloudbricklayer
IMAGE_NAME=tetris-app
TAG=latest


echo generatin $REPONAME/$IMAGE_NAME:$TAG image

docker build -t $REPONAME/$IMAGE_NAME:$TAG .
docker push $REPONAME/$IMAGE_NAME:$TAG

echo generating Nginx image

cd nginx
docker build -t $REPONAME/nginx-app:$TAG .
docker push $REPONAME/nginx-app:$TAG


cd ..
cd k8s
echo deploying to k8s
kubectl apply -f .