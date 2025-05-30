# drill

## Overview

drill is a powerful DNS debugging tool designed as a successor to dig. It provides detailed DNS query capabilities, DNSSEC validation, and trace functionality, making it ideal for troubleshooting DNS issues in cloud environments.

## Official Documentation
- [LDNS Documentation](https://www.nlnetlabs.nl/documentation/ldns/)
- [Man Page](https://linux.die.net/man/1/drill)

## Key Features
- DNS lookup and debugging
- DNSSEC validation
- Trace functionality
- Zone transfer support
- Multiple query types
- Chase functionality
- Detailed error reporting
- Custom DNS port support

## Basic Usage

### Simple Queries
```bash
# Basic DNS lookup
drill example.com

# Specify record type
drill A example.com

# Use specific nameserver
drill example.com @8.8.8.8

# Reverse lookup
drill -x 1.1.1.1
```

### Advanced Options
```bash
# DNSSEC validation
drill -D example.com

# Trace query path
drill -T example.com

# Zone transfer
drill -a example.com

# Chase DNSSEC records
drill -S example.com
```

## Cloud/Container Use Cases

### 1. Azure DNS Debugging

Debug Azure DNS configurations:

```bash
# Query Azure DNS server
drill myapp.azurewebsites.net @168.63.129.16

# Check Azure Private DNS
drill myservice.internal @10.0.0.10

# Test custom domain
drill custom.domain.com A @168.63.129.16

# Verify Azure DNS records
drill -T myapp.azurewebsites.net
```

### 2. Kubernetes DNS

Debug Kubernetes DNS resolution:

```bash
# Check service DNS
drill service-name.namespace.svc.cluster.local

# Verify pod DNS
drill pod-ip.namespace.pod.cluster.local

# Test external service
drill external-service.com @kube-dns.kube-system

# Debug DNS policy
drill -T service-name.namespace.svc.cluster.local
```

### 3. Multi-Zone DNS

Work with multiple DNS zones:

```bash
# Check different zones
drill app1.internal @zone1-dns
drill app2.internal @zone2-dns

# Compare nameservers
drill NS example.com @ns1.example.com
drill NS example.com @ns2.example.com

# Test zone transfers
drill -a example.com @primary-ns
```

## Common Scenarios

### 1. DNS Resolution Issues
```bash
# Check DNS chain
drill -T example.com

# Verify all records
drill ANY example.com

# Test multiple nameservers
for ns in ns1 ns2 ns3; do
  drill example.com @$ns.example.com
done
```

### 2. DNSSEC Validation
```bash
# Check DNSSEC
drill -D example.com

# Verify chain of trust
drill -S example.com

# Test key validation
drill -T -D example.com
```

### 3. Email Configuration
```bash
# Check mail records
drill MX example.com

# Verify SPF
drill TXT example.com

# Test DMARC
drill TXT _dmarc.example.com
```

## Azure-Specific Features

### 1. Private DNS Zones
```bash
# Query private zone
drill myapp.internal @private-dns

# Check service endpoints
drill -p 53 service.internal @private-dns

# Test zone transfers
drill -a internal @private-dns
```

### 2. Traffic Manager
```bash
# Check routing
drill myapp.trafficmanager.net

# Verify endpoints
drill -T myapp.trafficmanager.net

# Test regional routing
for region in westus eastus; do
  drill myapp.trafficmanager.net @$region-dns
done
```

### 3. Service Resolution
```bash
# Check App Service
drill webapp.azurewebsites.net

# Verify SQL endpoints
drill database.database.windows.net

# Test custom domains
drill custom.domain.com CNAME
```

## Best Practices

### 1. Troubleshooting
```bash
# Comprehensive check
drill -TD example.com

# Compare nameservers
for ns in $(drill NS example.com | grep IN | awk '{print $5}'); do
  echo "Testing $ns..."
  drill example.com @$ns
done

# Debug routing
drill -T example.com > trace.log
```

### 2. Security
```bash
# DNSSEC validation
drill -DS example.com

# Check security records
drill CAA example.com

# Verify TLS records
drill TLSA _443._tcp.example.com
```

### 3. Performance
```bash
# Test response times
time drill example.com

# Check closest nameserver
drill -T example.com | grep "Received"

# Verify anycast
drill example.com @anycast-dns
```

## Integration Examples

### 1. DNS Monitoring Script
```bash
#!/bin/bash
# DNS resolution monitoring

check_dns() {
  local domain=$1
  local record=${2:-A}
  local nameserver=${3:-@8.8.8.8}
  
  drill $record $domain $nameserver
}

# Monitor critical domains
while true; do
  check_dns example.com A
  check_dns example.com MX
  sleep 300
done
```

### 2. Azure DNS Validation
```bash
#!/bin/bash
# Azure DNS verification

verify_azure_dns() {
  local resource=$1
  
  echo "Checking $resource..."
  drill $resource @168.63.129.16
  drill -T $resource
}

# Test Azure services
verify_azure_dns "myapp.azurewebsites.net"
verify_azure_dns "mydatabase.database.windows.net"
```

### 3. Kubernetes DNS Debug
```bash
#!/bin/bash
# Kubernetes DNS troubleshooting

debug_kube_dns() {
  local service=$1
  local namespace=${2:-default}
  local cluster_domain=${3:-cluster.local}
  
  local fqdn="$service.$namespace.svc.$cluster_domain"
  
  echo "Testing $fqdn..."
  drill $fqdn
  drill -T $fqdn
  drill SRV $fqdn
}

# Debug services
debug_kube_dns "api-service"
debug_kube_dns "database" "backend"
