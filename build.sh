#!/bin/bash

sudo docker build -t djyoon0223/base:basic -f base.basic.Dockerfile .
sudo docker build -t djyoon0223/base:caret -f base.caret.Dockerfile .
sudo docker build -t djyoon0223/base:tf_torch -f base.tf_torch.Dockerfile .
sudo docker build -t djyoon0223/base:full -f base.full.Dockerfile .
