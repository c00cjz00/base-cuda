# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
LABEL maintainer="djyoon0223@gmail.com"

# ignore interaction
ARG DEBIAN_FRONTEND=noninteractive

# environment
SHELL ["/bin/bash", "-ic"]
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR $HOME

# copy context
COPY context/config     /opt/docker/context/config
COPY context/entrypoint /opt/docker/context/entrypoint
COPY context/package    /opt/docker/context/package

# install fundamental apt packages
RUN apt update && \
    xargs apt install -y < /opt/docker/context/package/requirements.apt && \
    rm -rf /var/lib/apt/lists/*

# set fundamental configuration
RUN cat /opt/docker/context/config/account | chpasswd && \
    cat /opt/docker/context/config/sshd_config >> /etc/ssh/sshd_config && \
    cat /opt/docker/context/config/bashrc >> /root/.bashrc && \
    cat /opt/docker/context/config/vimrc >> /usr/share/vim/vimrc

# install python
RUN /opt/docker/context/package/install_python.sh

# install pyenv
RUN /opt/docker/context/package/install_pyenv.sh

# install poetry
RUN /opt/docker/context/package/install_poetry.sh

# install java
RUN /opt/docker/context/package/install_java.sh

# install extension packages
COPY context/extension /opt/docker/context/extension
RUN /opt/docker/context/extension/install.sh

# run entrypoint.sh
ENTRYPOINT [ "/opt/docker/context/entrypoint/entrypoint.sh" ]
CMD [ "/bin/bash" ]
