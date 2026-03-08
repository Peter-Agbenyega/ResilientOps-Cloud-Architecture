#!/bin/bash
sudo su
yum update -y
yum install -y httpd wget unzip
cd /tmp
wget https://github.com/Ernest41k/UAICEI-terraform-infra-project-004/raw/main/jupiter-main.zip
unzip jupiter-main.zip
cp -r jupiter-main/* /var/www/html/
rm -rf jupiter-main jupiter-main.zip
systemctl enable httpd
systemctl start httpd