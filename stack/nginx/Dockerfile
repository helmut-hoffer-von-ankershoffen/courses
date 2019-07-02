FROM webdevops/nginx:debian-9

MAINTAINER Helmut Hoffer von Ankershoffen <helmuthva@googlemail.com>

USER root

RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common procps less nano vim telnet iputils-ping sudo && \
    apt-get clean

RUN apt-get update && \
    curl -f -L -sS https://ngxpagespeed.com/install > /tmp/ngxpagespeed && \
    chmod 775 /tmp/ngxpagespeed

RUN apt-get update && \
    apt-get install -y openssl libssl-dev && \
    apt-get clean

RUN yes | /tmp/ngxpagespeed --nginx-version latest --assume-yes -a '--with-pcre-jit --conf-path=/etc/nginx/nginx.conf --sbin-path=/usr/sbin/nginx --with-file-aio --with-threads --with-http_gzip_static_module --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/run/nginx.pid --lock-path=/var/lock/nginx.lock --http-client-body-temp-path=/var/lib/nginx/body --http-proxy-temp-path=/var/lib/nginx/proxy --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-http_stub_status_module --with-http_gzip_static_module --with-http_ssl_module --with-http_v2_module' && \
    rm /tmp/ngxpagespeed && \
    rm -rf /usr/local/nginx

RUN apt-get update && \
    apt-get install -y certbot python-certbot-nginx && \
    apt-get clean

RUN rm /etc/nginx/modules-enabled/*
RUN rm /etc/nginx/conf.d/10-docker.conf

RUN mkdir /var/log/pagespeed

COPY etc /etc/
COPY opt /opt/
COPY app/ /app/

EXPOSE 80/tcp
EXPOSE 443/tcp

ENV MEMCACHED_HOST='memcached' \
    APP_UPSTREAM_HOST='varnish' \
    APP_UPSTREAM_PORT='80' \
    APP_DOMAIN='courses.localhost' \
    APP_CERTBOT_NAME='courses.20steps.de' \
    APP_CERTBOT_DOMAINS='courses.20steps.de' \
    APP_CERTBOT_EMAIL='helmuthva@googlemail.com' \
    APP_CDN_DOMAIN='courses-2daa.kxcdn.com'