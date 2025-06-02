#!/bin/bash
set -e

# Install Redis OSS + build tools + memtier deps
sudo apt-get update -y
sudo apt-get install -y redis-server build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev git libssl-dev

# Clean up any old clone
rm -rf /home/ubuntu/memtier_benchmark || true

# Clone and build memtier_benchmark
cd /home/ubuntu
git clone https://github.com/RedisLabs/memtier_benchmark.git
cd memtier_benchmark
mkdir -p autom4te.cache
chmod 777 autom4te.cache
autoreconf -ivf
./configure
make
sudo make install

# Enable Redis OSS on boot (optional)
sudo systemctl enable redis-server
