#!/bin/bash

# =========================================
# Docker Manager for Envelope SaaS
# Comprehensive Docker management tool
# Supports both Development and Production
# =========================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$INFRA_DIR"

# Docker compose files (in parent infra directory)
DEV_COMPOSE="$INFRA_DIR/docker-compose.yml"
PROD_COMPOSE="$INFRA_DIR/docker-compose.prod.yml"

# Current environment (dev or prod)
ENV_MODE="dev"

# =========================================
# HELPER FUNCTIONS
# =========================================

print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

get_compose_file() {
    if [ "$ENV_MODE" = "prod" ]; then
        echo "$PROD_COMPOSE"
    else
        echo "$DEV_COMPOSE"
    fi
}

get_compose_cmd() {
    local compose_file=$(get_compose_file)
    echo "docker compose -f $compose_file"
}

run_compose() {
    local cmd=$(get_compose_cmd)
    eval "$cmd $@"
}

require_sudo() {
    if ! sudo -n true 2>/dev/null; then
        print_warning "This operation requires sudo privileges"
        sudo -v
    fi
}

press_enter() {
    echo ""
    read -p "Press Enter to continue..."
}

# =========================================
# ENVIRONMENT SELECTION
# =========================================

select_environment() {
    clear
    print_header "Select Environment"
    echo "1) Development (docker-compose.yml)"
    echo "2) Production (docker-compose.prod.yml)"
    echo ""
    read -p "Select [1-2]: " choice
    
    case $choice in
        1) ENV_MODE="dev" ;;
        2) ENV_MODE="prod" ;;
        *) 
            print_error "Invalid selection"
            select_environment
            return
            ;;
    esac
    
    print_success "Selected: $ENV_MODE environment"
    sleep 1
}

# =========================================
# DOCKER OPERATIONS
# =========================================

build_images() {
    print_header "Building Docker Images"
    read -p "Service name (leave empty for all): " service
    
    if [ -z "$service" ]; then
        print_info "Building all images..."
        run_compose build
    else
        print_info "Building $service..."
        run_compose build "$service"
    fi
    
    print_success "Build completed"
    press_enter
}

rebuild_images() {
    print_header "Rebuilding Docker Images"
    read -p "Service name (leave empty for all): " service
    
    if [ -z "$service" ]; then
        print_info "Rebuilding all images (no cache)..."
        run_compose build --no-cache
    else
        print_info "Rebuilding $service (no cache)..."
        run_compose build --no-cache "$service"
    fi
    
    print_success "Rebuild completed"
    press_enter
}

start_services() {
    print_header "Starting Services"
    read -p "Service name (leave empty for all): " service
    
    if [ -z "$service" ]; then
        print_info "Starting all services..."
        run_compose up -d
    else
        print_info "Starting $service..."
        run_compose up -d "$service"
    fi
    
    print_success "Services started"
    press_enter
}

stop_services() {
    print_header "Stopping Services"
    read -p "Service name (leave empty for all): " service
    
    if [ -z "$service" ]; then
        print_info "Stopping all services..."
        run_compose stop
    else
        print_info "Stopping $service..."
        run_compose stop "$service"
    fi
    
    print_success "Services stopped"
    press_enter
}

restart_services() {
    print_header "Restarting Services"
    read -p "Service name (leave empty for all): " service
    
    if [ -z "$service" ]; then
        print_info "Restarting all services..."
        run_compose restart
    else
        print_info "Restarting $service..."
        run_compose restart "$service"
    fi
    
    print_success "Services restarted"
    press_enter
}

down_services() {
    print_header "Stopping and Removing Services"
    print_warning "This will stop and remove all containers, networks, and volumes"
    read -p "Are you sure? [y/N]: " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        read -p "Remove volumes? [y/N]: " remove_volumes
        
        if [[ "$remove_volumes" =~ ^[Yy]$ ]]; then
            print_info "Stopping and removing services with volumes..."
            run_compose down -v
        else
            print_info "Stopping and removing services..."
            run_compose down
        fi
        
        print_success "Services stopped and removed"
    else
        print_info "Operation cancelled"
    fi
    
    press_enter
}

pull_images_with_retry() {
    print_header "Pull Images with Retry Logic"
    
    local MAX_RETRIES=3
    local RETRY_DELAY=10
    local PULL_TIMEOUT=300
    
    read -p "Max retries [3]: " retries_input
    MAX_RETRIES=${retries_input:-3}
    
    local images=("mariadb:10.11" "redis:7-alpine" "axllent/mailpit:latest")
    local failed_images=()
    local success_count=0
    
    print_info "Pulling external Docker images..."
    echo ""
    
    for image in "${images[@]}"; do
        local retry_count=0
        local success=false
        
        print_info "Pulling image: $image"
        
        while [ $retry_count -lt $MAX_RETRIES ] && [ "$success" = false ]; do
            if timeout $PULL_TIMEOUT docker pull "$image" 2>&1; then
                print_success "Successfully pulled $image"
                success=true
                success_count=$((success_count + 1))
            else
                retry_count=$((retry_count + 1))
                if [ $retry_count -lt $MAX_RETRIES ]; then
                    print_warning "Retrying in $RETRY_DELAY seconds... (Attempt $retry_count/$MAX_RETRIES)"
                    sleep $RETRY_DELAY
                else
                    print_error "Failed to pull $image after $MAX_RETRIES attempts"
                    failed_images+=("$image")
                fi
            fi
        done
        echo ""
    done
    
    print_info "Summary: $success_count/${#images[@]} images pulled successfully"
    
    if [ ${#failed_images[@]} -gt 0 ]; then
        print_warning "Failed images (will use cached if available):"
        for img in "${failed_images[@]}"; do
            echo "  - $img"
        done
    fi
    
    press_enter
}

# =========================================
# IMAGE MANAGEMENT
# =========================================

list_images() {
    print_header "Docker Images"
    echo ""
    docker images | grep -E "(REPOSITORY|envelope)" || docker images
    echo ""
    press_enter
}

delete_image() {
    print_header "Delete Docker Image"
    echo ""
    docker images | grep envelope || docker images
    echo ""
    read -p "Image name or ID: " image_name
    
    if [ -z "$image_name" ]; then
        print_error "Image name required"
        press_enter
        return
    fi
    
    print_warning "Deleting image: $image_name"
    read -p "Are you sure? [y/N]: " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker rmi "$image_name" || print_error "Failed to delete image"
        print_success "Image deleted"
    else
        print_info "Operation cancelled"
    fi
    
    press_enter
}

delete_all_images() {
    print_header "Delete All Envelope Images"
    print_warning "This will delete ALL envelope-related images"
    read -p "Are you sure? [y/N]: " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Deleting envelope images..."
        docker images | grep envelope | awk '{print $3}' | xargs -r docker rmi -f || true
        print_success "All envelope images deleted"
    else
        print_info "Operation cancelled"
    fi
    
    press_enter
}

# =========================================
# CONTAINER MANAGEMENT
# =========================================

list_containers() {
    print_header "Docker Containers"
    echo ""
    echo -e "${CYAN}Running containers:${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|envelope)" || docker ps
    echo ""
    echo -e "${CYAN}All containers:${NC}"
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|envelope)" || docker ps -a
    echo ""
    press_enter
}

show_logs() {
    print_header "Container Logs"
    read -p "Service name (leave empty for all): " service
    
    if [ -z "$service" ]; then
        print_info "Showing logs for all services (last 50 lines)..."
        run_compose logs --tail=50 -f
    else
        read -p "Number of lines [50]: " lines
        lines=${lines:-50}
        print_info "Showing logs for $service (last $lines lines)..."
        run_compose logs --tail="$lines" -f "$service"
    fi
}

# =========================================
# DEBUGGING & DIAGNOSTICS
# =========================================

show_status() {
    print_header "Service Status"
    echo ""
    run_compose ps
    echo ""
    press_enter
}

show_health() {
    print_header "Container Health Status"
    echo ""
    docker ps --format "table {{.Names}}\t{{.Status}}" | grep envelope || docker ps
    echo ""
    press_enter
}

inspect_container() {
    print_header "Inspect Container"
    read -p "Container name: " container_name
    
    if [ -z "$container_name" ]; then
        print_error "Container name required"
        press_enter
        return
    fi
    
    echo ""
    docker inspect "$container_name" | less
}

exec_into_container() {
    print_header "Execute into Container"
    read -p "Container name: " container_name
    
    if [ -z "$container_name" ]; then
        print_error "Container name required"
        press_enter
        return
    fi
    
    print_info "Entering container: $container_name"
    print_info "Type 'exit' to leave"
    docker exec -it "$container_name" /bin/bash || docker exec -it "$container_name" /bin/sh
}

diagnose_service() {
    print_header "Service Diagnostics"
    require_sudo
    
    echo "Available services: api, hq, tenant"
    read -p "Service name (leave empty for all): " service_name
    
    if [ -z "$service_name" ]; then
        services=("api" "hq" "tenant")
    else
        services=("$service_name")
    fi
    
    echo ""
    echo "1. Checking Docker Compose Services Status..."
    echo "--------------------------------------------"
    run_compose ps
    echo ""
    
    for service in "${services[@]}"; do
        print_header "Diagnosing $service Service"
        
        # Get container name based on service
        case $service in
            api) container="envelope_api" ;;
            hq) container="envelope_hq" ;;
            tenant) container="envelope_tenant" ;;
            *) 
                print_error "Unknown service: $service"
                continue
                ;;
        esac
        
        echo "2. Checking ${service^} Container Logs (last 100 lines)..."
        echo "--------------------------------------------"
        run_compose logs "$service" --tail=100
        echo ""
        
        echo "3. Checking if ${service^} Container is Running..."
        echo "--------------------------------------------"
        if docker ps | grep -q "$container"; then
            print_success "${service^} container is running"
            echo ""
            echo "4. Checking Container Health..."
            echo "--------------------------------------------"
            docker inspect "$container" --format='{{.State.Status}} - Health: {{.State.Health.Status}}' 2>/dev/null || echo "Health check not available"
            echo ""
            echo "5. Checking Port Mappings..."
            echo "--------------------------------------------"
            docker port "$container" 2>/dev/null || echo "Cannot get port mappings"
            echo ""
            
            # Service-specific diagnostics
            if [ "$service" = "api" ]; then
                echo "6. Testing API Endpoint..."
                echo "--------------------------------------------"
                curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8008 || echo "Cannot connect to API"
                echo ""
                echo "7. Checking Octane Process Inside Container..."
                echo "--------------------------------------------"
                docker exec "$container" ps aux | grep -E "(octane|php|supervisor)" 2>/dev/null || echo "Cannot check processes"
                echo ""
                echo "8. Checking Supervisor Status..."
                echo "--------------------------------------------"
                docker exec "$container" supervisorctl status 2>&1 || echo "Cannot check supervisor"
                echo ""
                echo "9. Checking Octane Logs..."
                echo "--------------------------------------------"
                docker exec "$container" tail -50 /var/www/html/storage/logs/octane.log 2>/dev/null || echo "Cannot read Octane logs"
                echo ""
                echo "10. Checking Laravel Logs..."
                echo "--------------------------------------------"
                docker exec "$container" tail -50 /var/www/html/storage/logs/laravel.log 2>/dev/null || echo "Cannot read Laravel logs"
                echo ""
                echo "11. Checking Environment Variables..."
                echo "--------------------------------------------"
                docker exec "$container" env | grep -E "(OCTANE|REVERB|DB_|APP_)" || echo "Cannot check environment"
                echo ""
                echo "12. Checking Database Connection..."
                echo "--------------------------------------------"
                docker exec "$container" php /var/www/html/artisan tinker --execute="try { DB::connection()->getPdo(); echo 'DB Connected'; } catch (Exception \$e) { echo 'DB Error: ' . \$e->getMessage(); }" 2>&1 || echo "Cannot test DB connection"
            elif [ "$service" = "hq" ] || [ "$service" = "tenant" ]; then
                local port="3000"
                if [ "$service" = "tenant" ]; then
                    port="3001"
                fi
                echo "6. Testing ${service^} Frontend Endpoint..."
                echo "--------------------------------------------"
                curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" "http://localhost:$port" || echo "Cannot connect to ${service^}"
                echo ""
                echo "7. Checking Node Processes..."
                echo "--------------------------------------------"
                docker exec "$container" ps aux | grep -E "(node|nuxt|pnpm)" 2>/dev/null || echo "Cannot check processes"
                echo ""
                echo "8. Checking Environment Variables..."
                echo "--------------------------------------------"
                docker exec "$container" env | grep -E "(NODE_ENV|NUXT|PORT|BASE_URL)" || echo "Cannot check environment"
            fi
        else
            print_error "${service^} container is NOT running"
            echo ""
            echo "4. Checking why container exited..."
            echo "--------------------------------------------"
            run_compose logs "$service" --tail=50
            echo ""
            echo "5. Checking Container Exit Code..."
            echo "--------------------------------------------"
            docker inspect "$container" --format='Exit Code: {{.State.ExitCode}}' 2>/dev/null || echo "Container not found"
        fi
        
        echo ""
    done
    
    print_header "Diagnostic Complete"
    press_enter
}

test_services() {
    print_header "Testing Services"
    
    test_service() {
        local name=$1
        local url=$2
        local expected_status=${3:-200}
        
        echo -n "Testing $name... "
        
        local http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        
        if echo "$http_code" | grep -q "$expected_status"; then
            print_success "OK (HTTP $http_code)"
            return 0
        else
            print_error "FAILED (HTTP $http_code, expected $expected_status)"
            return 1
        fi
    }
    
    echo "Checking Docker containers..."
    if ! run_compose ps | grep -q "Up"; then
        print_warning "Some containers may not be running"
    fi
    
    echo ""
    echo "Testing services..."
    echo ""
    
    # Test API
    echo "API Service:"
    echo "   URL: http://localhost:8008"
    test_service "API Root" "http://localhost:8008" "200"
    test_service "API Health" "http://localhost:8008/up" "200"
    echo ""
    
    # Test HQ Frontend
    echo "HQ Frontend:"
    echo "   URL: http://localhost:3000"
    test_service "HQ Frontend" "http://localhost:3000" "200"
    echo ""
    
    # Test Tenant Frontend
    echo "Tenant Frontend:"
    echo "   URL: http://localhost:3001"
    test_service "Tenant Frontend" "http://localhost:3001/auth/login" "200"
    echo ""
    
    # Test Mailpit
    echo "Mailpit:"
    echo "   URL: http://localhost:8025"
    test_service "Mailpit UI" "http://localhost:8025" "200"
    echo ""
    
    print_header "Health Check Complete"
    press_enter
}

fix_service_cache() {
    print_header "Fix Service - Clear Caches"
    require_sudo
    
    echo "Available services: api, hq, tenant"
    read -p "Service name (leave empty for all): " service_name
    
    if [ -z "$service_name" ]; then
        services=("api" "hq" "tenant")
    else
        services=("$service_name")
    fi
    
    for service in "${services[@]}"; do
        print_header "Fixing $service Service"
        
        # Get container name based on service
        case $service in
            api) container="envelope_api" ;;
            hq) container="envelope_hq" ;;
            tenant) container="envelope_tenant" ;;
            *) 
                print_error "Unknown service: $service"
                continue
                ;;
        esac
        
        echo "1. Stopping ${service^} container..."
        run_compose stop "$service"
        
        echo ""
        echo "2. Clearing cache files..."
        if docker ps -a | grep -q "$container"; then
            if [ "$service" = "api" ]; then
                # Laravel cache clearing
                docker exec "$container" rm -f /var/www/html/bootstrap/cache/packages.php 2>/dev/null || echo "   (packages.php not found)"
                docker exec "$container" rm -f /var/www/html/bootstrap/cache/services.php 2>/dev/null || echo "   (services.php not found)"
            elif [ "$service" = "hq" ] || [ "$service" = "tenant" ]; then
                # Nuxt cache clearing
                docker exec "$container" rm -rf /app/.nuxt 2>/dev/null || echo "   (.nuxt not found)"
                docker exec "$container" rm -rf /app/.output 2>/dev/null || echo "   (.output not found)"
            fi
        fi
        
        echo ""
        echo "3. Starting ${service^} container..."
        run_compose up -d "$service"
        
        echo ""
        echo "4. Waiting for container to start..."
        sleep 10
        
        echo ""
        echo "5. Clearing runtime caches inside container..."
        if [ "$service" = "api" ]; then
            # Laravel cache commands
            docker exec "$container" php artisan config:clear 2>/dev/null || echo "   (config:clear failed)"
            docker exec "$container" php artisan cache:clear 2>/dev/null || echo "   (cache:clear failed)"
            docker exec "$container" php artisan optimize:clear 2>/dev/null || echo "   (optimize:clear failed)"
            echo ""
            echo "6. Regenerating composer autoload..."
            docker exec "$container" composer dump-autoload 2>/dev/null || echo "   (composer dump-autoload failed)"
            echo ""
            echo "7. Waiting for Octane to start..."
            sleep 5
        elif [ "$service" = "hq" ] || [ "$service" = "tenant" ]; then
            # Nuxt doesn't need runtime cache clearing, it's handled on startup
            echo "   (Nuxt caches cleared, service will rebuild on next request)"
            sleep 3
        fi
        
        echo ""
        echo "8. Checking container status..."
        run_compose ps "$service"
        
        echo ""
        echo "9. Checking logs..."
        run_compose logs "$service" --tail=30
        
        echo ""
    done
    
    print_header "Cache clearing complete!"
    press_enter
}

configure_docker() {
    print_header "Configure Docker Daemon"
    require_sudo
    
    local DAEMON_JSON="/etc/docker/daemon.json"
    local DAEMON_JSON_BACKUP="/etc/docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)"
    
    print_info "Configuring Docker daemon for better network reliability..."
    
    # Create daemon.json if it doesn't exist
    if [ ! -f "$DAEMON_JSON" ]; then
        print_info "Creating new daemon.json..."
        mkdir -p /etc/docker
        echo '{}' > "$DAEMON_JSON"
    else
        print_info "Backing up existing daemon.json..."
        cp "$DAEMON_JSON" "$DAEMON_JSON_BACKUP"
        print_success "Backup saved to: $DAEMON_JSON_BACKUP"
    fi
    
    # Check if jq is available
    if command -v jq &> /dev/null; then
        local config=$(cat "$DAEMON_JSON" 2>/dev/null || echo '{}')
        config=$(echo "$config" | jq '
            .max-concurrent-downloads = 3 |
            .max-concurrent-uploads = 5 |
            .default-ulimits.nofile.soft = 64000 |
            .default-ulimits.nofile.hard = 64000 |
            .log-driver = "json-file" |
            .log-opts."max-size" = "10m" |
            .log-opts."max-file" = "3"
        ')
        echo "$config" > "$DAEMON_JSON"
        print_success "Docker daemon configuration updated"
    else
        print_warning "jq not found. Manual configuration recommended."
        print_info "Add these settings to $DAEMON_JSON:"
        cat << EOF
{
  "max-concurrent-downloads": 3,
  "max-concurrent-uploads": 5,
  "default-ulimits": {
    "nofile": {
      "soft": 64000,
      "hard": 64000
    }
  },
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
        press_enter
        return
    fi
    
    # Restart Docker daemon
    print_info "Restarting Docker daemon..."
    if systemctl restart docker 2>/dev/null || service docker restart 2>/dev/null; then
        print_success "Docker daemon restarted"
    else
        print_warning "Could not restart Docker daemon automatically"
        print_info "Please restart Docker manually: sudo systemctl restart docker"
    fi
    
    press_enter
}

cleanup_docker() {
    print_header "Docker Cleanup"
    echo ""
    echo "This will remove:"
    echo "  - Stopped containers"
    echo "  - Unused networks"
    echo "  - Unused images"
    echo "  - Build cache"
    echo ""
    read -p "Continue? [y/N]: " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cleaning up Docker..."
        docker system prune -af --volumes
        print_success "Cleanup completed"
    else
        print_info "Operation cancelled"
    fi
    
    press_enter
}

# =========================================
# MAIN MENU
# =========================================

show_main_menu() {
    clear
    print_header "Docker Manager - $ENV_MODE Environment"
    echo ""
    echo "Current compose file: $(get_compose_file)"
    echo ""
    echo -e "${CYAN}Environment:${NC}"
    echo "  [E] Change Environment (Current: $ENV_MODE)"
    echo ""
    echo -e "${CYAN}Build & Deploy:${NC}"
    echo "  [1] Build Images"
    echo "  [2] Rebuild Images (no cache)"
    echo "  [3] Pull Images (with retry)"
    echo "  [4] Start Services"
    echo "  [5] Stop Services"
    echo "  [6] Restart Services"
    echo "  [7] Down Services (stop & remove)"
    echo ""
    echo -e "${CYAN}Image Management:${NC}"
    echo "  [8] List Images"
    echo "  [9] Delete Image"
    echo "  [10] Delete All Envelope Images"
    echo ""
    echo -e "${CYAN}Container Management:${NC}"
    echo "  [11] List Containers"
    echo "  [12] Show Logs"
    echo "  [13] Show Status"
    echo "  [14] Show Health"
    echo ""
    echo -e "${CYAN}Debugging & Testing:${NC}"
    echo "  [15] Diagnose Service (api/hq/tenant/all)"
    echo "  [16] Test Services"
    echo "  [17] Fix Service Cache (api/hq/tenant/all)"
    echo "  [18] Inspect Container"
    echo "  [19] Execute into Container"
    echo ""
    echo -e "${CYAN}Configuration:${NC}"
    echo "  [20] Configure Docker Daemon"
    echo "  [21] Docker Cleanup"
    echo ""
    echo "  [Q] Quit"
    echo ""
}

# =========================================
# MAIN LOOP
# =========================================

main() {
    # Check if docker is available
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    # Check if docker-compose file exists
    if [ ! -f "$DEV_COMPOSE" ]; then
        print_error "Development compose file not found: $DEV_COMPOSE"
        exit 1
    fi
    
    while true; do
        show_main_menu
        read -p "Select option: " choice
        
        case $choice in
            [Ee]) select_environment ;;
            1) build_images ;;
            2) rebuild_images ;;
            3) pull_images_with_retry ;;
            4) start_services ;;
            5) stop_services ;;
            6) restart_services ;;
            7) down_services ;;
            8) list_images ;;
            9) delete_image ;;
            10) delete_all_images ;;
            11) list_containers ;;
            12) show_logs ;;
            13) show_status ;;
            14) show_health ;;
            15) diagnose_service ;;
            16) test_services ;;
            17) fix_service_cache ;;
            18) inspect_container ;;
            19) exec_into_container ;;
            20) configure_docker ;;
            21) cleanup_docker ;;
            [Qq]) 
                print_info "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                sleep 1
                ;;
        esac
    done
}

# Run main function
main
