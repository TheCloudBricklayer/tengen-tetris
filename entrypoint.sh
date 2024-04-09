#!/bin/bash

echo "Starting entrypoint.sh"
# Set environment variables
export TZ=America/Ciudad_de_Mexico #UTC-6

# Start Flask application server
#uwsgi --http 0.0.0.0:8080 --module application:app --http-websockets --master --processes 4 --threads 2
#uwsgi --http-socket 0.0.0.0:8080 --module application:app --plugin /plugins/gevent --gevent 1000 --http-websockets --master --processes 4 --threads 2
uwsgi --http-socket 0.0.0.0:8080 --module application:app --http-websockets --master --processes 4 --threads 2

#python application.py
exec "$@"