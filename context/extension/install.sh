#!/bin/bash

CONTEXT=/opt/docker/context
VIRTUALENV=pyenv version | awk '{print $1}'

# apt package
xargs apt install -y < $CONTEXT/extension/requirements.apt

# python package
pip install -r $CONTEXT/extension/requirements.pip

# install nanum fonts
. $CONTEXT/extension/install_nanum.sh

# add kernel
python -m ipykernel install --user --name "$VIRTUALENV" --display-name "$VIRTUALENV"
