#!/bin/bash
echo "Deploy app"
cd ~
echo "clone the app from github"
git clone -b monolith https://github.com/express42/reddit.git
echo "Bundle installing"
cd reddit/ && bundle install
echo "Starting puma server"
puma -d
echo "Done"