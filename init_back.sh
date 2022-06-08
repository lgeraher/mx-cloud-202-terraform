#! /bin/bash
# Set the timezone
sudo timedatectl set-timezone America/Mexico_City

# Update OS & Dist
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Reboot server
sudo reboot