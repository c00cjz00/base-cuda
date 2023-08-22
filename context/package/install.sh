#!/bin/bash

CONTEXT=/opt/docker/context

# apt package
apt update && xargs apt install -y < $CONTEXT/package/requirements.apt

# python
ln -s /usr/bin/python3 /usr/bin/python
apt install -y python3-pip

# pyenv
$CONTEXT/package/install_pyenv.sh

# poetry
$CONTEXT/package/install_poetry.sh

# java
$CONTEXT/package/install_java.sh
