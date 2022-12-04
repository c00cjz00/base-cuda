#!/bin/bash

ROOT=/opt/docker/context/config

cat $ROOT/account | chpasswd
cat $ROOT/bashrc >> ~/.bashrc
cat $ROOT/vimrc >> /usr/share/vim/vimrc
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
mkdir -p /run/sshd