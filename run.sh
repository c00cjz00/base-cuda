#!/bin/bash

sudo docker run \
--name "compute" \
--hostname "dev" \
--gpus '"device=0"' \
--ipc host \
--restart always \
--privileged \
-v .:/opt/project \
-p 10022:22 \
-p 3306:3306 \
-p 5000:5000 \
-p 5006:5006 \
-p 6000:6000 \
-p 6006:6006 \
-p 7860:7860 \
-p 8000:8000 \
-p 8080:8080 \
-p 8384:8384 \
-p 8501:8501 \
-p 8786:8786 \
-p 8787:8787 \
-p 8888:8888 \
-p 8889:8889 \
-itd \
alchemine/base-cuda:11.8.0-cudnn8-runtime-ubuntu22.04
