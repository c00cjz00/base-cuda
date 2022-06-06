# Prepared CUDA based Machine Learning Project Image
- **DockerHub**: [djyoon0223/base](https://hub.docker.com/repository/docker/djyoon0223/base)
```
$ docker pull djyoon0223/base:basic
$ docker pull djyoon0223/base:full
```

# Summary
## - Tag
1. `djyoon0223/base:basic` \
`nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04` + `miniconda` + `jupyter`
2. `djyoon0223/base:full` \
`nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04` + `miniconda` + `jupyter` + `rapids(cudf, cuml)` + `pycaret` + `tensorflow` + `torch` + `opencv`

## - Usage
### 1. `docker run`
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

### 2. `docker-compose`
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
    restart: always
    hostname: "base"
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

# Image building

# 1. `common`: Commonly used files when building images
## 1.1 [`common/.bashrc`](https://github.com/djy-git/base_env/blob/main/common/.bashrc)
Additional `bash` setting
```
### custom configurations
# alias
alias vb='vi ~/.bashrc'
alias sb='source ~/.bashrc'
alias wn='watch -n 0.5 nvidia-smi'
alias jn='jupyter notebook --allow-root &'

# ls color
export LS_COLORS='di=00;36:fi=00;37'
```

## 1.2 [`common/account`](https://github.com/djy-git/base_env/blob/main/common/account)
Format: `ID:PASSWORD`
```
root:1234
```

## 1.3 [`common/jupyter_notebook_config.py`](https://github.com/djy-git/base_env/blob/main/common/jupyter_notebook_config.py)
Additional `jupyter notebook` setting
```
c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '*'
c.NotebookApp.notebook_dir = '/root'
c.NotebookApp.open_browser = False
c.NotebookApp.password = ''
c.NotebookApp.token = ''
```

## 1.4 [`common/jupytertheme.sh`](https://github.com/djy-git/base_env/blob/main/common/jupytertheme.sh)
`jupyter notebook` theme (applied only to `djyoon0223/base:full`) \
Use `$ jt -r` if you want to reset jupyter theme
```
jt -t onedork -cellw 98% -f roboto -fs 10 -nfs 11 -tfs 11 -T
# jt -r  # reset jupyter theme
```

## 1.5 [`common/vimrc`](https://github.com/djy-git/base_env/blob/main/common/vimrc)
Additional `vim` setting
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

## 1.6 [`common/requirements_basic.apt`](https://github.com/djy-git/base_env/blob/main/common/requirements_basic.apt)
`apt` package list for `djyoon0223/base:basic`
```
wget
bzip2
ca-certificates 
curl 
git 
vim 
openssh-server
```

## 1.7 [`common/requirements_full.apt`](https://github.com/djy-git/base_env/blob/main/common/requirements_full.apt)
`apt` package list for `djyoon0223/base:full`
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

## 1.8 [`common/requirements_basic.pip`](https://github.com/djy-git/base_env/blob/main/common/requirements_basic.pip)
`pip` package list for `djyoon0223/base:basic`
```
jupyter
jupyterlab
```

## 1.9 [`common/requirements_full.pip`](https://github.com/djy-git/base_env/blob/main/common/requirements_full.pip)
`pip` package list for `djyoon0223/base:full`
```
```


# 2. Dockerfile
## 2.1 `djyoon0223/base:basic`
[`base.basic.Dockerfile`](https://github.com/djy-git/base_env/blob/main/base.basic.Dockerfile)
```dockerfile
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

# create new env
#RUN conda create -n full -c rapidsai -c nvidia -c conda-forge cudf=22.04 cuml=22.04 python=3.8 cudatoolkit=11.2 numpy=1.19 && \
#    echo "conda activate full" >> ~/.bashrc
#SHELL ["conda", "run", "-n", "full", "/bin/bash", "-c"]
#RUN conda install ipykernel && \
#    python -m ipykernel install --user --name full --display-name "full"
#RUN pip install pycaret[full]==2.3.10 --ignore-installed && \
#    pip install tensorflow==2.9.1 torch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 opencv-python==4.5.5.64 && \
#    pip install numpy==1.20

# ssh setting
RUN apt-get install -y openssh-server && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    mkdir -p /run/sshd

# jupyter setting
RUN pip install jupyter jupyterlab && \
    jupyter notebook --generate-config

# copy common directory
COPY common common

# bashrc, vim, account, jupyter setting
RUN printf "\n# PATH \nexport PATH=$PATH" >> .bashrc && \
    cat common/.bashrc >> .bashrc && \
    apt-get install -y vim && cat common/vimrc >> /usr/share/vim/vimrc && \
    cat common/account | chpasswd && \
    cat common/jupyter_notebook_config.py >> .jupyter/jupyter_notebook_config.py

# install apt, pip packages
RUN xargs apt-get install -y < common/requirements_basic.apt && \
#    xargs apt-get install -y < common/requirements_full.apt && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/*

# install pip packages
RUN pip install -r common/requirements_basic.pip
#    pip install -r common/requirements_full.pip

# clean
RUN rm -r common

# open ssh, jupyter server
ENTRYPOINT service ssh start && jupyter notebook --allow-root
```

## 2.2 `djyoon0223/base:full`
[`base.full.Dockerfile`](https://github.com/djy-git/base_env/blob/main/base.full.Dockerfile)
```dockerfile
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

# create new env
RUN conda create -n full -c rapidsai -c nvidia -c conda-forge cudf=22.04 cuml=22.04 python=3.8 cudatoolkit=11.2 numpy=1.19 && \
    echo "conda activate full" >> ~/.bashrc
SHELL ["conda", "run", "-n", "full", "/bin/bash", "-c"]
RUN conda install ipykernel && \
    python -m ipykernel install --user --name full --display-name "full"
RUN pip install pycaret[full]==2.3.10 --ignore-installed && \
    pip install tensorflow==2.9.1 torch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 opencv-python==4.5.5.64 && \
    pip install numpy==1.20

# ssh setting
RUN apt-get install -y openssh-server && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    mkdir -p /run/sshd

# jupyter setting
RUN pip install jupyter jupyterlab && \
    jupyter notebook --generate-config

# copy common directory
COPY common common

# bashrc, vim, account, jupyter setting
RUN printf "\n# PATH \nexport PATH=$PATH" >> .bashrc && \
    cat common/.bashrc >> .bashrc && \
    apt-get install -y vim && cat common/vimrc >> /usr/share/vim/vimrc && \
    cat common/account | chpasswd && \
    cat common/jupyter_notebook_config.py >> .jupyter/jupyter_notebook_config.py

# install apt, pip packages
RUN xargs apt-get install -y < common/requirements_basic.apt && \
    xargs apt-get install -y < common/requirements_full.apt && \
    apt-get clean && \
    rm -rf /var/lib/ap/lists/*

# install pip packages
RUN pip install -r common/requirements_basic.pip && \
    pip install -r common/requirements_full.pip

# clean
RUN rm -r common

# open ssh, jupyter server
ENTRYPOINT service ssh start && jupyter notebook --allow-root
```
