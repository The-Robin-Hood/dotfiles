#!/bin/bash

# Allow nothing in, everything out
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow ports for LocalSend
sudo ufw allow 53317/udp comment 'LocalSend UDP'
sudo ufw allow 53317/tcp comment 'LocalSend TCP'
# Alternatively, restrict LocalSend to a specific interface
# sudo ufw allow in on eth0 to any port 53317 proto udp comment 'LocalSend UDP'
# sudo ufw allow in on eth0 to any port 53317 proto tcp comment 'LocalSend TCP'

# Allow Docker containers to use DNS on host
# sudo ufw allow in proto udp from 172.16.0.0/12 to 172.17.0.1 port 53 comment 'allow-docker-dns'
sudo ufw allow in proto udp from 172.17.0.0/16 to 172.17.0.1 port 53 comment 'Docker DNS'
sudo ufw logging medium

# Turn on the firewall
sudo ufw --force enable
sudo systemctl enable ufw

if command -v ufw-docker &> /dev/null; then
    sudo ufw-docker install
fi

sudo ufw reload
echo "✅ UFW setup complete!"


