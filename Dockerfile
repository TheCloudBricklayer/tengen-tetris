FROM python:3.12-slim as builder

WORKDIR /build-app

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    gcc libc6-dev libssl-dev libpcre3 libpcre3-dev ruby

ADD https://projects.unbit.it/downloads/uwsgi-2.0.19.1.tar.gz .

RUN tar -zxvf uwsgi-2.0.19.1.tar.gz -C .

RUN ls -la

COPY requirements.txt /build-app

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /build-app/wheels -r requirements.txt
#RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels uwsgi --build-option="--build-ext" --build-option="--openssl=/usr/local/opt/openssl/" 
#RUN UWSGI_PROFILE_OVERRIDE=ssl=true pip wheel --no-cache-dir --no-deps --wheel-dir /build-app/wheels uwsgi
RUN pip install uwsgi
#RUN uwsgi --build-plugin /build-app/uwsgi-2.0.19.1/plugins/gevent
WORKDIR /build-app/uwsgi-2.0.19.1

RUN python uwsgiconfig.py --plugin plugins/gevent gevent

# assamble stage
FROM python:3.12-slim as app

COPY --from=builder /build-app/wheels /wheels
COPY --from=builder /build-app/uwsgi-2.0.19.1/gevent_plugin.so /plugins/gevent_plugin.so

RUN ls /plugins/gevent_plugin.so

WORKDIR /

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    libpcre3

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY app/. /app

WORKDIR /app

RUN pip install --no-cache /wheels/*

COPY entrypoint.sh /app

RUN chmod +x entrypoint.sh

# Expose the port on which the Flask API will run
EXPOSE 8080

# Set the entrypoint to the shell script
ENTRYPOINT [ "./entrypoint.sh" ]
