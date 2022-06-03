# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04

# ignore interaction
ARG DEBIAN_FRONTEND=noninteractive

# environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH:.
WORKDIR /root

# apt packages
RUN apt-get update && \
    apt-get install -y wget bzip2 ca-certificates curl git vim openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/*

# ssh setting
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    mkdir -p /run/sshd

# install miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# create new env
RUN conda create -n full -c rapidsai -c nvidia -c conda-forge cudf=22.04 cuml=22.04 python=3.8 cudatoolkit=11.2 numpy=1.19 && \
    echo "conda activate full" >> ~/.bashrc
SHELL ["conda", "run", "-n", "full", "/bin/bash", "-c"]
RUN conda install ipykernel
RUN python -m ipykernel install --user --name full --display-name "full"
RUN pip install pycaret[full]==2.3.10 --ignore-installed && \
    pip install tensorflow==2.9.1 torch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 opencv-python==4.5.5.64 && \
    pip install numpy==1.20

# apt packages
RUN apt-get update && apt-get install -y \
    htop net-tools iproute2 ubuntu-drivers-common build-essential rinetd unzip libgl1-mesa-glx && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/*

# vim, bashrc, account setting
COPY common common
RUN cat common/vimrc >> /usr/share/vim/vimrc && \
    cat common/.bashrc >> .bashrc && \
    cat common/account | chpasswd

# jupyter setting
RUN pip install jupyter jupyterlab && \
    jupyter notebook --generate-config && \
    cat common/jupyter_notebook_config.py >> .jupyter/jupyter_notebook_config.py
RUN pip install jupyterthemes && \
    chmod +x common/jupytertheme.sh && \
    common/jupytertheme.sh

# clean
RUN rm -r common

# open ssh, jupyter server
ENTRYPOINT service ssh start && jupyter notebook --allow-root
