#!/bin/bash

pushd /home/kazauwa
git clone -b monolith https://github.com/express42/reddit.git
pushd reddit
bundle instal
puma -d
