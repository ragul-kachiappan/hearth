# docker/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/app /app/app
COPY scripts/entrypoint.sh /app/entrypoint.sh
COPY scripts/startup.sh /app/startup.sh

# Make scripts executable
RUN chmod +x /app/entrypoint.sh /app/startup.sh

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/startup.sh"]