#!/bin/bash

for tag in basic pycaret full tf_torch
do
  sudo docker build -t djyoon0223/base:$tag -f dockerfile/base.$tag.Dockerfile .
done
