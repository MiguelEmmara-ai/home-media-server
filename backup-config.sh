#!/bin/bash
cd "$(dirname "$0")"
DEST="${1:-$HOME/media-server-backup}"
mkdir -p "$DEST"

# Check disk space (need at least 500MB free)
FREE_MB=$(df -m "$DEST" | tail -1 | awk '{print $4}')
if [ "$FREE_MB" -lt 500 ]; then
  echo "❌ Not enough disk space (${FREE_MB}MB free, need 500MB)"
  exit 1
fi

# Check Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "❌ Docker is not running"
  exit 1
fi

echo "📦 Backing up configs to $DEST..."
FAILED=0
for vol in sonarr radarr prowlarr nzbget jellyseerr plex qbittorrent jellyfin emby; do
  if docker run --rm -v "media-server_${vol}_data:/data" -v "$DEST:/backup" alpine tar czf "/backup/${vol}_data.tar.gz" -C /data . 2>/dev/null; then
    SIZE=$(du -h "$DEST/${vol}_data.tar.gz" | cut -f1)
    echo "  ✅ $vol ($SIZE)"
  else
    echo "  ❌ $vol FAILED"
    FAILED=$((FAILED + 1))
  fi
done

if [ "$FAILED" -gt 0 ]; then
  echo "⚠️  $FAILED backup(s) failed!"
  exit 1
fi

echo ""
echo "✅ All backups complete ($(du -sh "$DEST" | cut -f1) total)"
echo "📍 Location: $DEST"
ls -lh "$DEST"/*.tar.gz | awk '{print "  " $9 " (" $5 ", " $6 " " $7 " " $8 ")"}'
