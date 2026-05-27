#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run as root: sudo $0"
    exit 1
fi

echo "Checking PreRequisites"

# ── ufWall ───────────────────────────────────────────────────────────────
if ! command -v ufWall &>/dev/null; then
    if ! command -v yay &>/dev/null; then
        echo "yay not found — install yay first: https://github.com/Jguer/yay"
        exit 1
    fi
    echo "Installing ufwall..."
    
		sudo -u "$SUDO_USER" yay -S --noconfirm ufwall
fi

# ── ufw-docker ───────────────────────────────────────────────────────────────
if ! command -v ufw-docker &>/dev/null; then
	echo "Installing ufw-docker..."
	if command -v curl &>/dev/null; then
		curl -fsSL -o /usr/local/bin/ufw-docker \
			https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
	else
		echo "Neither curl nor wget found — install ufw-docker manually"
		exit 1
	fi
	chmod +x /usr/local/bin/ufw-docker
fi

echo "Configuring UFW..."

ufw default deny incoming
ufw default deny routed
ufw default allow outgoing
ufw logging medium

# LocalSend needs both tcp and udp 
ufw allow 53317/tcp comment 'localsend tcp'
ufw allow 53317/udp comment 'localsend udp'

# Allow Docker containers to resolve DNS via host
ufw allow in proto udp from 172.17.0.0/16 to 172.17.0.1 port 53 comment 'docker dns'

ufw allow 22/tcp comment 'ssh port'

ufw --force enable
systemctl enable ufw

echo "Configuring ufw-docker..."

ufw-docker install --docker-subnets
ufw reload

if systemctl is-active --quiet docker; then
    systemctl restart docker
fi

echo ""
echo "Firewall setup complete!"
