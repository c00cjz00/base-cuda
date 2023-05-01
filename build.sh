#!/bin/bash

for tag in basic pycaret tf_torch full
do
  sudo docker build -t djyoon0223/base:$tag -f dockerfile/base.$tag.Dockerfile .
done