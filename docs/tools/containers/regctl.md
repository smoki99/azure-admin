# regctl - Container Registry Client

## Overview
`regctl` is a powerful command-line tool for interacting with container registries. It provides advanced functionality for managing container images, tags, and manifests across different registry providers.

## Official Documentation
[regctl Documentation](https://github.com/regclient/regclient)

## Basic Usage

### 1. Image Operations
```bash
# Pull image information
regctl image get docker.io/library/ubuntu:latest

# List image tags
regctl tag ls docker.io/library/nginx

# Copy images between registries
regctl image copy \
  docker.io/library/nginx:latest \
  registry.example.com/nginx:prod
```

### 2. Manifest Operations
```bash
# Get image manifest
regctl manifest get docker.io/library/ubuntu:latest

# Get manifest digest
regctl manifest digest docker.io/library/ubuntu:latest

# List manifest platforms
regctl manifest list docker.io/library/ubuntu:latest
```

### 3. Registry Authentication
```bash
# Login to registry
regctl registry login docker.io

# Configure registry credentials
regctl registry set docker.io --tls-verify=true

# Test registry connection
regctl registry check docker.io
```

## Cloud/Container Use Cases

### 1. Azure Container Registry
```bash
# Login to ACR
regctl registry login myregistry.azurecr.io \
      --username $USERNAME \
      --password $PASSWORD

# Pull from ACR
regctl image get \
      myregistry.azurecr.io/myapp:latest

# Push to ACR
regctl image copy \
      docker.io/library/nginx:latest \
      myregistry.azurecr.io/nginx:prod
```

### 2. Multi-Registry Management
```bash
# Copy between registries
regctl image copy \
      registry1.example.com/app:v1 \
      registry2.example.com/app:v1

# Compare manifests
regctl manifest get registry1.example.com/app:v1
regctl manifest get registry2.example.com/app:v1

# Sync repositories
regctl image sync \
      src-registry.com/app \
      dest-registry.com/app
```

### 3. CI/CD Integration
```bash
# Check image existence
regctl tag check registry.example.com/app:latest

# Get image details for deployment
regctl image config registry.example.com/app:latest

# Update image tags
regctl tag add registry.example.com/app:latest stable
```

## Advanced Features

### 1. Image Analysis
```bash
# View image configuration
regctl image config docker.io/library/ubuntu:latest

# Check image layers
regctl image manifest docker.io/library/ubuntu:latest

# Get image digest
regctl image digest docker.io/library/ubuntu:latest
```

### 2. Multi-Platform Support
```bash
# List supported platforms
regctl manifest platforms docker.io/library/nginx:latest

# Get platform-specific digest
regctl manifest get \
      docker.io/library/nginx:latest \
      --platform linux/arm64

# Copy platform-specific image
regctl image copy \
      --platform linux/amd64 \
      src-image:tag dst-image:tag
```

### 3. Registry Mirroring
```bash
# Configure mirror
regctl registry set mirror.example.com \
      --mirror docker.io

# Test mirror
regctl registry check mirror.example.com

# Pull through mirror
regctl image get mirror.example.com/library/ubuntu:latest
```

## Best Practices

### 1. Security
```bash
# Verify TLS certificates
regctl registry set registry.example.com --tls-verify=true

# Use credential helpers
regctl registry login --helper gcr

# Check image signatures
regctl image verify registry.example.com/app:latest
```

### 2. Performance
```bash
# Use manifest lists
regctl manifest get --list registry.example.com/app:latest

# Optimize transfers
regctl image copy --jobs 4 src-image:tag dst-image:tag

# Cache management
regctl image prune --older-than 30d
```

### 3. Automation
```bash
# Script-friendly output
regctl image digest --quiet image:tag

# Batch operations
regctl image copy --recursive src-repo dst-repo

# Format output
regctl image get --format json image:tag
```

## Common Scenarios

### 1. Registry Migration
```bash
# Sync entire repository
regctl image sync \
      old-registry.com/myapp \
      new-registry.com/myapp

# Verify migration
regctl image compare \
      old-registry.com/myapp:latest \
      new-registry.com/myapp:latest

# Update references
regctl tag mirror old-registry.com/myapp new-registry.com/myapp
```

### 2. Image Management
```bash
# Tag management
regctl tag ls registry.example.com/app
regctl tag rm registry.example.com/app:old-tag
regctl tag add registry.example.com/app:latest stable

# Clean up old images
regctl image delete registry.example.com/app:old-version
```

### 3. Registry Operations
```bash
# Health checks
regctl registry check registry.example.com

# Repository listing
regctl repo ls registry.example.com

# Tag maintenance
regctl tag prune --keep 5 registry.example.com/app
```

## Troubleshooting

### Common Issues
1. Authentication Problems
   ```bash
   # Check credentials
   regctl registry check registry.example.com

   # Reset auth
   regctl registry logout registry.example.com
   regctl registry login registry.example.com
   ```

2. Network Issues
   ```bash
   # Test connectivity
   regctl registry ping registry.example.com

   # Check TLS
   regctl registry check --tls-verify registry.example.com
   ```

3. Image Problems
   ```bash
   # Verify manifest
   regctl manifest verify image:tag

   # Check layers
   regctl image manifest image:tag
   ```

### Integration Tips
1. Azure Integration
   ```bash
   # ACR setup
   regctl registry set myregistry.azurecr.io \
         --tls-verify=true \
         --credential-helper acr

   # Managed identity
   regctl registry login myregistry.azurecr.io \
         --identity
   ```

2. CI/CD Pipeline
   ```bash
   # Automated tagging
   regctl tag add \
         registry.example.com/app:${CI_COMMIT_SHA} \
         latest

   # Version management
   regctl tag ls --sort time registry.example.com/app
   ```

3. Docker Integration
   ```bash
   # Use Docker config
   regctl registry import-docker

   # Mirror configuration
   regctl registry set-host docker.io \
         --mirror registry-mirror.example.com
