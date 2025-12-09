#!/bin/bash

# Docker configuration helper script
# This script helps configure Docker for better network reliability

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DAEMON_JSON="/etc/docker/daemon.json"
DAEMON_JSON_BACKUP="/etc/docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)"

configure_docker_daemon() {
    echo -e "${BLUE}Configuring Docker daemon for better network reliability...${NC}"
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script must be run as root (use sudo)${NC}"
        exit 1
    fi
    
    # Create daemon.json if it doesn't exist
    if [ ! -f "$DAEMON_JSON" ]; then
        echo -e "${YELLOW}Creating new daemon.json...${NC}"
        mkdir -p /etc/docker
        echo '{}' > "$DAEMON_JSON"
    else
        echo -e "${YELLOW}Backing up existing daemon.json...${NC}"
        cp "$DAEMON_JSON" "$DAEMON_JSON_BACKUP"
        echo -e "${GREEN}Backup saved to: $DAEMON_JSON_BACKUP${NC}"
    fi
    
    # Read existing config
    local config=$(cat "$DAEMON_JSON" 2>/dev/null || echo '{}')
    
    # Add/update max-concurrent-downloads and other settings
    # Use jq if available, otherwise use a simple approach
    if command -v jq &> /dev/null; then
        config=$(echo "$config" | jq '
            .max-concurrent-downloads = 3 |
            .max-concurrent-uploads = 5 |
            .default-ulimits.nofile.soft = 64000 |
            .default-ulimits.nofile.hard = 64000 |
            .log-driver = "json-file" |
            .log-opts."max-size" = "10m" |
            .log-opts."max-file" = "3"
        ')
    else
        echo -e "${YELLOW}Warning: jq not found. Manual configuration recommended.${NC}"
        echo -e "${BLUE}Add these settings to $DAEMON_JSON:${NC}"
        echo '{'
        echo '  "max-concurrent-downloads": 3,'
        echo '  "max-concurrent-uploads": 5,'
        echo '  "default-ulimits": {'
        echo '    "nofile": {'
        echo '      "soft": 64000,'
        echo '      "hard": 64000'
        echo '    }'
        echo '  },'
        echo '  "log-driver": "json-file",'
        echo '  "log-opts": {'
        echo '    "max-size": "10m",'
        echo '    "max-file": "3"'
        echo '  }'
        echo '}'
        return 1
    fi
    
    # Write updated config
    echo "$config" > "$DAEMON_JSON"
    echo -e "${GREEN}✓ Docker daemon configuration updated${NC}"
    
    # Restart Docker daemon
    echo -e "${YELLOW}Restarting Docker daemon...${NC}"
    if systemctl restart docker 2>/dev/null; then
        echo -e "${GREEN}✓ Docker daemon restarted${NC}"
    elif service docker restart 2>/dev/null; then
        echo -e "${GREEN}✓ Docker daemon restarted${NC}"
    else
        echo -e "${YELLOW}⚠ Could not restart Docker daemon automatically${NC}"
        echo -e "${BLUE}Please restart Docker manually:${NC}"
        echo "  sudo systemctl restart docker"
        echo "  # or"
        echo "  sudo service docker restart"
    fi
}

show_network_tips() {
    echo ""
    echo -e "${BLUE}=== Network Troubleshooting Tips ===${NC}"
    echo ""
    echo "If you continue to experience TLS handshake timeouts:"
    echo ""
    echo "1. Check your internet connection:"
    echo "   ping registry-1.docker.io"
    echo ""
    echo "2. Try using a Docker registry mirror (if available):"
    echo "   Edit $DAEMON_JSON and add:"
    echo '   "registry-mirrors": ["https://your-mirror-url"]'
    echo ""
    echo "3. Increase Docker pull timeout:"
    echo "   export DOCKER_CLIENT_TIMEOUT=300"
    echo "   export COMPOSE_HTTP_TIMEOUT=300"
    echo ""
    echo "4. Use the --no-pull flag to skip pulling and use cached images:"
    echo "   ./docker-up.sh --no-pull"
    echo ""
    echo "5. Pull images manually with retries:"
    echo "   docker pull mariadb:10.11"
    echo "   docker pull redis:alpine"
    echo "   docker pull axllent/mailpit"
    echo ""
}

main() {
    echo -e "${GREEN}Docker Configuration Helper${NC}"
    echo ""
    
    if [ "$1" = "--configure" ]; then
        configure_docker_daemon
    else
        echo -e "${YELLOW}This script can configure Docker daemon settings for better reliability.${NC}"
        echo ""
        echo "Usage:"
        echo "  sudo $0 --configure    # Configure Docker daemon"
        echo "  $0 --tips              # Show troubleshooting tips"
        echo ""
        
        if [ "$1" = "--tips" ]; then
            show_network_tips
        else
            echo "Run with --configure to set up Docker daemon (requires sudo)"
            echo "Run with --tips to see network troubleshooting tips"
        fi
    fi
    
    show_network_tips
}

main "$@"

