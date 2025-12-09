# Docker Setup Guide

This guide will help you run the entire Envelope application (API, Tenant, HQ, Database) locally using Docker.

## Prerequisites

- Docker Desktop installed and running.

## Quick Start

### 1. Setup Environment Variables

Ensure you have `.env` files in each directory. You can copy the examples:

```bash
cp api/.env.example api/.env
cp tenant/.env.example tenant/.env
cp hq/.env.example hq/.env
```

**Important:** Update `api/.env` to point to the Docker services:

```ini
DB_HOST=mysql
REDIS_HOST=redis
```

### 2. Build and Start

**Recommended:** Use the helper script for better reliability:

```bash
./docker-up.sh -d
```

Or use Docker Compose directly:

```bash
docker-compose up --build -d
```

This will start:

- **API**: http://localhost:8000
- **Tenant App**: http://localhost:3001
- **HQ App**: http://localhost:3002
- **Mailpit** (Emails): http://localhost:8025
- **MySQL**: Port 3307
- **Redis**: Port 6379

### 3. Run Migrations

Once the containers are up, run the migrations inside the API container:

```bash
docker-compose exec api php artisan migrate --seed
```

## Useful Commands

| Action              | Command                                                             |
| :------------------ | :------------------------------------------------------------------ |
| **Start Services**  | `./docker-up.sh -d` (recommended) or `docker-compose up --build -d` |
| **Stop All**        | `docker-compose down`                                               |
| **View Logs**       | `docker-compose logs -f`                                            |
| **API Shell**       | `docker-compose exec api bash`                                      |
| **Run Artisan**     | `docker-compose exec api php artisan <command>`                     |
| **Rebuild**         | `./docker-up.sh --build -d` or `docker-compose up --build -d`       |
| **Skip Image Pull** | `./docker-up.sh --no-pull -d` (uses cached images)                  |

## Troubleshooting

### Network Timeout Issues

If you encounter TLS handshake timeouts or network errors when pulling images:

1. **Use the helper script** (handles retries automatically):

   ```bash
   ./docker-up.sh -d
   ```

2. **Skip pulling images** (use cached images):

   ```bash
   ./docker-up.sh --no-pull -d
   ```

3. **Configure Docker daemon** for better network reliability:

   ```bash
   sudo ./docker-configure.sh --configure
   ```

4. **View troubleshooting tips**:

   ```bash
   ./docker-configure.sh --tips
   ```

5. **Pull images manually** with retries:
   ```bash
   docker pull mariadb:10.11
   docker pull redis:alpine
   docker pull axllent/mailpit
   ```

### Common Issues

- **"pull access denied" warnings**: These are expected for local images (envelope-api, envelope-tenant, envelope-hq). They will be built automatically.
- **TLS handshake timeout**: Use `./docker-up.sh` which includes retry logic, or configure Docker daemon settings.
- **Port conflicts**: Ensure ports 3001, 3002, 3307, 6379, 8016, 8025, 8080, and 1025 are not in use.

## Architecture Note

This Docker setup mirrors the Production AWS Fargate architecture:

- **API**: Runs Octane (Swoole).
- **Worker**: Runs as a separate container (simulating a separate Fargate task).
- **Frontends**: Run as separate Node.js services.
