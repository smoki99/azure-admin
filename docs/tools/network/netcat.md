# netcat (nc)

## Overview

Netcat (nc) is a versatile networking utility that can read and write data across network connections. Often called the "TCP/IP Swiss Army knife", it's invaluable for debugging and monitoring network connections in cloud and container environments.

## Official Documentation
- [GNU Netcat](https://www.gnu.org/software/netcat/)
- [OpenBSD Netcat](https://man.openbsd.org/nc.1)

## Key Features
- TCP and UDP connection testing
- Port scanning capabilities
- Simple server creation
- Data transfer between hosts
- Network daemon testing
- Port forwarding
- Proxying capabilities

## Basic Usage

### Connection Testing
```bash
# Test TCP port
nc -zv hostname 80

# Test UDP port
nc -zuv hostname 53

# Multiple port scan
nc -zv hostname 20-25
```

### Server/Client Mode
```bash
# Listen on port (server)
nc -l 8080

# Connect to server (client)
nc hostname 8080

# Keep server listening
nc -lk 8080
```

## Cloud/Container Use Cases

### 1. Kubernetes Service Testing

Test service connectivity in Kubernetes:

```bash
# Create debug pod
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: netcat-debug
spec:
  containers:
  - name: netcat
    image: nicolaka/netshoot
    command: ['sleep', 'infinity']
EOF

# Test service connectivity
kubectl exec -it netcat-debug -- nc -zv my-service 80

# Monitor service port
kubectl exec -it netcat-debug -- nc -l -p 8080

# Test cross-namespace service
kubectl exec -it netcat-debug -- nc -zv \
  my-service.other-namespace.svc.cluster.local 443
```

### 2. Azure Service Validation

Test Azure service endpoints:

```bash
# Test Azure SQL connectivity
nc -zv my-server.database.windows.net 1433

# Test Azure Storage
nc -zv myaccount.blob.core.windows.net 443

# Test Azure Cache for Redis
nc -zv my-cache.redis.cache.windows.net 6380

# Batch test Azure services
#!/bin/bash
services=(
  "myapp.azurewebsites.net:443"
  "myserver.database.windows.net:1433"
  "mystorageaccount.blob.core.windows.net:443"
)

for service in "${services[@]}"; do
  host=${service%:*}
  port=${service#*:}
  echo "Testing $host:$port"
  nc -zv $host $port
done
```

### 3. Container Network Debugging

Debug container networking issues:

```bash
# Test container connectivity
podman run --rm nicolaka/netshoot nc -zv container-name 80

# Port forwarding in containers
podman run -d --name web nginx
podman run --rm nicolaka/netshoot nc -zv web 80

# Test container DNS
podman run --rm nicolaka/netshoot sh -c \
  'nc -zv $(getent hosts web | awk "{print \$1}") 80'
```

## Common Troubleshooting Scenarios

### 1. Service Availability Testing
```bash
# HTTP service test
echo -e "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n" | nc example.com 80

# HTTPS service verification
nc -zv example.com 443

# Custom timeout
nc -zv -w 5 example.com 443
```

### 2. Load Balancer Testing
```bash
# Test backend connectivity
for i in {1..5}; do
  nc -zv lb.example.com 80
  sleep 1
done

# Monitor backend responses
nc -l 8080 | tee responses.log
```

### 3. Network Debugging
```bash
# Simple chat server
nc -l 8080

# File transfer (sender)
nc -l 8080 < file.txt

# File transfer (receiver)
nc hostname 8080 > received_file.txt
```

## Azure-Specific Use Cases

### 1. Service Health Monitoring
```bash
#!/bin/bash
# Azure service health check script

check_service() {
  local host=$1
  local port=$2
  nc -zv -w 5 $host $port 2>&1
}

# Check Azure services
check_service "myapp.azurewebsites.net" 443
check_service "mydb.database.windows.net" 1433
check_service "myredis.redis.cache.windows.net" 6380
```

### 2. AKS Network Policy Testing
```bash
# Test egress policy
kubectl exec -it netcat-debug -- nc -zv api.example.com 443

# Test ingress policy
kubectl exec -it netcat-debug -- nc -l -p 8080

# Cross-namespace communication
kubectl exec -it netcat-debug -- nc -zv \
  service.namespace.svc.cluster.local 80
```

### 3. Azure Front Door Validation
```bash
# Test backend pools
for backend in ${backends[@]}; do
  nc -zv $backend 443
done
```

## Best Practices

### 1. Security Considerations
- Use timeouts with -w flag
- Avoid exposing unnecessary ports
- Monitor connection attempts
- Use secure protocols when possible

### 2. Performance Testing
```bash
# Connection time measurement
time nc -zv hostname port

# Batch testing script
for i in {1..100}; do
  nc -zv hostname port 2>&1 | tee -a results.log
  sleep 0.1
done
```

### 3. Automation Tips
```bash
# Service check function
check_port() {
  nc -zv $1 $2 2>&1 > /dev/null
  echo $?
}

# Usage in scripts
if check_port example.com 80; then
  echo "Service is up"
else
  echo "Service is down"
fi
```

## Integration Examples

### 1. Monitoring Script
```bash
#!/bin/bash
# Regular service monitoring

SERVICES=(
  "web:80"
  "api:443"
  "db:5432"
)

while true; do
  for service in "${SERVICES[@]}"; do
    host=${service%:*}
    port=${service#*:}
    nc -zv $host $port 2>&1 | logger -t service-monitor
  done
  sleep 300
done
```

### 2. Azure Function Integration
```python
import subprocess
import datetime
import azure.functions as func

def run_netcat(host, port):
    try:
        subprocess.run(['nc', '-zv', '-w', '5', host, str(port)],
                      check=True, capture_output=True)
        return True
    except subprocess.CalledProcessError:
        return False

def main(mytimer: func.TimerRequest) -> None:
    services = [
        ('myapp.azurewebsites.net', 443),
        ('mydb.database.windows.net', 1433)
    ]
    
    results = {}
    for host, port in services:
        results[f"{host}:{port}"] = run_netcat(host, port)
    
    # Log results to Azure Monitor
    log_results(results)
```

### 3. Kubernetes NetworkPolicy Testing
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: network-policy-test
spec:
  template:
    spec:
      containers:
      - name: netcat
        image: nicolaka/netshoot
        command:
        - /bin/sh
        - -c
        - |
          for target in $TARGETS; do
            nc -zv $target
          done
      restartPolicy: Never
