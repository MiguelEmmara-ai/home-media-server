#!/bin/bash
cd "$(dirname "$0")"
DEST="${1:-$HOME/media-server-backup}"
mkdir -p "$DEST"

echo "📦 Backing up configs to $DEST..."
for vol in sonarr radarr prowlarr nzbget jellyseerr plex qbittorrent jellyfin emby; do
  docker run --rm -v "media-server_${vol}_data:/data" -v "$DEST:/backup" alpine tar czf "/backup/${vol}_data.tar.gz" -C /data . 2>/dev/null
  echo "  ✅ $vol"
done
echo "Done. $(du -sh "$DEST" | cut -f1) total"
