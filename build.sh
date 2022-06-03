#!/bin/bash

sudo docker build -t base:basic -f base.basic.Dockerfile .
sudo docker build -t base:full -f base.full.Dockerfile .
