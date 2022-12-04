#!/bin/bash

ENV=$1

# Install packages
sudo apt-get install fonts-nanum* fontconfig
sudo fc-cache -fv
sudo cp /usr/share/fonts/truetype/nanum/Nanum* $ENV/matplotlib/mpl-data/fonts/ttf/

# Remove cache
rm -rf ~/.cache/matplotlib/*