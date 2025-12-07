# Docker Setup Guide

This guide will help you run the entire Envelope application (API, Tenant, HQ, Database) locally using Docker.

## Prerequisites
*   Docker Desktop installed and running.

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
Run the following command from the root `/App` directory:

```bash
docker-compose up --build -d
```

This will start:
*   **API**: http://localhost:8000
*   **Tenant App**: http://localhost:3001
*   **HQ App**: http://localhost:3002
*   **Mailpit** (Emails): http://localhost:8025
*   **MySQL**: Port 3307
*   **Redis**: Port 6379

### 3. Run Migrations
Once the containers are up, run the migrations inside the API container:

```bash
docker-compose exec api php artisan migrate --seed
```

## Useful Commands

| Action | Command |
| :--- | :--- |
| **Stop All** | `docker-compose down` |
| **View Logs** | `docker-compose logs -f` |
| **API Shell** | `docker-compose exec api bash` |
| **Run Artisan** | `docker-compose exec api php artisan <command>` |
| **Rebuild** | `docker-compose up --build -d` |

## Architecture Note
This Docker setup mirrors the Production AWS Fargate architecture:
*   **API**: Runs Octane (Swoole).
*   **Worker**: Runs as a separate container (simulating a separate Fargate task).
*   **Frontends**: Run as separate Node.js services.
