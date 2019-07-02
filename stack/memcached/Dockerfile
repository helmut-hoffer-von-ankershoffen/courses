FROM memcached:1.5.16

MAINTAINER Helmut Hoffer von Ankershoffen <helmuthva@googlemail.com>

# Install some base packages
USER root
RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common procps less nano vim telnet iputils-ping && \
    apt-get clean

# Switch back user
USER memcache