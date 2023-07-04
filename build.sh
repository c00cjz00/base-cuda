#!/bin/bash

BASE_TAG="11.8.0-cudnn8-runtime-ubuntu22.04"

for id in basic # torch ml full
do
  tag=$id-$BASE_TAG
  sudo docker build -t alchemine/base:$tag -f dockerfile/base.$id.Dockerfile .
done
