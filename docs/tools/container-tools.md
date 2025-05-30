# Container Tools Overview

This document provides an overview of all container-related tools included in the Azure Admin Container environment. These tools are designed to work together to provide a complete container management solution.

## Tool Categories

### Core Container Tools

#### [Podman](containers/podman.md)
- Container management and orchestration
- Docker-compatible CLI
- Daemonless architecture
- Rootless container support

#### [Buildah](containers/buildah.md)
- Container image building
- Fine-grained image control
- Dockerfile compatibility
- Layer manipulation

#### [Skopeo](containers/skopeo.md)
- Image inspection and management
- Registry operations
- Image signing and verification
- Image copying between registries

### Container Development Tools

#### [nerdctl](containers/nerdctl.md)
- Docker-compatible CLI for containerd
- Built-in Compose support
- IPFS integration
- Image encryption support

#### [lazydocker](containers/lazydocker.md)
- Terminal UI for container management
- Real-time monitoring
- Log viewing and analysis
- Resource usage visualization

### Networking Tools

#### [CNI Plugins](containers/cni-plugins.md)
- Container network interface plugins
- Network configuration
- IP address management
- Multi-network support

## Common Use Cases

### 1. Container Development
```bash
# Build image with Buildah
buildah bud -t myapp .

# Run with Podman
podman run -d --name myapp myapp:latest

# Monitor with lazydocker
lazydocker
```

### 2. Image Management
```bash
# Build with Buildah
buildah bud -t myregistry.azurecr.io/myapp:v1 .

# Copy with Skopeo
skopeo copy \
  docker-daemon:myapp:latest \
  docker://myregistry.azurecr.io/myapp:v1

# Clean up with Podman
podman system prune -a
```

### 3. Production Operations
```bash
# Deploy containers
podman-compose up -d

# Monitor resources
lazydocker

# Manage networks
podman network create app-network
```

## Tool Integration

### Building and Publishing
1. Use Buildah for image creation
2. Verify with Skopeo
3. Push to registry
4. Deploy with Podman

### Development Workflow
1. Build with Buildah
2. Test locally with Podman
3. Monitor with lazydocker
4. Push using Skopeo

### Production Operations
1. Pull images with Skopeo
2. Deploy with Podman
3. Configure networking with CNI
4. Monitor with lazydocker

## Azure Integration

### Azure Container Registry
```bash
# Login to ACR
podman login myregistry.azurecr.io

# Build and push
buildah bud -t myregistry.azurecr.io/myapp:v1 .
podman push myregistry.azurecr.io/myapp:v1
```

### Azure Kubernetes Service
```bash
# Build for AKS
buildah bud -t myregistry.azurecr.io/myapp:v1 .

# Push to ACR
skopeo copy \
  docker-daemon:myapp:v1 \
  docker://myregistry.azurecr.io/myapp:v1
```

### Azure Container Instances
```bash
# Prepare image
buildah bud -t myapp .

# Push to ACR
skopeo copy \
  docker-daemon:myapp:latest \
  docker://myregistry.azurecr.io/myapp:latest
```

## Best Practices

### Security
- Use rootless containers when possible
- Implement image signing
- Regular security scanning
- Proper access control

### Performance
- Optimize image sizes
- Use multi-stage builds
- Implement proper caching
- Monitor resource usage

### Development
- Consistent development environments
- Automated testing
- Clear documentation
- Version control

## Common Issues and Solutions

### Image Building
```bash
# Layer caching issues
buildah bud --layers --force-rm .

# Multi-arch support
buildah bud --platform linux/amd64,linux/arm64 .
```

### Networking
```bash
# DNS issues
podman run --dns 8.8.8.8 myapp

# Network isolation
podman network create --internal mynet
```

### Resource Management
```bash
# Memory limits
podman run --memory 512m myapp

# CPU constraints
podman run --cpus 2 myapp
```

## Additional Resources

### Documentation
- [Podman Documentation](https://docs.podman.io/)
- [Buildah Documentation](https://buildah.io/manual/)
- [Skopeo Documentation](https://github.com/containers/skopeo)
- [CNI Documentation](https://www.cni.dev/)

### Tutorials
- [Getting Started with Podman](https://podman.io/getting-started/)
- [Buildah Tutorial](https://github.com/containers/buildah/tree/main/docs/tutorials)
- [Container Security Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/container_security_guide/)

### Community Resources
- [Container Tools GitHub](https://github.com/containers)
- [Azure Container Blog](https://azure.microsoft.com/en-us/blog/tag/containers/)
- [Podman Community](https://podman.io/community/)
