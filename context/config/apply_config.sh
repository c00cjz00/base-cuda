#!/bin/bash

cat /opt/docker/context/config/account | chpasswd
cat /opt/docker/context/config/bashrc >> /root/.bashrc
cat /opt/docker/context/config/vimrc >> /usr/share/vim/vimrc
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
mkdir -p /run/sshd
