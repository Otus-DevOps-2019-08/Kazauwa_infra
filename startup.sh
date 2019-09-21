#!/bin/bash

# Install ruby and bundler
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

# Install mongodb
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod && sudo systemctl enable mongod

# Deploy application
pushd /home/kazauwa
git clone -b monolith https://github.com/express42/reddit.git
pushd reddit
bundle instal
puma -d
