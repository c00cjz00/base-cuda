#!/bin/bash

for tag in basic torch ml full
do
  sudo docker push djyoon0223/base:$tag
done
