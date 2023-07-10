# Prepared CUDA based Image for Machine Learning Project
- **GitHub**: [alchemine/base-cuda](https://github.com/alchemine/base-cuda)
- **DockerHub**: [alchemine/base-cuda](https://hub.docker.com/repository/docker/alchemine/base-cuda)
```
$ docker pull alchemine/base-cuda:11.8.0-cudnn8-runtime-ubuntu22.04
```


# 1. Base Image
[`nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04`](https://hub.docker.com/r/nvidia/cuda/tags)


# 2. Installed Packages
1. Python3.10.6
2. apt packages
   - [context/package/requirements.apt](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/package/requirements.apt)
   - [context/extension/requirements.apt](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/extension/requirements.apt)
3. Pyenv(virtualenv)
   - [context/package/install_pyenv.sh](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/package/install_pyenv.sh)
4. Poetry
   - [context/package/install_poetry.sh](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/package/install_poetry.sh) 
5. Jupyter
   - [context/package/install_jupyter.sh](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/package/install_jupyter.sh)
6. PyPI packages
   - [context/extension/requirements.pip](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/extension/requirements.pip)


# 3. Usage
## 3.1 `docker run`
- [run.sh](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/run.sh)
```
$ sudo docker run \
--name "compute_server" \
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
-p 18889:8889 \
-itd \
alchemine/base-cuda:11.8.0-cudnn8-runtime-ubuntu22.04
```

## 3.2 `docker-compose`
- [docker-compose.yaml](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/docker-compose.yaml)
```
$ sudo docker-compose up -d
```


# 4. Dockerfile
- [Dockerfile](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/Dockerfile)
