#!/bin/bash

# Simple dashboard startup script
# Starts the Next.js dashboard with proper setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/dashboard"

echo "Starting AI Agent Orchestrator Dashboard..."

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Installing dashboard dependencies..."
    npm install
fi

# Create logs directory if it doesn't exist
mkdir -p ../logs

# Kill any existing dashboard processes
pkill -f "next dev" 2>/dev/null || true

# Start dashboard service
echo "Starting dashboard service on port 3000..."
nohup npm run dev > ../logs/dashboard.log 2>&1 &
DASH_PID=$!

# Save PID for later reference
echo $DASH_PID > ../dashboard.pid

echo "Dashboard started with PID: $DASH_PID"
echo "Logs: logs/dashboard.log"
echo "Dashboard available at: http://localhost:3000"

# Wait a moment and check if process is still running
sleep 3
if kill -0 $DASH_PID 2>/dev/null; then
    echo "✓ Dashboard service is running successfully"
else
    echo "✗ Dashboard failed to start - check logs/dashboard.log"
    exit 1
fi
