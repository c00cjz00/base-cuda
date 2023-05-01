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
RUN apt-get update && \
    xargs apt-get install -y < /opt/docker/context/package/requirements.apt && \
    pip install -r /opt/docker/context/package/requirements.pip

## create environment: pycaret (cuml + pycaret)
#RUN conda create -n pycaret -c rapidsai -c nvidia -c conda-forge cuml=0.19 python=3.8 cudatoolkit=11.2
#SHELL ["conda", "run", "-n", "pycaret", "/bin/bash", "-c"]
#RUN rm -r /opt/conda/envs/pycaret/lib/python3.8/site-packages/llvmlite*
#RUN pip install pycaret[full]==2.3.10
#RUN conda install ipykernel && \
#    python -m ipykernel install --user --name pycaret --display-name "pycaret"

# create environment: tf_torch (rapids + tensorflow + torch)
RUN conda create -n tf_torch -c rapidsai -c nvidia -c pytorch -c conda-forge rapids=22.02 python=3.8 cudatoolkit=11.3 pytorch=1.12 torchvision=0.13 torchaudio=0.12
SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
RUN pip install tensorflow==2.9.1
RUN conda install -c nvidia cuda-python=11.7.0
RUN conda install ipykernel && \
    python -m ipykernel install --user --name tf_torch --display-name "tf_torch"

# copy context directory
COPY context /opt/docker/context
RUN chmod 755 $(find /opt/docker/context -type f)

# install additional apt packages
RUN apt-get update && \
    xargs apt-get install -y < /opt/docker/context/package/requirements_expansion.apt

# install third party packages
RUN /opt/docker/context/package/other/install_syncthing.sh && \
    /opt/docker/context/package/other/install_nanum.sh tf_torch

# install pip packages for environments
RUN /opt/docker/context/package/install_pip.sh tf_torch

# common configuration
RUN /opt/docker/context/config/apply.sh

# remove apt cache
RUN rm -rf /var/lib/apt/lists/*

# configure jupyter
RUN jupyter notebook --generate-config && \
    cat /opt/docker/context/package/jupyter/jupyter_notebook_config.py >> ~/.jupyter/jupyter_notebook_config.py

# run entrypoint.sh
ENTRYPOINT [ "/opt/docker/context/entrypoint/entrypoint.sh" ]
CMD [ "/bin/bash" ]