# dog

## Overview

dog is a modern DNS client tool designed as a more user-friendly alternative to dig. It provides colorized output, JSON support, and better readability, making it ideal for DNS troubleshooting and debugging in cloud environments.

## Official Documentation
- [Dog GitHub](https://github.com/ogham/dog)
- [Dog Manual](https://dns.lookup.dog/)

## Key Features
- Human-friendly output
- JSON output support
- Multiple query types
- DNSSEC validation
- TLS support
- Color-coded responses
- Batch query support
- Transport protocol selection

## Basic Usage

### Simple Queries
```bash
# Basic DNS lookup
dog example.com

# Specify record type
dog A example.com

# Multiple record types
dog example.com A MX NS

# Short output
dog --short example.com
```

### Advanced Options
```bash
# JSON output
dog --json example.com

# Use specific nameserver
dog @8.8.8.8 example.com

# DNSSEC validation
dog +dnssec example.com

# Reverse DNS lookup
dog -x 1.1.1.1
```

## Cloud/Container Use Cases

### 1. Azure DNS Troubleshooting

Debug Azure DNS issues:

```bash
# Query Azure DNS
dog @168.63.129.16 myapp.azurewebsites.net

# Check Azure Private DNS
dog @10.0.0.10 myservice.internal

# Verify Azure DNS records
dog --json myapp.azurewebsites.net > dns_check.json

# Test custom domains
dog @168.63.129.16 mycustomdomain.com A CNAME
```

### 2. Kubernetes Service Discovery

Debug Kubernetes DNS:

```bash
# Check service DNS
dog my-service.default.svc.cluster.local

# Verify pod DNS
dog pod-ip-addr.default.pod.cluster.local

# Check external service
dog @kube-dns.kube-system my-external-service.com

# Test DNS policy
dog --json \
  my-service.default.svc.cluster.local \
  > service_dns.json
```

### 3. Multi-Region DNS

Test DNS resolution across regions:

```bash
# Check different regions
dog @westus-dns myapp.azurewebsites.net
dog @eastus-dns myapp.azurewebsites.net

# Compare responses
dog --json @westus-dns myapp.azurewebsites.net > west.json
dog --json @eastus-dns myapp.azurewebsites.net > east.json

# Test global endpoints
dog @8.8.8.8 myapp.trafficmanager.net
```

## Common Scenarios

### 1. DNS Resolution Issues
```bash
# Check all record types
dog ANY example.com

# Verify nameserver
dog NS example.com

# Test alternate nameservers
dog @1.1.1.1 example.com
dog @8.8.8.8 example.com
```

### 2. Email Configuration
```bash
# Check mail records
dog example.com MX

# Verify SPF
dog example.com TXT

# Check DMARC
dog _dmarc.example.com TXT
```

### 3. Security Validation
```bash
# Check DNSSEC
dog +dnssec example.com

# Verify CAA records
dog example.com CAA

# Check security policies
dog example.com TXT
```

## Azure-Specific Features

### 1. Private DNS Zones
```bash
# Query private zone
dog @private-dns myservice.internal

# Check alias records
dog @private-dns myapp.internal ALIAS

# Test service endpoints
dog @private-dns database.internal SRV
```

### 2. Traffic Manager
```bash
# Check Traffic Manager endpoint
dog myapp.trafficmanager.net

# Verify health checks
dog -t A myapp.trafficmanager.net

# Test global routing
for region in westus eastus; do
  echo "Testing $region..."
  dog @$region-dns myapp.trafficmanager.net
done
```

### 3. App Service DNS
```bash
# Verify app service DNS
dog myapp.azurewebsites.net

# Check custom domain
dog customdomain.com CNAME

# Test SSL bindings
dog customdomain.com A
```

## Best Practices

### 1. Query Optimization
```bash
# Use short output for scripts
dog --short example.com

# Batch queries
dog example.com A MX TXT NS

# JSON output for parsing
dog --json example.com > results.json
```

### 2. Troubleshooting
```bash
# Test multiple nameservers
for ns in 8.8.8.8 1.1.1.1 9.9.9.9; do
  echo "Testing $ns..."
  dog @$ns example.com
done

# Debug routing
dog +trace example.com
```

### 3. Security
```bash
# Validate DNSSEC
dog +dnssec example.com

# Check TLS support
dog --tls example.com

# Verify security records
dog example.com CAA TXT
```

## Integration Examples

### 1. DNS Monitoring Script
```bash
#!/bin/bash
# Monitor DNS resolution

check_dns() {
  local domain=$1
  local record=${2:-A}
  
  dog --json $domain $record | \
    jq -r '.answers[] | .record'
}

# Monitor critical domains
while true; do
  check_dns example.com
  check_dns example.com MX
  sleep 300
done
```

### 2. Azure Integration
```bash
#!/bin/bash
# Azure DNS validation

# Check Azure resources
check_azure_dns() {
  local resource=$1
  
  dog @168.63.129.16 $resource
  dog @private-dns $resource
}

# Test Azure services
check_azure_dns "myapp.azurewebsites.net"
check_azure_dns "mydb.database.windows.net"
```

### 3. Kubernetes DNS Debug
```bash
#!/bin/bash
# Kubernetes DNS verification

# Test service discovery
check_service() {
  local service=$1
  local namespace=${2:-default}
  
  dog $service.$namespace.svc.cluster.local
}

# Check critical services
check_service "api-service"
check_service "db-service"
check_service "monitoring" "kube-system"
