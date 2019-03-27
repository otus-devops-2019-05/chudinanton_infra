#!/bin/bash
echo "Deploy app"
cd /home/chudinanton
echo "clone the app from github"
git clone -b monolith https://github.com/express42/reddit.git
echo "Bundle installing"
cd reddit/ && bundle install
echo "Starting puma server"
mv /home/chudinanton/reddit.service /etc/systemd/system/
systemctl start reddit
systemctl enable reddit
echo "Done"
