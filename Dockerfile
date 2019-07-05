FROM ubuntu:18.04

LABEL maintainer="ttorres@vmware.com"

RUN apt-get update -y && \
    apt-get install -y \
        openssl \
        bash \
        curl \
        vim \
        xvfb \
        npm \
        build-essential \
        sshpass \
        ffmpeg \
        python \
        python-pip \
        supervisor \
        ffmpeg\
        openjdk-8-jre\
        iputils-ping 

#Update pip and install sshuttle
RUN pip install sshuttle

#sudo iptables needed 
RUN apt-get install iptables sudo -y

RUN npm install -g protractor && \
  webdriver-manager update

RUN npm install -g @angular/cli -y 

RUN npm install -g n

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY  ./gear2  /project/

# Add a non-privileged user for running Protrator
RUN adduser --home /project --uid 1100 \
  --disabled-login --disabled-password --gecos node node

# Add main configuration file
ADD supervisor.conf /etc/supervisor/supervisor.conf

# Add service definitions for Xvfb, Selenium and Protractor runner
ADD supervisord/*.conf /etc/supervisor/conf.d/

# Container's entry point, executing supervisord in the foreground
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisor.conf"]

# Protractor test project needs to be mounted at /project
VOLUME ["/project"]