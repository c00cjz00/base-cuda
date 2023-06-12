# Prepared CUDA based Image for Machine Learning Project
- **GitHub**: [alchemine/base](https://github.com/alchemine/base)
- **DockerHub**: [djyoon0223/base](https://hub.docker.com/repository/docker/djyoon0223/base)
```
$ docker pull djyoon0223/base:basic
$ docker pull djyoon0223/base:torch
$ docker pull djyoon0223/base:ml
$ docker pull djyoon0223/base:full
```


# 1. Base Image
[`nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04`](https://hub.docker.com/r/nvidia/cuda/tags)


# 2. Tags
1. `djyoon0223/base:basic`
   - `jupyter`
2. `djyoon0223/base:torch`
   - `jupyter` + `torch=2.0.1`
3. `djyoon0223/base:ml`
   - `jupyter` + `pycaret=3.0.0`
4. `djyoon0223/base:full`
   - `pycaret`: `djyoon0223/base:pycaret`
   - `tf_torch`: `djyoon0223/base:tf_torch`


# 3. Usage
## 3.1 [`docker run`](https://github.com/djy-git/base/blob/main/run.sh)
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

## 3.2 [`docker-compose`](https://github.com/djy-git/base/blob/main/docker-compose.yaml)
```
$ sudo docker-compose up -d
```


# 4. Dockerfile
## 2.1 [`djyoon0223/base:basic`](https://github.com/djy-git/base/blob/main/dockerfile/base.basic.Dockerfile)
## 2.2 [`djyoon0223/base:torch`](https://github.com/djy-git/base/blob/main/dockerfile/base.torch.Dockerfile)
## 2.3 [`djyoon0223/base:ml`](https://github.com/djy-git/base/blob/main/dockerfile/base.ml.Dockerfile)
## 2.4 [`djyoon0223/base:full`](https://github.com/djy-git/base/blob/main/dockerfile/base.full.Dockerfile)
