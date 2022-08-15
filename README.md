# Prepared CUDA based Image for Machine Learning Project
- **GitHub**: [djyoon0223/base](https://github.com/djy-git/base)
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
   - `caret`: `jupyter` + `rapids(cuml)=0.19` + `pycaret[full]=2.3.10` + `cudatoolkit=11.2`
3. `djyoon0223/base:tf_torch`
   - `tf_torch`: `jupyter` + `rapids=22.02` + `tensorflow=2.9.1` + `torch=1.12` + `torchvision=0.13` + `torchaudio=0.12` + `cudatoolkit=11.3`
4. `djyoon0223/base:full`
   - `caret`: `djyoon0223/base:caret`
   - `tf_torch`: `djyoon0223/base:tf_torch`


# Ⅲ. Usage
## 1. [`docker run`](https://github.com/djy-git/base/blob/main/docker-run.sh)
```
sudo docker run \
--name compute_server \
--hostname base \
--gpus '"device=0"' \ 
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
[`docker-compose.yaml`](https://github.com/djy-git/base/blob/main/docker-compose.yaml)
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
#### 1.1.1 [`context/setting/bashrc`](https://github.com/djy-git/base/blob/main/context/setting/bashrc)
Additional `bash` setting

#### 1.1.2 [`context/setting/account`](https://github.com/djy-git/base/blob/main/context/setting/account)
`USER:PASSWORD`

#### 1.1.3 [`context/setting/vimrc`](https://github.com/djy-git/base/blob/main/context/setting/vimrc)
Additional `vim` setting

### 1.2 `context/package`: `apt`, `pip` packages
#### 1.2.1 [`context/package/requirements_basic.apt`](https://github.com/djy-git/base/blob/main/context/package/requirements_basic.apt)
Basic `apt` packages

#### 1.2.2 [`context/package/requirements_expansion.apt`](https://github.com/djy-git/base/blob/main/context/package/requirements_expansion.apt)
Expansion `apt` packages 

#### 1.2.3 [`context/package/requirements_basic.pip`](https://github.com/djy-git/base/blob/main/context/package/requirements_basic.pip)
Basic `pip` packages

#### 1.2.4 [`context/package/requirements_expansion.pip`](https://github.com/djy-git/base/blob/main/context/package/requirements_expansion.pip)
Expansion `pip` packages


### 1.3 `context/jupyter`: `jupyter` settings
#### 1.3.1 [`context/jupyter/jupyter_notebook_config.py`](https://github.com/djy-git/base/blob/main/context/jupyter/jupyter_notebook_config.py)
`jupyter` setting

#### 1.3.2 [`context/jupyter/jupytertheme.sh`](https://github.com/djy-git/base/blob/main/context/jupyter/jupytertheme.sh)
Apply `jupyter` theme (Reset `jupyter` theme: `$ jt -r`)

### 1.4 `context/bin`: Shell scripts
#### 1.4.1 [`context/bin/entrypoint.sh`](https://github.com/djy-git/base/blob/main/context/bin/entrypoint.sh)
`entrypoint` for Dockerfile

### 1.5 `context/test`: Pytest scripts
#### 1.5.1 [`context/test/caret.py`](https://github.com/djy-git/base/blob/main/context/test/caret.py)
#### 1.5.2 [`context/test/tf_torch.py`](https://github.com/djy-git/base/blob/main/context/test/tf_torch.py)


## 2. Dockerfile
### 2.1 [`djyoon0223/base:basic`](https://github.com/djy-git/base/blob/main/base.basic.Dockerfile)
### 2.2 [`djyoon0223/base:caret`](https://github.com/djy-git/base/blob/main/base.caret.Dockerfile)
### 2.3 [`djyoon0223/base:tf_torch`](https://github.com/djy-git/base/blob/main/base.tf_torch.Dockerfile)
### 2.4 [`djyoon0223/base:full`](https://github.com/djy-git/base/blob/main/base.full.Dockerfile)
