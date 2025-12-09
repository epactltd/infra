#!/bin/bash

# Docker Compose wrapper script with retry logic for image pulls
# Usage: ./docker-up.sh [options]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
MAX_RETRIES=3
RETRY_DELAY=10
PULL_IMAGES=true
PULL_TIMEOUT=300  # 5 minutes timeout per pull

# Parse arguments
DOCKER_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-pull)
            PULL_IMAGES=false
            shift
            ;;
        --retries)
            MAX_RETRIES="$2"
            shift 2
            ;;
        --timeout)
            PULL_TIMEOUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [options] [docker-compose options]"
            echo ""
            echo "Options:"
            echo "  --no-pull          Skip pulling images before starting"
            echo "  --retries N        Maximum number of retries for image pulls (default: 3)"
            echo "  --timeout N        Timeout in seconds for each pull attempt (default: 300)"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "Any additional arguments will be passed to docker-compose up"
            exit 0
            ;;
        *)
            DOCKER_ARGS+=("$1")
            shift
            ;;
    esac
done

# Function to pull a single image with retry logic
pull_image_with_retry() {
    local image=$1
    local retry_count=0
    local success=false
    
    echo -e "${BLUE}Pulling image: ${image}${NC}"
    
    while [ $retry_count -lt $MAX_RETRIES ] && [ "$success" = false ]; do
        # Use timeout command to limit pull time
        if timeout $PULL_TIMEOUT docker pull "$image" 2>&1 | tee /tmp/docker-pull.log; then
            echo -e "${GREEN}✓ Successfully pulled ${image}${NC}"
            success=true
            return 0
        else
            local exit_code=${PIPESTATUS[0]}
            retry_count=$((retry_count + 1))
            
            # Check if it's a timeout or network error
            if grep -q "TLS handshake timeout\|context deadline exceeded\|net/http" /tmp/docker-pull.log 2>/dev/null; then
                if [ $retry_count -lt $MAX_RETRIES ]; then
                    echo -e "${YELLOW}⚠ Network timeout. Retrying in ${RETRY_DELAY} seconds... (Attempt $retry_count/$MAX_RETRIES)${NC}"
                    sleep $RETRY_DELAY
                else
                    echo -e "${RED}✗ Failed to pull ${image} after $MAX_RETRIES attempts (network timeout)${NC}"
                    echo -e "${YELLOW}  Continuing anyway - will use cached image if available${NC}"
                    return 1
                fi
            elif [ $exit_code -eq 124 ]; then
                # Timeout command exit code
                if [ $retry_count -lt $MAX_RETRIES ]; then
                    echo -e "${YELLOW}⚠ Pull timed out. Retrying in ${RETRY_DELAY} seconds... (Attempt $retry_count/$MAX_RETRIES)${NC}"
                    sleep $RETRY_DELAY
                else
                    echo -e "${RED}✗ Pull timed out for ${image} after $MAX_RETRIES attempts${NC}"
                    echo -e "${YELLOW}  Continuing anyway - will use cached image if available${NC}"
                    return 1
                fi
            else
                # Other error (e.g., image not found, but that's OK for local builds)
                echo -e "${YELLOW}⚠ Could not pull ${image} (may not exist remotely - will build locally)${NC}"
                return 0  # Not a fatal error
            fi
        fi
    done
    
    return 1
}

# Function to pull only external images (not local builds)
pull_external_images() {
    local images=("mariadb:10.11" "redis:alpine" "axllent/mailpit")
    local failed_images=()
    local success_count=0
    
    echo -e "${YELLOW}Pulling external Docker images...${NC}"
    echo ""
    
    for image in "${images[@]}"; do
        if pull_image_with_retry "$image"; then
            success_count=$((success_count + 1))
        else
            failed_images+=("$image")
        fi
        echo ""
    done
    
    echo -e "${BLUE}Summary: ${success_count}/${#images[@]} images pulled successfully${NC}"
    
    if [ ${#failed_images[@]} -gt 0 ]; then
        echo -e "${YELLOW}Failed images (will use cached if available):${NC}"
        for img in "${failed_images[@]}"; do
            echo -e "  - ${img}"
        done
        echo ""
        echo -e "${YELLOW}Note: Docker Compose will continue and use cached images if available${NC}"
        return 1
    fi
    
    return 0
}

# Function to check Docker daemon
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}Error: Docker daemon is not running${NC}"
        echo "Please start Docker Desktop or the Docker daemon and try again."
        exit 1
    fi
}

# Main execution
main() {
    check_docker
    
    # Pull external images if requested
    if [ "$PULL_IMAGES" = true ]; then
        pull_external_images || true  # Continue even if pull fails
    fi
    
    # Start services
    echo -e "${GREEN}Starting Docker Compose services...${NC}"
    echo -e "${BLUE}Note: Local images (envelope-api, envelope-tenant, envelope-hq) will be built automatically${NC}"
    echo ""
    
    # Build and start services
    docker compose up --build "${DOCKER_ARGS[@]}"
}

main "$@"

