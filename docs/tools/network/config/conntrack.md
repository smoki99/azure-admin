# conntrack - Connection Tracking Tool

## Overview
`conntrack` is a userspace tool that interfaces with the Linux kernel's netfilter connection tracking system. It's essential for managing, inspecting, and manipulating network connection states, particularly in NAT and firewall environments.

## Official Documentation
[conntrack Documentation](https://conntrack-tools.netfilter.org/)

## Basic Usage

### View Connections
```bash
# Show all connections
conntrack -L

# Show connections in real-time
conntrack -E

# Show connection count
conntrack -C
```

### Connection Management
```bash
# Delete all connections
conntrack -F

# Delete specific protocol
conntrack -D -p tcp

# Delete by source
conntrack -D -s 192.168.1.100
```

## Cloud/Container Use Cases

### 1. Container Network Tracking
```bash
# Monitor container connections
conntrack -E -s 172.17.0.0/16

# Clear container connections
conntrack -D -s 172.17.0.0/16

# Track NAT sessions
conntrack -E -n nat
```

### 2. Kubernetes Connection Management
```bash
# Monitor service connections
conntrack -E -d 10.96.0.0/16

# Clear service entries
conntrack -D -d 10.96.0.0/16

# Track pod connections
conntrack -E -s 10.244.0.0/16
```

### 3. Load Balancer Tracking
```bash
# Monitor load balancer
conntrack -E --state ESTABLISHED

# Clear stale connections
conntrack -D --state TIME_WAIT

# Track NAT translations
conntrack -E -n nat --orig-src 10.0.0.0/8
```

## Advanced Features

### 1. Connection Filtering
```bash
# Filter by protocol
conntrack -L -p tcp

# Filter by state
conntrack -L --state ESTABLISHED

# Filter by service
conntrack -L --dport 80
```

### 2. Connection Statistics
```bash
# Show statistics
conntrack -S

# Monitor events
conntrack -E -e NEW,DESTROYED

# Count by protocol
conntrack -C -p tcp
```

### 3. NAT Tracking
```bash
# Show NAT connections
conntrack -L -n nat

# Monitor NAT events
conntrack -E -n nat

# Clear NAT entries
conntrack -F -n nat
```

## Best Practices

### 1. Performance Management
```bash
# Tune connection tracking
sysctl -w net.netfilter.nf_conntrack_max=131072

# Configure timeouts
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=7200

# Monitor table usage
watch -n1 'cat /proc/sys/net/netfilter/nf_conntrack_count'
```

### 2. Security
```bash
# Track suspicious connections
conntrack -E --state NEW -p tcp --dport 22

# Monitor connection attempts
conntrack -E --state SYN_SENT

# Track rejected connections
conntrack -E --state INVALID
```

### 3. Maintenance
```bash
# Regular cleanup
conntrack -F --state TIME_WAIT

# Remove idle connections
conntrack -D --state ESTABLISHED --timeout 3600

# Clear specific service
conntrack -D -p tcp --dport 80
```

## Common Scenarios

### 1. Troubleshooting
```bash
# Check connection state
conntrack -L --src 192.168.1.100

# Monitor new connections
conntrack -E --state NEW

# Track connection timeouts
conntrack -E --state CLOSE
```

### 2. Service Monitoring
```bash
# Web server connections
conntrack -L -p tcp --dport 80

# Database connections
conntrack -L -p tcp --dport 5432

# Mail server tracking
conntrack -L -p tcp --dport 25
```

### 3. Network Debugging
```bash
# Track connection failures
conntrack -E --state INVALID

# Monitor connection resets
conntrack -E --state CLOSE

# Check NAT issues
conntrack -E -n nat --orig-src 192.168.0.0/24
```

## Integration Examples

### 1. With Container Platforms
```bash
# Docker connection tracking
conntrack -E -s 172.17.0.0/16 --state NEW

# Kubernetes service tracking
conntrack -E -d 10.96.0.0/16 --state ESTABLISHED

# Clear container connections
conntrack -D -s 172.17.0.0/16 --state TIME_WAIT
```

### 2. With Load Balancers
```bash
# Monitor load balancer NAT
conntrack -E -n nat --orig-dst 10.0.0.100

# Track backend connections
conntrack -L --dst 192.168.0.0/24 --state ESTABLISHED

# Clear stale sessions
conntrack -D --state TIME_WAIT --orig-dst 10.0.0.100
```

### 3. With Firewalls
```bash
# Track firewall states
conntrack -E --state NEW,INVALID

# Monitor blocked connections
conntrack -E --state INVALID -p tcp

# Clear blocked states
conntrack -D --state INVALID
```

## Troubleshooting

### Common Issues
1. Table full errors
   ```bash
   # Check table usage
   cat /proc/sys/net/netfilter/nf_conntrack_count
   
   # Increase table size
   sysctl -w net.netfilter.nf_conntrack_max=262144
   ```

2. Connection tracking issues
   ```bash
   # Check connection state
   conntrack -L --src 192.168.1.100
   
   # Monitor state changes
   conntrack -E --src 192.168.1.100
   ```

3. Performance problems
   ```bash
   # Monitor table usage
   watch -n1 'cat /proc/sys/net/netfilter/nf_conntrack_count'
   
   # Check memory usage
   conntrack -S
   ```

### Best Practices
1. Regular monitoring
   ```bash
   # Monitor table usage
   watch -n1 'conntrack -C'
   
   # Track new connections
   conntrack -E --state NEW
   ```

2. Maintenance tasks
   ```bash
   # Regular cleanup
   conntrack -F --state TIME_WAIT
   
   # Remove idle connections
   conntrack -D --state ESTABLISHED --timeout 3600
   ```

3. Performance tuning
   ```bash
   # Optimize settings
   sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=3600
   sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
