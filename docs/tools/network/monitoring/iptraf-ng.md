# iptraf-ng - Interactive Network Monitor

## Overview
`iptraf-ng` is an IP traffic monitor that provides detailed network statistics including TCP/UDP traffic breakdowns, interface statistics, and protocol distribution. It's particularly useful for analyzing network protocols and troubleshooting network issues.

## Official Documentation
[iptraf-ng Manual](https://linux.die.net/man/8/iptraf-ng)

## Basic Usage

### Starting the Monitor
```bash
# Start interactive interface
iptraf-ng

# Monitor specific interface
iptraf-ng -i eth0

# View IP traffic
iptraf-ng -g
```

### Common Options
```bash
# Run in text mode
iptraf-ng -t

# Show detailed statistics
iptraf-ng -d eth0

# Monitor specific ports
iptraf-ng -f "port 80 or port 443"
```

## Cloud/Container Use Cases

### 1. Container Network Analysis
```bash
# Monitor container interface
iptraf-ng -i docker0

# Watch Kubernetes traffic
iptraf-ng -i cni0

# Analyze service mesh
iptraf-ng -i istio-proxy
```

### 2. Protocol Analysis
```bash
# Monitor web traffic
iptraf-ng -f "tcp and (port 80 or port 443)"

# Track database connections
iptraf-ng -f "tcp and port 5432"

# Watch service discovery
iptraf-ng -f "udp and port 53"
```

### 3. Performance Monitoring
```bash
# Interface statistics
iptraf-ng -s eth0

# TCP/UDP breakdown
iptraf-ng -z

# Detailed packet info
iptraf-ng -d eth0
```

## Advanced Features

### 1. Traffic Filters
```bash
# Filter by protocol
iptraf-ng -f "tcp"

# Filter by port range
iptraf-ng -f "portrange 8000-9000"

# Complex filters
iptraf-ng -f "tcp and host 10.0.0.1"
```

### 2. Statistical Analysis
```bash
# Interface rates
iptraf-ng -r eth0

# Protocol distribution
iptraf-ng -p

# Connection tracking
iptraf-ng -c
```

### 3. Logging Options
```bash
# Log to file
iptraf-ng -L /var/log/iptraf-ng.log

# Timed logging
iptraf-ng -B

# Activity logging
iptraf-ng -l
```

## Best Practices

### 1. Monitoring Strategy
```bash
# Regular traffic analysis
iptraf-ng -t -i eth0

# Protocol breakdown
iptraf-ng -z -i eth0

# Connection tracking
iptraf-ng -c -i eth0
```

### 2. Troubleshooting
```bash
# Find busy services
iptraf-ng -d eth0

# Track unusual traffic
iptraf-ng -f "not (port 80 or port 443)"

# Monitor errors
iptraf-ng -e eth0
```

### 3. Performance Analysis
```bash
# Bandwidth monitoring
iptraf-ng -s eth0

# Protocol efficiency
iptraf-ng -z

# Interface errors
iptraf-ng -r eth0
```

## Common Scenarios

### 1. Container Monitoring
```bash
# Container network analysis
iptraf-ng -i docker0 -z

# Service mesh traffic
iptraf-ng -i istio-proxy -d

# Cross-container communication
iptraf-ng -f "net 172.17.0.0/16"
```

### 2. Service Analysis
```bash
# Web service monitoring
iptraf-ng -f "tcp and (port 80 or port 443)" -i eth0

# Database traffic
iptraf-ng -f "tcp and (port 3306 or port 5432)"

# Microservice communication
iptraf-ng -f "portrange 8000-9000"
```

### 3. Network Debugging
```bash
# Find connectivity issues
iptraf-ng -e eth0

# Track packet loss
iptraf-ng -r eth0

# Monitor retransmissions
iptraf-ng -d eth0
```

## Integration Examples

### 1. With Container Tools
```bash
# Monitor container networks
iptraf-ng -i $(podman network ls --format '{{.Name}}')

# Track Kubernetes services
iptraf-ng -f "net $(kubectl cluster-info | grep -oE '10\.[0-9]+\.[0-9]+\.[0-9]+')"
```

### 2. With Monitoring Tools
```bash
# Generate traffic reports
iptraf-ng -t -L /var/log/traffic.log

# Real-time monitoring
watch -n 1 "iptraf-ng -g -t"

# Performance analysis
iptraf-ng -s eth0 | tee perf.log
```

### 3. With Cloud Tools
```bash
# Monitor cloud connectivity
iptraf-ng -i $(az network nic list --query '[].name' -o tsv)

# Track VPN traffic
iptraf-ng -i tun0

# Analyze load balancer
iptraf-ng -f "port 80" -i eth0
```

## Troubleshooting

### Common Issues
1. Permission problems
   ```bash
   # Run with sudo
   sudo iptraf-ng
   
   # Check permissions
   ls -l /var/log/iptraf-ng/
   ```

2. Display issues
   ```bash
   # Use text mode
   iptraf-ng -t
   
   # Set terminal type
   TERM=xterm iptraf-ng
   ```

3. High resource usage
   ```bash
   # Limit logging
   iptraf-ng -B
   
   # Use filters
   iptraf-ng -f "host 10.0.0.1"
   ```

### Best Practices
1. Regular monitoring intervals
2. Targeted filtering
3. Proper logging configuration
4. Resource usage monitoring
5. Backup log files
