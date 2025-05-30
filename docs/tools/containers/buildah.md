# buildah

## Overview

Buildah is a tool specializing in building OCI container images. It provides a more granular and flexible approach to image building compared to traditional Dockerfile builds, with enhanced security features and no daemon requirement.

## Official Documentation
- [Buildah Documentation](https://buildah.io/)
- [Buildah GitHub](https://github.com/containers/buildah)
- [Buildah Tutorials](https://github.com/containers/buildah/tree/main/docs/tutorials)

## Key Features
- Daemon-less operation
- Fine-grained image control
- Dockerfile compatibility
- Root and rootless builds
- OCI image format support
- Layer manipulation
- Integration with other tools
- Mount-and-modify capability

## Basic Usage

### Image Building
```bash
# Build from Dockerfile
buildah bud -t myapp .

# Build from scratch
buildah from scratch
buildah copy mycontainer source dest
buildah config --cmd /app/myapp mycontainer
buildah commit mycontainer myapp:latest

# Build with multiple stages
buildah bud --target builder -t myapp-builder .
buildah bud --target production -t myapp .
```

### Container Operations
```bash
# Create container
buildah from alpine

# Mount container filesystem
buildah mount mycontainer

# Copy files
buildah copy mycontainer app/ /app/

# Run commands
buildah run mycontainer -- npm install

# Commit changes
buildah commit mycontainer myapp:latest
```

## Cloud/Container Use Cases

### 1. Azure Container Registry Integration

Build and push to Azure:

```bash
# Login to ACR
buildah login myregistry.azurecr.io

# Build for ACR
buildah bud \
  --tag myregistry.azurecr.io/myapp:v1 \
  --file Dockerfile.prod \
  .

# Push to ACR
buildah push myregistry.azurecr.io/myapp:v1

# Build and push in one step
buildah bud \
  --tag myregistry.azurecr.io/myapp:v1 \
  --push \
  .
```

### 2. Multi-Stage Builds

Create optimized production images:

```bash
# Development stage
cat << EOF > Dockerfile
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:16-slim
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package*.json ./
RUN npm install --production
CMD ["npm", "start"]
EOF

# Build with buildah
buildah bud \
  --tag myapp:prod \
  --file Dockerfile \
  .
```

### 3. Custom Base Images

Create specialized base images:

```bash
# Create minimal base image
container=$(buildah from scratch)
buildah copy $container rootfs/ /
buildah config \
  --cmd /bin/bash \
  --env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  $container
buildah commit $container minimal-base:latest

# Add Azure tools
container=$(buildah from minimal-base:latest)
buildah run $container -- \
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash
buildah commit $container azure-base:latest
```

## Common Scenarios

### 1. Layer Optimization
```bash
# Combine RUN commands
buildah run $container -- sh -c \
  'apt-get update && \
   apt-get install -y python3 && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/*'

# Use mount for complex operations
mnt=$(buildah mount $container)
cp -r assets $mnt/app/
buildah unmount $container
```

### 2. Security Hardening
```bash
# Remove unnecessary files
buildah run $container -- sh -c \
  'rm -rf /tmp/* /var/cache/apt/*'

# Set secure defaults
buildah config \
  --user nonroot \
  --port 8080 \
  --env SSL_CERT_DIR=/etc/ssl/certs \
  $container
```

### 3. Build Automation
```bash
# Build script
#!/bin/bash
container=$(buildah from alpine:latest)

# Add dependencies
buildah run $container apk add --no-cache python3

# Copy application
buildah copy $container app/ /app/

# Configure
buildah config \
  --workingdir /app \
  --entrypoint '["python3", "app.py"]' \
  $container

# Commit
buildah commit $container myapp:latest
```

## Azure-Specific Features

### 1. Azure Integration
```bash
# Build with Azure credentials
buildah bud \
  --tag myapp:latest \
  --build-arg AZURE_CLIENT_ID=$CLIENT_ID \
  --build-arg AZURE_TENANT_ID=$TENANT_ID \
  .

# Build with Azure storage
buildah bud \
  --tag myapp:latest \
  --secret id=azure-storage,src=azure-storage.txt \
  .
```

### 2. Azure Services Support
```bash
# Build with service dependencies
buildah run $container -- sh -c \
  'curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
   gpg --dearmor | \
   tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null'

buildah run $container -- sh -c \
  'echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
   tee /etc/apt/sources.list.d/azure-cli.list'

buildah run $container -- apt-get update && apt-get install -y azure-cli
```

### 3. Azure DevOps Integration
```bash
# Build for different environments
buildah bud \
  --tag myapp:dev \
  --file Dockerfile.dev \
  --build-arg ENVIRONMENT=development \
  .

buildah bud \
  --tag myapp:prod \
  --file Dockerfile.prod \
  --build-arg ENVIRONMENT=production \
  .
```

## Best Practices

### 1. Image Size Optimization
```bash
# Use multi-stage builds
buildah bud \
  --target builder \
  --tag temp:latest \
  .

buildah bud \
  --target production \
  --tag myapp:latest \
  .

# Clean up build artifacts
buildah run $container -- sh -c \
  'rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*'
```

### 2. Security Considerations
```bash
# Run as non-root
buildah config --user 1000:1000 $container

# Minimize attack surface
buildah config \
  --env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  --env DEBIAN_FRONTEND=noninteractive \
  $container
```

### 3. Build Performance
```bash
# Use buildah cache
buildah bud \
  --layers \
  --tag myapp:latest \
  .

# Parallel builds
buildah bud \
  --jobs 4 \
  --tag myapp:latest \
  .
```

## Integration Examples

### 1. CI/CD Pipeline
```yaml
# Azure DevOps pipeline
steps:
- script: |
    buildah bud \
      --tag $(imageTag) \
      --file Dockerfile.prod \
      --build-arg BUILD_VERSION=$(Build.BuildNumber) \
      .
    buildah push $(imageTag)
  displayName: 'Build and Push Image'
```

### 2. Development Workflow
```bash
#!/bin/bash
# Development build script

# Build development image
buildah bud \
  --tag myapp:dev \
  --file Dockerfile.dev \
  --build-arg NODE_ENV=development \
  .

# Run development container
podman run -d \
  --name myapp-dev \
  -v $PWD:/app \
  -p 3000:3000 \
  myapp:dev
```

### 3. Production Deployment
```bash
#!/bin/bash
# Production deployment script

# Build production image
buildah bud \
  --tag myregistry.azurecr.io/myapp:prod \
  --file Dockerfile.prod \
  --build-arg NODE_ENV=production \
  .

# Push to registry
buildah push myregistry.azurecr.io/myapp:prod

# Deploy to AKS
kubectl set image deployment/myapp \
  myapp=myregistry.azurecr.io/myapp:prod
