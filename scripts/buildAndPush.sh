#!/bin/bash
set -a
source ../TENGEN-TETRIS/.env
set +a

echo generatin $REPONAME/$APP_IMAGE:$TETRIS_IMAGE_TAG image

docker build -t $REPONAME/$APP_IMAGE:$TETRIS_IMAGE_TAG -t $REPONAME/$APP_IMAGE:latest --no-cache .
docker push $REPONAME/$APP_IMAGE:$TETRIS_IMAGE_TAG
docker push $REPONAME/$APP_IMAGE:latest

echo generating $REPONAME/$NGINX_IMAGE:$NGINX_IMAGE_TAG image

cd nginx
docker build -t $REPONAME/$NGINX_IMAGE:$NGINX_IMAGE_TAG -t $REPONAME/$NGINX_IMAGE:latest --no-cache .
docker push $REPONAME/$NGINX_IMAGE:$NGINX_IMAGE_TAG
docker push $REPONAME/$NGINX_IMAGE:latest
