#!/bin/bash

source variables.sh

./install-prometheus.sh

ssh $USER@$IPADDR "sudo -n -s bash" < ./install-node-exporter.sh 
