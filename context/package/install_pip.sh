#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
ROOT=/opt/docker/context/package

# install pip packages
for ENV in "$@"
do
  conda activate $ENV
  pip install -r $ROOT/requirements_basic.pip
  pip install -r $ROOT/requirements_expansion.pip
done