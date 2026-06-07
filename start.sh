#!/bin/bash
cd "$(dirname "$0")"
docker-compose up -d
echo "⏳ Waiting for services..."
sleep 30
docker-compose restart nginx
# Fix VirtioFS permission bug (macOS Docker known issue)
nohup ~/Code/media-server/fix-perms.sh &>/dev/null &
echo "✅ Ready"
