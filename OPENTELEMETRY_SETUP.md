# OpenTelemetry Setup Guide

This guide explains how to use the OpenTelemetry observability stack that has been integrated into the Envelope SaaS application.

## Overview

The OpenTelemetry setup includes:

- **OpenTelemetry Collector**: Receives telemetry data from the Laravel application
- **Jaeger**: Distributed tracing backend for visualizing request traces
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization dashboard for metrics and traces

## Architecture

```
Laravel API/Worker → OpenTelemetry Collector → Jaeger (Traces)
                                          → Prometheus (Metrics)
                                          → Grafana (Dashboards)
```

## Services and Ports

| Service               | Port  | URL                    | Description                  |
| --------------------- | ----- | ---------------------- | ---------------------------- |
| Jaeger UI             | 16686 | http://localhost:16686 | Trace visualization          |
| Grafana               | 3002  | http://localhost:3002  | Metrics and traces dashboard |
| Prometheus            | 9090  | http://localhost:9090  | Metrics query interface      |
| OTEL Collector (gRPC) | 4317  | -                      | Receives OTLP data via gRPC  |
| OTEL Collector (HTTP) | 4318  | -                      | Receives OTLP data via HTTP  |

## Getting Started

### 1. Start the Services

From the `infra` directory, start all services:

```bash
cd infra
docker compose up -d
```

This will start:

- All existing services (API, MySQL, Redis, etc.)
- OpenTelemetry Collector
- Jaeger
- Prometheus
- Grafana

### 2. Access the Dashboards

#### Jaeger (Traces)

- URL: http://localhost:16686
- Use this to view distributed traces from your Laravel application
- Search for traces by service name, operation, tags, etc.

#### Grafana (Metrics & Dashboards)

- URL: http://localhost:3002
- Default credentials:
  - Username: `admin`
  - Password: `admin` (change this in production!)
- Pre-configured datasources:
  - Prometheus (for metrics)
  - Jaeger (for traces)

#### Prometheus (Metrics Query)

- URL: http://localhost:9090
- Use PromQL to query metrics directly

### 3. Viewing Traces

1. Make some requests to your Laravel API
2. Open Jaeger UI at http://localhost:16686
3. Select the service name (e.g., `envelope-api` or `envelope-worker`)
4. Click "Find Traces" to see all traces
5. Click on a trace to see the detailed span breakdown

### 4. Viewing Metrics

1. Open Grafana at http://localhost:3002
2. Navigate to "Explore" to query metrics
3. Select "Prometheus" as the datasource
4. Use PromQL queries like:
   - `http_server_request_duration` - HTTP request duration
   - `http_server_request_count` - HTTP request count
   - `db_client_operation_duration` - Database query duration

## Configuration

### Environment Variables

The following environment variables are configured in `docker-compose.yml`:

#### For API Service:

- `OTEL_SERVICE_NAME`: Service name (default: `envelope-api`)
- `OTEL_EXPORTER_OTLP_ENDPOINT`: Collector endpoint (default: `http://otel-collector:4318`)
- `OTEL_EXPORTER_OTLP_PROTOCOL`: Protocol to use (default: `http/protobuf`)

#### For Worker Service:

- `OTEL_SERVICE_NAME`: Service name (default: `envelope-worker`)

### Customizing Instrumentation

You can enable/disable specific instrumentations by setting environment variables:

```bash
# Disable HTTP server instrumentation
OTEL_INSTRUMENTATION_HTTP_SERVER=false

# Disable database query instrumentation
OTEL_INSTRUMENTATION_QUERY=false

# Disable Redis instrumentation
OTEL_INSTRUMENTATION_REDIS=false

# Disable queue instrumentation
OTEL_INSTRUMENTATION_QUEUE=false
```

See `api/config/opentelemetry.php` for all available options.

### Disabling OpenTelemetry

To completely disable OpenTelemetry, set:

```bash
OTEL_SDK_DISABLED=true
```

## Manual Tracing

You can create custom traces in your Laravel code:

```php
use Keepsuit\LaravelOpenTelemetry\Facades\Tracer;

// Simple trace
Tracer::newSpan('my custom trace')->measure(function () {
    // Your code here
});

// Advanced trace with attributes
$span = Tracer::newSpan('database operation')
    ->setAttribute('db.operation', 'select')
    ->setAttribute('db.table', 'users')
    ->start();

try {
    // Your code here
    $span->setStatus('ok');
} catch (\Exception $e) {
    $span->setStatus('error', $e->getMessage());
    throw $e;
} finally {
    $span->end();
}
```

## Metrics

You can create custom metrics:

```php
use Keepsuit\LaravelOpenTelemetry\Facades\Meter;

// Counter
$counter = Meter::createCounter('my_counter', 'times', 'My custom counter');
$counter->add(1, ['status' => 'success']);

// Histogram
$histogram = Meter::createHistogram('my_histogram', 'ms', 'My custom histogram');
$histogram->record(100, ['operation' => 'query']);

// Gauge
$gauge = Meter::createGauge('my_gauge', null, 'My custom gauge');
$gauge->record(42, ['label' => 'value']);
```

## Logs

OpenTelemetry logs are automatically correlated with traces. The trace ID is injected into log context automatically.

You can also use the OpenTelemetry logger directly:

```php
use Keepsuit\LaravelOpenTelemetry\Facades\Logger;

Logger::info('My log message', ['key' => 'value']);
```

## Troubleshooting

### Traces not appearing in Jaeger

1. Check that the OpenTelemetry Collector is running:

   ```bash
   docker compose ps otel-collector
   ```

2. Check collector logs:

   ```bash
   docker compose logs otel-collector
   ```

3. Verify the API service can reach the collector:

   ```bash
   docker compose exec api ping otel-collector
   ```

4. Check that environment variables are set correctly in the API container:
   ```bash
   docker compose exec api env | grep OTEL
   ```

### Metrics not appearing in Prometheus

1. Check Prometheus targets: http://localhost:9090/targets
2. Verify the collector is exposing metrics on port 8889
3. Check Prometheus configuration in `prometheus-config.yaml`

### Grafana not connecting to datasources

1. Check Grafana logs:

   ```bash
   docker compose logs grafana
   ```

2. Verify datasource configuration in `grafana-datasources.yaml`
3. Check that Prometheus and Jaeger are accessible from Grafana container

## Production Considerations

1. **Change default passwords**: Update Grafana admin credentials
2. **Resource limits**: Add resource limits to containers in production
3. **Persistence**: Ensure volumes are properly backed up
4. **Sampling**: Consider enabling trace sampling to reduce overhead:
   ```bash
   OTEL_TRACES_SAMPLER_TYPE=traceidratio
   OTEL_TRACES_SAMPLER_TRACEIDRATIO_RATIO=0.1  # Sample 10% of traces
   ```
5. **Security**: Use TLS for OTLP endpoints in production
6. **Retention**: Configure appropriate retention policies for Prometheus

## Additional Resources

- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Laravel OpenTelemetry Package](https://github.com/keepsuit/laravel-opentelemetry)
- [Jaeger Documentation](https://www.jaegertracing.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
