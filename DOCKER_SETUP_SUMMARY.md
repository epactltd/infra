# Docker Setup Summary

## What Was Created

### 1. Development Configuration

- **File:** `docker-compose.yml`
- **Purpose:** Local development with hot reload
- **Features:**
  - Volume mounts for live code editing
  - Watch mode for automatic rebuilds
  - Development Dockerfiles (`Dockerfile.dev`) for Nuxt apps
  - Mailpit for email testing
  - Development-optimized settings

### 2. Production Configuration

- **File:** `docker-compose.prod.yml`
- **Purpose:** Production deployment
- **Features:**
  - Pre-built production images
  - No volume mounts (immutable)
  - Production Dockerfiles (multi-stage builds)
  - Resource limits
  - Health checks
  - Production environment variables

### 3. Development Dockerfiles

- **Files:**
  - `hq/Dockerfile.dev`
  - `tenant/Dockerfile.dev`
- **Purpose:** Fast development builds (no production build step)
- **Features:**
  - Installs dependencies only
  - Runs `pnpm dev` for hot reload
  - Faster startup for development

## Port Configuration

| Service      | Container Port | Host Port | URL                   |
| ------------ | -------------- | --------- | --------------------- |
| API (Octane) | 8000           | 8008      | http://localhost:8008 |
| API (Reverb) | 8080           | 8080      | ws://localhost:8080   |
| HQ           | 3000           | 3000      | http://localhost:3000 |
| Tenant       | 3000           | 3001      | http://localhost:3001 |
| MySQL        | 3306           | 3307      | localhost:3307        |
| Redis        | 6379           | 6379      | localhost:6379        |
| Mailpit UI   | 8025           | 8025      | http://localhost:8025 |

## Key Differences: Dev vs Prod

| Feature             | Development             | Production                 |
| ------------------- | ----------------------- | -------------------------- |
| **Dockerfiles**     | `Dockerfile.dev` (Nuxt) | `Dockerfile` (multi-stage) |
| **Volumes**         | ✅ Yes (live editing)   | ❌ No (immutable)          |
| **Watch Mode**      | ✅ Yes                  | ❌ No                      |
| **Build Step**      | ❌ No (dev server)      | ✅ Yes (production build)  |
| **Environment**     | `local` / `development` | `production`               |
| **Debug Mode**      | ✅ Enabled              | ❌ Disabled                |
| **Mail Service**    | Mailpit                 | External SMTP              |
| **Resource Limits** | ❌ No                   | ✅ Yes                     |
| **Hot Reload**      | ✅ Yes                  | ❌ No                      |

## Quick Start

### Development

```bash
cd infra
docker compose up -d
```

### Production

```bash
cd infra
docker compose -f docker-compose.prod.yml up -d
```

## Environment Variables Required

### Development (.env)

```env
APP_ENV=local
DB_DATABASE=envelope
DB_USERNAME=root
DB_PASSWORD=root
```

### Production (.env.prod)

```env
APP_ENV=production
DB_DATABASE=envelope_prod
DB_USERNAME=envelope_user
DB_PASSWORD=secure_password
TENANT_BASE_URL=https://tenant.yourdomain.com
HQ_BASE_URL=https://hq.yourdomain.com
# ... (see DOCKER_COMPOSE_README.md for full list)
```

## File Structure

```
infra/
├── docker-compose.yml          # Development config
├── docker-compose.prod.yml     # Production config
├── DOCKER_COMPOSE_README.md   # Full documentation
└── DOCKER_SETUP_SUMMARY.md    # This file

hq/
├── Dockerfile                  # Production build
└── Dockerfile.dev             # Development (no build)

tenant/
├── Dockerfile                  # Production build
└── Dockerfile.dev             # Development (no build)

api/
└── Dockerfile                  # Used for both dev & prod
```

## Next Steps

1. **Create `.env` file** in `infra/` directory with your configuration
2. **Start development:** `docker compose up -d`
3. **Check logs:** `docker compose logs -f`
4. **Access services:**
   - API: http://localhost:8008
   - HQ: http://localhost:3000
   - Tenant: http://localhost:3001
   - Mailpit: http://localhost:8025

For detailed documentation, see `DOCKER_COMPOSE_README.md`.
