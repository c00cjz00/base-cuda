#!/bin/bash

CONTEXT=/opt/docker/context

# apt package
apt update && xargs apt install -y < $CONTEXT/package/requirements.apt

# bashrc
cat $CONTEXT/package/bashrc >> ~/.bashrc

# vim
cat $CONTEXT/package/vimrc >> /usr/share/vim/vimrc

# ssh
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
mkdir -p /run/sshd

# python
ln -s /usr/bin/python3 /usr/bin/python
apt install -y python3-pip

# pyenv
. $CONTEXT/package/install_pyenv.sh

# poetry
. $CONTEXT/package/install_poetry.sh
