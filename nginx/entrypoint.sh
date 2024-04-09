#!/bin/sh

# Sustituye las variables de entorno en tu archivo de configuración de Nginx
echo "Sustituyendo las variables de entorno en el archivo de configuración de Nginx..."
envsubst '$HOSTNAME $UWSGI_HOST $UWSGI_PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

chmod 644 /etc/nginx/nginx.conf

./docker-entrypoint.sh
# Espera a que el servicio de Python esté listo
while ! nc -z $UWSGI_HOST:$UWSGI_PORT; do
  sleep 1
  echo "Esperando a que el servicio de Python esté listo..."
done
echo "El servicio de Python está listo"
# Inicia Nginx
nginx -g 'daemon off;'