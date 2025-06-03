#!/bin/bash

exec > /var/log/user-data.log 2>&1
set -e

echo "=== Starting user_data setup ==="

# Retry logic
retry() {
  local n=0
  local try=5
  local cmd="$@"
  until [ $n -ge $try ]; do
    $cmd && break
    n=$((n+1))
    echo "Attempt $n failed. Retrying in 10 seconds..."
    sleep 10
  done
}

# Update & install required packages
retry sudo apt-get update -y
retry sudo apt-get install -y redis-server curl unzip git docker.io

# Start Redis
sudo systemctl enable redis-server
sudo systemctl start redis-server
sleep 5

# Verify Redis
if redis-cli ping | grep -q PONG; then
  echo "Redis OSS installed and responding to PING."
else
  echo "Redis OSS installation failed or Redis not responding."
  exit 1
fi

# Install RIOTX
RIOTX_VERSION="0.7.3"
RIOTX_ZIP="riotx-standalone-${RIOTX_VERSION}-linux-x86_64.zip"
RIOTX_URL="https://github.com/redis-field-engineering/riotx-dist/releases/download/v${RIOTX_VERSION}/${RIOTX_ZIP}"

cd /opt
sudo curl -LO "$RIOTX_URL"
sudo unzip -o "$RIOTX_ZIP"
sudo chmod +x /opt/riotx-standalone-${RIOTX_VERSION}-linux-x86_64/bin/riotx
sudo ln -sf /opt/riotx-standalone-${RIOTX_VERSION}-linux-x86_64/bin/riotx /usr/local/bin/riotx

# Verify RIOTX
if riotx --version | grep -q "riotx ${RIOTX_VERSION}"; then
  echo "RIOTX ${RIOTX_VERSION} successfully installed."
else
  echo "RIOTX installation failed."
  exit 1
fi

echo "=== RIOTX installed. Proceeding with observability setup ==="

# Enable Docker and add ubuntu user to docker group
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# Install Docker Compose v2 (manually)
mkdir -p /home/ubuntu/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-linux-x86_64 -o /home/ubuntu/.docker/cli-plugins/docker-compose
chmod +x /home/ubuntu/.docker/cli-plugins/docker-compose
chown -R ubuntu:ubuntu /home/ubuntu/.docker

# Clone riotx-dist and launch Prometheus + Grafana
cd /home/ubuntu
git clone https://github.com/redis-field-engineering/riotx-dist.git
cd riotx-dist
sudo -u ubuntu docker compose up -d

echo "=== Setup complete: Prometheus running on port 9090, Grafana on port 3000 ==="
