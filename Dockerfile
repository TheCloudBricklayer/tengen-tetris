FROM python:3.12-slim as builder

WORKDIR /build-app

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    gcc libc6-dev libssl-dev libpcre3 libpcre3-dev \
    libevent-dev python3-dev build-essential

#ADD https://projects.unbit.it/downloads/uwsgi-2.0.19.1.tar.gz .

#RUN tar -zxvf uwsgi-2.0.19.1.tar.gz -C .

COPY requirements.txt /build-app

#RUN ls -l /usr/include/openssl && ls -l /usr/lib/ssl
#ENV CFLAGS="-I/usr/include/openssl"
#ENV LDFLAGS="-L/usr/lib/ssl"
#ENV UWSGI_PROFILE_OVERRIDE=ssl=true
    
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /build-app/wheels -r requirements.txt

#RUN ls /build-app/uwsgi-2.0.19.1

#WORKDIR /build-app/uwsgi-2.0.19.1
#RUN python uwsgiconfig.py --plugin plugins/gevent gevent

# assamble stage
FROM python:3.12-slim as app

COPY --from=builder /build-app/wheels /wheels
#COPY --from=builder /build-app/uwsgi-2.0.19.1/gevent_plugin.so /plugins/gevent_plugin.so

WORKDIR /

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libpcre3 libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY app/. /app
WORKDIR /app

RUN pip install --no-cache /wheels/*

COPY entrypoint.sh /app
RUN chmod +x entrypoint.sh

# Expose the port on which the Flask API will run
EXPOSE 8080
ENTRYPOINT [ "./entrypoint.sh" ]
