# 🎬 Media Server Setup

Complete media server stack with zero-hassle remote access via Cloudflare Tunnel.

## What's Included

- **Plex** - Stream media on any device
- **Jellyfin** - Free open-source media streaming
- **Emby** - Media streaming (Smart TV compatible)
- **Jellyseerr** - Request shows/movies
- **Homepage** - Dashboard with live service stats
- **Sonarr** - Auto-download TV shows
- **Radarr** - Auto-download movies
- **Prowlarr** - Manage indexers (torrent + usenet)
- **NZBGet** - Usenet download client
- **qBittorrent** - Torrent download client
- **Nginx** - Reverse proxy
- **Cloudflare Tunnel** - Secure remote access

## Quick Start

### 1. Prerequisites

- macOS (Apple Silicon) or Linux
- Homebrew (macOS): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Cloudflare account (free)
- Plex account (free)

### 2. Install (macOS)

```bash
brew install colima docker docker-compose
colima start --cpu 4 --memory 8 --disk 50 --vm-type vz --mount-type virtiofs --vz-rosetta
```

### 3. Setup

```bash
git clone https://github.com/MiguelEmmara-ai/home-media-server.git
cd home-media-server
cp .env.example .env

# Get tokens
# 1. Plex: https://www.plex.tv/claim (expires in 4 minutes)
# 2. Cloudflare Tunnel: https://one.dash.cloudflare.com/connections/tunnels

# Fill in your tokens
nano .env

# Run setup
./setup.sh
```

### 3. Configure Services

```bash
./control.sh configure
```

Follow the guide to set up each service.

### 4. Search & Watch

1. Open Jellyseerr: `http://localhost:5055` (or your Cloudflare domain)
2. Search for a movie or show
3. Click "Request"
4. Sonarr/Radarr automatically downloads
5. Appears in Plex within minutes
6. Watch on iPhone, Smart TV, or browser

## Usage

```bash
# Start all services
./start.sh

# Check health of all services
./check.sh

# Stop services
./control.sh down

# View status
./control.sh status

# See logs
./control.sh logs jellyseerr

# Configure shell access
./control.sh shell plex

# Add media manually
./control.sh add-media /path/to/video.mp4
```

## Remote Access

Your media server is accessible anywhere via Cloudflare Tunnel:

- **Jellyseerr** (requests): `https://your-domain.example.com`
- **Plex**: `https://your-domain.example.com/plex`
- **Management**: `https://your-domain.example.com/sonarr`, `/radarr`, `/prowlarr`

### On iPhone/Smart TV

1. Install Plex app
2. Sign in with your Plex account
3. Media automatically appears
4. Stream anywhere on any network

## Storage

Media stored in `~/media-server-data/`:
- `media/tv/` - TV shows (organized by Sonarr)
- `media/movies/` - Movies (organized by Radarr)
- `downloads/` - Torrent downloads (auto-moved to media folders)

## Troubleshooting

```bash
# Check if services are running
./control.sh status

# View logs for a service
./control.sh logs sonarr
./control.sh logs radarr
./control.sh logs plex

# Restart a service
docker-compose restart plex

# Restart everything
./control.sh restart
```

## Default Ports (Local)

- Jellyseerr: 5055
- Plex: 32400
- Sonarr: 8989
- Radarr: 7878
- Prowlarr: 9696
- qBittorrent: 8080

## Performance Tips

- Don't request too many shows/movies at once (queue them)
- Ensure your internet speed supports streaming (at least 5 Mbps recommended)
- Configure Plex remote quality based on your internet speed
- Monitor qBittorrent to avoid maxing out bandwidth

## Security

- Cloudflare Tunnel encrypts all traffic
- Services only accessible via tunnel (no port forwarding)
- Keep Docker images updated: `docker-compose pull && docker-compose up -d`

## Next Steps

- Join Plex communities for recommendations
- Add custom indexers to Prowlarr for better results
- Set up notifications in Sonarr/Radarr (Discord, Telegram, etc.)

## Mac Mini / Always-On Server Setup

If using a Mac Mini (or any Mac) as a dedicated server:

```bash
# Prevent sleep, disk sleep, and auto-restart after power failure
sudo pmset -a sleep 0 disksleep 0 autorestart 1

# Prevent sleep even with lid closed (MacBook only)
sudo pmset -a disablesleep 1

# Enable SSH for remote management
sudo systemsetup -setremotelogin on

# Auto-mount external drives without login
sudo defaults write /Library/Preferences/SystemConfiguration/autodiskmount AutomountDisksWithoutUserLogin -bool true

# Disable Spotlight on media drive (saves CPU)
sudo mdutil -i off /Volumes/YourMediaDrive
```

To undo lid-close prevention: `sudo pmset -a disablesleep 0`
