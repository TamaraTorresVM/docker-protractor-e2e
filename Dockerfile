
FROM pcfkubo/kubo-ci:stable

LABEL maintainer="ttorres@vmware.com"

RUN apt-get update -y && \
    apt-get install -y \
        openssl \
        vim \
        bash \
        xvfb \
        npm \
        sshpass \
        wget \
        python \
        python-pip \
        supervisor \
        ffmpeg\
        openjdk-8-jre

RUN python -m pip install --upgrade pip setuptools wheel

RUN  wget -qO- https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/1.7.7/credhub-linux-1.7.7.tgz | tar xvz && mv credhub /usr/bin

RUN npm install npm@latest -g

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
  apt-get update --fix-missing && \
  apt-get install -y nodejs chromium-browser

RUN gem install cf-uaac -v '4.1.0'

RUN npm install -g protractor && \
  webdriver-manager update

RUN npm install -g @angular/cli -y

# Add a non-privileged user for running Protrator
RUN adduser --home /project --uid 1100 \
  --disabled-login --disabled-password --gecos node node

# Add main configuration file
ADD supervisor.conf /etc/supervisor/supervisor.conf

# Add service definitions for Xvfb, Selenium and Protractor runner
ADD supervisord/*.conf /etc/supervisor/conf.d/

# Container's entry point, executing supervisord in the foreground
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisor.conf"]

# Cleanup to make the docker image small
RUN  apt-get -y remove && apt-get -y autoremove && rm -rf /var/cache/apk/*

# Protractor test project needs to be mounted at /project
VOLUME ["/project"]
