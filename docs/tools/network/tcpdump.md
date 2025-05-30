# tcpdump

## Overview

tcpdump is a powerful command-line packet analyzer that allows you to capture and display network traffic. It's essential for debugging network issues, analyzing protocols, and monitoring traffic in cloud and container environments.

## Official Documentation
- [TCPDump Manual](https://www.tcpdump.org/manpages/tcpdump.1.html)
- [TCPDump Examples](https://www.tcpdump.org/manpages/pcap-filter.7.html)

## Key Features
- Real-time packet capture
- Powerful filtering capabilities
- Protocol analysis
- Write captures to files
- Read from capture files
- Support for multiple interfaces
- Advanced expression matching

## Basic Usage

### Capture Options
```bash
# Basic capture on interface
tcpdump -i eth0

# Write to file
tcpdump -w capture.pcap

# Read from file
tcpdump -r capture.pcap

# Verbose output
tcpdump -v -i eth0
```

### Common Filters
```bash
# Filter by host
tcpdump host 192.168.1.1

# Filter by port
tcpdump port 80

# Filter by protocol
tcpdump tcp

# Complex filter
tcpdump 'tcp and port 80 and host 192.168.1.1'
```

## Cloud/Container Use Cases

### 1. Kubernetes Network Analysis

Debug pod networking issues:

```bash
# Create debug pod
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: tcpdump-debug
spec:
  containers:
  - name: tcpdump
    image: nicolaka/netshoot
    command: ['sleep', 'infinity']
    securityContext:
      capabilities:
        add: ["NET_ADMIN"]
EOF

# Capture pod traffic
kubectl exec -it tcpdump-debug -- tcpdump -i eth0 -w /tmp/pod.pcap

# Monitor service traffic
kubectl exec -it tcpdump-debug -- tcpdump \
  -i any \
  "port 80 and host service-name"

# Analyze CNI traffic
kubectl exec -it tcpdump-debug -- tcpdump \
  -i any \
  -vvv \
  'udp port 8472'  # VXLAN traffic
```

### 2. Azure Network Monitoring

Monitor Azure service communication:

```bash
# Monitor Azure SQL traffic
tcpdump -i any \
  "host myserver.database.windows.net and port 1433" \
  -w sql_traffic.pcap

# Track Azure Storage access
tcpdump -i any \
  "host mystorageaccount.blob.core.windows.net and port 443" \
  -w storage_traffic.pcap

# Monitor AKS API server traffic
tcpdump -i any \
  "host my-aks-cluster.hcp.eastus.azmk8s.io and port 443" \
  -w aks_api_traffic.pcap
```

### 3. Container Network Debugging

Analyze container networking:

```bash
# Monitor container traffic
podman run --net=host --privileged nicolaka/netshoot \
  tcpdump -i docker0 -w container_traffic.pcap

# Track inter-container communication
tcpdump -i any \
  "host container1 and host container2" \
  -w container_comms.pcap

# Monitor container DNS queries
tcpdump -i any port 53
```

## Common Troubleshooting Scenarios

### 1. Service Communication Issues
```bash
# HTTP traffic analysis
tcpdump -A -s0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'

# HTTPS handshake inspection
tcpdump -i any -n 'tcp port 443 and tcp[tcp[12]>>2&0x3C==16]'

# Connection tracking
tcpdump 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0'
```

### 2. DNS Problems
```bash
# Capture DNS queries
tcpdump -i any 'udp port 53'

# DNS response analysis
tcpdump -i any 'udp port 53 and udp[10] & 0x0f > 0'

# Complete DNS traffic
tcpdump -vvv -s0 'port 53'
```

### 3. Load Balancer Issues
```bash
# Monitor backend traffic
tcpdump -n "host backend1 or host backend2"

# Track client connections
tcpdump "dst port 80 and tcp[tcpflags] & tcp-syn != 0"
```

## Azure-Specific Troubleshooting

### 1. AKS Network Policies
```bash
# Monitor policy enforcement
tcpdump -i any \
  "tcp and (port 80 or port 443) and host pod-ip"

# Ingress traffic analysis
tcpdump -i any \
  "dst net 10.0.0.0/16 and tcp[tcpflags] & tcp-syn != 0"

# Egress traffic monitoring
tcpdump -i any \
  "src net 10.0.0.0/16 and not dst net 10.0.0.0/16"
```

### 2. Service Mesh Analysis
```bash
# Capture Istio sidecar traffic
tcpdump -i any \
  "port 15001 or port 15006" \
  -w istio_traffic.pcap

# Monitor Envoy proxy
tcpdump -i any \
  "port 15000" \
  -w envoy_admin.pcap
```

### 3. Azure Service Endpoints
```bash
# Monitor private endpoints
tcpdump -i any \
  "net 10.0.0.0/8 and port 1433" \
  -w private_endpoint.pcap
```

## Best Practices

### 1. Capture Management
- Use `-C` for rotating capture files
- Apply specific filters to reduce noise
- Use `-w` to save captures for analysis
- Monitor capture file sizes

### 2. Performance Considerations
```bash
# Limit packet size
tcpdump -s 96 -i any

# Use specific filters
tcpdump -i any \
  "host target-host and port target-port"

# Buffer size adjustment
tcpdump -i any -B 4096
```

### 3. Security Best Practices
- Avoid capturing sensitive data
- Use proper file permissions
- Clean up capture files
- Monitor system resources

## Integration Examples

### 1. Automated Capture Script
```bash
#!/bin/bash
# Network traffic monitoring

INTERFACE="eth0"
CAPTURE_DIR="/captures"
MAX_SIZE="100M"

start_capture() {
  local name=$1
  local filter=$2
  
  tcpdump -i $INTERFACE \
    -C $MAX_SIZE \
    -w "$CAPTURE_DIR/${name}_%Y%m%d_%H%M%S.pcap" \
    $filter
}

# Start captures
start_capture "web" "port 80 or port 443" &
start_capture "dns" "port 53" &
start_capture "sql" "port 1433" &
```

### 2. Azure Function Monitoring
```python
import subprocess
import azure.functions as func

def capture_traffic(interface, filter_exp, output_file):
    subprocess.Popen([
        'tcpdump',
        '-i', interface,
        '-w', output_file,
        filter_exp
    ])

def main(mytimer: func.TimerRequest) -> None:
    # Monitor different traffic patterns
    capture_traffic('any', 'port 443', 'https_traffic.pcap')
    capture_traffic('any', 'port 53', 'dns_traffic.pcap')
```

### 3. Kubernetes DaemonSet
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: network-monitor
spec:
  selector:
    matchLabels:
      app: network-monitor
  template:
    metadata:
      labels:
        app: network-monitor
    spec:
      containers:
      - name: tcpdump
        image: nicolaka/netshoot
        command:
        - tcpdump
        - -i
        - any
        - -w
        - /capture/traffic.pcap
        securityContext:
          capabilities:
            add: ["NET_ADMIN"]
        volumeMounts:
        - name: capture-volume
          mountPath: /capture
      volumes:
      - name: capture-volume
        persistentVolumeClaim:
          claimName: capture-pvc
