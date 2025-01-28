#!/bin/bash
set -e

# Run with Gunicorn using Uvicorn workers
exec gunicorn src.app.main:app \
    --workers 4 \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind 0.0.0.0:8080 \
    --access-logfile - \
    --error-logfile - \
    --log-level info \
    --timeout 120