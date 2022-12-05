# Prepared CUDA based Image for Machine Learning Project
- **GitHub**: [djyoon0223/base](https://github.com/djy-git/base)
- **DockerHub**: [djyoon0223/base](https://hub.docker.com/repository/docker/djyoon0223/base)
```
$ docker pull djyoon0223/base:basic
$ docker pull djyoon0223/base:pycaret
$ docker pull djyoon0223/base:tf_torch
$ docker pull djyoon0223/base:full
```


# Ⅰ. Base Image
[`nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04`](https://hub.docker.com/r/nvidia/cuda/tags)


# Ⅱ. Tag
1. `djyoon0223/base:basic`
   - `base`: `jupyter`
2. `djyoon0223/base:pycaret`
   - `pycaret`: `jupyter` + `rapids(cuml)=0.19` + `pycaret[full]=2.3.10` + `cudatoolkit=11.2`
3. `djyoon0223/base:tf_torch`
   - `tf_torch`: `jupyter` + `rapids=22.02` + `tensorflow=2.9.1` + `torch=1.12` + `torchvision=0.13` + `torchaudio=0.12` + `cudatoolkit=11.3`
4. `djyoon0223/base:full`
   - `pycaret`: `djyoon0223/base:pycaret`
   - `tf_torch`: `djyoon0223/base:tf_torch`


# Ⅲ. Usage
## 1. [`docker run`](https://github.com/djy-git/base/blob/main/run.sh)
```
$ sudo docker run \
--name "compute-server" \
--hostname "3090" \
--gpus '"device=0"' \
--ipc host \
--restart always \
--privileged \
-v /workspace/shared:/workspace \
-v /workspace2/shared:/workspace2 \
-p 10022:22 \
-p 13306:3306 \
-p 15000:5000 \
-p 15006:5006 \
-p 16000:6000 \
-p 16006:6006 \
-p 17860:7860 \
-p 18000:8000 \
-p 18384:8384 \
-p 18786:8786 \
-p 18787:8787 \
-p 18888:8888 \
-p 22000:22000 \
-p 10000-10010:10000-10010 \
-itd \
djyoon0223/base:full
```

## 2. [`docker-compose`](https://github.com/djy-git/base/blob/main/docker-compose.yaml)
```
$ sudo docker-compose up -d
```


---


# Ⅳ. Building Image
## 1. `context`: Commonly used files for building images
### 1.1 `context/config`: `bashrc`, `account`, `vimrc` Settings
#### 1.1.1 [`context/config/bashrc`](https://github.com/djy-git/base/blob/main/context/config/bashrc)
Additional `bash` setting

#### 1.1.2 [`context/config/account`](https://github.com/djy-git/base/blob/main/context/config/account)
`USER:PASSWORD`

#### 1.1.3 [`context/config/vimrc`](https://github.com/djy-git/base/blob/main/context/config/vimrc)
Additional `vim` setting

#### 1.1.4 [`context/config/apply_config.sh`](https://github.com/djy-git/base/blob/main/context/config/apply_config.sh)
Apply config settings


### 1.2 `context/package`: `apt`, `pip` packages
#### 1.2.1 [`context/package/requirements_basic.apt`](https://github.com/djy-git/base/blob/main/context/package/requirements_basic.apt)
Basic `apt` packages

#### 1.2.2 [`context/package/requirements_expansion.apt`](https://github.com/djy-git/base/blob/main/context/package/requirements_expansion.apt)
Expansion `apt` packages 

#### 1.2.3 [`context/package/requirements_basic.pip`](https://github.com/djy-git/base/blob/main/context/package/requirements_basic.pip)
Basic `pip` packages

#### 1.2.4 [`context/package/requirements_expansion.pip`](https://github.com/djy-git/base/blob/main/context/package/requirements_expansion.pip)
Expansion `pip` packages

#### 1.2.5 [`context/package/install_syncthing.sh`](https://github.com/djy-git/base/blob/main/context/package/install_syncthing.sh)
Install `syncthing` package


### 1.3 `context/package/jupyter`: `jupyter` package
#### 1.3.1 [`context/package/jupyter/jupyter_notebook_config.py`](https://github.com/djy-git/base/blob/main/context/package/jupyter/jupyter_notebook_config.py)
`jupyter` setting

#### 1.3.2 [`context/package/jupyter/jupytertheme.sh`](https://github.com/djy-git/base/blob/main/context/package/jupyter/jupytertheme.sh)
Apply `jupyter` theme (Reset `jupyter` theme: `$ jt -r`)


### 1.4 `context/entrypoint`: Shell scripts
#### 1.4.1 [`context/entrypoint/entrypoint.sh`](https://github.com/djy-git/base/blob/main/context/entrypoint/entrypoint.sh)
`entrypoint` for Dockerfile


### 1.5 `context/test`: Pytest scripts
#### 1.5.1 [`context/test/pycaret.py`](https://github.com/djy-git/base/blob/main/context/test/pycaret.py)
#### 1.5.2 [`context/test/tf_torch.py`](https://github.com/djy-git/base/blob/main/context/test/tf_torch.py)


## 2. Dockerfile
### 2.1 [`djyoon0223/base:basic`](https://github.com/djy-git/base/blob/main/dockerfile/base.basic.Dockerfile)
### 2.2 [`djyoon0223/base:pycaret`](https://github.com/djy-git/base/blob/main/dockerfile/base.pycaret.Dockerfile)
### 2.3 [`djyoon0223/base:tf_torch`](https://github.com/djy-git/base/blob/main/dockerfile/base.tf_torch.Dockerfile)
### 2.4 [`djyoon0223/base:full`](https://github.com/djy-git/base/blob/main/dockerfile/base.full.Dockerfile)
