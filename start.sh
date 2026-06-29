#!/bin/bash
cd "$(dirname "$0")"

# Auto-detect media path
if [ -d "/Volumes/TRANSCEND/media-server" ]; then
  export MEDIA_PATH=/Volumes/TRANSCEND/media-server
  echo "📀 Using external SSD"
else
  export MEDIA_PATH=$HOME/media-server-data
  mkdir -p "$MEDIA_PATH/media/movies" "$MEDIA_PATH/media/tv" "$MEDIA_PATH/downloads/completed/Movies" "$MEDIA_PATH/downloads/completed/Series" "$MEDIA_PATH/downloads/intermediate"
  echo "💻 Using internal drive"
fi

docker-compose up -d
echo "⏳ Waiting for services..."
sleep 30
docker-compose restart nginx
echo "✅ Ready (media: $MEDIA_PATH)"
