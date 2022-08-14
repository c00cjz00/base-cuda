#!/bin/bash

for tag in basic caret full tf_torch
do
  sudo docker push djyoon0223/base:$tag
done
