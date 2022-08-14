# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04

# ignore interaction
ARG DEBIAN_FRONTEND=noninteractive

# environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH $PATH:/opt/conda/bin:.
WORKDIR /root

# install miniconda
RUN apt-get update && \
    apt-get install -y wget && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# install basic packages
COPY context/package/requirements_basic.apt /opt/docker/context/package/requirements_basic.apt
COPY context/package/requirements_basic.pip /opt/docker/context/package/requirements_basic.pip
RUN xargs apt-get install -y < /opt/docker/context/package/requirements_basic.apt && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/* && \
    pip install -r /opt/docker/context/package/requirements_basic.pip

# create environment: caret (rapids + pycaret)
RUN conda create -n caret -c rapidsai -c nvidia -c conda-forge cuml=0.19 python=3.8 cudatoolkit=11.2
SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
RUN rm -r /opt/conda/envs/caret/lib/python3.8/site-packages/llvmlite*
RUN pip install pycaret[full]
RUN conda install ipykernel && \
    python -m ipykernel install --user --name caret --display-name "caret"

# create environment: tf_torch (rapids + tensorflow + torch)
RUN conda create -n tf_torch -c rapidsai -c nvidia -c pytorch -c conda-forge rapids=22.02 python=3.8 cudatoolkit=11.3 pytorch=1.12 torchvision=0.13 torchaudio=0.12
SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
RUN pip install tensorflow==2.9.1
RUN conda install -c nvidia cuda-python=11.7.0
RUN conda install ipykernel && \
    python -m ipykernel install --user --name tf_torch --display-name "tf_torch"

# install additional apt packages
COPY context/package/requirements_expansion.apt /opt/docker/context/package/requirements_expansion.apt
COPY context/package/requirements_expansion.pip /opt/docker/context/package/requirements_expansion.pip
RUN xargs apt-get install -y < /opt/docker/context/package/requirements_expansion.apt && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/*

# install additional pip packages for environment caret
SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
RUN pip install -r /opt/docker/context/package/requirements_basic.pip && \
    pip install -r /opt/docker/context/package/requirements_expansion.pip

# install additional pip packages for environment tf_torch
SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
RUN pip install -r /opt/docker/context/package/requirements_basic.pip && \
    pip install -r /opt/docker/context/package/requirements_expansion.pip

# copy context directory
COPY context /opt/docker/context

# account, bashrc, vim setting
RUN cat /opt/docker/context/setting/account | chpasswd && \
    cat /opt/docker/context/setting/bashrc >> /root/.bashrc && \
    cat /opt/docker/context/setting/vimrc >> /usr/share/vim/vimrc && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    mkdir -p /run/sshd

# jupyter setting
RUN jupyter notebook --generate-config && \
    cat /opt/docker/context/jupyter/jupyter_notebook_config.py >> /root/.jupyter/jupyter_notebook_config.py

# run entrypoint.sh
RUN chmod +x /opt/docker/context/bin/entrypoint.sh
ENTRYPOINT [ "/opt/docker/context/bin/entrypoint.sh" ]
CMD [ "/bin/bash" ]
