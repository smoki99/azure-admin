# Implementing Container Health Checks with Podman

## Problem Statement
You need to ensure containers report their live status and recover from failures automatically by defining and monitoring health checks.

## Solution Overview
Use the OCI `HEALTHCHECK` instruction in your Containerfile, build the image with Podman, and configure Podman to monitor and restart unhealthy containers.

## Tools Used
- podman
- buildah
- bash

## Implementation

### 1. Add HEALTHCHECK to Containerfile
```Dockerfile
FROM docker.io/library/nginx:alpine

# Add custom healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Keep default command
CMD ["nginx", "-g", "daemon off;"]
```

### 2. Build the Image
```bash
podman build -t mynginx-health:latest -f Containerfile .
```

### 3. Run Container with Auto-Restart
```bash
podman run -d \
  --name mynginx \
  --health-cmd="curl -f http://localhost/ || exit 1" \
  --health-interval=30s \
  --health-retries=3 \
  --restart=on-failure \
  mynginx-health:latest
```

### 4. Monitor Health Status
```bash
# Inspect health status
podman ps --filter name=mynginx --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# Continuously watch status
watch -n5 podman inspect mynginx --format '{{.State.Health.Status}}'
```

### 5. Automated Recovery
Podman’s `--restart=on-failure` automatically restarts failed containers. For more control, use systemd unit:

```bash
podman generate systemd --name mynginx --restart-policy=on-failure \
  > /etc/systemd/system/mynginx.service

systemctl enable --now mynginx.service
```

## Validation
1. Force health check failure:
   ```bash
   podman exec mynginx sed -i 's/index.html/index.html.bak/' /usr/share/nginx/html/index.html
   ```
2. Watch `podman ps` or `systemctl status mynginx` to see restart.
3. Restore file and confirm container returns to healthy state.

## Common Issues
- **Healthcheck command not present**: ensure `curl` or required binary is installed in image.  
- **Incorrect exit codes**: health commands must exit non-zero on failure.  
- **Restart loops**: tune `--health-retries` and restart policy to avoid rapid cycling.

## Additional Notes
- Use minimal health scripts for performance.  
- Combine with liveness/readiness probes in Kubernetes.  
- Adjust intervals for production workloads.
