#!/bin/bash
echo "Install MongoDB Server"
echo "Adding keys"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "Adding repository"
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
echo "Installing mongodb"
sudo apt update
sudo apt install -y mongodb-org
echo "Starting service MongoDB"
sudo systemctl start mongod
sudo systemctl enable mongod
echo "Done"