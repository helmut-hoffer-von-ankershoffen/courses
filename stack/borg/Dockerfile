FROM webdevops/base:debian-9

MAINTAINER Helmut Hoffer von Ankershoffen <helmuthva@googlemail.com>

# Install some base packages
RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common procps less nano vim telnet iputils-ping && \
    apt-get clean

# Install packages required by borg
RUN apt-get update && \
    apt-get install -y openssh-client python-pip && \
    apt-get clean

# Download borg
RUN wget -O /usr/local/bin/borg https://github.com/borgbackup/borg/releases/download/1.1.4/borg-linux64 && \
    chmod 755 /usr/local/bin/borg

# Install Jinja2 client required by provisioning
RUN pip install j2cli[yaml]

# Copy files for provisioning borg
COPY /container/ /

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]
CMD ["supervisord"]