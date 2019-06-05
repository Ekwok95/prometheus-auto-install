#!/bin/bash

#Update system
sudo yum update -y

#Add prometheus user with no shell and no bin directory
sudo useradd --no-create-home --shell /bin/false prometheus

#Create relevant prometheus directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

#Give permissions to prometheus directories
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

#Download, extract and move prometheus application files to a new directory
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.3.2/prometheus-2.3.2.linux-amd64.tar.gz
tar -xvf prometheus-2.3.2.linux-amd64.tar.gz
mv prometheus-2.3.2.linux-amd64 prometheus-files

#Move Prometheus binaries to respective folders
sudo cp prometheus-files/prometheus /usr/local/bin/
sudo cp prometheus-files/promtool /usr/local/bin/

#Set permissions to Prometheus binary folders
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

#Create config file
sudo cat <<EOT >> /etc/prometheus/prometheus.yml
global:
  scrape_interval: 10s
 
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
EOT

#Change permissions of Prometheus config file 
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

#Create prometheus service file
sudo cat <<EOT >> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
 
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries
 
[Install]
WantedBy=multi-user.target
EOT

#Reload and start Prometheus service
sudo systemctl daemon-reload
sudo systemctl start prometheus


