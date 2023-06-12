#!/bin/bash

sudo docker run \
--name "dev" \
--hostname "3080" \
--gpus '"device=0"' \
--ipc host \
--restart always \
--privileged \
-v /mnt:/mnt \
-itd \
djyoon0223/base:full
