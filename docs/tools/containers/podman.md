# podman

## Overview

Podman (Pod Manager) is a daemonless container engine for developing, managing, and running OCI containers. It provides a Docker-compatible command-line interface and can run containers in root or rootless mode.

## Official Documentation
- [Podman Documentation](https://docs.podman.io/)
- [Podman GitHub](https://github.com/containers/podman)
- [Podman Tutorials](https://podman.io/getting-started/)

## Key Features
- Daemonless architecture
- Rootless containers
- Pod support
- Docker compatibility
- Systemd integration
- Network management
- Volume management
- Image management

## Basic Usage

### Container Operations
```bash
# Run container
podman run -d --name web nginx

# List containers
podman ps

# Stop container
podman stop web

# Remove container
podman rm web

# Container logs
podman logs web
```

### Image Management
```bash
# Pull image
podman pull nginx:latest

# List images
podman images

# Build image
podman build -t myapp .

# Push to registry
podman push myapp myregistry.azurecr.io/myapp
```

## Cloud/Container Use Cases

### 1. Azure Container Registry Integration

Work with Azure container registry:

```bash
# Login to ACR
podman login myregistry.azurecr.io

# Pull from ACR
podman pull myregistry.azurecr.io/myapp:latest

# Build and push
podman build -t myregistry.azurecr.io/myapp:v1 .
podman push myregistry.azurecr.io/myapp:v1

# Run from ACR
podman run -d \
  --name myapp \
  myregistry.azurecr.io/myapp:v1
```

### 2. Local Development

Develop and test applications:

```bash
# Create development environment
podman run -d \
  --name devenv \
  -v $(pwd):/app \
  -w /app \
  -p 3000:3000 \
  node:latest

# Run development tasks
podman exec -it devenv npm install
podman exec -it devenv npm run dev

# View logs
podman logs -f devenv
```

### 3. Pod Management

Work with pods (similar to Kubernetes pods):

```bash
# Create pod
podman pod create --name webapp

# Add containers to pod
podman run -d \
  --pod webapp \
  --name frontend \
  nginx

podman run -d \
  --pod webapp \
  --name backend \
  myapp-backend

# View pod status
podman pod ps

# Manage pod
podman pod stop webapp
podman pod start webapp
```

## Common Scenarios

### 1. Network Management
```bash
# Create network
podman network create mynet

# Run container with network
podman run -d \
  --network mynet \
  --name db \
  postgres

# Inspect network
podman network inspect mynet

# DNS resolution
podman run --network mynet alpine ping db
```

### 2. Volume Management
```bash
# Create volume
podman volume create mydata

# Use volume
podman run -d \
  --name db \
  -v mydata:/var/lib/postgresql/data \
  postgres

# Backup volume
podman run --rm \
  -v mydata:/source \
  -v $(pwd):/backup \
  alpine tar czf /backup/data.tar.gz /source
```

### 3. Resource Management
```bash
# Set resource limits
podman run -d \
  --name app \
  --cpus 2 \
  --memory 512m \
  myapp

# Monitor resources
podman stats

# Update limits
podman update --cpus 4 --memory 1g app
```

## Azure-Specific Features

### 1. Azure Identity Integration
```bash
# Use Azure credentials
podman run -d \
  --name azure-app \
  -e AZURE_CLIENT_ID=$CLIENT_ID \
  -e AZURE_TENANT_ID=$TENANT_ID \
  -e AZURE_CLIENT_SECRET=$CLIENT_SECRET \
  myapp

# Mount Azure config
podman run -d \
  --name azure-app \
  -v $HOME/.azure:/root/.azure:ro \
  azure-cli
```

### 2. Azure Storage Integration
```bash
# Mount Azure Files
podman run -d \
  --name storage \
  -v azure-vol:/data \
  myapp

# Use Azure Blob storage
podman run -d \
  --name blob \
  -e AZURE_STORAGE_CONNECTION_STRING=$CONNECTION_STRING \
  azure-storage-app
```

### 3. Azure Service Integration
```bash
# Connect to Azure SQL
podman run -d \
  --name sql-app \
  -e DB_HOST=myserver.database.windows.net \
  -e DB_USER=admin \
  -e DB_PASS=password \
  sql-app

# Use Azure Redis
podman run -d \
  --name cache \
  -e REDIS_HOST=mycache.redis.cache.windows.net \
  -e REDIS_KEY=$REDIS_KEY \
  cache-app
```

## Best Practices

### 1. Security
```bash
# Run rootless containers
podman run --user 1000:1000 myapp

# Read-only root filesystem
podman run --read-only myapp

# Drop capabilities
podman run --cap-drop ALL --cap-add NET_BIND_SERVICE nginx
```

### 2. Resource Management
```bash
# Set appropriate limits
podman run \
  --cpu-shares 512 \
  --memory 256m \
  --memory-swap 512m \
  myapp

# Use cgroup constraints
podman run \
  --cgroup-parent myapp.slice \
  myapp
```

### 3. Networking
```bash
# Use custom networks
podman network create \
  --subnet 172.20.0.0/16 \
  --gateway 172.20.0.1 \
  appnet

# Configure DNS
podman run \
  --dns 8.8.8.8 \
  --dns-search example.com \
  myapp
```

## Integration Examples

### 1. Development Workflow
```bash
#!/bin/bash
# Local development script

# Start development environment
podman run -d \
  --name devenv \
  -v $PWD:/app \
  -w /app \
  -p 3000:3000 \
  node:latest

# Watch for changes
podman exec -d devenv npm run watch

# Run tests
podman exec devenv npm test
```

### 2. CI/CD Pipeline
```yaml
# Azure DevOps pipeline
steps:
- script: |
    podman build -t $(imageTag) .
    podman login -u $(acrUser) -p $(acrPass) $(acrServer)
    podman push $(imageTag)
  displayName: 'Build and Push Image'
```

### 3. Production Setup
```bash
# System service configuration
cat << EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
ExecStart=podman run --rm --name myapp myregistry.azurecr.io/myapp:latest
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
systemctl enable --now myapp
