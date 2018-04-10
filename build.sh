#!/usr/bin/env sh
set -ex

mkdir -p /go/src/github.com/aliyun
ln -s `pwd` /go/src/github.com/aliyun/aliyun-cli
make pi
