Here is your updated **Podman documentation** with all the key findings from your experiments, especially around running Podman inside Docker on **Windows with WSL2**. I've added a new section for **Running Podman Inside Docker**, included **limitations of rootless in Docker Desktop**, and marked key configuration options for privileged mode.

---

````markdown
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

---

## Running Podman Inside Docker (Windows / WSL2)

### ⚠️ Limitations of Rootless Mode

Rootless Podman **does not work** in Docker Desktop with WSL2 due to lack of support for user namespaces and tools like `newuidmap`. You'll see errors such as:

```text
newuidmap: open of uid_map failed: Permission denied
````

This is a **kernel restriction**, not a Podman issue.

### ✅ Recommended: Privileged Mode

To run Podman inside Docker (in WSL2), use the following flags:

```bash
docker run --privileged -it azure-admin
```

**Minimal working config for Podman in Docker:**

```bash
docker run -it \
  --privileged \
  --device=/dev/fuse \
  --tmpfs /tmp \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  azure-admin
```

Inside the container:

* Use the `podman` CLI normally.
* Optionally set `cgroup_manager = "cgroupfs"` in `/etc/containers/containers.conf` to avoid `pids` controller errors.
* Avoid using `runc` runtime if unavailable. Prefer `crun`.

---

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

---

## Cloud/Container Use Cases

### 1. Azure Container Registry Integration

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

```bash
podman run -d \
  --name devenv \
  -v $(pwd):/app \
  -w /app \
  -p 3000:3000 \
  node:latest

podman exec -it devenv npm install
podman exec -it devenv npm run dev
podman logs -f devenv
```

### 3. Pod Management

```bash
podman pod create --name webapp

podman run -d --pod webapp --name frontend nginx
podman run -d --pod webapp --name backend myapp-backend

podman pod ps
podman pod stop webapp
podman pod start webapp
```

---

## Common Scenarios

### 1. Network Management

```bash
podman network create mynet

podman run -d --network mynet --name db postgres

podman network inspect mynet
podman run --network mynet alpine ping db
```

### 2. Volume Management

```bash
podman volume create mydata

podman run -d -v mydata:/var/lib/postgresql/data --name db postgres

podman run --rm \
  -v mydata:/source \
  -v $(pwd):/backup \
  alpine tar czf /backup/data.tar.gz /source
```

### 3. Resource Management

```bash
podman run -d \
  --name app \
  --cpus 2 \
  --memory 512m \
  myapp

podman stats
podman update --cpus 4 --memory 1g app
```

---

## Azure-Specific Features

### 1. Azure Identity Integration

```bash
podman run -d \
  --name azure-app \
  -e AZURE_CLIENT_ID=$CLIENT_ID \
  -e AZURE_TENANT_ID=$TENANT_ID \
  -e AZURE_CLIENT_SECRET=$CLIENT_SECRET \
  myapp

podman run -d \
  --name azure-app \
  -v $HOME/.azure:/root/.azure:ro \
  azure-cli
```

### 2. Azure Storage Integration

```bash
podman run -d -v azure-vol:/data --name storage myapp

podman run -d \
  --name blob \
  -e AZURE_STORAGE_CONNECTION_STRING=$CONNECTION_STRING \
  azure-storage-app
```

### 3. Azure Service Integration

```bash
podman run -d \
  --name sql-app \
  -e DB_HOST=myserver.database.windows.net \
  -e DB_USER=admin \
  -e DB_PASS=password \
  sql-app

podman run -d \
  --name cache \
  -e REDIS_HOST=mycache.redis.cache.windows.net \
  -e REDIS_KEY=$REDIS_KEY \
  cache-app
```

---

## Best Practices

### 1. Security

```bash
# Rootless mode (not supported in Docker on WSL2)
podman run --user 1000:1000 myapp

# Read-only FS
podman run --read-only myapp

# Drop capabilities
podman run --cap-drop ALL --cap-add NET_BIND_SERVICE nginx
```

### 2. Resource Management

```bash
podman run \
  --cpu-shares 512 \
  --memory 256m \
  --memory-swap 512m \
  myapp

podman run \
  --cgroup-parent myapp.slice \
  myapp
```

### 3. Networking

```bash
podman network create \
  --subnet 172.20.0.0/16 \
  --gateway 172.20.0.1 \
  appnet

podman run \
  --dns 8.8.8.8 \
  --dns-search example.com \
  myapp
```

---

## Integration Examples

### 1. Development Workflow

```bash
#!/bin/bash
# Local development script

podman run -d \
  --name devenv \
  -v $PWD:/app \
  -w /app \
  -p 3000:3000 \
  node:latest

podman exec -d devenv npm run watch
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

systemctl enable --now myapp
```
