#!/bin/bash

for tag in basic pycaret tf_torch full
do
  sudo docker push djyoon0223/base:$tag
done
