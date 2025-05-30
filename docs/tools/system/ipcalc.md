# ipcalc - IP Network Calculator

## Overview
`ipcalc` is a command-line tool for calculating IP addressing information. It helps with network planning, subnet calculations, and CIDR notation conversions.

## Official Documentation
[ipcalc Documentation](https://gitlab.com/ipcalc/ipcalc)

## Basic Usage

### 1. Network Calculations
```bash
# Basic IP information
ipcalc 192.168.1.0/24

# Detailed subnet analysis
ipcalc -b 192.168.1.0/24

# Network address range
ipcalc -n 192.168.1.0/24
```

### 2. Subnet Operations
```bash
# Split network into subnets
ipcalc -s 32 10.0.0.0/24

# Calculate broadcast address
ipcalc -b 192.168.1.0/24

# Show network class
ipcalc -c 192.168.1.0
```

### 3. CIDR Notation
```bash
# Convert netmask to CIDR
ipcalc 192.168.1.0 255.255.255.0

# Show all CIDR information
ipcalc -i 192.168.1.0/24

# Display binary netmask
ipcalc -m 192.168.1.0/24
```

## Cloud/Container Use Cases

### 1. Azure Network Planning
```bash
# Calculate VNet address space
ipcalc 10.0.0.0/16

# Subnet division for services
ipcalc -s 16 10.0.0.0/16

# AKS pod networking
ipcalc 10.244.0.0/16
```

### 2. Container Networking
```bash
# Docker network ranges
ipcalc 172.17.0.0/16

# Kubernetes pod CIDR
ipcalc 10.244.0.0/16

# Service CIDR allocation
ipcalc 10.96.0.0/12
```

### 3. Network Segmentation
```bash
# Split network for zones
ipcalc -s 4 10.0.0.0/16

# DMZ planning
ipcalc -b 192.168.0.0/24

# Private network design
ipcalc -n 172.16.0.0/12
```

## Advanced Features

### 1. Network Information
```bash
# Detailed breakdown
ipcalc -i -b -n 192.168.1.0/24

# Host range calculation
ipcalc -h 192.168.1.0/24

# Network class details
ipcalc -c -b 192.168.1.0/24
```

### 2. Subnet Planning
```bash
# Multiple subnet division
ipcalc -s 8,16,32 10.0.0.0/16

# Equal-sized subnets
ipcalc -s 64 172.16.0.0/16

# Custom subnet masks
ipcalc -m 192.168.1.0/255.255.255.240
```

### 3. Address Analysis
```bash
# Check address type
ipcalc -t 192.168.1.1

# Reverse DNS lookup
ipcalc -r 192.168.1.0/24

# Address range info
ipcalc -a 192.168.1.0-192.168.1.255
```

## Best Practices

### 1. Network Design
```bash
# Plan hierarchical networks
ipcalc -s 4,8,16 10.0.0.0/16

# Reserve network ranges
ipcalc -s 256 192.168.0.0/16

# Document network allocation
ipcalc -n -b > network_plan.txt
```

### 2. Subnet Management
```bash
# Verify network overlap
ipcalc -c 192.168.1.0/24 192.168.0.0/16

# Calculate address capacity
ipcalc -h 10.0.0.0/24

# Plan growth capacity
ipcalc -s 2,4,8,16 172.16.0.0/16
```

### 3. IP Assignment
```bash
# Check address availability
ipcalc -n 192.168.1.0/24

# Plan DHCP ranges
ipcalc -h 192.168.1.0/24

# Static IP allocation
ipcalc -s 32 10.0.0.0/24
```

## Common Scenarios

### 1. Network Migration
```bash
# Plan address translation
ipcalc 192.168.1.0/24 10.0.0.0/24

# Capacity verification
ipcalc -h oldnet/24 newnet/22

# Overlap detection
ipcalc -c net1/24 net2/24
```

### 2. Cloud Deployment
```bash
# VPC planning
ipcalc -s 16 10.0.0.0/8

# Availability zone subnets
ipcalc -s 3 10.0.0.0/16

# Service segmentation
ipcalc -s 8 172.16.0.0/16
```

### 3. Security Zoning
```bash
# DMZ planning
ipcalc -s 8 192.168.0.0/24

# Internal segments
ipcalc -s 4 10.0.0.0/16

# Isolation zones
ipcalc -s 16 172.16.0.0/12
```

## Troubleshooting

### Common Issues
1. Address Conflicts
   ```bash
   # Check overlap
   ipcalc -c net1/24 net2/24

   # Verify ranges
   ipcalc -n net1/24 net2/24

   # Address space
   ipcalc -a range1 range2
   ```

2. Subnet Problems
   ```bash
   # Verify subnet size
   ipcalc -h subnet/24

   # Check boundaries
   ipcalc -b subnet/24

   # Network capacity
   ipcalc -n subnet/24
   ```

3. CIDR Issues
   ```bash
   # Convert notation
   ipcalc ip netmask

   # Verify CIDR
   ipcalc -i cidr

   # Check address space
   ipcalc -n cidr
   ```

### Integration Tips
1. Cloud Migration
   ```bash
   # Map address spaces
   ipcalc oldnet/16 newnet/16

   # Plan subnets
   ipcalc -s zones vpc_range

   # Verify capacity
   ipcalc -h vpc_range
   ```

2. Network Documentation
   ```bash
   # Generate topology
   ipcalc -n network > topology.txt

   # Document subnets
   ipcalc -s divisions network

   # Address allocation
   ipcalc -h network > allocation.txt
   ```

3. Automation Support
   ```bash
   # Script-friendly output
   ipcalc -n network | grep "Network:"

   # Range extraction
   ipcalc -b network | grep "Broadcast:"

   # Host counting
   ipcalc -h network | grep "Hosts/Net:"
