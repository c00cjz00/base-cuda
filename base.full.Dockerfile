# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04

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

# install fundamental packages
COPY context/package/requirements_basic.apt /opt/docker/context/requirements_basic.apt
COPY context/package/requirements_basic.pip /opt/docker/context/requirements_basic.pip
RUN xargs apt-get install -y < /opt/docker/context/requirements_basic.apt && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/* && \
    pip install -r /opt/docker/context/requirements_basic.pip

# copy context directory
COPY context /opt/docker/context

# create new env
RUN conda create -n full -c rapidsai -c nvidia -c conda-forge cudf=22.04 cuml=22.04 python=3.8 cudatoolkit=11.2 numpy=1.19 && \
    echo "conda activate full" >> /root/.bashrc
SHELL ["conda", "run", "-n", "full", "/bin/bash", "-c"]
RUN conda install ipykernel && \
    python -m ipykernel install --user --name full --display-name "full"
RUN pip install pycaret[full]==2.3.10 --ignore-installed && \
    pip install tensorflow==2.9.1 torch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 opencv-python==4.5.5.64 && \
    pip install numpy==1.20

# install additional apt packages
RUN xargs apt-get install -y < /opt/docker/context/package/requirements_full.apt && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/* && \
    pip install -r /opt/docker/context/package/requirements_basic.pip && \
    pip install -r /opt/docker/context/package/requirements_full.pip

# run entrypoint.sh
ENTRYPOINT [ "/usr/bin/tini", "--", "/opt/docker/context/bin/entrypoint.sh" ]
CMD [ "/bin/bash" ]
