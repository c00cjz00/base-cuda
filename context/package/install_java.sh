#!/bin/bash

CONTEXT=/opt/docker/context

# install java
apt update && apt install -y openjdk-8-jdk

# add env
echo "" >> ~/.bashrc
echo "# java" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
