FROM nginx:stable-alpine

WORKDIR /etc/nginx

COPY . /etc/nginx/

WORKDIR /

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]