#!/bin/bash
cd "$(dirname "$0")"
docker-compose up -d
echo "⏳ Waiting for services..."
sleep 30
docker-compose restart nginx
echo "✅ Ready"
