# Building Secure Container Images with Buildah

## Problem Statement
You need to build container images with minimal attack surface, strong layer caching, and reproducible, signed artifacts.

## Solution Overview
Use Buildah to construct images from scratch or from minimal base, apply multi-stage builds, restrict files and users, scan for vulnerabilities, and sign the final image.

## Tools Used
- buildah
- skopeo
- podman
- regctl
- nerdctl (optional for OCI operations)

## Implementation

### 1. Prepare Dockerfile (or Containerfile)
```Dockerfile
# Use a minimal base
FROM docker.io/library/alpine:3.18 AS builder

# Install build dependencies
RUN apk add --no-cache build-base

# Copy and compile application
COPY --chown=builder:builder . /src
RUN cd /src && make && install -Dm755 myapp /usr/local/bin/myapp

# Final image
FROM docker.io/library/distroless/static-debian11

# Copy runtime binary
COPY --from=builder /usr/local/bin/myapp /usr/local/bin/myapp

# Drop privileges
USER 65532:65532

ENTRYPOINT ["/usr/local/bin/myapp"]
```

### 2. Build with Buildah
```bash
# Configure rootless build
buildah bud --format docker -t myapp:secure -f Containerfile .

# Inspect layers
buildah inspect myapp:secure --format '{{range .Layers}}{{println .}}{{end}}'
```

### 3. Scan for Vulnerabilities
```bash
# Push locally and scan with regctl (requires vulnerability provider)
buildah push myapp:secure oci:/tmp/registries/myapp:secure
regctl image scan oci:/tmp/registries/myapp:secure
```

### 4. Sign the Image
```bash
# Generate signing key (if not existing)
openssl genpkey -algorithm ED25519 -out cosign.key

# Sign with cosign (via nerdctl)
nerdctl image sign --key cosign.key myapp:secure

# Verify signature
nerdctl image verify myapp:secure
```

## Validation
1. Run container and verify functionality:
   ```bash
   podman run --rm myapp:secure --version
   ```
2. Check user and file permissions inside:
   ```bash
   podman run --rm --user 65532:65532 myapp:secure ls -l /usr/local/bin/myapp
   ```
3. Confirm no extraneous packages:
   ```bash
   podman run --rm myapp:secure sh -c "apk info || echo 'No apk tools present'"
   ```

## Common Issues
- Missing runtime libraries: ensure base image includes required libs.
- Signing errors: confirm key permissions and correct cosign version.
- Vulnerability scanner failing: configure provider endpoint and credentials.

## Additional Notes
- Use reproducible builds (`--layers` ordering).
- Automate in CI/CD pipeline with GitHub Actions or Azure Pipelines.
- Consider using distroless or scratch as base for minimal images.
