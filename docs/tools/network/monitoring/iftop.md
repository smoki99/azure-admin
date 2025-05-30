# iftop - Network Bandwidth Monitoring Tool

## Overview
`iftop` monitors bandwidth usage on an interface and displays a table of current bandwidth usage by pairs of hosts. It's particularly useful for monitoring container and service network traffic in real-time.

## Official Documentation
[iftop Manual](https://linux.die.net/man/8/iftop)

## Basic Usage

### Interface Monitoring
```bash
# Monitor default interface
iftop

# Monitor specific interface
iftop -i eth0

# Monitor container interface
iftop -i docker0
```

### Display Options
```bash
# Show port numbers
iftop -P

# Show hostnames
iftop -n

# Show port names
iftop -N
```

## Cloud/Container Use Cases

### 1. Container Network Monitoring
```bash
# Monitor container traffic
iftop -i docker0

# Watch Kubernetes pod network
iftop -i cni0

# Check service mesh traffic
iftop -i istio-proxy
```

### 2. Service Analysis
```bash
# Monitor service ports
iftop -P -f "port 80 or port 443"

# Watch database traffic
iftop -f "port 5432"

# Monitor microservices
iftop -f "port range 8000-8100"
```

### 3. Cloud Connectivity
```bash
# Monitor VPN traffic
iftop -i tun0

# Watch Azure ExpressRoute
iftop -i azure-er

# Check load balancer traffic
iftop -i eth0 -f "port 80"
```

## Advanced Features

### 1. Traffic Filtering
```bash
# Filter by host
iftop -f "host 10.0.0.1"

# Filter by port
iftop -f "port 80"

# Complex filters
iftop -f "not port 22 and host 10.0.0.1"
```

### 2. Display Control
```bash
# Show bytes
iftop -B

# Show packets
iftop -p

# Show direction arrows
iftop -t
```

### 3. Output Options
```bash
# Text output
iftop -t -s 1 

# No DNS resolution
iftop -n

# Show total bandwidth
iftop -L 0
```

## Best Practices

### 1. Performance Monitoring
```bash
# Monitor service traffic
iftop -P -f "port 80"

# Check bandwidth limits
iftop -L 100M

# Watch specific hosts
iftop -f "host 10.0.0.1 or host 10.0.0.2"
```

### 2. Troubleshooting
```bash
# Debug high traffic
iftop -P -B

# Find noisy neighbors
iftop -n -P

# Check for anomalies
iftop -t -L 0
```

### 3. Resource Management
```bash
# Monitor bandwidth usage
iftop -B -L 100M

# Track service traffic
iftop -P -f "net 10.0.0.0/24"

# Watch container networks
iftop -i docker0 -P
```

## Common Scenarios

### 1. Container Monitoring
```bash
# Watch container traffic
iftop -i docker0 -P

# Monitor pod network
iftop -i cni0 -f "net 10.244.0.0/16"

# Check service mesh
iftop -i istio-proxy -P
```

### 2. Service Analysis
```bash
# Web traffic
iftop -P -f "port 80 or port 443"

# Database connections
iftop -P -f "port 3306 or port 5432"

# API monitoring
iftop -P -f "port 8080"
```

### 3. Network Debugging
```bash
# Find bandwidth issues
iftop -B -L 100M

# Track connection spikes
iftop -t -s 1

# Monitor specific hosts
iftop -n -f "host problematic-host"
```

## Integration Examples

### 1. With Container Tools
```bash
# Monitor container network
podman run -it --net=host iftop -i docker0

# Track Kubernetes networking
iftop -i $(kubectl get nodes -o jsonpath='{.items[0].spec.podCIDR}')
```

### 2. With Monitoring Tools
```bash
# Save statistics
iftop -t -s 10 > bandwidth.log

# Alert on high usage
iftop -t -L 100M | grep "exceeds"

# Generate reports
iftop -t -s 3600 | awk '/bandwidth/{print}'
```

### 3. With Cloud Tools
```bash
# Monitor Azure traffic
iftop -i azure0

# Watch cloud connectivity
iftop -i vpn0

# Check service endpoints
iftop -P -f "net 10.0.0.0/8"
```

## Troubleshooting

### Common Issues
1. Permission problems
   ```bash
   # Run with sudo
   sudo iftop -i eth0
   
   # Add capabilities
   setcap cap_net_raw+ep /usr/bin/iftop
   ```

2. Interface not found
   ```bash
   # List interfaces
   ip link show
   
   # Check interface status
   ifconfig -a
   ```

3. High CPU usage
   ```bash
   # Reduce refresh rate
   iftop -t -s 2
   
   # Limit DNS lookups
   iftop -n
   ```

### Best Practices
1. Monitor appropriate interfaces
2. Use filtering effectively
3. Consider DNS resolution impact
4. Watch resource usage
5. Keep historical data
