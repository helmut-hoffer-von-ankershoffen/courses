FROM rabbitmq:3.7.15-management

MAINTAINER Helmut Hoffer von Ankershoffen <helmuthva@googlemail.com>

# Install some base packages
RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common procps less nano vim telnet iputils-ping && \
    apt-get clean
