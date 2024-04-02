#!/bin/bash

echo "Starting entrypoint.sh"
# Set environment variables
export TZ=America/Ciudad_de_Mexico #UTC-6

# Start Flask development server
uwsgi --http 0.0.0.0:8080 --module application:app --master --processes "4" --threads "2"
#python application.py
exec "$@"