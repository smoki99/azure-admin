# dnsutils - DNS Utilities Suite

## Overview
`dnsutils` is a collection of DNS client tools including `dig`, `nslookup`, and `nsupdate`. These tools are essential for DNS querying, troubleshooting, and dynamic DNS updates.

## Official Documentation
[BIND Documentation](https://www.isc.org/bind/)

## Basic Usage

### dig (Domain Information Groper)
```bash
# Simple query
dig example.com

# Query specific record type
dig example.com MX

# Query specific nameserver
dig @8.8.8.8 example.com
```

### nslookup
```bash
# Interactive mode
nslookup
> example.com

# Direct query
nslookup example.com

# Set query type
nslookup -type=MX example.com
```

### nsupdate
```bash
# Interactive update
nsupdate
> server ns1.example.com
> update add host.example.com 3600 A 192.168.1.1
> send

# Update from file
nsupdate update.txt
```

## Cloud/Container Use Cases

### 1. Service Discovery
```bash
# Find service endpoints
dig SRV _http._tcp.service.example.com

# Query container DNS
dig @127.0.0.1 -p 53 container.local

# Kubernetes service lookup
dig @10.96.0.10 service.namespace.svc.cluster.local
```

### 2. DNS Validation
```bash
# Check propagation
dig +trace example.com

# Verify load balancing
dig service.example.com +short

# Test DNS round-robin
for i in {1..5}; do dig service.example.com +short; done
```

### 3. Cloud DNS Management
```bash
# Azure DNS query
dig @168.63.129.16 azure-service.internal

# AWS Route53 check
dig +trace example.com @ns-xxx.awsdns-xx.com

# GCP DNS verification
dig @dns.google example.com
```

## Advanced Features

### 1. DNS Troubleshooting
```bash
# Check DNSSEC
dig +dnssec example.com

# Trace query path
dig +trace example.com

# Debug query
dig +debug example.com
```

### 2. Record Management
```bash
# Batch updates
nsupdate <<EOF
server ns1.example.com
update add www.example.com 3600 A 192.168.1.1
update delete old.example.com A
send
EOF

# Zone transfer
dig @ns1.example.com example.com AXFR
```

### 3. Query Options
```bash
# Custom query flags
dig +noall +answer example.com

# Reverse lookup
dig -x 192.168.1.1

# TCP query
dig +tcp example.com
```

## Best Practices

### 1. DNS Querying
```bash
# Use short format
dig +short example.com

# Verify authoritative answer
dig +noadditional example.com

# Check response time
dig +stats example.com
```

### 2. Troubleshooting
```bash
# Full query path
dig +trace +dnssec example.com

# Check all records
dig any example.com

# Verify timeouts
dig +timeout=5 example.com
```

### 3. Update Security
```bash
# Secure updates
nsupdate -k Kexample.com.+157+15Praha.key

# TSIG authentication
nsupdate -y "hmac-sha256:keyname:base64key"

# Verify update
dig @server name type
```

## Common Scenarios

### 1. DNS Health Check
```bash
# Check nameservers
dig +short NS example.com

# Verify records
dig +noall +answer example.com ANY

# Test response time
dig +stats example.com | grep "Query time"
```

### 2. Service Verification
```bash
# Check mail servers
dig MX example.com

# Verify SPF
dig TXT example.com

# Test service availability
dig SRV _service._proto.example.com
```

### 3. DNS Debugging
```bash
# Full resolution path
dig +trace example.com

# Check DNSSEC chain
dig +dnssec +cd example.com

# Verify reverse DNS
dig -x IP-ADDRESS
```

## Integration Examples

### 1. With Container Platforms
```bash
# Kubernetes DNS
dig @10.96.0.10 kubernetes.default.svc.cluster.local

# Docker DNS
dig @127.0.0.11 container-name

# Service discovery
dig SRV _service._tcp.consul
```

### 2. With Cloud Services
```bash
# Azure Private DNS
dig @168.63.129.16 privatelink.database.windows.net

# AWS Service Discovery
dig service.region.amazonaws.com

# GCP Internal DNS
dig mylb.internal.gcpproject.com
```

### 3. With Monitoring Tools
```bash
# DNS response time
dig +stats example.com | awk '/Query time/ {print $4}'

# Record changes
dig +short example.com > current
diff previous current

# Monitoring script
while true; do
  dig +short example.com
  sleep 300
done
```

## Troubleshooting

### Common Issues
1. Resolution failures
   ```bash
   # Check nameservers
   dig +trace example.com
   
   # Verify resolver
   dig @8.8.8.8 example.com
   
   # Test local resolution
   dig @127.0.0.1 example.com
   ```

2. Update problems
   ```bash
   # Debug update
   nsupdate -d
   
   # Check permissions
   nsupdate -k keyfile
   
   # Verify zone
   dig @server example.com SOA
   ```

3. DNSSEC issues
   ```bash
   # Check DNSSEC chain
   dig +dnssec +cd example.com
   
   # Verify DS records
   dig example.com DS
   
   # Test validation
   dig +cdflag example.com
   ```

### Best Practices
1. Regular monitoring
   ```bash
   # Check response times
   dig +stats example.com
   
   # Monitor changes
   dig +short example.com
   
   # Verify DNSSEC
   dig +dnssec example.com
   ```

2. Security considerations
   ```bash
   # Use TSIG
   nsupdate -k keyfile
   
   # Verify updates
   dig @server name type
   
   # Check DNSSEC
   dig +dnssec example.com
   ```

3. Performance optimization
   ```bash
   # Use TCP when needed
   dig +tcp example.com
   
   # Minimize responses
   dig +noall +answer example.com
   
   # Cache management
   dig +ttlid example.com
