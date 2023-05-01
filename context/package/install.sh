#!/bin/bash
CONTEXT=/opt/docker/context

# apt package
apt update && xargs apt install -y < $CONTEXT/package/requirements.apt

# pip package
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.8 get-pip.py
rm get-pip.py

# third party
$CONTEXT/package/install_pyenv.sh
$CONTEXT/package/install_poetry.sh
