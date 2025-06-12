#!/bin/bash
set -e

REDIS_CLOUD_ENDPOINT=$1
REDIS_CLOUD_PORT=$2
REDIS_CLOUD_PASSWORD=$3
EC2_PUBLIC_IP=$4

# Save cutover variables to file
cat <<EOF > /home/ubuntu/.cutover_env
REDIS_CLOUD_ENDPOINT=$REDIS_CLOUD_ENDPOINT
REDIS_CLOUD_PORT=$REDIS_CLOUD_PORT
REDIS_CLOUD_PASSWORD=$REDIS_CLOUD_PASSWORD
EC2_PUBLIC_IP=$EC2_PUBLIC_IP
EOF

chmod 600 /home/ubuntu/.cutover_env
chown ubuntu:ubuntu /home/ubuntu/.cutover_env

# Install Flask in leaderboard app's virtual environment
/opt/leaderboard_app/venv/bin/pip install flask

# Start the cutover UI server
nohup /opt/leaderboard_app/venv/bin/python /home/ubuntu/ui_server.py > /home/ubuntu/ui.log 2>&1 &
