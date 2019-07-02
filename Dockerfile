FROM ubuntu:xenial

LABEL maintainer="ttorres@vmware.com"

RUN apt-get update && \
    apt-get install -y \
        openssl \
        bash \
        curl \
        vim \
        xvfb \
        wget \
        npm \
        build-essential \
        sshpass \
        ffmpeg \
        python3 \
        supervisor \
        nodejs \
        libgconf-2-4 \
        libexif12 \
        netcat-traditional \
        jq \
        ffmpeg\
        openjdk-8-jre

#Update pip and install sshuttle
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip install sshuttle

#Install chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get update --fix-missing && \
  apt-get install -y nodejs chromium-browser

RUN npm install -g protractor && \
  webdriver-manager update
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a non-privileged user for running Protrator
RUN adduser --home /project --uid 1100 \
  --disabled-login --disabled-password --gecos node node

# Add main configuration file
ADD supervisor.conf /etc/supervisor/supervisor.conf

# Add service defintions for Xvfb, Selenium and Protractor runner
ADD supervisord/*.conf /etc/supervisor/conf.d/

# Container's entry point, executing supervisord in the foreground
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisor.conf"]

# Protractor test project needs to be mounted at /project
VOLUME ["/project"]