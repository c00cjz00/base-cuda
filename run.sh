#!/bin/bash

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
