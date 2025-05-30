# nerdctl

## Overview

nerdctl is a Docker-compatible CLI for containerd that enables users to manage containers with familiar Docker-like commands. It provides additional features specifically designed for cloud-native environments.

## Official Documentation
- [nerdctl GitHub](https://github.com/containerd/nerdctl)
- [nerdctl Documentation](https://github.com/containerd/nerdctl/tree/master/docs)
- [containerd Documentation](https://containerd.io/docs/)

## Key Features
- Docker-compatible CLI
- containerd native support
- Rootless container support
- IPFS integration
- Lazy pulling
- Image encryption
- Compose compatibility
- CNI networking support

## Basic Usage

### Container Operations
```bash
# Run container
nerdctl run -d --name web nginx

# List containers
nerdctl ps

# Execute command
nerdctl exec -it web bash

# View logs
nerdctl logs -f web

# Stop and remove
nerdctl stop web
nerdctl rm web
```

### Image Management
```bash
# Pull image
nerdctl pull nginx:latest

# List images
nerdctl images

# Build image
nerdctl build -t myapp .

# Push to registry
nerdctl push myregistry.azurecr.io/myapp
```

## Cloud/Container Use Cases

### 1. Azure Container Registry Integration

Work with Azure container registry:

```bash
# Login to ACR
nerdctl login myregistry.azurecr.io

# Pull from ACR
nerdctl pull myregistry.azurecr.io/myapp:latest

# Build and push
nerdctl build \
  -t myregistry.azurecr.io/myapp:v1 \
  --platform linux/amd64,linux/arm64 \
  .

nerdctl push myregistry.azurecr.io/myapp:v1

# Run with ACR image
nerdctl run -d \
  --name myapp \
  myregistry.azurecr.io/myapp:v1
```

### 2. Compose Operations

Manage multi-container applications:

```bash
# Start Compose application
nerdctl compose up -d

# View Compose services
nerdctl compose ps

# Scale service
nerdctl compose scale web=3

# View logs
nerdctl compose logs -f

# Stop application
nerdctl compose down
```

### 3. Advanced Features

Utilize nerdctl-specific features:

```bash
# IPFS integration
nerdctl pull ipfs://Qm...

# Lazy pulling
nerdctl run --pull=always --snapshotter=stargz nginx

# Image encryption
nerdctl build \
  --encrypt-recipients-file keys.txt \
  -t encrypted-image .

# Multi-platform build
nerdctl build \
  --platform linux/amd64,linux/arm64 \
  -t myapp .
```

## Common Scenarios

### 1. Development Workflow
```bash
# Start development environment
nerdctl run -d \
  --name devenv \
  -v $(pwd):/app \
  -w /app \
  -p 3000:3000 \
  node:latest

# Install dependencies
nerdctl exec devenv npm install

# Run development server
nerdctl exec -d devenv npm run dev

# View logs
nerdctl logs -f devenv
```

### 2. Resource Management
```bash
# Set resource limits
nerdctl run -d \
  --name app \
  --cpus 2 \
  --memory 512m \
  myapp

# View stats
nerdctl stats

# Update limits
nerdctl update --cpus 4 --memory 1g app
```

### 3. Network Management
```bash
# Create network
nerdctl network create mynet

# Run container with network
nerdctl run -d \
  --network mynet \
  --name db \
  postgres

# Inspect network
nerdctl network inspect mynet
```

## Azure-Specific Features

### 1. Azure Integration
```bash
# Use Azure identity
nerdctl run -d \
  --name azure-app \
  -e AZURE_CLIENT_ID=$CLIENT_ID \
  -e AZURE_TENANT_ID=$TENANT_ID \
  myapp

# Mount Azure config
nerdctl run -d \
  --name azure-app \
  -v $HOME/.azure:/root/.azure:ro \
  azure-cli
```

### 2. Storage Integration
```bash
# Use Azure storage
nerdctl run -d \
  --name storage \
  -e AZURE_STORAGE_CONNECTION_STRING=$CONNECTION_STRING \
  storage-app

# Mount Azure Files
nerdctl run -d \
  --name app \
  -v azure-vol:/data \
  myapp
```

### 3. Service Integration
```bash
# Connect to Azure services
nerdctl compose up \
  -f docker-compose.yml \
  -f docker-compose.azure.yml \
  -d

# Use Azure service principal
nerdctl run -d \
  --name app \
  -e AZURE_SP_ID=$SP_ID \
  -e AZURE_SP_SECRET=$SP_SECRET \
  myapp
```

## Best Practices

### 1. Security
```bash
# Run rootless
nerdctl --rootless run nginx

# Use security options
nerdctl run \
  --security-opt no-new-privileges \
  --security-opt apparmor=docker-default \
  nginx

# Enable encryption
nerdctl build \
  --encrypt-recipients-file keys.txt \
  -t secure-image .
```

### 2. Performance
```bash
# Use buildkit cache
nerdctl build \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  -t myapp .

# Enable lazy pulling
nerdctl run \
  --snapshotter=stargz \
  --pull=always \
  myapp
```

### 3. Monitoring
```bash
# Check container health
nerdctl inspect \
  --format '{{.State.Health.Status}}' \
  container_name

# Monitor resource usage
nerdctl stats --no-stream
```

## Integration Examples

### 1. CI/CD Pipeline
```yaml
# Azure DevOps pipeline
steps:
- script: |
    nerdctl login $(acrServer) -u $(acrUser) -p $(acrPass)
    nerdctl build -t $(imageTag) .
    nerdctl push $(imageTag)
  displayName: 'Build and Push Image'
```

### 2. Development Script
```bash
#!/bin/bash
# Local development environment

# Start environment
nerdctl compose -f docker-compose.dev.yml up -d

# Watch logs
nerdctl compose logs -f

# Run tests
nerdctl exec app npm test

# Clean up
nerdctl compose down
```

### 3. Production Setup
```bash
#!/bin/bash
# Production deployment

# Pull latest images
nerdctl compose pull

# Update services
nerdctl compose up -d --remove-orphans

# Check status
nerdctl compose ps

# Monitor logs
nerdctl compose logs -f --tail=100
```

### 4. Automation
```bash
#!/bin/bash
# Container management script

cleanup_containers() {
    # Remove stopped containers
    nerdctl container prune -f
    
    # Remove unused images
    nerdctl image prune -a -f
}

update_containers() {
    # Pull latest images
    nerdctl compose pull
    
    # Update services
    nerdctl compose up -d
}

# Run maintenance
cleanup_containers
update_containers
