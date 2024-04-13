import os

class Config:
    app_host    = os.getenv('APP_HOST', '0.0.0.0')
    app_port    = os.getenv('APP_PORT', '8080')
    debug       = os.getenv('DEBUG', False)