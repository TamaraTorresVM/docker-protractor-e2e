# docker-protractor-e2e
## Dockerfile for Protractor test execution on concourse
Based on caltha/protractor (https://hub.docker.com/r/caltha/protractor/) 
and flexys/docker-protractor (https://hub.docker.com/r/flexys/docker-protractor) 
This image contains a fully configured environment for running Protractor tests

This version additionally add sshpass,python3,pip, sshuttle

# Installed software

- Xvfb The headless X server, for running browsers inside Docker
- node.js The runtime platform for running JavaScript on the server side, including Protractor tests
- npm Node.js package manager used to install Protractor and any specific node.js modules the tests may need
- Selenium webdriver Browser instrumentation agent used by Protractor to execute the tests
- OpenJDK 8 JRE Needed by Selenium
- Chromium The OSS core part of Google Chrome browser
- Protractor An end-to-end test framework for web applications
- Supervisor Process controll system used to manage Xvfb and Selenium background processes needed by Protractor
Running
- sshpass
- python3 in order to get pip 
- pip  in order to get sshuttle 
- ssthuttle
