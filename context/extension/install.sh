#!/bin/bash

CONTEXT=/opt/docker/context

# apt package
xargs apt install -y < $CONTEXT/extension/requirements.apt

# pypi package
pip install -r $CONTEXT/extension/requirements.pip
