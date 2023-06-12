#!/bin/bash

for tag in basic ml torch
do
  sudo docker build -t djyoon0223/base:$tag -f dockerfile/base.$tag.Dockerfile .
done
