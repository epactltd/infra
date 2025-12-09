# Docker Compose Configuration Guide

This directory contains Docker Compose configurations for both **Development** and **Production** environments.

## Files

- `docker-compose.yml` - Development environment with hot reload and watch mode
- `docker-compose.prod.yml` - Production environment with optimized builds

## Port Configuration

### Development & Production Ports

| Service        | Container Port | Host Port (Dev) | Host Port (Prod) | Description              |
| -------------- | -------------- | --------------- | ---------------- | ------------------------ |
| API (Octane)   | 8000           | 8008            | 8008             | Laravel API server       |
| API (Reverb)   | 8080           | 8080            | 8080             | WebSocket server         |
| HQ (Nuxt)      | 3000           | 3000            | 3000             | HQ frontend app          |
| Tenant (Nuxt)  | 3000           | 3001            | 3001             | Tenant frontend app      |
| MySQL          | 3306           | 3307            | 3307             | Database server          |
| Redis          | 6379           | 6379            | 6379             | Cache & queue            |
| Mailpit (SMTP) | 1025           | 1025            | -                | Email testing (dev only) |
| Mailpit (UI)   | 8025           | 8025            | -                | Email UI (dev only)      |

## Development Environment

### Features

- ✅ Hot reload for code changes
- ✅ Volume mounts for live editing
- ✅ Watch mode for automatic rebuilds
- ✅ Development-optimized settings
- ✅ Mailpit for email testing

### Usage

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop all services
docker compose down

# Rebuild specific service
docker compose build api
docker compose up -d api
```

### Environment Variables

Create a `.env` file in the `infra` directory:

```env
# Application Environment
APP_ENV=local
APP_DEBUG=true

# Database
DB_DATABASE=envelope
DB_USERNAME=root
DB_PASSWORD=root
MYSQL_ROOT_PASSWORD=root

# Ports (optional - defaults shown)
OCTANE_HOST_PORT=8008
TENANT_PORT=3001
HQ_PORT=3000
MYSQL_HOST_PORT=3307

# Frontend URLs
TENANT_BASE_URL=http://localhost:3001
HQ_BASE_URL=http://localhost:3000
BASE_DOMAIN=localhost
TENANT_PRIMARY_DOMAIN=localhost

# Reverb (WebSocket)
REVERB_APP_KEY=your-reverb-key
REVERB_APP_SECRET=your-reverb-secret
REVERB_APP_ID=your-reverb-id
REVERB_HOST=localhost
REVERB_PORT=8080

# ReCAPTCHA (optional)
RECAPTCHA_V2_SITEKEY=your-site-key
```

### Development Workflow

1. **First Time Setup:**

   ```bash
   # Build images
   docker compose build

   # Start services
   docker compose up -d

   # Install dependencies (if needed)
   docker compose exec api composer install
   docker compose exec tenant pnpm install
   docker compose exec hq pnpm install

   # Run migrations
   docker compose exec api php artisan migrate
   ```

2. **Daily Development:**

   ```bash
   # Start services
   docker compose up -d

   # View logs
   docker compose logs -f api
   docker compose logs -f tenant
   docker compose logs -f hq
   ```

3. **Code Changes:**
   - Changes to Laravel code are automatically synced via volumes
   - Changes to Nuxt code trigger automatic rebuilds via watch mode
   - No need to rebuild containers for code changes

## Production Environment

### Features

- ✅ Pre-built production images
- ✅ No volume mounts (immutable containers)
- ✅ Optimized for performance
- ✅ Production-ready environment variables
- ✅ Resource limits configured

### Usage

```bash
# Build production images
docker compose -f docker-compose.prod.yml build

# Start production services
docker compose -f docker-compose.prod.yml up -d

# View logs
docker compose -f docker-compose.prod.yml logs -f

# Stop production services
docker compose -f docker-compose.prod.yml down
```

### Environment Variables

Create a `.env.prod` file or set environment variables:

```env
# Application Environment
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.yourdomain.com

# Database
DB_HOST=mysql
DB_DATABASE=envelope_prod
DB_USERNAME=envelope_user
DB_PASSWORD=secure_password
MYSQL_ROOT_PASSWORD=secure_root_password

# Redis
REDIS_HOST=redis
REDIS_PASSWORD=secure_redis_password

# Ports
OCTANE_HOST_PORT=8008
TENANT_PORT=3001
HQ_PORT=3000

# Frontend URLs
TENANT_BASE_URL=https://tenant.yourdomain.com
HQ_BASE_URL=https://hq.yourdomain.com
BASE_DOMAIN=yourdomain.com
TENANT_PRIMARY_DOMAIN=yourdomain.com

# API URLs (for frontend)
TENANT_API_URL=https://api.yourdomain.com
HQ_API_URL=https://api.yourdomain.com

# Reverb (WebSocket)
REVERB_APP_KEY=your-production-key
REVERB_APP_SECRET=your-production-secret
REVERB_APP_ID=your-production-id
REVERB_HOST=yourdomain.com
REVERB_PORT=8080
REVERB_CLUSTER=mt1

# CORS
CORS_ALLOWED_ORIGINS=https://tenant.yourdomain.com,https://hq.yourdomain.com

# Mail
MAIL_MAILER=smtp
MAIL_HOST=smtp.yourdomain.com
MAIL_PORT=587
MAIL_USERNAME=your-email@yourdomain.com
MAIL_PASSWORD=your-email-password
MAIL_FROM_ADDRESS=noreply@yourdomain.com
MAIL_FROM_NAME=Envelope

# ReCAPTCHA
RECAPTCHA_V2_SITEKEY=your-production-site-key
```

### Production Deployment

1. **Build Images:**

   ```bash
   docker compose -f docker-compose.prod.yml build --no-cache
   ```

2. **Set Environment Variables:**

   ```bash
   export $(cat .env.prod | xargs)
   ```

3. **Start Services:**

   ```bash
   docker compose -f docker-compose.prod.yml up -d
   ```

4. **Verify Health:**
   ```bash
   docker compose -f docker-compose.prod.yml ps
   ```

## Service Details

### API (Laravel)

- **Framework:** Laravel with Octane (Swoole)
- **Ports:** 8008 (HTTP), 8080 (WebSocket)
- **Health Check:** PHP CLI check
- **Dependencies:** MySQL, Redis

### Worker (Laravel Queue)

- **Purpose:** Background job processing
- **Dependencies:** MySQL, Redis
- **Command:** Supervisor-managed queue workers

### HQ (Nuxt)

- **Framework:** Nuxt 4
- **Port:** 3000
- **Build:** Production build in Dockerfile
- **Dependencies:** API

### Tenant (Nuxt)

- **Framework:** Nuxt 4
- **Port:** 3001
- **Build:** Production build in Dockerfile
- **Dependencies:** API

### MySQL (MariaDB)

- **Version:** 10.11
- **Port:** 3307
- **Health Check:** Database connection check
- **Data Persistence:** Named volume `mysql_data`

### Redis

- **Version:** 7-alpine
- **Port:** 6379
- **Health Check:** Redis ping
- **Data Persistence:** Named volume `redis_data`

### Mailpit (Development Only)

- **Purpose:** Email testing and debugging
- **Ports:** 1025 (SMTP), 8025 (Web UI)
- **Access:** http://localhost:8025

## Troubleshooting

### Port Conflicts

If ports are already in use, modify the port mappings in docker-compose.yml:

```yaml
ports:
  - '8009:8000' # Change 8008 to 8009
```

### Memory Issues

If builds fail with memory errors:

1. Increase Docker Desktop memory allocation (Settings → Resources)
2. Or build with explicit memory limit:
   ```bash
   docker compose build --memory=8g
   ```

### Database Connection Issues

1. Check MySQL is healthy:

   ```bash
   docker compose ps mysql
   ```

2. Check connection from API container:
   ```bash
   docker compose exec api php artisan tinker
   # Then: DB::connection()->getPdo();
   ```

### Frontend Build Issues

1. Clear Nuxt cache:

   ```bash
   docker compose exec tenant rm -rf .nuxt .output
   docker compose exec hq rm -rf .nuxt .output
   ```

2. Rebuild containers:
   ```bash
   docker compose build tenant hq
   ```

## Switching Between Environments

### Development → Production

```bash
# Stop development
docker compose down

# Start production
docker compose -f docker-compose.prod.yml up -d
```

### Production → Development

```bash
# Stop production
docker compose -f docker-compose.prod.yml down

# Start development
docker compose up -d
```

## Best Practices

1. **Never commit `.env` files** - Use `.env.example` as template
2. **Use separate compose files** - Keep dev and prod configurations separate
3. **Regular backups** - Backup MySQL and Redis volumes regularly
4. **Monitor resources** - Use `docker stats` to monitor resource usage
5. **Health checks** - All services have health checks configured
6. **Resource limits** - Production has resource limits set

## Additional Commands

```bash
# View all running containers
docker compose ps

# Execute commands in containers
docker compose exec api php artisan migrate
docker compose exec tenant pnpm install
docker compose exec mysql mysql -u root -p

# View service logs
docker compose logs -f api
docker compose logs -f tenant
docker compose logs -f hq

# Restart a service
docker compose restart api

# Remove all containers and volumes (⚠️ destructive)
docker compose down -v
```
