#!/bin/bash

CONTEXT=/opt/docker/context

# apt package
apt update && \
xargs apt install -y < $CONTEXT/package/requirements.apt && \
rm -rf /var/lib/apt/lists/*

# python 3.8, 3.9, 3.10
$CONTEXT/package/install_python.sh

# pyenv
$CONTEXT/package/install_pyenv.sh

# poetry
$CONTEXT/package/install_poetry.sh

# java
$CONTEXT/package/install_java.sh
