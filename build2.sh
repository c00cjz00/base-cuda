#!/bin/bash

for tag in full
do
  sudo docker build -t djyoon0223/base:$tag -f dockerfile/base.$tag.Dockerfile .
done
