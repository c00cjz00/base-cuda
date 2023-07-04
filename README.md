# Prepared CUDA based Image for Machine Learning Project
- **GitHub**: [alchemine/base](https://github.com/alchemine/base)
- **DockerHub**: [alchemine/base](https://hub.docker.com/repository/docker/alchemine/base)
```
$ docker pull alchemine/base:basic-11.8.0-cudnn8-runtime-ubuntu22.04
```


# 1. Base Image
[`nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04`](https://hub.docker.com/r/nvidia/cuda/tags)


# 2. Tags
1. `alchemine/base:basic`
   - `pyenv activate base`: `jupyter`


# 3. Usage
## 3.1 [`docker run`](https://github.com/alchemine/base/blob/nvidia/cuda/11.8.0-cudnn8-runtime-ubuntu22.04/run.sh)
```
$ sudo docker run \
--name "compute-server" \
--hostname "dev" \
--gpus '"device=0"' \
--ipc host \
--restart always \
--privileged \
-v /root/project:/workspace/project \
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
-itd \
alchemine/base:basic-11.8.0-cudnn8-runtime-ubuntu22.04
```

## 3.2 [`docker-compose`](https://github.com/alchemine/base/blob/nvidia/cuda/11.8.0-cudnn8-runtime-ubuntu22.04/docker-compose.yaml)
```
$ sudo docker-compose up -d
```

# 4. Dockerfile
## 2.1 [`alchemine/base:basic`](https://github.com/alchemine/base/blob/nvidia/cuda/11.8.0-cudnn8-runtime-ubuntu22.04/dockerfile/base.basic.Dockerfile)
