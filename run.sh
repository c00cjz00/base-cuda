#!/bin/bash

sudo docker run \
--name "tmp" \
--hostname "3080" \
--gpus '"device=0"' \
--ipc host \
--restart always \
--privileged \
-v /mnt:/mnt \
-itd \
basic
