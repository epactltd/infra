#!/bin/bash

# =========================================
# Development Tools Installation Script
# Installs: Composer, MariaDB, Redis, phpredis, Node.js, pnpm
# =========================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# =========================================
# Homebrew Installation
# =========================================

install_homebrew() {
    print_header "Checking Homebrew"
    
    if command_exists brew; then
        print_success "Homebrew is already installed"
        brew --version
        return 0
    fi
    
    # Check if Homebrew directories exist
    if [ -d "/opt/homebrew" ] || [ -d "/usr/local/Homebrew" ]; then
        print_warning "Homebrew directories found but brew command not in PATH"
        print_info "Adding Homebrew to PATH..."
        
        if [ -d "/opt/homebrew" ]; then
            # Apple Silicon Mac
            export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
            echo 'export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"' >> ~/.zshrc
        elif [ -d "/usr/local/Homebrew" ]; then
            # Intel Mac
            export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
            echo 'export PATH="/usr/local/bin:/usr/local/sbin:$PATH"' >> ~/.zshrc
        fi
        
        if command_exists brew; then
            print_success "Homebrew is now accessible"
            return 0
        fi
    fi
    
    print_warning "Homebrew is not installed"
    print_info "Homebrew requires interactive installation with sudo"
    echo ""
    echo "Please run the following command manually:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo ""
    read -p "Have you installed Homebrew? (y/N): " answer
    
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        # Try to add Homebrew to PATH
        if [ -d "/opt/homebrew" ]; then
            export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
            echo 'export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"' >> ~/.zshrc
        elif [ -d "/usr/local/Homebrew" ]; then
            export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
            echo 'export PATH="/usr/local/bin:/usr/local/sbin:$PATH"' >> ~/.zshrc
        fi
        
        if command_exists brew; then
            print_success "Homebrew is now accessible"
            return 0
        else
            print_error "Homebrew still not accessible. Please restart your terminal and run this script again."
            exit 1
        fi
    else
        print_error "Please install Homebrew first and then run this script again"
        exit 1
    fi
}

# =========================================
# Node.js Installation (via nvm)
# =========================================

install_node() {
    print_header "Installing Node.js"
    
    if command_exists node; then
        print_success "Node.js is already installed"
        node --version
        npm --version
        return 0
    fi
    
    # Load nvm if it exists
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        source "$NVM_DIR/nvm.sh"
    elif [ -s "$HOME/.nvm/nvm.sh" ]; then
        export NVM_DIR="$HOME/.nvm"
        source "$HOME/.nvm/nvm.sh"
    else
        print_info "Installing nvm (Node Version Manager)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    fi
    
    if ! command_exists nvm; then
        # Try to source nvm again
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" || true
        [ -s "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh" || true
    fi
    
    if command_exists nvm || [ -s "$NVM_DIR/nvm.sh" ]; then
        print_info "Installing Node.js LTS version..."
        source "$NVM_DIR/nvm.sh" 2>/dev/null || source "$HOME/.nvm/nvm.sh" 2>/dev/null || true
        
        # Install Node.js LTS
        nvm install --lts
        nvm use --lts
        nvm alias default node
        
        # Add nvm to shell config if not already there
        if ! grep -q "NVM_DIR" ~/.zshrc 2>/dev/null; then
            cat >> ~/.zshrc << 'EOF'

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
        fi
        
        print_success "Node.js installed"
        node --version
        npm --version
    else
        print_error "Failed to install nvm. Trying alternative method..."
        
        # Alternative: Install via Homebrew
        if command_exists brew; then
            print_info "Installing Node.js via Homebrew..."
            brew install node
            print_success "Node.js installed via Homebrew"
            node --version
            npm --version
        else
            print_error "Cannot install Node.js. Please install Homebrew first."
            exit 1
        fi
    fi
}

# =========================================
# pnpm Installation
# =========================================

install_pnpm() {
    print_header "Installing pnpm"
    
    if command_exists pnpm; then
        print_success "pnpm is already installed"
        pnpm --version
        return 0
    fi
    
    if ! command_exists npm; then
        print_error "npm is required to install pnpm. Please install Node.js first."
        exit 1
    fi
    
    print_info "Installing pnpm globally..."
    npm install -g pnpm
    
    print_success "pnpm installed"
    pnpm --version
}

# =========================================
# Composer Installation
# =========================================

install_composer() {
    print_header "Installing Composer"
    
    if command_exists composer; then
        print_success "Composer is already installed"
        composer --version
        return 0
    fi
    
    print_info "Downloading Composer installer..."
    
    # Check if PHP is installed
    if ! command_exists php; then
        print_warning "PHP is not installed. Installing via Homebrew..."
        if command_exists brew; then
            brew install php
        else
            print_error "PHP is required but Homebrew is not available"
            exit 1
        fi
    fi
    
    # Download and install Composer
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
    
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        print_error "Composer installer checksum verification failed!"
        rm composer-setup.php
        exit 1
    fi
    
    print_info "Installing Composer globally..."
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    rm composer-setup.php
    
    # If /usr/local/bin is not writable, install to user directory
    if ! command_exists composer; then
        print_info "Installing Composer to user directory..."
        php composer-setup.php --install-dir="$HOME/.local/bin" --filename=composer
        rm composer-setup.php
        
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            export PATH="$HOME/.local/bin:$PATH"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        fi
    fi
    
    if command_exists composer; then
        print_success "Composer installed"
        composer --version
    else
        print_error "Failed to install Composer"
        exit 1
    fi
}

# =========================================
# MariaDB Installation
# =========================================

install_mariadb() {
    print_header "Installing MariaDB"
    
    if command_exists mariadb || command_exists mysql; then
        print_success "MariaDB/MySQL is already installed"
        mariadb --version 2>/dev/null || mysql --version
        return 0
    fi
    
    if ! command_exists brew; then
        print_error "Homebrew is required to install MariaDB"
        exit 1
    fi
    
    print_info "Installing MariaDB via Homebrew..."
    brew install mariadb
    
    print_info "Starting MariaDB service..."
    brew services start mariadb
    
    print_success "MariaDB installed and started"
    print_info "You can connect with: mysql -u root"
    print_info "To stop: brew services stop mariadb"
    print_info "To start: brew services start mariadb"
}

# =========================================
# Redis Installation
# =========================================

install_redis() {
    print_header "Installing Redis"
    
    if command_exists redis-server; then
        print_success "Redis is already installed"
        redis-server --version
        return 0
    fi
    
    if ! command_exists brew; then
        print_error "Homebrew is required to install Redis"
        exit 1
    fi
    
    print_info "Installing Redis via Homebrew..."
    brew install redis
    
    print_info "Starting Redis service..."
    brew services start redis
    
    print_success "Redis installed and started"
    print_info "You can test with: redis-cli ping"
    print_info "To stop: brew services stop redis"
    print_info "To start: brew services start redis"
}

# =========================================
# phpredis Extension Installation
# =========================================

install_phpredis() {
    print_header "Installing phpredis Extension"
    
    if ! command_exists php; then
        print_error "PHP is required to install phpredis"
        exit 1
    fi
    
    # Check if phpredis is already installed
    if php -m | grep -q redis; then
        print_success "phpredis extension is already installed"
        php -m | grep redis
        return 0
    fi
    
    if ! command_exists brew; then
        print_error "Homebrew is required to install phpredis dependencies"
        exit 1
    fi
    
    print_info "Installing dependencies..."
    brew install autoconf pkg-config
    
    # Get PHP version
    PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
    PHP_EXT_DIR=$(php-config --extension-dir)
    
    print_info "PHP Version: $PHP_VERSION"
    print_info "Extension Directory: $PHP_EXT_DIR"
    
    # Clone and build phpredis
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    
    print_info "Cloning phpredis repository..."
    git clone https://github.com/phpredis/phpredis.git
    cd phpredis
    
    print_info "Building phpredis extension..."
    phpize
    ./configure
    make
    sudo make install
    
    # Clean up
    cd -
    rm -rf "$TMP_DIR"
    
    # Find php.ini location
    PHP_INI=$(php --ini | grep "Loaded Configuration File" | awk '{print $4}')
    
    if [ -n "$PHP_INI" ] && [ -f "$PHP_INI" ]; then
        if ! grep -q "extension=redis" "$PHP_INI"; then
            print_info "Adding extension to php.ini..."
            echo "extension=redis.so" >> "$PHP_INI"
        fi
    else
        # Try common locations
        for ini in /etc/php.ini /usr/local/etc/php/*/php.ini "$(brew --prefix)/etc/php/$PHP_VERSION/php.ini"; do
            if [ -f "$ini" ]; then
                if ! grep -q "extension=redis" "$ini"; then
                    print_info "Adding extension to $ini..."
                    echo "extension=redis.so" >> "$ini"
                    break
                fi
            fi
        done
    fi
    
    # Verify installation
    if php -m | grep -q redis; then
        print_success "phpredis extension installed successfully"
        php -m | grep redis
    else
        print_warning "phpredis extension installed but may need PHP restart"
        print_info "Please restart your PHP service or web server"
    fi
}

# =========================================
# Main Installation Flow
# =========================================

main() {
    print_header "Development Tools Installation"
    echo ""
    
    # Install Homebrew first (required for most tools)
    install_homebrew
    
    # Install Node.js
    install_node
    
    # Install pnpm
    install_pnpm
    
    # Install Composer
    install_composer
    
    # Install MariaDB
    install_mariadb
    
    # Install Redis
    install_redis
    
    # Install phpredis
    install_phpredis
    
    echo ""
    print_header "Installation Complete!"
    echo ""
    print_success "All tools have been installed successfully"
    echo ""
    echo "Installed tools:"
    echo "  • Node.js: $(node --version 2>/dev/null || echo 'N/A')"
    echo "  • npm: $(npm --version 2>/dev/null || echo 'N/A')"
    echo "  • pnpm: $(pnpm --version 2>/dev/null || echo 'N/A')"
    echo "  • Composer: $(composer --version 2>/dev/null | head -1 || echo 'N/A')"
    echo "  • MariaDB: $(mariadb --version 2>/dev/null | head -1 || mysql --version 2>/dev/null | head -1 || echo 'N/A')"
    echo "  • Redis: $(redis-server --version 2>/dev/null || echo 'N/A')"
    echo "  • phpredis: $(php -m 2>/dev/null | grep redis || echo 'Not loaded')"
    echo ""
    print_warning "Note: You may need to restart your terminal or run 'source ~/.zshrc' for all changes to take effect"
    echo ""
}

# Run main function
main

