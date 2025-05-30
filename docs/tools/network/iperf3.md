# iperf3

## Overview

iperf3 is a modern network performance measurement tool that can measure both TCP and UDP bandwidth performance. It's particularly useful for diagnosing network performance issues in cloud and container environments.

## Official Documentation
- [iperf3 Documentation](https://iperf.fr/iperf-doc.php)
- [Man Page](https://software.es.net/iperf/invoking.html)

## Key Features
- TCP and UDP bandwidth measurements
- JSON output for programmatic parsing
- Client and server functionality
- Support for parallel streams
- Configurable time intervals
- Bidirectional testing

## Basic Usage

### Server Mode
```bash
# Start iperf3 server
iperf3 -s

# Server on specific port
iperf3 -s -p 5201

# Server with JSON output
iperf3 -s --json
```

### Client Mode
```bash
# Basic bandwidth test
iperf3 -c server-ip

# Specific duration test
iperf3 -c server-ip -t 30

# Parallel streams
iperf3 -c server-ip -P 4
```

## Cloud/Container Use Cases

### 1. AKS Pod Network Performance

Test network performance between pods in different nodes:

```bash
# Deploy iperf3 server pod
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: iperf3-server
  labels:
    app: iperf3-server
spec:
  containers:
  - name: iperf3-server
    image: networkstatic/iperf3
    args: ["-s"]
    ports:
    - containerPort: 5201
EOF

# Deploy iperf3 client pod
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: iperf3-client
spec:
  containers:
  - name: iperf3-client
    image: networkstatic/iperf3
    command: ["sleep", "infinity"]
EOF

# Run test between pods
SERVER_POD=$(kubectl get pod -l app=iperf3-server -o jsonpath='{.items[0].status.podIP}')
kubectl exec -it iperf3-client -- iperf3 -c $SERVER_POD -t 30 --json > pod_network_test.json
```

### 2. Azure Virtual Network Performance

Test performance between VNets or across regions:

```bash
# In VNET1 VM
iperf3 -s -p 5201

# In VNET2 VM
iperf3 -c vnet1-ip -p 5201 -t 60 -J > vnet_perf.json

# Analyze results
cat vnet_perf.json | jq '.end.sum_received.bits_per_second/1000000000'
```

### 3. Container Network Performance

Test container network driver performance:

```bash
# Create network for testing
podman network create test-net

# Start server container
podman run -d --name iperf3-server \
  --network test-net \
  -p 5201:5201 \
  networkstatic/iperf3 -s

# Run client test
podman run --rm \
  --network test-net \
  networkstatic/iperf3 -c iperf3-server -t 30 -J > container_perf.json
```

## Common Testing Scenarios

### 1. Bandwidth Testing
```bash
# TCP bandwidth test
iperf3 -c server-ip -t 60 -P 4

# UDP bandwidth test
iperf3 -c server-ip -u -b 1G
```

### 2. Latency Testing
```bash
# Test with small packets
iperf3 -c server-ip -n 1000 -l 64

# Test with specific interval
iperf3 -c server-ip -i 0.5
```

### 3. Network Stress Testing
```bash
# Multiple parallel streams
iperf3 -c server-ip -P 10 -t 300

# Maximum bandwidth test
iperf3 -c server-ip -b 0
```

## Troubleshooting Azure/AKS Issues

### 1. Pod-to-Pod Communication
Problem: Slow communication between pods across nodes
```bash
# Test bandwidth between pods
kubectl exec -it iperf3-client -- iperf3 -c $SERVER_POD -t 60 -P 4
```

### 2. Service Performance
Problem: Service latency issues
```bash
# Test service endpoint
iperf3 -c service-ip -p service-port -t 30 --json
```

### 3. Cross-Region Performance
Problem: High latency between regions
```bash
# Long duration test with detailed stats
iperf3 -c remote-ip -t 300 -i 10 --json
```

## Best Practices

1. **Test Duration**
   - Run tests for at least 30 seconds
   - Use longer durations for stability testing
   - Include multiple test iterations

2. **Performance Analysis**
   - Always use JSON output for automation
   - Compare results with Azure SLAs
   - Document baseline performance

3. **Security Considerations**
   - Restrict iperf3 server access
   - Use specific ports
   - Monitor resource usage

4. **Resource Impact**
   - Be mindful of bandwidth consumption
   - Schedule tests during maintenance windows
   - Monitor container resource usage

## Integration Examples

### 1. Monitoring Script
```bash
#!/bin/bash
# Regular network performance monitoring
while true; do
  timestamp=$(date +%Y%m%d_%H%M%S)
  iperf3 -c target-ip -t 30 --json > "perf_${timestamp}.json"
  sleep 3600
done
```

### 2. Azure DevOps Pipeline
```yaml
steps:
- task: Bash@3
  inputs:
    targetType: 'inline'
    script: |
      # Network performance test in pipeline
      iperf3 -c $(targetIp) -t 60 --json > network_perf.json
      cat network_perf.json | jq '.end.sum_received.bits_per_second/1000000000' > bandwidth.txt
```

### 3. Kubernetes CronJob
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: network-performance-test
spec:
  schedule: "0 */6 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: iperf3
            image: networkstatic/iperf3
            args:
            - /bin/sh
            - -c
            - iperf3 -c $(TARGET_IP) -t 30 --json > /data/results.json
