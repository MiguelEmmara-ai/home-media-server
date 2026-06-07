#!/bin/bash

MEDIA_PATH="$HOME/media-server-data"

case "${1:-help}" in
    up)
        docker-compose up -d
        echo "⏳ Waiting for services to initialize..."
        sleep 30
        docker-compose restart nginx
        echo "✅ All services started"
        ;;
    down)
        docker-compose down
        echo "⏹️  All services stopped"
        ;;
    restart)
        docker-compose restart
        echo "🔄 All services restarted"
        ;;
    logs)
        docker-compose logs -f "${2:-jellyseerr}"
        ;;
    status)
        echo "📊 Service Status:"
        docker-compose ps
        ;;
    configure)
        echo "⚙️  Configuration Guide"
        echo ""
        echo "1. PROWLARR (Indexers)"
        echo "   - Go to: http://localhost:9696"
        echo "   - Add indexers (torrent sites)"
        echo "   - Copy API key"
        echo ""
        echo "2. SONARR (TV Automation)"
        echo "   - Go to: http://localhost:8989"
        echo "   - Settings > Download Clients > Add qBittorrent"
        echo "   - Settings > Indexers > Add Prowlarr (paste API key)"
        echo "   - Settings > Media Management > TV Folder: /media/tv"
        echo ""
        echo "3. RADARR (Movie Automation)"
        echo "   - Go to: http://localhost:7878"
        echo "   - Settings > Download Clients > Add qBittorrent"
        echo "   - Settings > Indexers > Add Prowlarr (paste API key)"
        echo "   - Settings > Media Management > Movie Folder: /media/movies"
        echo ""
        echo "4. PLEX (Streaming)"
        echo "   - Go to: http://localhost:32400/web"
        echo "   - Add Libraries pointing to /media"
        echo ""
        echo "5. JELLYSEERR (Requests)"
        echo "   - Go to: http://localhost:5055"
        echo "   - Connect to Plex"
        echo "   - Add Sonarr & Radarr servers"
        echo ""
        ;;
    add-media)
        if [ -z "$2" ]; then
            echo "Usage: ./control.sh add-media <file-or-folder>"
            exit 1
        fi
        cp -r "$2" "$MEDIA_PATH/media/"
        echo "✅ Media added: $2"
        ;;
    shell)
        docker-compose exec "${2:-jellyseerr}" /bin/bash
        ;;
    help|*)
        echo "Media Server Control"
        echo ""
        echo "Usage: ./control.sh <command> [options]"
        echo ""
        echo "Commands:"
        echo "  up              Start all services"
        echo "  down            Stop all services"
        echo "  restart         Restart all services"
        echo "  status          Show service status"
        echo "  logs [service]  View logs (default: jellyseerr)"
        echo "  configure       Configuration guide"
        echo "  add-media <path> Add media file/folder"
        echo "  shell [service] Open shell in container"
        echo "  help            Show this help"
        echo ""
        ;;
esac
