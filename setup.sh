#!/bin/bash

set -e

echo "🎬 Media Server Setup"
echo "===================="

# Create media directories
echo "Creating directories..."
mkdir -p ~/media-server-data/media/tv
mkdir -p ~/media-server-data/media/movies
mkdir -p ~/media-server-data/downloads/{completed/Movies,completed/Series,intermediate}
chown -R 501:20 ~/media-server-data
chmod -R 2775 ~/media-server-data

# Check if .env is configured
if ! grep -q "PLEX_CLAIM=[^ ]" .env 2>/dev/null; then
    echo ""
    echo "⚠️  SETUP REQUIRED:"
    echo "1. Get Plex Claim Token: https://www.plex.tv/claim"
    echo "2. Create Cloudflare Tunnel: https://one.dash.cloudflare.com/connections/tunnels"
    echo ""
    echo "Then update .env file with:"
    echo "   PLEX_CLAIM=<your-token>"
    echo "   TUNNEL_TOKEN=<your-tunnel-token>"
    exit 1
fi

echo "✅ Starting containers..."
docker-compose up -d

# Wait for services to be ready, then restart nginx
echo "Waiting for services to initialize..."
sleep 30
docker-compose restart nginx

echo ""
echo "🚀 Services starting:"
echo "   Jellyseerr (Request UI): http://localhost:5055"
echo "   Plex: http://localhost:32400/web"
echo "   Sonarr: http://localhost:8989"
echo "   Radarr: http://localhost:7878"
echo "   Prowlarr: http://localhost:9696"
echo "   qBittorrent: http://localhost:8080"
echo ""
echo "Remote access: Check your Cloudflare Tunnel dashboard for your domain"
echo ""
echo "Next steps:"
echo "1. Wait 30s for services to initialize"
echo "2. Run: ./control.sh configure"
