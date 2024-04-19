#!/bin/bash
set -a
source ../.env
set +a

if [ ! -f "../.env" ]; then
    echo "El archivo .env no se encuentra en la ruta esperada."
    exit 1
fi

echo generatin $REPONAME/$APP_IMAGE:$TETRIS_IMAGE_TAG image

docker build -t $REPONAME/$APP_IMAGE:$TETRIS_IMAGE_TAG -t $REPONAME/$APP_IMAGE:latest --no-cache ../.
docker push $REPONAME/$APP_IMAGE:$TETRIS_IMAGE_TAG
docker push $REPONAME/$APP_IMAGE:latest

echo generating $REPONAME/$NGINX_IMAGE:$NGINX_IMAGE_TAG image

cd nginx
docker build -t $REPONAME/$NGINX_IMAGE:$NGINX_IMAGE_TAG -t $REPONAME/$NGINX_IMAGE:latest --no-cache ../.
docker push $REPONAME/$NGINX_IMAGE:$NGINX_IMAGE_TAG
docker push $REPONAME/$NGINX_IMAGE:latest
