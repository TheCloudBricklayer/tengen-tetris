#!/bin/bash
set -a
source ../.env
set +a
# Ruta de la carpeta del entorno virtual
venv_path="../.venv"
requirements_path="../requirements.txt"
app_path="../app/"

echo "Ruta completa del entorno virtual: $(realpath "$venv_path")"

# Eliminar la carpeta del entorno virtual si existe
if [ -d "$venv_path" ]; then
    echo "Eliminando la carpeta del entorno virtual..."
    rm -rf "$venv_path"
fi

# Crear un nuevo entorno virtual
echo "Creando un nuevo entorno virtual..."
python3 -m venv "$venv_path"

ls "$venv_path/bin/activate"

# Activar el entorno virtual
source "$venv_path/bin/activate"

# Instalar la librería requerida
echo "Instalando la librería..."
pip install -r "$requirements_path"

# Activar la aplicación
echo "Activando la aplicación..."
gunicorn -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 -b ${APP_HOST}:${APP_PORT} application:app --chdir ${app_path}
