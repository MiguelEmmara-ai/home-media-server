#!/bin/bash
cd "$(dirname "$0")"

echo "🔍 Service Health Check"
echo "======================="

check() {
  local name=$1 url=$2
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
  if [ "$code" = "000" ] || [ "$code" = "502" ] || [ "$code" = "530" ]; then
    echo "  ❌ $name - DOWN"
  else
    echo "  ✅ $name - $code"
  fi
}

echo ""
echo "📡 Local Services:"
check "Jellyseerr" "http://localhost:5055"
check "Plex" "http://localhost:32400/web"
check "Sonarr" "http://localhost:8989/sonarr"
check "Radarr" "http://localhost:7878/radarr"
check "Prowlarr" "http://localhost:9696/prowlarr"
check "qBittorrent" "http://localhost:8080"
check "NZBGet" "http://localhost:6789"
check "Jellyfin" "http://localhost:8096"
check "Emby" "http://localhost:8920"

echo ""
echo "🌐 Remote Access:"
check "Jellyseerr (tunnel)" "https://home-plex.miguelemmara.me/"
check "Sonarr (tunnel)" "https://home-plex.miguelemmara.me/sonarr/"
check "Radarr (tunnel)" "https://home-plex.miguelemmara.me/radarr/"
check "Prowlarr (tunnel)" "https://home-plex.miguelemmara.me/prowlarr/"
check "Plex (tunnel)" "https://plex.miguelemmara.me/web/index.html"

echo ""
echo "💾 Media Library:"
movies=$(find ~/media-server-data/media/movies -type f -not -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
tv=$(find ~/media-server-data/media/tv -type f -not -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
echo "  🎬 Movies: $movies"
echo "  📺 TV Episodes: $tv"

echo ""
echo "📦 Downloads:"
active=$(docker exec nzbget ls /downloads/intermediate/ 2>/dev/null | wc -l | tr -d ' ')
echo "  Active: $active"

echo ""
echo "💿 Disk:"
docker exec nzbget df -h / 2>/dev/null | tail -1 | awk '{print "  Docker: " $4 " free / " $2 " total"}'
df -h ~/media-server-data 2>/dev/null | tail -1 | awk '{print "  Mac: " $4 " free / " $2 " total"}'
