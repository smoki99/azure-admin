# VLAN Tools - Virtual LAN Configuration

## Overview
VLAN tools in Linux allow the creation and management of Virtual LANs, enabling network segmentation and traffic isolation. Primary tools include `vconfig` (legacy) and `ip` command with VLAN support.

## Official Documentation
[Linux VLAN Documentation](https://wiki.linuxfoundation.org/networking/vlan)

## Basic Usage

### VLAN Management
```bash
# Create VLAN interface (modern method)
ip link add link eth0 name eth0.100 type vlan id 100

# Create VLAN interface (legacy method)
vconfig add eth0 100

# Delete VLAN interface
ip link delete eth0.100

# Show VLAN information
ip -d link show eth0.100
```

### VLAN Configuration
```bash
# Enable VLAN interface
ip link set eth0.100 up

# Assign IP address
ip addr add 192.168.100.1/24 dev eth0.100

# Set VLAN priority
ip link set eth0.100 type vlan egress-qos-map 0:1
```

## Cloud/Container Use Cases

### 1. Container Network Segmentation
```bash
# Create container VLAN
ip link add link docker0 name docker0.100 type vlan id 100

# Configure container network
ip addr add 172.18.100.1/24 dev docker0.100
ip link set docker0.100 up

# Assign to container
ip link set netns container123 dev docker0.100
```

### 2. Cloud Network Isolation
```bash
# Create cloud tenant VLAN
ip link add link eth0 name tenant100 type vlan id 100

# Configure cloud network
ip addr add 10.100.0.1/24 dev tenant100
ip link set tenant100 up

# Set QoS for cloud traffic
ip link set tenant100 type vlan egress-qos-map 0:5
```

### 3. Service Segmentation
```bash
# Create service VLANs
ip link add link eth0 name frontend type vlan id 10
ip link add link eth0 name backend type vlan id 20

# Configure services
ip addr add 192.168.10.1/24 dev frontend
ip addr add 192.168.20.1/24 dev backend
```

## Advanced Features

### 1. QoS Configuration
```bash
# Set ingress QoS
ip link set eth0.100 type vlan ingress-qos-map 0:1

# Set egress QoS
ip link set eth0.100 type vlan egress-qos-map 0:1

# Configure priority
ip link set eth0.100 type vlan egress-qos-map 1:2 2:3 3:4
```

### 2. VLAN Filtering
```bash
# Create VLAN filter
bridge vlan add vid 100 dev eth0

# Add VLAN range
bridge vlan add vid 100-200 dev eth0

# Set PVID
bridge vlan add vid 100 pvid dev eth0
```

### 3. Advanced Routing
```bash
# Policy routing for VLAN
ip rule add from 192.168.100.0/24 table 100

# VLAN specific route
ip route add 10.0.0.0/8 via 192.168.100.254 table 100

# Source routing
ip route add default via 192.168.100.1 table 100
```

## Best Practices

### 1. VLAN Creation
```bash
# Create VLAN with best practices
ip link add link eth0 name eth0.100 type vlan id 100
ip link set eth0.100 up
ip addr add 192.168.100.1/24 dev eth0.100
ip link set eth0.100 mtu 1500
```

### 2. Security
```bash
# Isolate VLAN traffic
iptables -A FORWARD -i eth0.100 -o eth0.200 -j DROP

# Configure VLAN filtering
bridge vlan add vid 100 dev eth0 pvid untagged

# Set access restrictions
ip link set eth0.100 promisc off
```

### 3. Performance
```bash
# Optimize MTU
ip link set eth0.100 mtu 9000

# Configure multiqueue
ethtool -L eth0 combined 4

# Set TX queue length
ip link set eth0.100 txqueuelen 10000
```

## Common Scenarios

### 1. Multi-tenant Setup
```bash
# Create tenant VLANs
ip link add link eth0 name tenant1 type vlan id 100
ip link add link eth0 name tenant2 type vlan id 200

# Configure isolation
iptables -A FORWARD -i tenant1 -o tenant2 -j DROP
iptables -A FORWARD -i tenant2 -o tenant1 -j DROP
```

### 2. Service Deployment
```bash
# Web service VLAN
ip link add link eth0 name web type vlan id 10
ip addr add 192.168.10.1/24 dev web

# Database VLAN
ip link add link eth0 name db type vlan id 20
ip addr add 192.168.20.1/24 dev db
```

### 3. Network Segmentation
```bash
# Create department VLANs
ip link add link eth0 name hr type vlan id 100
ip link add link eth0 name it type vlan id 200
ip link add link eth0 name finance type vlan id 300
```

## Integration Examples

### 1. With Container Platforms
```bash
# Docker VLAN setup
ip link add link docker0 name docker0.100 type vlan id 100
ip addr add 172.18.100.1/24 dev docker0.100

# Kubernetes VLAN
ip link add link cni0 name cni0.100 type vlan id 100
ip addr add 10.244.100.1/24 dev cni0.100
```

### 2. With Cloud Infrastructure
```bash
# Cloud provider VLAN
ip link add link eth0 name cloud100 type vlan id 100
ip addr add 10.100.0.1/24 dev cloud100

# Tenant isolation
iptables -A FORWARD -i cloud100 -o cloud200 -j DROP
```

### 3. With Virtual Machines
```bash
# VM network VLAN
ip link add link br0 name vm100 type vlan id 100
brctl addif br-vm vm100

# Storage network VLAN
ip link add link br0 name storage type vlan id 200
```

## Troubleshooting

### Common Issues
1. VLAN creation fails
   ```bash
   # Check kernel support
   zcat /proc/config.gz | grep VLAN
   
   # Verify interface status
   ip link show eth0
   
   # Load VLAN module
   modprobe 8021q
   ```

2. Connectivity issues
   ```bash
   # Check VLAN interface
   ip -d link show eth0.100
   
   # Verify routing
   ip route show table 100
   
   # Test VLAN connectivity
   ping -I eth0.100 192.168.100.2
   ```

3. Performance problems
   ```bash
   # Check interface statistics
   ip -s link show eth0.100
   
   # Monitor traffic
   iftop -i eth0.100
   
   # Verify QoS settings
   ip -d link show eth0.100
   ```

### Best Practices
1. Document VLAN configurations
2. Use consistent naming conventions
3. Implement proper security measures
4. Monitor VLAN performance
5. Regular maintenance and cleanup
