# OpenTelemetry Quick Start

## Start Services

```bash
cd infra
docker compose up -d
```

## Access Dashboards

- **Jaeger (Traces)**: http://localhost:16686
- **Grafana (Metrics)**: http://localhost:3002 (admin/admin)
- **Prometheus**: http://localhost:9090

## Test It

1. Make some API requests to your Laravel application
2. Open Jaeger UI and search for traces from `envelope-api`
3. View metrics in Grafana

## Disable OpenTelemetry

Set in your `.env` or docker-compose:

```bash
OTEL_SDK_DISABLED=true
```

See `OPENTELEMETRY_SETUP.md` for detailed documentation.
