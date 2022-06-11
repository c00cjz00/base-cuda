#!/bin/bash

source ~/.bashrc

# Account, bashrc, vim, jupyter setting
cat /opt/docker/context/setting/account | chpasswd
cat /opt/docker/context/setting/bashrc >> /root/.bashrc
cat /opt/docker/context/setting/vimrc >> /usr/share/vim/vimrc
jupyter notebook --generate-config && \
cat /opt/docker/context/jupyter/jupyter_notebook_config.py >> /root/.jupyter/jupyter_notebook_config.py

# Start ssh
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
mkdir -p /run/sshd && \
service ssh start

# Start jupyter
nohup jupyter notebook > /dev/null 2>&1 &

# Check if we should quote the exec params
UNQUOTE=false
if [ "$1" = "--unquote-exec" ]; then
  UNQUOTE=true
  shift
elif [ -n "${UNQUOTE_EXEC}" ] && [[ "${UNQUOTE_EXEC}" =~ ^(true|yes|y)$ ]]; then
  UNQUOTE=true
fi

# Run whatever the user wants.
if [ "${UNQUOTE}" = "true" ]; then
  exec $@
else
  exec "$@"
fi
