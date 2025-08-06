# AI Agent Orchestrator

A simple, reliable orchestrator for AI agent services with a web dashboard.

## Quick Start

### Start Services
```bash
./start-orchestrator.sh    # Starts orchestrator API on port 8000
./start-dashboard.sh       # Starts web dashboard on port 3000
```

### Stop Services
```bash
./stop-services.sh         # Stops all services cleanly
```

### Check Status
```bash
./status.sh               # Shows service status, PIDs, and recent logs
```

## Services

- **Orchestrator**: FastAPI service managing AI agents (http://localhost:8000)
- **Dashboard**: Next.js web interface for monitoring (http://localhost:3000)

## Logs

All logs are stored in the `logs/` directory:
- `orchestrator.log` - Main orchestrator service logs
- `dashboard.log` - Dashboard service logs

## Development

### Orchestrator
- Python FastAPI service in `orchestrator/`
- Virtual environment created automatically on first run
- Configuration in `config/orchestrator.yaml`

### Dashboard  
- Next.js application in `dashboard/`
- Node dependencies installed automatically on first run
- Modern React with TypeScript and Tailwind CSS

## Service Management

Services run as background processes with PID files for tracking:
- `orchestrator.pid` - Orchestrator process ID
- `dashboard.pid` - Dashboard process ID

The scripts handle:
- Environment setup (venv/node_modules)
- Dependency installation
- Process management
- Graceful shutdown
- Status monitoring

## Configuration

### Orchestrator Configuration

Edit `config/orchestrator.yaml`:

```yaml
orchestrator:
  host: "0.0.0.0"
  port: 8000
  log_level: "INFO"
  data_dir: "./data"
  log_dir: "./logs"
  services_dir: "./services"

monitoring:
  interval: 30        # Health check interval (seconds)
  timeout: 10         # HTTP timeout for health checks
  enabled: true

recovery:
  enabled: true
  max_retries: 3
  backoff_seconds: 30

api:
  cors_origins:
    - "http://localhost:3000"
  api_key: null       # Optional API key protection
  rate_limit: 100

database:
  path: "./data/registry.db"
```

### Service Configuration

Services are configured using YAML files in the `services/` directory:

```yaml
# services/my-service.yaml
id: my-service
name: My AI Service
type: ai-agent
executable: python /path/to/my_service.py
health_endpoint: http://localhost:8001/health
api_endpoint: http://localhost:8001
auto_start: true
restart_policy:
  max_retries: 3
  backoff_seconds: 30
resources:
  max_memory: 512MB
  max_cpu: 25%
environment:
  SERVICE_PORT: "8001"
  LOG_LEVEL: "INFO"
```

## CLI Usage

```bash
# Show orchestrator status
python -m cli.orchestrator_cli status

# List all services
python -m cli.orchestrator_cli list

# Show service details
python -m cli.orchestrator_cli show my-service

# Control services
python -m cli.orchestrator_cli start my-service
python -m cli.orchestrator_cli stop my-service
python -m cli.orchestrator_cli restart my-service
```

## API Reference

### REST API Endpoints

- `GET /api/services` - List all services
- `GET /api/services/{id}` - Get service details
- `POST /api/services` - Register new service
- `PUT /api/services/{id}/start` - Start service
- `PUT /api/services/{id}/stop` - Stop service
- `PUT /api/services/{id}/restart` - Restart service
- `GET /api/services/{id}/logs` - Get service logs
- `GET /health` - Orchestrator health check

### WebSocket Events

Connect to `ws://localhost:8000/ws` for real-time updates:
```javascript
const ws = new WebSocket('ws://localhost:8000/ws');
ws.onmessage = (event) => {
    const update = JSON.parse(event.data);
    // Handle service status updates
};
```

## Service Integration

### Making Services Orchestrator-Compatible

Services need to implement a few simple requirements:

1. **Health Endpoint**: Expose a `/health` endpoint
```python
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "my-service",
        "timestamp": datetime.now().isoformat()
    }
```

2. **Graceful Shutdown**: Handle SIGTERM signals
```python
import signal
import sys

def signal_handler(sig, frame):
    print('Shutting down gracefully...')
    # Cleanup code here
    sys.exit(0)

signal.signal(signal.SIGTERM, signal_handler)
```

3. **Service Registration** (optional): Auto-register with orchestrator
```python
from orchestrator_sdk import ServiceAgent

agent = ServiceAgent("my-service", "http://localhost:8000")
agent.register()
```
