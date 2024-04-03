FROM python:3.12-slim as builder

WORKDIR /app

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    gcc libc6-dev libssl-dev

COPY requirements.txt /app
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt
#RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels uwsgi --build-option="--build-ext" --build-option="--openssl=/usr/local/opt/openssl/" 
RUN UWSGI_PROFILE_OVERRIDE=ssl=true pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels uwsgi
# assamble stage
FROM python:3.12-slim as app 

WORKDIR /app

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY app/. /app

COPY --from=builder /app/wheels /wheels

RUN pip install --no-cache /wheels/*

COPY entrypoint.sh /app

RUN chmod +x entrypoint.sh

# Expose the port on which the Flask API will run
EXPOSE 8080

# Set the entrypoint to the shell script
ENTRYPOINT [ "./entrypoint.sh" ]
