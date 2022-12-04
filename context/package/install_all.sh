#!/bin/bash

FOR ENV in "$@"
DO
  pip install -r /opt/docker/context/package/requirements_basic.pip
  pip install -r /opt/docker/context/package/requirements_expansion.pip
  /opt/docker/context/package/install_nanum.sh $ENV
DONE

/opt/docker/context/package/install_syncthing.sh
/opt/docker/context/package/jupyter/generate_config.sh