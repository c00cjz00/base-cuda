#!/bin/bash

CONTEXT=/opt/docker/context

# install jupyter
pip install jupyter

# jupyter configuration
jupyter notebook --generate-config
cat $CONTEXT/package/jupyter/jupyter_notebook_config.py >> ~/.jupyter/jupyter_notebook_config.py
