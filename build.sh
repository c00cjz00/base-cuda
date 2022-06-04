#!/bin/bash

sudo docker build -t djyoon0223/base:basic -f base.basic.Dockerfile .
sudo docker build -t djyoon0223/base:full -f base.full.Dockerfile .
