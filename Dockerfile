FROM python:3.11

# Install required applications
USER root
RUN apt-get update && apt-get install -y \
    python3.11-venv \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app
