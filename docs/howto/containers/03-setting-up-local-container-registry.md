# Setting Up a Local Container Registry with Authentication

## Problem Statement
You need a private, authenticated container registry for local development and CI/CD pipelines, ensuring only authorized users can push or pull images.

## Solution Overview
Use the official registry image with Podman/Buildah, configure HTTP basic authentication via `htpasswd`, and secure with TLS.

## Tools Used
- podman
- buildah
- skopeo
- htpasswd (from apache2-utils)
- openssl

## Implementation

### 1. Generate Authentication Credentials
```bash
# Install htpasswd if needed
apk add --no-cache apache2-utils

# Create auth directory and password file
mkdir -p /etc/registry/auth
htpasswd -Bbn registry_user > /etc/registry/auth/htpasswd
```

### 2. Generate Self-Signed TLS Certificates
```bash
mkdir -p /etc/registry/certs
openssl req -newkey rsa:4096 -nodes -sha256 \
    -keyout /etc/registry/certs/domain.key \
    -x509 -days 365 \
    -out /etc/registry/certs/domain.crt \
    -subj "/CN=localhost"
```

### 3. Run the Registry Container
```bash
podman run -d --name local-registry \
  -p 5000:5000 \
  -v /etc/registry/auth:/auth:Z \
  -v /etc/registry/certs:/certs:Z \
  registry:2 \
  /entrypoint.sh /etc/docker/registry/config.yml
```

Create `/etc/docker/registry/config.yml`:
```yaml
version: 0.1
storage:
  filesystem:
    rootdirectory: /var/lib/registry
http:
  addr: :5000
  tls:
    certificate: /certs/domain.crt
    key: /certs/domain.key
  headers:
    X-Content-Type-Options: [nosniff]
auth:
  htpasswd:
    realm: Registry Realm
    path: /auth/htpasswd
```

### 4. Test Authentication and Push/Pull
```bash
# Login to local registry
podman login localhost:5000 \
  --username registry_user \
  --password $(htpasswd -Bbn registry_user | cut -d':' -f2)

# Tag and push an image
podman tag myapp:latest localhost:5000/myapp:latest
podman push localhost:5000/myapp:latest

# Pull test
podman pull localhost:5000/myapp:latest
```

### 5. Mirror Registry Content (Optional)
```bash
# Mirror all repos to another registry
skopeo sync --src docker --dest docker \
  --dest-creds user:pass \
  localhost:5000 secondary.registry.local:5000
```

## Validation
1. Ensure registry is listening on TLS port:
   ```bash
   curl -k https://localhost:5000/v2/_catalog
   ```
2. Verify only authenticated access:
   ```bash
   curl https://localhost:5000/v2/_catalog || echo "Auth required"
   ```
3. Inspect registry logs:
   ```bash
   podman logs local-registry
   ```

## Common Issues
- **Permission errors**: Ensure volumes are labeled correct (`:Z` or `:z`).
- **TLS failures**: Pass `--tls-verify=false` for self-signed certs or import CA.
- **Auth failures**: Verify `htpasswd` format and credentials.

## Additional Notes
- Use real certificates for production.
- Automate registry startup via systemd or CI scripts.
- Integrate with Azure Container Registry for hybrid setups.
