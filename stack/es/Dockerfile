FROM docker.elastic.co/elasticsearch/elasticsearch:7.1.1

MAINTAINER Helmut Hoffer von Ankershoffen <helmuthva@googlemail.com>

ENV TZ="Europe/Berlin" \
    cluster.name=app \
    discovery.type=single-node \
    bootstrap.memory_lock=false \
    xpack.security.enabled=false \
    xpack.monitoring.enabled=false \
    http.host=0.0.0.0 \
    transport.host=0.0.0.0