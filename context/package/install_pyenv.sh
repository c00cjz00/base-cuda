#!/bin/bash

# add path
echo -e "# pyenv" >> ~/.bashrc
echo "export PYENV_ROOT=\$HOME/.pyenv" >> ~/.bashrc
echo "export PATH=\$PYENV_ROOT/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

# pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# virtualenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

# initialize
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
