# AI Agent Service Management Commands

**Context**: These are the conversational commands for managing AI Agent services through Claude Code terminal interface.

**IMPORTANT**: These commands work from ANY directory - Claude will automatically navigate to the correct location.

## Service Management Commands

### "Claude, turn on our services"
**Action**: Start both orchestrator and dashboard services

**Commands to Execute** (from any directory):
```bash
cd /Users/ianswanson/Development/ai-agent-orchestrator
./start-orchestrator.sh
./start-dashboard.sh
./status.sh
```

**Expected Response Format**:
```
🚀 AI Agent Services Started

✅ Orchestrator: Running on http://localhost:8000
✅ Dashboard: Running on http://localhost:3000

Services are ready for use.
```

### "Claude, check our services" / "What's the status of our services?"
**Action**: Check current service status without starting anything

**Commands to Execute** (from any directory):
```bash
cd /Users/ianswanson/Development/ai-agent-orchestrator
./status.sh
```

**Response Format**:
- If both running: "✅ All services operational"
- If partial: "⚠️ Some services need attention"  
- If none running: "❌ Services are stopped - say 'turn on our services' to start"

### "Claude, stop our services"
**Action**: Cleanly shut down all services

**Commands to Execute** (from any directory):
```bash
cd /Users/ianswanson/Development/ai-agent-orchestrator
./stop-services.sh
```

**Expected Response Format**:
```
🛑 Services Stopped

All AI Agent services have been cleanly shut down.
```

### "Claude, restart our services"
**Action**: Full stop and start cycle

**Commands to Execute** (from any directory):
```bash
cd /Users/ianswanson/Development/ai-agent-orchestrator
./stop-services.sh
sleep 3
./start-orchestrator.sh
./start-dashboard.sh
./status.sh
```

## Available Scripts

**Service Scripts** (created by complexity trap breakthrough cleanup):
- `start-orchestrator.sh` - Starts orchestrator with venv setup
- `start-dashboard.sh` - Starts Next.js dashboard with npm setup  
- `stop-services.sh` - Cleanly stops all services
- `status.sh` - Shows service status, PIDs, ports, and recent logs

## Troubleshooting

### If Start Fails
1. **Port conflicts**: Check `lsof -i :8000` and `lsof -i :3000`
2. **Missing dependencies**: Verify venv exists and npm packages installed
3. **Permission issues**: Check script permissions with `ls -la *.sh`

### Success Criteria
Services are successfully running when:
- Orchestrator responds to `curl http://localhost:8000/health`
- Dashboard responds to `curl http://localhost:3000`
- Status script shows both services with PIDs

## Context Notes

- **These scripts were created** after cleaning up failed complex automation
- **Scripts are tested and working** - they were validated during creation
- **Manual startup is intentional** - chosen over broken automation for reliability
- **Foundation for future enhancement** - automation can be added once manual process is solid
