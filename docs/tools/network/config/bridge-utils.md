# bridge-utils - Network Bridge Management Tools

## Overview
`bridge-utils` provides tools for configuring network bridges in Linux, which is essential for container networking, virtual machines, and software-defined networking. The main command is `brctl`.

## Official Documentation
[bridge-utils Manual](https://wiki.linuxfoundation.org/networking/bridge)

## Basic Usage

### Bridge Management
```bash
# List bridges
brctl show

# Create bridge
brctl addbr br0

# Delete bridge
brctl delbr br0

# Add interface to bridge
brctl addif br0 eth0
```

### Bridge Configuration
```bash
# Set spanning tree protocol
brctl stp br0 on

# Set bridge priority
brctl setbridgeprio br0 32768

# Set bridge forward delay
brctl setfd br0 15
```

## Cloud/Container Use Cases

### 1. Container Networking
```bash
# Create container bridge
brctl addbr docker0

# Configure container bridge
brctl setfd docker0 0
brctl stp docker0 off

# Add container interface
brctl addif docker0 veth123
```

### 2. Virtual Machine Networking
```bash
# Create VM bridge
brctl addbr br-vm

# Add physical interface
brctl addif br-vm eth0

# Configure for VMs
brctl stp br-vm on
brctl setfd br-vm 15
```

### 3. Network Isolation
```bash
# Create isolated network
brctl addbr br-isolated

# Configure isolation
brctl setageing br-isolated 0
brctl stp br-isolated off

# Add specific interfaces
brctl addif br-isolated eth1
```

## Advanced Features

### 1. Bridge Configuration
```bash
# Set aging time
brctl setageing br0 300

# Set hello time
brctl sethello br0 2

# Set max age
brctl setmaxage br0 20
```

### 2. Port Management
```bash
# Set port priority
brctl setportprio br0 eth0 128

# Set path cost
brctl setpathcost br0 eth0 100

# Show port details
brctl showstp br0
```

### 3. STP Configuration
```bash
# Enable STP
brctl stp br0 on

# Set bridge priority
brctl setbridgeprio br0 32768

# Set forwarding delay
brctl setfd br0 15
```

## Best Practices

### 1. Bridge Creation
```bash
# Create bridge with best practices
brctl addbr br0
brctl stp br0 on
brctl setfd br0 15
ip link set br0 up
```

### 2. Security
```bash
# Isolate bridge
brctl setageing br-isolated 0
brctl stp br-isolated off

# Control forwarding
ebtables -A FORWARD -i br-isolated -j DROP
```

### 3. Performance
```bash
# Optimize for containers
brctl setfd docker0 0
brctl stp docker0 off
brctl setageing docker0 300
```

## Common Scenarios

### 1. Container Setup
```bash
# Setup container bridge
brctl addbr docker0
ip addr add 172.17.0.1/16 dev docker0
ip link set docker0 up

# Add container interface
brctl addif docker0 veth1234
```

### 2. Virtual Machine Setup
```bash
# Create VM network
brctl addbr br-vm
ip link set br-vm up
brctl addif br-vm eth0
brctl stp br-vm on
```

### 3. Network Segmentation
```bash
# Create isolated networks
brctl addbr br-prod
brctl addbr br-dev

# Configure isolation
brctl stp br-prod on
brctl stp br-dev on
```

## Integration Examples

### 1. With Container Platforms
```bash
# Docker bridge setup
brctl addbr docker0
ip addr add 172.17.0.1/16 dev docker0
ip link set docker0 up

# Kubernetes CNI bridge
brctl addbr cni0
ip addr add 10.244.0.1/16 dev cni0
ip link set cni0 up
```

### 2. With Virtual Machines
```bash
# KVM bridge setup
brctl addbr br-kvm
brctl addif br-kvm eth0
ip link set br-kvm up

# Configure for VM traffic
brctl stp br-kvm on
brctl setfd br-kvm 15
```

### 3. With Cloud Networks
```bash
# Cloud network bridge
brctl addbr br-cloud
ip link set br-cloud up

# Configure for cloud
brctl stp br-cloud on
brctl setfd br-cloud 0
```

## Troubleshooting

### Common Issues
1. Bridge creation fails
   ```bash
   # Check existing bridges
   brctl show
   
   # Verify interface status
   ip link show
   
   # Check for name conflicts
   ip addr show
   ```

2. Interface addition fails
   ```bash
   # Check interface exists
   ip link show eth0
   
   # Verify interface status
   ip link set eth0 up
   
   # Remove from other bridges
   brctl delif other-bridge eth0
   ```

3. Network connectivity issues
   ```bash
   # Check bridge status
   brctl showstp br0
   
   # Verify forwarding
   cat /proc/sys/net/bridge/bridge-nf-call-iptables
   
   # Check bridge MAC table
   brctl showmacs br0
   ```

### Best Practices
1. Document bridge configurations
2. Monitor bridge status
3. Regular cleanup of unused bridges
4. Proper security configuration
5. Performance optimization
