# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# ignore interaction
ARG DEBIAN_FRONTEND=noninteractive

# environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR $HOME

# copy context
COPY context /opt/docker/context

# apply fundamental setting
RUN /opt/docker/context/config/apply.sh && \
    /opt/docker/context/package/install.sh


## install basic packages
#COPY context/package/requirements.apt /opt/docker/context/package/requirements.apt
#COPY context/package/requirements.pip /opt/docker/context/package/requirements.pip
#RUN apt-get update && \
#    xargs apt-get install -y < /opt/docker/context/package/requirements.apt && \
#    pip install -r /opt/docker/context/package/requirements.pip
#
### create environment: pycaret (cuml + pycaret)
##RUN conda create -n pycaret -c rapidsai -c nvidia -c conda-forge cuml=0.19 python=3.8 cudatoolkit=11.2
##SHELL ["conda", "run", "-n", "pycaret", "/bin/bash", "-c"]
##RUN rm -r /opt/conda/envs/pycaret/lib/python3.8/site-packages/llvmlite*
##RUN pip install pycaret[full]==2.3.10
##RUN conda install ipykernel && \
##    python -m ipykernel install --user --name pycaret --display-name "pycaret"
##
### create environment: tf_torch (rapids + tensorflow + torch)
##RUN conda create -n tf_torch -c rapidsai -c nvidia -c pytorch -c conda-forge rapids=22.02 python=3.8 cudatoolkit=11.3 pytorch=1.12 torchvision=0.13 torchaudio=0.12
##SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
##RUN pip install tensorflow==2.9.1
##RUN conda install -c nvidia cuda-python=11.7.0
##RUN conda install ipykernel && \
##    python -m ipykernel install --user --name tf_torch --display-name "tf_torch"
#
## copy context directory
#COPY context /opt/docker/context
#RUN chmod 755 $(find /opt/docker/context -type f)
#
### install additional apt packages
##RUN apt-get update && \
##    xargs apt-get install -y < /opt/docker/context/package/requirements_expansion.apt
#
### install third party packages
##RUN /opt/docker/context/package/other/install_syncthing.sh && \
##    /opt/docker/context/package/other/install_nanum.sh
#
## install pip packages for environments
#RUN /opt/docker/context/package/install_pip.sh
#
## common configuration
#RUN /opt/docker/context/config/apply.sh
#
## remove apt cache
#RUN rm -rf /var/lib/apt/lists/*
#
## configure jupyter
#RUN jupyter notebook --generate-config && \
#    cat /opt/docker/context/package/jupyter/jupyter_notebook_config.py >> ~/.jupyter/jupyter_notebook_config.py

# run entrypoint.sh
ENTRYPOINT [ "/opt/docker/context/entrypoint/entrypoint.sh" ]
CMD [ "/bin/bash" ]