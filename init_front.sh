#! /bin/bash
# Set the timezone
sudo timedatectl set-timezone America/Mexico_City

# Update OS & Dist
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Install Nginx
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y nginx

# Install certbot
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Generate certificate
sudo certbot certonly --nginx -d ${dns} -m gerardo.hernandez@improving.com --agree-tos --no-eff-email

# Install certificate
sudo certbot install --nginx --cert-name ${dns} -d ${dns}

# Reboot server
sudo reboot