# nethogs - Per-Process Network Bandwidth Monitor

## Overview
`nethogs` is a small 'net top' tool that groups bandwidth by process rather than by IP or interface. It's particularly useful for finding which process is using bandwidth in a containerized environment.

## Official Documentation
[nethogs GitHub](https://github.com/raboof/nethogs)

## Basic Usage

### Simple Monitoring
```bash
# Monitor all interfaces
nethogs

# Monitor specific interface
nethogs eth0

# Monitor multiple interfaces
nethogs eth0 docker0
```

### Display Control
```bash
# Update every 1 second
nethogs -d 1

# Show traffic in KB/s
nethogs -v 1

# Show traffic in MB/s
nethogs -v 2
```

## Cloud/Container Use Cases

### 1. Container Network Monitoring
```bash
# Monitor container interface
nethogs docker0

# Track Kubernetes networking
nethogs cni0

# Monitor all container traffic
nethogs docker0 cni0 veth*
```

### 2. Process Analysis
```bash
# Monitor specific services
nethogs -f "port 80" eth0

# Track database processes
nethogs -f "port 5432"

# Watch microservice traffic
nethogs -f "port range 8000-8100"
```

### 3. Resource Management
```bash
# Monitor high bandwidth users
nethogs -t

# Track specific processes
nethogs -p process_name

# Watch container processes
nethogs -v 2 docker0
```

## Advanced Features

### 1. Output Control
```bash
# Trace mode
nethogs -t

# Sort by received
nethogs -v 3

# Sort by sent
nethogs -v 2
```

### 2. Process Filtering
```bash
# Monitor specific process
nethogs -p nginx

# Watch container processes
nethogs -p containerd

# Track application servers
nethogs -p java
```

### 3. Interface Selection
```bash
# Multiple interfaces
nethogs eth0 wlan0

# Virtual interfaces
nethogs veth* docker0

# All interfaces
nethogs all
```

## Best Practices

### 1. Performance Monitoring
```bash
# Regular updates
nethogs -d 0.5

# Track heavy users
nethogs -t -v 2

# Monitor specific services
nethogs -p service_name
```

### 2. Troubleshooting
```bash
# Find bandwidth hogs
nethogs -t all

# Track unusual traffic
nethogs -v 3 -d 1

# Monitor specific network
nethogs -f "net 10.0.0.0/8"
```

### 3. Resource Management
```bash
# Track per-container usage
nethogs docker0 -d 1

# Monitor service traffic
nethogs -p service -v 2

# Watch system processes
nethogs -t -v 3
```

## Common Scenarios

### 1. Container Operations
```bash
# Monitor container networking
nethogs docker0 cni0

# Track microservices
nethogs -p node -p java -p python

# Watch service mesh
nethogs -p istio-proxy
```

### 2. Service Monitoring
```bash
# Web services
nethogs -p nginx -p apache2

# Database traffic
nethogs -p postgres -p mysql

# Application servers
nethogs -p java -p node
```

### 3. Troubleshooting
```bash
# Find network issues
nethogs -t all

# Track specific issues
nethogs -p problematic_process

# Monitor system services
nethogs -p systemd-*
```

## Integration Examples

### 1. With Container Tools
```bash
# Monitor container traffic
nethogs $(podman network ls --format '{{.Name}}')

# Track Kubernetes networking
nethogs $(kubectl get pods -o jsonpath='{.items[*].status.hostIP}')
```

### 2. With Monitoring Tools
```bash
# Save statistics
nethogs -t | tee network.log

# Monitor and alert
nethogs -t | grep -E "MB/s|GB/s"

# Generate reports
nethogs -t | awk '/Total/{print strftime("%Y-%m-%d %H:%M:%S"), $0}'
```

### 3. With Cloud Tools
```bash
# Monitor cloud services
nethogs $(az network nic list --query '[].ipConfigurations[].subnet.id' -o tsv)

# Track VPN traffic
nethogs tun0 vpn0

# Watch load balancer
nethogs -p haproxy
```

## Troubleshooting

### Common Issues
1. Permission errors
   ```bash
   # Run with sudo
   sudo nethogs
   
   # Add capabilities
   setcap cap_net_admin,cap_net_raw+ep /usr/sbin/nethogs
   ```

2. Process identification
   ```bash
   # Check process names
   ps aux | grep process
   
   # Use full path
   nethogs -p /usr/bin/process
   ```

3. Interface issues
   ```bash
   # List interfaces
   ip link show
   
   # Check interface status
   ifconfig -a
   ```

### Best Practices
1. Regular monitoring intervals
2. Proper interface selection
3. Process name matching
4. Output formatting
5. Resource usage consideration
