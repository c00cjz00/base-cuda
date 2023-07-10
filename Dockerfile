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
COPY context/test       /opt/docker/context/test

# apply fundamental configuration
RUN /opt/docker/context/package/install.sh && \
    /opt/docker/context/package/install_jupyter.sh && \
    cat /opt/docker/context/config/account | chpasswd && \
    cat /opt/docker/context/config/sshd_config >> /etc/ssh/sshd_config && \
    cat /opt/docker/context/config/bashrc >> /root/.bashrc && \
    cat /opt/docker/context/config/vimrc >> /usr/share/vim/vimrc

# install extension packages
COPY context/extension /opt/docker/context/extension
RUN /opt/docker/context/extension/install.sh

# clean
RUN rm -rf /var/lib/apt/lists/*

# run entrypoint.sh
ENTRYPOINT [ "/opt/docker/context/entrypoint/entrypoint.sh" ]
CMD [ "/bin/bash" ]
