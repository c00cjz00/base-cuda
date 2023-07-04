#!/bin/bash

BASE_TAG="11.8.0-cudnn8-runtime-ubuntu22.04"

for id in basic # torch ml full
do
  tag=$id-$BASE_TAG
  sudo docker push alchemine/base:$tag
done
