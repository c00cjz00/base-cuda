#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh

# install packages
apt-get install -y fonts-nanum* fontconfig
fc-cache -fv

# copy fonts to matplotlib package
for ENV in "$@"
do
  conda activate $1
  PACKAGE_PATH=$(python -c 'import site; print(site.getsitepackages()[0])')
  cp /usr/share/fonts/truetype/nanum/Nanum* $PACKAGE_PATH/matplotlib/mpl-data/fonts/ttf/
done

# remove cache
rm -rf ~/.cache/matplotlib/*