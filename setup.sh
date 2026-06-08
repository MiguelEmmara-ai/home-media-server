#!/bin/bash
set -e

echo "🎬 Media Server Setup"
echo "===================="

# Detect OS
OS=$(uname -s)
echo "Detected: $OS"

# Detect UID/GID
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)
echo "User: $(whoami) ($CURRENT_UID:$CURRENT_GID)"

# Ask for media path
DEFAULT_MEDIA="$HOME/media-server-data"
read -p "Media storage path [$DEFAULT_MEDIA]: " MEDIA_PATH
MEDIA_PATH=${MEDIA_PATH:-$DEFAULT_MEDIA}

# Create directories
echo "Creating directories..."
mkdir -p "$MEDIA_PATH/media/tv"
mkdir -p "$MEDIA_PATH/media/movies"
mkdir -p "$MEDIA_PATH/downloads/completed/Movies"
mkdir -p "$MEDIA_PATH/downloads/completed/Series"
mkdir -p "$MEDIA_PATH/downloads/intermediate"

# Set permissions
if [ "$OS" = "Darwin" ]; then
  chown -R "$CURRENT_UID:$CURRENT_GID" "$MEDIA_PATH"
  chmod -R 2775 "$MEDIA_PATH"
else
  sudo chown -R "$CURRENT_UID:$CURRENT_GID" "$MEDIA_PATH"
  sudo chmod -R 2775 "$MEDIA_PATH"
fi

# Generate .env if not exists
if [ ! -f .env ]; then
  cp .env.example .env
  echo ""
  echo "⚠️  Fill in your tokens in .env:"
  echo "   PLEX_CLAIM - https://plex.tv/claim"
  echo "   TUNNEL_TOKEN - https://one.dash.cloudflare.com/connections/tunnels"
  echo ""
  read -p "Press Enter after editing .env..."
fi

# Set dynamic values in .env
sed -i.bak "s|^MEDIA_PATH=.*|MEDIA_PATH=$MEDIA_PATH|" .env 2>/dev/null || true
sed -i.bak "s|^PUID=.*|PUID=$CURRENT_UID|" .env 2>/dev/null || true
sed -i.bak "s|^PGID=.*|PGID=$CURRENT_GID|" .env 2>/dev/null || true
rm -f .env.bak

# Update docker-compose PUID/PGID
if [ "$OS" = "Darwin" ]; then
  sed -i '' "s/PUID=501/PUID=$CURRENT_UID/g; s/PGID=20/PGID=$CURRENT_GID/g" docker-compose.yml
else
  sed -i "s/PUID=501/PUID=$CURRENT_UID/g; s/PGID=20/PGID=$CURRENT_GID/g" docker-compose.yml
fi

# Remove platform: linux/arm64 on non-ARM
ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "aarch64" ]; then
  echo "Removing ARM64 platform constraints (x86 detected)..."
  if [ "$OS" = "Darwin" ]; then
    sed -i '' '/platform: linux\/arm64/d' docker-compose.yml
  else
    sed -i '/platform: linux\/arm64/d' docker-compose.yml
  fi
fi

# Start
echo "✅ Starting containers..."
docker-compose up -d

echo "Waiting for services to initialize..."
sleep 30
docker-compose restart nginx

echo ""
echo "🚀 Ready!"
echo "   Dashboard: http://localhost:3000"
echo "   Jellyseerr: http://localhost:5055"
echo "   Plex: http://localhost:32400/web"
echo ""
echo "Run ./check.sh to verify all services"
