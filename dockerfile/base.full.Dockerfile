# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
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
RUN cat /opt/docker/context/config/account | chpasswd && \
    . /opt/docker/context/package/install.sh

# create base python interpreter
RUN pyenv install 3.8.16

# create environment: base
RUN pyenv virtualenv 3.8.16 base && \
    pyenv global base && \
    pyenv activate base && \
    . /opt/docker/context/package/install_jupyter.sh

# create environment: torch
RUN pyenv virtualenv 3.8.16 torch && \
    pyenv activate torch && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# create environment: ml(rapids + pycaret)
RUN pyenv virtualenv 3.8.16 ml && \
    pyenv activate ml && \
    pip install pip==21.3.1 && \
    pip install cudf-cu11 cuml-cu11 --extra-index-url=https://pypi.nvidia.com && \
    pip install pycaret

# install extension packages
COPY context/extension /opt/docker/context/extension
RUN pyenv activate base  && . /opt/docker/context/extension/install.sh
RUN pyenv activate torch && . /opt/docker/context/extension/install.sh
RUN pyenv activate ml    && . /opt/docker/context/extension/install.sh

# clean
RUN rm -rf /var/lib/apt/lists/*

# run entrypoint.sh
ENTRYPOINT [ "/opt/docker/context/entrypoint/entrypoint.sh" ]
CMD [ "/bin/bash" ]
