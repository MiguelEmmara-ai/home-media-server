#!/bin/bash
# Cleans up completed downloads inside the Docker volume to prevent Colima disk ballooning
cd "$(dirname "$0")"
echo "🧹 Cleaning downloads volume..."
docker exec nzbget rm -rf /downloads/completed/Movies/* /downloads/completed/Series/* 2>/dev/null
docker exec nzbget rm -rf /downloads/intermediate/* 2>/dev/null
echo "✅ Cleaned"
docker exec nzbget df -h / | tail -1 | awk '{print "  Docker disk: " $4 " free / " $2 " total"}'
