# skopeo

## Overview

Skopeo is a command-line utility that enables operations on container images and image registries. It's particularly useful for image management tasks like copying, inspection, deletion, and signing of container images.

## Official Documentation
- [Skopeo Documentation](https://github.com/containers/skopeo/blob/main/docs/skopeo.1.md)
- [Skopeo GitHub](https://github.com/containers/skopeo)
- [Container Tools Documentation](https://github.com/containers/skopeo/tree/main/docs)

## Key Features
- Registry-to-registry image copying
- Image inspection
- Image deletion
- Image signing and verification
- Registry authentication
- Multiple transport protocols
- No daemon requirement
- OCI image support

## Basic Usage

### Image Operations
```bash
# Inspect image
skopeo inspect docker://docker.io/nginx:latest

# Copy image between registries
skopeo copy docker://nginx:latest docker://myregistry.azurecr.io/nginx:latest

# Delete image from registry
skopeo delete docker://myregistry.azurecr.io/nginx:latest

# List tags
skopeo list-tags docker://registry.hub.docker.com/library/ubuntu
```

### Authentication
```bash
# Login to registry
skopeo login myregistry.azurecr.io

# Copy with credentials
skopeo copy \
  --src-creds username:password \
  --dest-creds username:password \
  docker://source/image:tag \
  docker://dest/image:tag
```

## Cloud/Container Use Cases

### 1. Azure Container Registry Management

Work with Azure Container Registry:

```bash
# Login to ACR
skopeo login myregistry.azurecr.io \
  -u $ACR_USERNAME \
  -p $ACR_PASSWORD

# Copy between ACRs
skopeo copy \
  docker://sourceregistry.azurecr.io/myapp:latest \
  docker://destregistry.azurecr.io/myapp:latest

# Sync images to ACR
skopeo sync \
  --src docker \
  --dest docker \
  nginx:latest \
  myregistry.azurecr.io
```

### 2. Image Verification

Verify image integrity and security:

```bash
# Inspect image details
skopeo inspect \
  --raw \
  docker://myregistry.azurecr.io/myapp:latest

# Check image layers
skopeo inspect \
  --config \
  docker://myregistry.azurecr.io/myapp:latest

# Verify signatures
skopeo inspect \
  --verify-signature \
  docker://myregistry.azurecr.io/myapp:latest
```

### 3. Registry Migration

Migrate between registries:

```bash
# Batch copy images
for tag in v1 v2 v3; do
  skopeo copy \
    docker://oldregistry.azurecr.io/myapp:$tag \
    docker://newregistry.azurecr.io/myapp:$tag
done

# Copy with different names
skopeo copy \
  docker://sourceregistry.azurecr.io/app:latest \
  docker://destregistry.azurecr.io/newapp:prod
```

## Common Scenarios

### 1. Image Management
```bash
# Get image details
skopeo inspect \
  docker://registry.hub.docker.com/library/ubuntu:latest \
  --format "{{.Architecture}} {{.Created}}"

# Save image locally
skopeo copy \
  docker://myregistry.azurecr.io/myapp:latest \
  dir:/tmp/myapp

# Load local image
skopeo copy \
  dir:/tmp/myapp \
  docker-daemon:myapp:latest
```

### 2. Multi-Architecture Support
```bash
# List supported architectures
skopeo inspect docker://nginx:latest \
  --format '{{range .Manifest.Manifests}}{{.Platform.Architecture}} {{end}}'

# Copy specific architecture
skopeo copy \
  --override-arch arm64 \
  docker://nginx:latest \
  docker://myregistry.azurecr.io/nginx:arm64
```

### 3. Image Signing
```bash
# Sign image
skopeo copy \
  --sign-by dev@example.com \
  docker://myregistry.azurecr.io/myapp:latest \
  docker://myregistry.azurecr.io/myapp:signed

# Verify signature
skopeo standalone-verify \
  myregistry.azurecr.io/myapp:signed \
  mykey.pub
```

## Azure-Specific Features

### 1. ACR Authentication
```bash
# Login using service principal
skopeo login myregistry.azurecr.io \
  --username $SP_ID \
  --password $SP_SECRET

# Use Azure CLI credentials
az acr login --name myregistry
skopeo copy \
  docker://source/image:tag \
  docker://myregistry.azurecr.io/image:tag
```

### 2. Cross-Region Replication
```bash
# Copy between regions
skopeo copy \
  docker://eastusregistry.azurecr.io/myapp:latest \
  docker://westusregistry.azurecr.io/myapp:latest

# Sync regional registries
for image in $(az acr repository list -n sourceregistry --output tsv); do
  skopeo copy \
    docker://sourceregistry.azurecr.io/$image \
    docker://destregistry.azurecr.io/$image
done
```

### 3. Image Security
```bash
# Check vulnerabilities (with Azure Container Scanning)
skopeo inspect \
  docker://myregistry.azurecr.io/myapp:latest \
  --format '{{.SecurityDB}}'

# Verify trusted content
skopeo copy \
  --src-registry-token "$(az acr login --name myregistry --expose-token --output tsv --query accessToken)" \
  docker://myregistry.azurecr.io/myapp:latest \
  docker-archive:/tmp/myapp.tar
```

## Best Practices

### 1. Registry Operations
```bash
# Use credential helpers
skopeo login \
  --authfile=${XDG_RUNTIME_DIR}/containers/auth.json \
  myregistry.azurecr.io

# Parallel operations
for tag in $(skopeo list-tags docker://source/image | jq -r '.Tags[]'); do
  skopeo copy \
    docker://source/image:$tag \
    docker://dest/image:$tag &
done
wait
```

### 2. Security Considerations
```bash
# Use TLS verification
skopeo copy \
  --src-tls-verify=true \
  --dest-tls-verify=true \
  docker://source/image:tag \
  docker://dest/image:tag

# Work with encrypted images
skopeo copy \
  --encryption-key jwe:/path/to/key.pem \
  docker://source/image:tag \
  docker://dest/image:tag
```

### 3. Performance Optimization
```bash
# Use compression
skopeo copy \
  --compress \
  docker://source/image:tag \
  docker://dest/image:tag

# Concurrent operations
for region in eastus westus; do
  skopeo copy \
    docker://source/image:latest \
    docker://${region}registry.azurecr.io/image:latest &
done
wait
```

## Integration Examples

### 1. CI/CD Pipeline
```yaml
# Azure DevOps pipeline
steps:
- script: |
    skopeo login $(acrServer) -u $(acrUser) -p $(acrPass)
    skopeo copy \
      docker://$(buildRegistry)/$(imageName):$(Build.BuildId) \
      docker://$(prodRegistry)/$(imageName):$(Build.BuildId)
  displayName: 'Promote Image to Production'
```

### 2. Automation Script
```bash
#!/bin/bash
# Image sync script

SOURCE_REGISTRY="sourceregistry.azurecr.io"
DEST_REGISTRY="destregistry.azurecr.io"

# Get list of repositories
repos=$(az acr repository list -n ${SOURCE_REGISTRY%.*} --output tsv)

# Sync each repository
for repo in $repos; do
  echo "Syncing $repo..."
  tags=$(skopeo list-tags docker://$SOURCE_REGISTRY/$repo | jq -r '.Tags[]')
  
  for tag in $tags; do
    skopeo copy \
      docker://$SOURCE_REGISTRY/$repo:$tag \
      docker://$DEST_REGISTRY/$repo:$tag
  done
done
```

### 3. Monitoring Setup
```bash
#!/bin/bash
# Registry monitoring script

check_image() {
  local registry=$1
  local image=$2
  local tag=$3
  
  skopeo inspect \
    docker://$registry/$image:$tag \
    --format '{"repository": "{{.Name}}", "tag": "{{.Tag}}", "size": {{.Size}}, "created": "{{.Created}}"}' \
    | jq .
}

# Monitor critical images
while true; do
  check_image myregistry.azurecr.io myapp latest
  check_image myregistry.azurecr.io myapp stable
  sleep 300
done
