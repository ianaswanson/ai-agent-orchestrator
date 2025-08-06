#!/bin/bash

# Simple script to check status of orchestrator services
# Shows running status, PID, and service availability

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "AI Agent Orchestrator - Service Status"
echo "======================================"

# Function to check service status
check_service() {
    local pid_file=$1
    local service_name=$2
    local port=$3
    local url=$4
    
    echo -n "$service_name: "
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo -n "✓ RUNNING (PID: $pid)"
            
            # Check if port is accessible
            if command -v nc >/dev/null 2>&1; then
                if nc -z localhost "$port" 2>/dev/null; then
                    echo " - Port $port accessible"
                else
                    echo " - Port $port NOT accessible"
                fi
            else
                echo " - Port $port (check manually)"
            fi
            
            if [ -n "$url" ]; then
                echo "  URL: $url"
            fi
        else
            echo "✗ NOT RUNNING (stale PID file)"
        fi
    else
        echo "✗ NOT RUNNING (no PID file)"
    fi
    echo
}

# Check orchestrator service
check_service "orchestrator.pid" "Orchestrator" "8000" "http://localhost:8000"

# Check dashboard service
check_service "dashboard.pid" "Dashboard" "3000" "http://localhost:3000"

# Show recent log entries if available
echo "Recent Logs:"
echo "------------"
if [ -f "logs/orchestrator.log" ]; then
    echo "Orchestrator (last 3 lines):"
    tail -n 3 logs/orchestrator.log 2>/dev/null || echo "  No log entries"
    echo
fi

if [ -f "logs/dashboard.log" ]; then
    echo "Dashboard (last 3 lines):"
    tail -n 3 logs/dashboard.log 2>/dev/null || echo "  No log entries"
    echo
fi

# Show disk space for logs
echo "Log Files:"
echo "----------"
if [ -d "logs" ]; then
    ls -lh logs/ 2>/dev/null | grep -E '\.(log|out|err)$' || echo "  No log files found"
else
    echo "  No logs directory"
fi
