# Claude Code Implementation Instructions

## Project Overview
You are building the AI Agent Service Orchestrator - a master control system for managing multiple AI agent services. This builds upon the proven Reddit Monitor service architecture and creates a unified management platform for all AI agents.

## Current State
- **Reddit Monitor Service**: Successfully running as a true background service with 5-layer architecture
- **Service Pattern Proven**: Background daemon, HTTP API, web dashboard, automatic recovery all working
- **Next Evolution**: Build orchestrator to manage multiple services from one control point

## Critical Requirements

### 1. Service-First Architecture
Everything must be built as an always-on service, NOT a run-once application:
- **Background Process**: Orchestrator runs continuously without terminal
- **Self-Recovery**: Automatically restarts if it crashes
- **Health Monitoring**: Exposed health endpoints for status checking
- **Persistent State**: Survives computer restarts
- **Resource Management**: Handles memory/CPU responsibly

### 2. Core Functionality
The orchestrator must provide:
- **Service Registry**: Track all AI agent services and their configurations
- **Health Monitoring**: Continuously check if services are running/healthy
- **Automatic Recovery**: Restart failed services with appropriate backoff
- **Unified Dashboard**: Single web interface to monitor/control all services
- **Service Discovery**: Services can register themselves with orchestrator

### 3. Implementation Standards
- **Clean Code**: Well-organized, commented, following Python/JavaScript best practices
- **Error Handling**: Graceful degradation, helpful error messages
- **Logging**: Comprehensive logging for debugging and monitoring
- **Configuration**: Externalized config files, not hardcoded values
- **Documentation**: Clear README, setup instructions, API documentation

## Conversational Service Management

This project supports conversational commands for service management. See `SERVICE_COMMANDS.md` for complete reference.

### Quick Commands
- **"Claude, turn on our services"** - Start orchestrator and dashboard (works from any directory)
- **"Claude, check our services"** - Show current status (works from any directory)
- **"Claude, stop our services"** - Clean shutdown (works from any directory)
- **"Claude, restart our services"** - Full restart cycle (works from any directory)

### Current Service Scripts
After complexity trap breakthrough cleanup, these reliable scripts exist:
- `start-orchestrator.sh` - Start orchestrator with venv
- `start-dashboard.sh` - Start dashboard with npm
- `stop-services.sh` - Clean shutdown
- `status.sh` - Status check with PIDs and ports

**Note**: These scripts are tested and working. Manual startup was chosen over complex automation for reliability.

---

## Technical Implementation Guide

### Phase 1: Core Orchestrator Service

#### 1.1 Project Structure
```
ai-agent-orchestrator/
├── orchestrator/
│   ├── __init__.py
│   ├── orchestrator.py       # Main service entry point
│   ├── registry.py          # Service registry management
│   ├── monitor.py           # Health monitoring logic
│   ├── recovery.py          # Service recovery manager
│   ├── api.py              # REST API endpoints
│   └── config.py           # Configuration management
├── dashboard/
│   ├── app/                # Next.js app directory
│   ├── components/         # React components
│   ├── public/            # Static assets
│   └── package.json       # Node dependencies
├── cli/
│   ├── __init__.py
│   └── orchestrator_cli.py  # CLI tool
├── sdk/
│   ├── __init__.py
│   └── agent.py           # Service agent SDK
├── services/              # Service configurations
│   └── reddit-monitor.yaml
├── data/                  # Persistent data
│   └── registry.db       # SQLite database
├── logs/                 # Log files
├── scripts/              # Management scripts
│   ├── start.sh
│   ├── stop.sh
│   └── install.sh
├── requirements.txt      # Python dependencies
├── README.md
└── .gitignore
```

#### 1.2 Service Registry Implementation
Start with a simple but extensible registry:
```python
# registry.py
class ServiceRegistry:
    def __init__(self, db_path):
        self.db_path = db_path
        self.init_database()
    
    def register_service(self, service_config):
        """Register a new service with the orchestrator"""
        # Validate configuration
        # Store in database
        # Return service ID
    
    def get_service(self, service_id):
        """Get service configuration and status"""
        
    def update_service_status(self, service_id, status):
        """Update service operational status"""
        
    def list_services(self):
        """List all registered services"""
```

#### 1.3 Health Monitoring Pattern
```python
# monitor.py
class HealthMonitor:
    def __init__(self, registry, interval=30):
        self.registry = registry
        self.interval = interval
        self.monitoring = False
        
    async def check_service_health(self, service):
        """Check if service is responsive"""
        # HTTP health check
        # Process existence check
        # Resource usage check
        
    async def monitoring_loop(self):
        """Continuous monitoring of all services"""
        while self.monitoring:
            services = self.registry.list_services()
            for service in services:
                health = await self.check_service_health(service)
                self.registry.update_service_status(service.id, health)
            await asyncio.sleep(self.interval)
```

### Phase 2: Web Dashboard

#### 2.1 Next.js Setup
```bash
# Create Next.js app with TypeScript
npx create-next-app@latest dashboard --typescript --tailwind --app
```

#### 2.2 Core Components Structure
```
dashboard/
├── app/
│   ├── layout.tsx
│   ├── page.tsx           # Main dashboard
│   └── api/
│       └── services/      # API routes
├── components/
│   ├── ServiceGrid.tsx    # Grid of service cards
│   ├── ServiceCard.tsx    # Individual service display
│   ├── ControlPanel.tsx   # Start/stop controls
│   ├── HealthChart.tsx    # Health metrics chart
│   └── LogViewer.tsx      # Service logs display
└── lib/
    ├── api.ts            # API client
    └── websocket.ts      # WebSocket client
```

#### 2.3 Real-time Updates
Use WebSocket for live dashboard updates:
```typescript
// lib/websocket.ts
export class OrchestratorWebSocket {
    private ws: WebSocket | null = null;
    
    connect() {
        this.ws = new WebSocket('ws://localhost:8000/ws');
        this.ws.onmessage = (event) => {
            const update = JSON.parse(event.data);
            // Update service state in UI
        };
    }
}
```

### Phase 3: Service Integration

#### 3.1 Reddit Monitor Integration
Create configuration file for existing Reddit Monitor:
```yaml
# services/reddit-monitor.yaml
id: reddit-monitor
name: Reddit Claude Monitor
type: monitoring
executable: /Users/ianswanson/Development/reddit-claude-monitor/reddit_monitor.py
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
  REDDIT_CLIENT_ID: ${REDDIT_CLIENT_ID}
  REDDIT_CLIENT_SECRET: ${REDDIT_CLIENT_SECRET}
```

#### 3.2 Service Adapter Pattern
Create adapter to make existing services orchestrator-compatible:
```python
# sdk/agent.py
class ServiceAgent:
    def __init__(self, service_id, orchestrator_url):
        self.service_id = service_id
        self.orchestrator_url = orchestrator_url
        
    def register(self):
        """Register this service with orchestrator"""
        
    def report_health(self, status):
        """Report health status to orchestrator"""
        
    def graceful_shutdown(self):
        """Handle shutdown signal from orchestrator"""
```

### Development Workflow

#### Step 1: Basic Orchestrator
1. Implement core orchestrator service with registry
2. Add basic health monitoring (process checking)
3. Create REST API for service management
4. Test with manual service registration

#### Step 2: Service Control
1. Add ability to start/stop services
2. Implement automatic restart for failed services
3. Add resource monitoring (CPU/memory)
4. Create service logs aggregation

#### Step 3: Dashboard Development
1. Build Next.js dashboard with service grid
2. Add WebSocket for real-time updates
3. Implement service control buttons
4. Add health visualization

#### Step 4: Production Features
1. Service configuration management
2. Advanced recovery strategies
3. Performance metrics collection
4. Alert system for failures

## Critical Implementation Details

### Process Management
Use Python's `subprocess` and `psutil` for robust process control:
```python
import subprocess
import psutil

def start_service(service_config):
    """Start a service as a subprocess"""
    process = subprocess.Popen(
        service_config['command'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        start_new_session=True  # Detach from parent
    )
    return process.pid

def check_process_exists(pid):
    """Check if process is still running"""
    try:
        process = psutil.Process(pid)
        return process.is_running()
    except psutil.NoSuchProcess:
        return False
```

### Service Discovery Protocol
Services announce themselves to orchestrator:
```python
# In each service's startup code
def announce_to_orchestrator():
    response = requests.post(
        'http://localhost:8000/api/services/announce',
        json={
            'service_id': 'my-service',
            'health_endpoint': 'http://localhost:8002/health',
            'api_endpoint': 'http://localhost:8002'
        }
    )
```

### Health Check Standard
All services must implement standard health endpoint:
```python
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "my-service",
        "timestamp": datetime.now().isoformat(),
        "metrics": {
            "memory_usage_mb": get_memory_usage(),
            "uptime_seconds": get_uptime()
        }
    }
```

## Testing Strategy

### Unit Tests
- Registry CRUD operations
- Health check logic
- Recovery manager decisions
- API endpoint functionality

### Integration Tests
- Service startup/shutdown
- Health monitoring cycle
- Dashboard WebSocket updates
- Multi-service coordination

### System Tests
- Full orchestrator with real services
- Failure recovery scenarios
- Resource limit enforcement
- Dashboard user workflows

## Deployment Considerations

### Local Development
1. Use virtual environment for Python
2. Run orchestrator on port 8000
3. Dashboard on port 3000
4. Services on ports 8001+

### Production Deployment
1. Systemd service for orchestrator
2. Nginx reverse proxy for dashboard
3. Process isolation for services
4. Monitoring integration (Prometheus/Grafana)

## Common Pitfalls to Avoid

1. **Don't Block**: Use async/await for all I/O operations
2. **Handle Crashes**: Expect services to fail unexpectedly
3. **Avoid Tight Coupling**: Services should work without orchestrator
4. **Resource Limits**: Prevent runaway services from consuming all resources
5. **Clean Shutdown**: Handle SIGTERM gracefully in all components

## Success Criteria

The orchestrator is successful when:
1. **Single Command**: All services start with one command
2. **Self-Healing**: Failed services automatically recover
3. **Full Visibility**: Dashboard shows real-time status of everything
4. **Easy Integration**: New services added in < 5 minutes
5. **Reliable Operation**: System runs for days without intervention

## Next Service Ideas

After orchestrator is working, consider adding:
1. **Email Monitor**: Check important emails, surface key items
2. **GitHub Monitor**: Track repository activity, PR reviews needed
3. **System Monitor**: CPU, disk, memory alerts
4. **News Aggregator**: Curated news from multiple sources
5. **Task Scheduler**: Cron-like job scheduling with UI

## Resources and References

- **Process Management**: https://docs.python.org/3/library/subprocess.html
- **FastAPI**: https://fastapi.tiangolo.com/
- **Next.js**: https://nextjs.org/docs
- **WebSocket**: https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
- **Systemd**: https://www.freedesktop.org/software/systemd/man/systemd.service.html

---

Remember: The goal is to create a system where AI agents "just work" without constant manual intervention. Every design decision should support this vision of operational excellence.
