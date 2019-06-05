#!/bin/bash

#Grab Prometheus Node Exporter Package
wget -P /tmp https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz

#Unpack tar file
tar -xvf node_exporter-0.16.0.linux-amd64.tar.gz

#Move Export Binary to /usr/local/bin
sudo mv node_exporter-0.16.0.linux-amd64/node_exporter /usr/local/bin/

#Create Node Exporter user
sudo useradd -rs /bin/false node_exporter

#Create service file
cat <<EOT >> /etc/systemd/system/node_exporter.service

[Unit]
Description=Node Exporter
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
 
[Install]
WantedBy=multi-user.target

EOT

#Reload daeemon and start Node Exporter	
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter


