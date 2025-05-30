# bind9-dnsutils - BIND9 DNS Utilities

## Overview
`bind9-dnsutils` provides additional DNS utilities from the BIND9 suite, including `host`, `delv`, and other specialized DNS tools. These tools complement the standard dnsutils package with more advanced DNS investigation capabilities.

## Official Documentation
[BIND9 Documentation](https://bind9.readthedocs.io/)

## Basic Usage

### host Command
```bash
# Simple lookup
host example.com

# Reverse lookup
host 192.168.1.1

# Query specific record type
host -t MX example.com
```

### delv Command
```bash
# DNSSEC lookup
delv example.com

# Trace DNSSEC chain
delv +trace example.com

# Query specific type
delv +qtypes=MX example.com
```

## Cloud/Container Use Cases

### 1. Container DNS Verification
```bash
# Check container DNS
host container.local

# Verify service discovery
host -t SRV _service._tcp.local

# Test internal DNS
host -v service.namespace.svc.cluster.local
```

### 2. DNSSEC Validation
```bash
# Verify DNSSEC chain
delv +vtrace example.com

# Check trust anchors
delv +root example.com

# Validate signatures
delv +cdflag example.com
```

### 3. Service Discovery
```bash
# Find services
host -t SRV _http._tcp.service.consul

# Check load balancer
host -t A lb.example.com

# Verify cloud endpoints
host service.region.cloudapp.azure.com
```

## Advanced Features

### 1. DNSSEC Analysis
```bash
# Check signature
delv +dnssec example.com

# Validate chain
delv +vtrace example.com

# Show trust anchors
delv +trust example.com
```

### 2. Record Analysis
```bash
# Verbose output
host -v example.com

# Check all records
host -a example.com

# Show TTL
host -l example.com
```

### 3. Debug Options
```bash
# Debug mode
host -d example.com

# Trace resolution
delv +trace example.com

# Show timing
host -t example.com
```

## Best Practices

### 1. DNS Validation
```bash
# Check authoritative servers
host -t NS example.com

# Verify DNSSEC
delv +dnssec example.com

# Test recursion
host -r example.com
```

### 2. Service Checks
```bash
# Test mail configuration
host -t MX example.com

# Verify SPF
host -t TXT example.com

# Check service records
host -t SRV _service._proto.example.com
```

### 3. Troubleshooting
```bash
# Debug resolution
host -d example.com

# Check reverse DNS
host -t PTR ip.address.in-addr.arpa

# Verify DNSSEC chain
delv +vtrace example.com
```

## Common Scenarios

### 1. DNS Health Checks
```bash
# Check nameservers
host -t NS example.com

# Verify mail setup
host -t MX example.com

# Test reverse DNS
host ip-address
```

### 2. Security Verification
```bash
# Check DNSSEC
delv +dnssec example.com

# Verify SPF
host -t TXT example.com

# Check DMARC
host -t TXT _dmarc.example.com
```

### 3. Service Validation
```bash
# Test service discovery
host -t SRV _service._tcp.example.com

# Check load balancing
for i in {1..5}; do host example.com; done

# Verify failover
host -t A failover.example.com
```

## Integration Examples

### 1. With Container Platforms
```bash
# Kubernetes service discovery
host service.namespace.svc.cluster.local

# Docker DNS check
host container.docker.internal

# Consul service lookup
host service.consul
```

### 2. With Cloud Services
```bash
# Azure DNS
host service.azurewebsites.net

# AWS Route53
host service.amazonaws.com

# GCP DNS
host -t A service.googleapis.com
```

### 3. With Monitoring
```bash
# Response time check
time host example.com

# Continuous monitoring
while true; do host example.com; sleep 300; done

# Record changes
host -a example.com > dns-record.log
```

## Troubleshooting

### Common Issues
1. Resolution failures
   ```bash
   # Debug resolution
   host -d example.com
   
   # Check nameservers
   host -t NS example.com
   
   # Verify records
   host -a example.com
   ```

2. DNSSEC problems
   ```bash
   # Check DNSSEC chain
   delv +vtrace example.com
   
   # Validate signatures
   delv +dnssec example.com
   
   # Test trust anchors
   delv +root example.com
   ```

3. Service issues
   ```bash
   # Check SRV records
   host -t SRV _service._proto.example.com
   
   # Verify aliases
   host -t CNAME service.example.com
   
   # Test load balancing
   host -v loadbalancer.example.com
   ```

### Best Practices
1. Regular checks
   ```bash
   # Health check script
   for type in A MX NS TXT; do
     host -t $type example.com
   done
   
   # DNSSEC validation
   delv +dnssec example.com
   ```

2. Security verification
   ```bash
   # Check DNSSEC
   delv +vtrace example.com
   
   # Verify SPF/DMARC
   host -t TXT example.com
   ```

3. Performance monitoring
   ```bash
   # Response time
   time host example.com
   
   # Continuous testing
   while true; do
     host example.com
     sleep 60
   done
