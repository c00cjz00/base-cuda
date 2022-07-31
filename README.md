# Prepared CUDA based Image for Machine Learning Project
- **DockerHub**: [djyoon0223/base](https://hub.docker.com/repository/docker/djyoon0223/base)
```
$ docker pull djyoon0223/base:basic
$ docker pull djyoon0223/base:caret
$ docker pull djyoon0223/base:tf_torch
$ docker pull djyoon0223/base:full
```

# Ⅰ. Base Image
[`nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04`](https://hub.docker.com/r/nvidia/cuda/tags)


# Ⅱ. Tag
1. `djyoon0223/base:basic`
   - `base`: `jupyter`
2. `djyoon0223/base:caret`
   - `caret`: `jupyter` + `rapids(cudf, cuml)=22.02` + `pycaret=3.0.0`
3. `djyoon0223/base:tf_torch`
   - `tf_torch`: `jupyter` + `rapids=22.02` + `tensorflow=2.9.1` + `torch=1.12` + `torchvision=0.13` + `torchaudio=0.12`
4. `djyoon0223/base:full`
   - `caret`: `djyoon0223/base:caret`
   - `tf_torch`: `djyoon0223/base:tf_torch`


# Ⅲ. Usage
## 1. `docker run`
```
$ sudo docker run \
--name compute_server \
--hostname base \
--gpus '"device=0"'
--ipc host \
--restart always \
--privileged \
-v /root/project:/root/project \
-p 10022:22 \
-p 13306:3306 \
-p 15000:5000 \
-p 15006:5006 \
-p 16000:6000 \
-p 16006:6006 \
-p 18786:8786 \
-p 18787:8787 \
-p 18888:8888 \
-p 18889:8889 \
-itd \
djyoon0223/base:full
```

## 2. `docker-compose`
[`docker-compose.yaml`](https://github.com/djy-git/base_env/blob/main/docker-compose.yaml)
```
version: "3.8"
services:
  compute_server:
    image: djyoon0223/base:full
    ports:
      - 10022:22
      - 13306:3306
      - 15000:5000
      - 15006:5006
      - 16000:6000
      - 16006:6006
      - 18786:8786
      - 18787:8787
      - 18888:8888
      - 18889:8889
    volumes:
      - /root/project:/root/project
    hostname: "base"
    restart: always
    tty: true
    ipc: host
    privileged: true
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              device_ids: ['0']
              capabilities: [gpu]
```

`$ sudo docker-compose up -d`


---


# Ⅳ. Building Image
## 1. `context`: Commonly used files for building images
### 1.1 `context/setting`: `bashrc`, `account`, `vimrc` Settings
#### 1.1.1 [`context/setting/bashrc`](https://github.com/djy-git/base_env/blob/main/context/setting/bashrc): Additional `bash` setting
```
### custom configurations
# env
export LS_COLORS='di=00;36:fi=00;37'
export PATH=$PATH:.

# alias
alias vb='vi ~/.bashrc'
alias sb='source ~/.bashrc'
alias wn='watch -n 0.5'
alias wnnv='watch -n 0.5 nvidia-smi'
alias jn='nohup jupyter notebook > /dev/null 2>&1 &'
```

#### 1.1.2 [`context/setting/account`](https://github.com/djy-git/base_env/blob/main/context/setting/account): `USER:PASSWORD`
```
root:1234
```

#### 1.1.3 [`context/setting/vimrc`](https://github.com/djy-git/base_env/blob/main/context/setting/vimrc): Additional `vim` setting
```
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

set hlsearch
set nu
set autoindent
set ts=4
set sts=4
set cindent
set laststatus=2
set shiftwidth=4
set smarttab
set smartindent
set ruler
set fileencodings=etf8,euc-kr
set viminfo=
colorscheme desert
```

### 1.2 `package`: `apt`, `pip` packages
#### 1.2.1 [`context/package/requirements_basic.apt`](https://github.com/djy-git/base_env/blob/main/context/package/requirements_basic.apt): basic `apt` packages
```
wget
bzip2
ca-certificates 
curl 
git 
vim 
openssh-server
```

#### 1.2.2 [`context/package/requirements_expansion.apt`](https://github.com/djy-git/base_env/blob/main/context/package/requirements_expansion.apt): expansion `apt` packages 
```
htop
net-tools
iproute2
ubuntu-drivers-common
build-essential
rinetd 
unzip 
libgl1-mesa-glx
```

#### 1.2.3 [`context/package/requirements_basic.pip`](https://github.com/djy-git/base_env/blob/main/context/package/requirements_basic.pip): basic `pip` packages
```
jupyter
jupyterlab
```

#### 1.2.4 [`context/package/requirements_expansion.pip`](https://github.com/djy-git/base_env/blob/main/context/package/requirements_expansion.pip): expansion `pip` packages
```
```

### 1.3 `context/jupyter`: `jupyter` settings
#### 1.3.1 [`context/jupyter/jupyter_notebook_config.py`](https://github.com/djy-git/base_env/blob/main/context/jupyter/jupyter_notebook_config.py): `jupyter` setting
```
c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '*'
c.NotebookApp.notebook_dir = '/root'
c.NotebookApp.open_browser = False
c.NotebookApp.password = ''
c.NotebookApp.token = ''
c.NotebookApp.allow_root = True
```

#### 1.3.2 [`context/jupyter/jupytertheme.sh`](https://github.com/djy-git/base_env/blob/main/context/jupyter/jupytertheme.sh): Apply `jupyter` theme
Reset `jupyter` theme: `$ jt -r`
```
pip install jupyterthemes
jt -t onedork -cellw 98% -f roboto -fs 10 -nfs 11 -tfs 11 -T
```

### 1.4 `context/bin`: Shell scripts
#### 1.4.1 [`context/bin/entrypoint.sh`](https://github.com/djy-git/base_env/blob/main/context/bin/entrypoint.sh): `entrypoint` for Dockerfile
```
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
```


## 2. Dockerfile
### 2.1 `djyoon0223/base:basic`: [`base.basic.Dockerfile`](https://github.com/djy-git/base_env/blob/main/base.basic.Dockerfile)
```dockerfile
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

## create environment: caret (rapids + pycaret)
#RUN conda create -n caret -c rapidsai -c nvidia -c conda-forge cuml=22.02 cudf=22.02 python=3.8 cudatoolkit=11.4
#SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
#RUN pip install --pre pycaret
#RUN conda install -c nvidia cuda-python=11.7.0
#RUN conda install ipykernel && \
#    python -m ipykernel install --user --name caret --display-name "caret"
#
## create environment: tf_torch (rapids + tensorflow + torch)
#RUN conda create -n tf_torch -c rapidsai -c nvidia -c pytorch -c conda-forge rapids=22.02 python=3.8 cudatoolkit=11.3 pytorch=1.12 torchvision=0.13 torchaudio=0.12
#SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
#RUN pip install tensorflow==2.9.1
#RUN conda install -c nvidia cuda-python=11.7.0
#RUN conda install ipykernel && \
#    python -m ipykernel install --user --name tf_torch --display-name "tf_torch"
#
## install additional apt packages
#COPY context/package/requirements_expansion.apt /opt/docker/context/package/requirements_expansion.apt
#COPY context/package/requirements_expansion.pip /opt/docker/context/package/requirements_expansion.pip
#RUN xargs apt-get install -y < /opt/docker/context/package/requirements_expansion.apt && \
#    apt-get clean && \
#    rm -rf /var/lib/ap/lists/*
#
## install additional pip packages for environment caret
#SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
#RUN pip install -r /opt/docker/context/package/requirements_basic.pip && \
#    pip install -r /opt/docker/context/package/requirements_expansion.pip
#
## install additional pip packages for environment tf_torch
#SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
#RUN pip install -r /opt/docker/context/package/requirements_basic.pip && \
#    pip install -r /opt/docker/context/package/requirements_expansion.pip

# copy context directory
COPY context /opt/docker/context

# run entrypoint.sh
RUN chmod +x /opt/docker/context/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/tini", "--", "/opt/docker/context/bin/entrypoint.sh" ]
CMD [ "/bin/bash" ]
```

### 2.2 `djyoon0223/base:caret`: [`base.caret.Dockerfile`](https://github.com/djy-git/base_env/blob/main/base.caret.Dockerfile)
```dockerfile
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
RUN conda create -n caret -c rapidsai -c nvidia -c conda-forge cuml=22.02 cudf=22.02 python=3.8 cudatoolkit=11.4
SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
RUN pip install --pre pycaret
RUN conda install -c nvidia cuda-python=11.7.0
RUN conda install ipykernel && \
    python -m ipykernel install --user --name caret --display-name "caret"

## create environment: tf_torch (rapids + tensorflow + torch)
#RUN conda create -n tf_torch -c rapidsai -c nvidia -c pytorch -c conda-forge rapids=22.02 python=3.8 cudatoolkit=11.3 pytorch=1.12 torchvision=0.13 torchaudio=0.12
#SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
#RUN pip install tensorflow==2.9.1
#RUN conda install -c nvidia cuda-python=11.7.0
#RUN conda install ipykernel && \
#    python -m ipykernel install --user --name tf_torch --display-name "tf_torch"

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

## install additional pip packages for environment tf_torch
#SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
#RUN pip install -r /opt/docker/context/package/requirements_basic.pip && \
#    pip install -r /opt/docker/context/package/requirements_expansion.pip

# copy context directory
COPY context /opt/docker/context

# run entrypoint.sh
RUN chmod +x /opt/docker/context/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/tini", "--", "/opt/docker/context/bin/entrypoint.sh" ]
CMD [ "/bin/bash" ]
```

### 2.3 `djyoon0223/base:tf_torch`: [`base.tf_torch.Dockerfile`](https://github.com/djy-git/base_env/blob/main/base.tf_torch.Dockerfile)
```dockerfile
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

## create environment: caret (rapids + pycaret)
#RUN conda create -n caret -c rapidsai -c nvidia -c conda-forge cuml=22.02 cudf=22.02 python=3.8 cudatoolkit=11.4
#SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
#RUN pip install --pre pycaret
#RUN conda install -c nvidia cuda-python=11.7.0
#RUN conda install ipykernel && \
#    python -m ipykernel install --user --name caret --display-name "caret"

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

## install additional pip packages for environment caret
#SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
#RUN pip install -r /opt/docker/context/package/requirements_basic.pip && \
#    pip install -r /opt/docker/context/package/requirements_expansion.pip

# install additional pip packages for environment tf_torch
SHELL ["conda", "run", "-n", "tf_torch", "/bin/bash", "-c"]
RUN pip install -r /opt/docker/context/package/requirements_basic.pip && \
    pip install -r /opt/docker/context/package/requirements_expansion.pip

# copy context directory
COPY context /opt/docker/context

# run entrypoint.sh
RUN chmod +x /opt/docker/context/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/tini", "--", "/opt/docker/context/bin/entrypoint.sh" ]
CMD [ "/bin/bash" ]
```

### 2.4 `djyoon0223/base:full`: [`base.full.Dockerfile`](https://github.com/djy-git/base_env/blob/main/base.full.Dockerfile)
```dockerfile
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
RUN conda create -n caret -c rapidsai -c nvidia -c conda-forge cuml=22.02 cudf=22.02 python=3.8 cudatoolkit=11.4
SHELL ["conda", "run", "-n", "caret", "/bin/bash", "-c"]
RUN pip install --pre pycaret
RUN conda install -c nvidia cuda-python=11.7.0
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

# run entrypoint.sh
RUN chmod +x /opt/docker/context/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/tini", "--", "/opt/docker/context/bin/entrypoint.sh" ]
CMD [ "/bin/bash" ]
```
