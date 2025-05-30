# Managing Multi-Registry Image Synchronization with Skopeo

## Problem Statement
You need to keep container images in sync across multiple registries (e.g., a private registry, Docker Hub, and an OCI-compliant mirror) to ensure availability and redundancy.

## Solution Overview
Use `skopeo` to inspect, copy, and synchronize images without a local daemon. Automate synchronization by scripting registry credentials, filtering tags, and verifying digests.

## Tools Used
- skopeo  
- podman (for optional local testing)  
- regctl (registry inspection)  
- bash  

## Implementation

### 1. Log in to Registries
```bash
# Docker Hub
skopeo login docker.io \
    --username "$DOCKERHUB_USER" \
    --password-stdin

# Private registry
skopeo login private.registry.local \
    --username "$REG_USER" \
    --password-stdin
```

### 2. Inspect Source Image Tags
```bash
# List tags on source registry
skopeo list-tags docker://docker.io/library/myapp \
    | jq -r '.Tags[]'
```

### 3. Copy Specific Tags
```bash
# Copy a single tag from Docker Hub to private registry
skopeo copy \
    docker://docker.io/library/myapp:1.2.3 \
    docker://private.registry.local/myapp:1.2.3
```

### 4. Bulk Synchronization Script
```bash
#!/bin/bash
SRC=“docker://docker.io/library/myapp”
DEST=“docker://private.registry.local/myapp”

# Synchronize all tags matching a pattern
skopeo sync --src docker --dest docker \
    --filter '.*-release$' \
    docker.io/library/myapp \
    private.registry.local/myapp
```

### 5. Mirror to OCI Layout (Optional)
```bash
# Export entire repository to OCI directory
skopeo sync --src docker --dest oci \
    docker.io/library/myapp /tmp/myapp-oci

# Mirror OCI layout to a second registry
skopeo copy \
    oci:/tmp/myapp-oci \
    docker://secondary.registry.local/myapp
```

## Validation
1. Compare digests:
   ```bash
   skopeo inspect --format '{{.Digest}}' docker://docker.io/library/myapp:1.2.3
   skopeo inspect --format '{{.Digest}}' docker://private.registry.local/myapp:1.2.3
   ```
2. Pull and run test:
   ```bash
   podman pull private.registry.local/myapp:1.2.3
   podman run --rm private.registry.local/myapp:1.2.3 --version
   ```
3. Verify tag list:
   ```bash
   skopeo list-tags docker://private.registry.local/myapp
   ```

## Common Issues
- **Authentication failures**: Ensure `skopeo login` credentials and access scopes.  
- **Rate limiting**: Use registry service accounts or mirror only required tags.  
- **Certificate errors**: Pass `--tls-verify=false` for self-signed registries or install CA.  

## Additional Notes
- Automate via cron or CI pipeline to run `sync` daily.  
- Use `--filter` to include/exclude tags by regex.  
- For multi-arch images, `skopeo copy` preserves manifest lists by default.  
- Combine with `regctl` for advanced registry operations (e.g., pruning old tags).
