#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install nginx
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install nginx
apt-get -y install python3-pip
apt-get -y install docker.io 

unlink /etc/nginx/sites-enabled/default

cat >/etc/nginx/sites-available/reverse-proxy.conf <<EOL
server {
    listen 80;
    server_name devsecops.securitydojo.co.in;
    location / {
        proxy_pass http://127.0.0.1:8000;
    }
}
EOL

ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

# make sure nginx is started
service nginx restart

# snap install core; sudo snap refresh core
# snap install --classic certbot
# ln -s /snap/bin/certbot /usr/bin/certbot

#certbot run -n --nginx --agree-tos -d devsecops.securitydojo.co.in  -m  mygmailid@gmail.com  --redirect