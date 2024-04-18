#!/bin/sh

export NGINX_TEMPLATE=/etc/nginx/nginx_gunicorn.conf.template
export tz=${TIME_ZONE:-UTC}
export APP_HOSTNAME=${APP_HOSTNAME:-localhost}
export APP_PORT=${APP_PORT:-8080}

# Sustituye las variables de entorno en tu archivo de configuración de Nginx
echo "Sustituyendo las variables de entorno en el archivo de configuración de Nginx..."
envsubst '$APP_HOSTNAME $APP_PORT' < $NGINX_TEMPLATE > /etc/nginx/nginx.conf

chmod 644 /etc/nginx/nginx.conf

./docker-entrypoint.sh
# Espera a que el servicio de Python esté listo
while ! nc -z $APP_HOSTNAME:$APP_PORT; do
  sleep 1
  echo "Esperando a que el servicio de Python esté listo..."
done
echo "El servicio de Python está listo"
# Inicia Nginx
nginx -g 'daemon off;'
