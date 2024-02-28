#!/bin/bash
if [ -d /opt/hvirt ]; then
    sudo rm -rf /opt/hvirt
fi
sudo git clone https://github.com/LexionN/hvirtd-example-python.git /opt/hvirt
cd /opt/hvirt
docker compose down -v && docker compose up -d

