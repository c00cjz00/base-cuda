#!/bin/bash
source ~/.bashrc
ROOT=/opt/docker/context/package

pip3 install jupyterthemes
jt -t onedork -cellw 98% -f roboto -fs 10 -nfs 11 -tfs 11 -T
