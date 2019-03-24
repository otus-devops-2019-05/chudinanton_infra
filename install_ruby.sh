#!/bin/bash
echo "Update the system and install ruby -> "
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y ruby-full ruby-bundler build-essential
echo " -> Done!"