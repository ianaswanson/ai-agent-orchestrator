#!/bin/bash

# Simple orchestrator startup script
# Starts the orchestrator service with proper environment setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Starting AI Agent Orchestrator..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    echo "Installing dependencies..."
    pip install -r requirements.txt
else
    source venv/bin/activate
fi

# Create logs directory if it doesn't exist
mkdir -p logs

# Kill any existing orchestrator processes
pkill -f "orchestrator.orchestrator" 2>/dev/null || true

# Start orchestrator service
echo "Starting orchestrator service on port 8000..."
nohup python -m orchestrator.orchestrator > logs/orchestrator.log 2>&1 &
ORCH_PID=$!

# Save PID for later reference
echo $ORCH_PID > orchestrator.pid

echo "Orchestrator started with PID: $ORCH_PID"
echo "Logs: logs/orchestrator.log"
echo "API available at: http://localhost:8000"

# Wait a moment and check if process is still running
sleep 2
if kill -0 $ORCH_PID 2>/dev/null; then
    echo "✓ Orchestrator service is running successfully"
else
    echo "✗ Orchestrator failed to start - check logs/orchestrator.log"
    exit 1
fi
