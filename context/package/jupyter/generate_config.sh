#!/bin/bash

jupyter notebook --generate-config
cat /opt/docker/context/package/jupyter/jupyter_notebook_config.py >> ~/.jupyter/jupyter_notebook_config.py