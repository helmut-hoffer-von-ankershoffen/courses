FROM webdevops/varnish:latest@sha256:a3b2fcd9c7d29d00cd0ecbc5a014c0aacce8ae0ece183605f13a2c8080d3d96b

# Upgrade varnish to 5.x
RUN apk add "varnish>5.0" --update-cache --repository http://nl.alpinelinux.org/alpine/latest-stable/main/ && \
    apk add "varnish-libs>5.0" --update-cache --repository http://nl.alpinelinux.org/alpine/latest-stable/main

# Install configuration
COPY /container /

# Configure default - override in your docker-compose file
ENV VARNISH_OPTS="-p vcc_err_unref=off -p thread_pools=4 -p thread_pool_max=10000 -p timeout_idle=60 -p nuke_limit=100000" \
    VARNISH_STORAGE=malloc,256m \
    VARNISH_PORT_REAL=80 \
    VARNISH_BACKEND_HOST=app \
    VARNISH_BACKEND_PORT=80 \
    VARNISH_BACKEND_MAX_CONNECTIONS=8096 \
    VARNISH_BACKEND_FIRST_BYTE_TIMEOUT=300s \
    VARNISH_BACKEND_CONNECT_TIMEOUT=5s \
    VARNISH_BACKEND_BETWEEN_BYTES_TIMEOUT=2s \
    VARNISH_BACKEND_PROBE_HOST=app \
    VARNISH_BACKEND_PROBE_PATH=/health.html \
    VARNISH_BACKEND_PROBE_FORWARDED_SCHEME=https \
    VARNISH_HOST_NEVER_CACHE_REGEX=NOMATCH \
    VARNISH_BACKEND_PROBE_INTERVAL=5 \
    VARNISH_BACKEND_PROBE_THRESHOLD=3 \
    VARNISH_STAGE=production

# We want varnishd and other services in parallel supervised by supervisord
CMD ["supervisord"]
