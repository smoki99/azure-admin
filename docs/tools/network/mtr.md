# mtr (My TraceRoute)

## Overview

mtr combines the functionality of 'traceroute' and 'ping' into a single network diagnostic tool. It continuously sends packets and shows real-time statistics about the network path between your host and a destination.

## Official Documentation
- [MTR GitHub Repository](https://github.com/traviscross/mtr)
- [MTR Manual](https://man.archlinux.org/man/mtr.8)

## Key Features
- Real-time network path analysis
- Continuous packet transmission
- Statistical data for each hop
- Multiple output formats (text, JSON, XML)
- Customizable packet sizes and intervals
- Both IPv4 and IPv6 support

## Basic Usage

### Basic Commands
```bash
# Basic MTR scan
mtr example.com

# Report mode (single output)
mtr -r example.com

# Report with 100 packets
mtr -r -c 100 example.com

# JSON output
mtr --json example.com
```

### Advanced Options
```bash
# Change packet size
mtr -s 1000 example.com

# IPv4 only
mtr -4 example.com

# Custom interval (in seconds)
mtr -i 0.5 example.com
```

## Cloud/Container Use Cases

### 1. Azure Service Connectivity

Test connectivity to Azure services:

```bash
# Test Azure Storage connectivity
mtr -r -c 50 myaccount.blob.core.windows.net

# Test AKS API server
mtr -r -c 100 my-aks-cluster.hcp.eastus.azmk8s.io

# Monitor Azure Front Door endpoint
mtr --json my-frontdoor.azurefd.net > frontdoor_path.json
```

### 2. AKS Network Troubleshooting

Debug Kubernetes service connectivity:

```bash
# Create debug pod
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: network-debug
spec:
  containers:
  - name: network-tools
    image: nicolaka/netshoot
    command: ['sleep', 'infinity']
EOF

# Test service mesh gateway
kubectl exec -it network-debug -- mtr -r istio-ingressgateway.istio-system.svc.cluster.local

# Check external service connection
kubectl exec -it network-debug -- mtr -r external-service.com

# Monitor inter-node communication
kubectl exec -it network-debug -- mtr -r node-internal-ip
```

### 3. Container Network Analysis

Analyze container networking:

```bash
# Run network analysis container
podman run -it --name nettools nicolaka/netshoot

# Test container-to-service connectivity
podman exec -it nettools mtr -r api.example.com

# Analyze container network path
podman exec -it nettools mtr --json gateway-ip > container_path.json
```

## Common Troubleshooting Scenarios

### 1. Latency Investigation
```bash
# Detailed latency analysis
mtr -r -c 100 -i 0.1 target-host

# Monitor specific hops
mtr -r -c 50 --report-wide target-host
```

### 2. Packet Loss Detection
```bash
# Extended test for packet loss
mtr -r -c 1000 problem-host

# UDP packet loss test
mtr --udp -r problem-host
```

### 3. Network Path Changes
```bash
# Monitor route changes
mtr --no-dns target-host

# Compare different paths
mtr -r path1.example.com > path1.txt
mtr -r path2.example.com > path2.txt
diff path1.txt path2.txt
```

## Azure-Specific Troubleshooting

### 1. Region Connectivity
```bash
# Test cross-region latency
mtr -r westeurope.cache.azure.net
mtr -r eastus.cache.azure.net

# Compare results
mtr --json westeurope.cache.azure.net > west.json
mtr --json eastus.cache.azure.net > east.json
```

### 2. Service Health Checks
```bash
# Azure services monitoring script
#!/bin/bash
services=(
  "myapp.azurewebsites.net"
  "mydb.database.windows.net"
  "mystg.blob.core.windows.net"
)

for service in "${services[@]}"; do
  echo "Testing $service"
  mtr -r -c 50 $service > "mtr_${service//[.:]/_}.txt"
done
```

### 3. AKS Network Policy Validation
```bash
# Test pod-to-service connectivity
kubectl exec -it network-debug -- mtr -r \
  my-service.namespace.svc.cluster.local

# Test pod-to-external connectivity
kubectl exec -it network-debug -- mtr -r \
  azure-service.com
```

## Best Practices

### 1. Performance Testing
- Run multiple iterations
- Use consistent packet counts
- Test during different times
- Compare results over time

### 2. Output Management
```bash
# Timestamp results
timestamp=$(date +%Y%m%d_%H%M%S)
mtr -r target > "mtr_${timestamp}.txt"

# JSON for automation
mtr --json target | jq > results.json
```

### 3. Security Considerations
- Avoid exposing MTR results publicly
- Use with caution in production
- Consider network security policies
- Monitor resource usage

## Integration Examples

### 1. Monitoring Script
```bash
#!/bin/bash
# Regular path monitoring
TARGETS=(
  "api.example.com"
  "db.example.com"
  "cache.example.com"
)

while true; do
  for target in "${TARGETS[@]}"; do
    timestamp=$(date +%Y%m%d_%H%M%S)
    mtr -r -c 100 $target > "mtr_${target}_${timestamp}.txt"
  done
  sleep 3600
done
```

### 2. Azure Function App
```python
import subprocess
import json
import azure.functions as func

def main(timer: func.TimerRequest) -> None:
    targets = ['api.example.com', 'db.example.com']
    results = {}
    
    for target in targets:
        process = subprocess.run(['mtr', '-r', '--json', target],
                               capture_output=True, text=True)
        results[target] = json.loads(process.stdout)
    
    # Store results in Azure Storage
    save_results(results)
```

### 3. Kubernetes Monitoring
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: network-path-monitor
spec:
  schedule: "*/30 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: network-monitor
            image: nicolaka/netshoot
            command:
            - /bin/sh
            - -c
            - |
              mtr -r -c 50 --json $TARGET_HOST > /data/path_analysis.json
          volumes:
          - name: data
            persistentVolumeClaim:
              claimName: network-data-pvc
