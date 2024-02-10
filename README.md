# cjz
```
docker build -t c00cjz00/cuda:11.8.0-cudnn8-runtime-ubuntu22.04 .
```

# Prepared CUDA based Image for Machine Learning Project
- **GitHub**: [alchemine/base-cuda](https://github.com/alchemine/base-cuda)
- **DockerHub**: [alchemine/base-cuda](https://hub.docker.com/repository/docker/alchemine/base-cuda)
```
$ docker pull alchemine/base-cuda:11.8.0-cudnn8-runtime-ubuntu22.04
```


# 1. Base Image
[`nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04`](https://hub.docker.com/r/nvidia/cuda/tags)


# 2. Installed Library
1. Python 3.8, 3.9, 3.10 (default: 3.8)
   - `update-alternatives --config python`
   - `update-alternatives --config pip`
2. apt packages
   - [context/utils/requirements.apt](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/utils/requirements.apt)
   - [context/extension/requirements.apt](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/extension/requirements.apt)
3. Poetry (1.7.1)
   - [context/utils/install_poetry.sh](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/utils/install_poetry.sh) 
4. Java (1.8.0_382)
   - [context/utils/install_java.sh](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/context/utils/install_java.sh) 


# 3. Usage
## 3.1 Project Sample
[alchemine/base-project](https://github.com/alchemine/base-project)

## 3.2 `docker run`
- [run.sh](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/run.sh)

## 3.3 `docker-compose`
- [docker-compose.yaml](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/docker-compose.yaml)


# 4. Dockerfile
- [Dockerfile](https://github.com/alchemine/base-cuda/blob/11.8.0-cudnn8-runtime-ubuntu22.04/Dockerfile)
