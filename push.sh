#!/bin/bash

for tag in basic pycaret full tf_torch
do
  sudo docker push djyoon0223/base:$tag
done
