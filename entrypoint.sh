#!/bin/bash
export app_host=${APP_HOST:-0.0.0.0}
export app_port=${APP_PORT:-8080}
echo "Starting entrypoint.sh"
# Set environment variables

# Start Flask application server
#uwsgi --http 0.0.0.0:8080 --plugin /plugins/gevent --gevent 100 --module application:app --http-websockets --master --processes 4 --threads 2 --thunder-lock
gunicorn -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 -b ${app_host}:${app_port} application:app

exec "$@"