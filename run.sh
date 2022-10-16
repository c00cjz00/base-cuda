#!/bin/bash

sudo docker run \
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
