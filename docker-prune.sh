#!/bin/bash
# Weekly Docker cleanup - prevents disk bloat inside Colima VM
# Add to crontab: 0 3 * * 0 ~/Code/media-server/docker-prune.sh
docker image prune -f
docker container prune -f
docker volume prune -f
echo "$(date): Docker pruned" >> /tmp/docker-prune.log
