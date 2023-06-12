#!/bin/bash

sudo docker run \
--name "compute_server" \
--hostname "dev" \
--gpus '"device=0"' \
--ipc host \
--restart always \
--privileged \
-v /root/project:/root/project \
-itd \
djyoon0223/base:full
