# socat

## Overview

socat (SOcket CAT) is a multipurpose relay tool for bidirectional data transfer between two independent data channels. It's particularly useful for advanced networking tasks in cloud and container environments, offering more features than netcat.

## Official Documentation
- [Socat Manual](http://www.dest-unreach.org/socat/doc/socat.html)
- [Socat Examples](http://www.dest-unreach.org/socat/doc/socat-ttydelay.html)

## Key Features
- Bidirectional data transfers
- Support for multiple protocols
- SSL/TLS encryption capabilities
- Advanced port forwarding
- UNIX domain socket support
- Complex data channel options
- IPv4 and IPv6 support

## Basic Usage

### Simple Connections
```bash
# TCP port listener
socat TCP-LISTEN:8080,fork -

# Connect to TCP port
socat - TCP:localhost:8080

# UDP listener
socat UDP-LISTEN:514,fork -

# UNIX domain socket
socat UNIX-LISTEN:/tmp/socket,fork -
```

### Advanced Options
```bash
# SSL server
socat OPENSSL-LISTEN:443,cert=server.pem,fork -

# Forward traffic
socat TCP-LISTEN:8080,fork TCP:target-host:80

# Bidirectional pipe
socat PIPE:/tmp/pipe -
```

## Cloud/Container Use Cases

### 1. Kubernetes Service Debugging

Debug service communication in Kubernetes:

```bash
# Create debug pod
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: socat-debug
spec:
  containers:
  - name: socat
    image: alpine/socat
    command: ['sleep', 'infinity']
EOF

# Port forward service traffic
kubectl exec -it socat-debug -- socat \
  TCP-LISTEN:8080,fork \
  TCP:service:80

# SSL/TLS service testing
kubectl exec -it socat-debug -- socat \
  OPENSSL-LISTEN:8443,cert=/certs/server.pem,fork \
  TCP:secure-service:443

# Debug service mesh traffic
kubectl exec -it socat-debug -- socat \
  TCP-LISTEN:15000,fork \
  TCP:localhost:15000
```

### 2. Azure Service Integration

Handle Azure service connections:

```bash
# Azure SQL SSL tunnel
socat \
  TCP-LISTEN:1433,fork,reuseaddr \
  OPENSSL:myserver.database.windows.net:1433,verify=0

# Azure Storage HTTPS proxy
socat \
  TCP-LISTEN:10000,fork,reuseaddr \
  OPENSSL:myaccount.blob.core.windows.net:443,verify=0

# Azure Redis connection
socat \
  TCP-LISTEN:6380,fork \
  OPENSSL:mycache.redis.cache.windows.net:6380,verify=0
```

### 3. Container Network Debugging

Debug container networking:

```bash
# Container port forwarding
podman run -d --name web nginx
socat TCP-LISTEN:8080,fork TCP:$(podman inspect -f '{{.NetworkSettings.IPAddress}}' web):80

# Container to container communication
socat TCP-LISTEN:9000,fork,reuseaddr TCP:container2:80

# Debug container SSL traffic
socat -v \
  OPENSSL-LISTEN:8443,cert=server.pem,fork \
  TCP:container:443
```

## Common Troubleshooting Scenarios

### 1. SSL/TLS Debugging
```bash
# SSL server with certificate
socat \
  OPENSSL-LISTEN:8443,cert=server.pem,fork \
  -

# SSL client with verbose output
socat -v \
  - \
  OPENSSL:localhost:8443,verify=0
```

### 2. Protocol Analysis
```bash
# HTTP traffic inspection
socat -v \
  TCP-LISTEN:8080,fork \
  TCP:api.example.com:80

# HTTPS traffic relay with logging
socat -v \
  OPENSSL-LISTEN:8443,cert=server.pem,fork \
  OPENSSL:api.example.com:443,verify=0
```

### 3. Service Tunneling
```bash
# Local to remote forwarding
socat \
  TCP-LISTEN:local_port,fork,reuseaddr \
  TCP:remote_host:remote_port

# UDP to TCP conversion
socat \
  UDP-LISTEN:514,fork \
  TCP:logserver:514
```

## Azure-Specific Use Cases

### 1. AKS Service Debugging
```yaml
# Debug pod configuration
apiVersion: v1
kind: Pod
metadata:
  name: socat-debug
spec:
  containers:
  - name: socat
    image: alpine/socat
    command:
    - socat
    - TCP-LISTEN:8080,fork
    - TCP:service:80
```

### 2. Azure Service Proxying
```bash
#!/bin/bash
# Azure service proxy script

# Start SQL proxy
socat \
  TCP-LISTEN:1433,fork,reuseaddr \
  OPENSSL:myserver.database.windows.net:1433,verify=0 &

# Start Storage proxy
socat \
  TCP-LISTEN:10000,fork,reuseaddr \
  OPENSSL:myaccount.blob.core.windows.net:443,verify=0 &

# Start Redis proxy
socat \
  TCP-LISTEN:6380,fork \
  OPENSSL:mycache.redis.cache.windows.net:6380,verify=0 &
```

### 3. Load Balancer Testing
```bash
# Test backend connections
for backend in ${backends[@]}; do
  socat -v \
    TCP-LISTEN:8080,fork \
    TCP:$backend:80
done
```

## Best Practices

### 1. Security Considerations
- Always use SSL/TLS for sensitive data
- Implement proper certificate validation
- Control access with IP restrictions
- Monitor relay connections

### 2. Performance Optimization
```bash
# Buffered relay
socat \
  TCP-LISTEN:80,fork,reuseaddr \
  TCP:target:80,keepalive

# Multiple concurrent connections
socat \
  TCP-LISTEN:80,fork,reuseaddr,max-children=10 \
  TCP:target:80
```

### 3. Error Handling
```bash
# Retry on connection failure
socat -v \
  TCP-LISTEN:8080,fork,retry=10 \
  TCP:target:80,forever

# Connection timeout
socat \
  TCP-LISTEN:8080,fork \
  TCP:target:80,connect-timeout=5
```

## Integration Examples

### 1. Service Monitoring
```bash
#!/bin/bash
# Monitor multiple services

monitor_service() {
  local listen_port=$1
  local target_host=$2
  local target_port=$3
  
  socat -v \
    TCP-LISTEN:$listen_port,fork \
    TCP:$target_host:$target_port 2>&1 | \
    logger -t service-monitor
}

# Monitor multiple services
monitor_service 8080 web-service 80 &
monitor_service 8443 secure-service 443 &
```

### 2. Azure Function Integration
```python
import subprocess
import azure.functions as func

def create_tunnel(host, port, local_port):
    subprocess.Popen([
        'socat',
        f'TCP-LISTEN:{local_port},fork,reuseaddr',
        f'TCP:{host}:{port}'
    ])

def main(mytimer: func.TimerRequest) -> None:
    # Create tunnels for different services
    create_tunnel('myapp.azurewebsites.net', 443, 8443)
    create_tunnel('mydb.database.windows.net', 1433, 1433)
```

### 3. Kubernetes Debugging
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: service-debug
spec:
  template:
    spec:
      containers:
      - name: socat
        image: alpine/socat
        command:
        - socat
        - -v
        - TCP-LISTEN:8080,fork
        - TCP:problem-service:80
      restartPolicy: Never
