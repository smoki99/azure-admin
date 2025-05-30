# dnsutils - DNS Lookup Utilities

## Overview
`dnsutils` is a collection of DNS lookup utilities, including the essential tools `dig`, `nslookup`, and `host`. These tools are crucial for DNS querying, troubleshooting, and domain name resolution in cloud environments.

## Official Documentation
[BIND 9 Documentation](https://bind9.readthedocs.io/)

## Basic Usage

### 1. dig (Domain Information Groper)
```bash
# Simple DNS lookup
dig example.com

# Query specific record type
dig example.com MX
dig example.com NS
dig example.com A

# Use specific DNS server
dig @8.8.8.8 example.com

# Reverse DNS lookup
dig -x 8.8.8.8
```

### 2. nslookup
```bash
# Basic lookup
nslookup example.com

# Query specific DNS server
nslookup example.com 8.8.8.8

# Set record type
nslookup -type=MX example.com
nslookup -type=NS example.com

# Interactive mode
nslookup
> server 8.8.8.8
> example.com
```

### 3. host
```bash
# Basic lookup
host example.com

# Verbose output
host -v example.com

# Query specific record type
host -t MX example.com
host -t NS example.com

# Reverse lookup
host 8.8.8.8
```

## Cloud/Container Use Cases

### 1. Azure DNS Verification
```bash
# Verify Azure DNS records
dig @168.63.129.16 myapp.azurewebsites.net

# Check Azure Private DNS
dig @10.0.0.10 myservice.internal +search

# Validate Custom Domains
dig myapp.example.com NS
```

### 2. Kubernetes DNS
```bash
# Check service DNS
dig @10.96.0.10 kubernetes.default.svc.cluster.local

# Verify pod DNS resolution
dig mysql.default.svc.cluster.local

# Debug CoreDNS
dig @10.96.0.10 kubernetes.default.svc.cluster.local +trace
```

### 3. Container DNS Resolution
```bash
# Check container DNS
dig @127.0.0.11 container-name

# Verify network DNS
dig @dns-server service-name.namespace.svc.cluster.local

# Debug service discovery
dig +search service-name
```

## Advanced Features

### 1. Trace DNS Resolution
```bash
# Full resolution trace
dig +trace example.com

# Show TTL values
dig +ttlid example.com

# Show timing information
dig +stats example.com
```

### 2. DNSSEC Validation
```bash
# Check DNSSEC
dig +dnssec example.com

# Validate signatures
dig +sigchase example.com

# Check DNSKEY records
dig +multiline DNSKEY example.com
```

### 3. Batch Processing
```bash
# Query multiple records
dig +short example.com MX NS A

# Read queries from file
dig -f queries.txt

# Output in batch format
dig +noall +answer example.com MX NS A
```

## Best Practices

### 1. Performance Optimization
```bash
# Use +short for brief output
dig +short example.com

# Minimize query traffic
dig +norecurse example.com

# Cache results
dig +ttlid example.com
```

### 2. Troubleshooting
```bash
# Debug query path
dig +trace example.com

# Check response timing
dig +stats example.com

# Verify authority
dig +nssearch example.com
```

### 3. Security Checks
```bash
# Verify DNSSEC
dig +dnssec example.com

# Check for AXFR
dig +norecurse AXFR example.com

# Validate SPF records
dig TXT example.com
```

## Common Scenarios

### 1. DNS Migration
```bash
# Compare authoritative servers
dig +nssearch old-domain.com
dig +nssearch new-domain.com

# Verify record propagation
dig @ns1.old-domain.com example.com
dig @ns1.new-domain.com example.com
```

### 2. Cloud Service Validation
```bash
# Check Azure endpoints
dig myapp.azurewebsites.net
dig mystorage.blob.core.windows.net

# Verify custom domains
dig CNAME www.example.com
dig A example.com
```

### 3. Email Configuration
```bash
# Check mail records
dig MX example.com
dig TXT example.com  # SPF records
dig _dmarc.example.com TXT
```

## Troubleshooting

### Common Issues
1. Resolution Failures
   ```bash
   # Check DNS server connectivity
   dig +retry=1 example.com

   # Verify DNS server settings
   dig +trace example.com
   ```

2. DNSSEC Problems
   ```bash
   # Validate DNSSEC chain
   dig +dnssec +cd example.com

   # Check signature expiration
   dig +dnssec +cd DNSKEY example.com
   ```

3. Propagation Issues
   ```bash
   # Check multiple nameservers
   dig @ns1.example.com example.com
   dig @ns2.example.com example.com
   ```

### Integration Tips
1. Azure Integration
   ```bash
   # Check Azure DNS
   dig @168.63.129.16 myapp.azurewebsites.net

   # Verify Private DNS
   dig +search privateservice.internal
   ```

2. Kubernetes Integration
   ```bash
   # Debug service DNS
   dig @10.96.0.10 service.namespace.svc.cluster.local

   # Check pod DNS
   dig +search podname.namespace.pod.cluster.local
   ```

3. Container DNS
   ```bash
   # Verify container resolution
   dig @127.0.0.11 container-name

   # Check network DNS
   dig +search service-name
