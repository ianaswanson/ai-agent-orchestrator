#!/bin/bash

# Simple script to stop all orchestrator services
# Stops both orchestrator and dashboard services cleanly

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Stopping AI Agent Orchestrator Services..."

# Function to stop process by PID file
stop_by_pid() {
    local pid_file=$1
    local service_name=$2
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo "Stopping $service_name (PID: $pid)..."
            kill "$pid"
            
            # Wait for graceful shutdown
            for i in {1..10}; do
                if ! kill -0 "$pid" 2>/dev/null; then
                    echo "✓ $service_name stopped successfully"
                    break
                fi
                sleep 1
            done
            
            # Force kill if still running
            if kill -0 "$pid" 2>/dev/null; then
                echo "Force killing $service_name..."
                kill -9 "$pid" 2>/dev/null || true
            fi
        else
            echo "$service_name was not running (stale PID file)"
        fi
        rm -f "$pid_file"
    fi
}

# Stop orchestrator service
stop_by_pid "orchestrator.pid" "Orchestrator"

# Stop dashboard service  
stop_by_pid "dashboard.pid" "Dashboard"

# Kill any remaining processes by name (backup)
echo "Checking for remaining processes..."
pkill -f "orchestrator.orchestrator" 2>/dev/null && echo "Killed remaining orchestrator processes" || true
pkill -f "next dev" 2>/dev/null && echo "Killed remaining dashboard processes" || true

echo "All services stopped."
