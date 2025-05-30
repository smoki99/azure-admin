# ldnsutils - Lightweight DNS Utilities

## Overview
`ldnsutils` provides an alternative set of DNS tools built on the ldns library, offering efficient DNS operations with a focus on DNSSEC. These utilities include tools like `drill` for DNS lookups and `ldns-key2ds` for DNSSEC key management.

## Official Documentation
[LDNS Documentation](https://nlnetlabs.nl/documentation/ldns/)

## Basic Usage

### 1. drill (DNS Lookup Tool)
```bash
# Basic DNS lookup
drill example.com

# Query specific record type
drill -t MX example.com
drill -t NS example.com

# Use specific nameserver
drill @8.8.8.8 example.com

# Trace DNS resolution path
drill -T example.com
```

### 2. ldns-key2ds
```bash
# Generate DS record from DNSKEY
ldns-key2ds -n zone.db

# Specify hash algorithm
ldns-key2ds -2 zone.db  # SHA-256
ldns-key2ds -4 zone.db  # SHA-384

# Generate DS records for all keys
ldns-key2ds -a zone.db
```

### 3. ldns-signzone
```bash
# Sign a zone
ldns-signzone zone.db K*.key

# Sign with specific algorithm
ldns-signzone -a RSASHA256 zone.db K*.key

# Sign with NSEC3
ldns-signzone -n zone.db K*.key
```

## Cloud/Container Use Cases

### 1. Azure DNS Management
```bash
# Verify Azure DNS records
drill @168.63.129.16 myapp.azurewebsites.net

# Check Azure Private DNS
drill -x @10.0.0.10 internal-service

# Generate DS records for Azure
ldns-key2ds -2 azure-zone.db
```

### 2. Kubernetes Integration
```bash
# Check cluster DNS
drill @10.96.0.10 kubernetes.default.svc.cluster.local

# Verify service discovery
drill -t SRV _service._tcp.namespace.svc.cluster.local

# Debug DNS resolution
drill -T service.namespace.svc.cluster.local
```

### 3. DNSSEC Management
```bash
# Sign zone files
ldns-signzone -n zone.db K*.key

# Generate DS records
ldns-key2ds -a zone.db

# Verify signatures
ldns-verify-zone zone.db
```

## Advanced Features

### 1. DNS Query Options
```bash
# DNSSEC validation
drill -D example.com

# TCP mode
drill -t example.com

# Check signature
drill -S example.com
```

### 2. Zone Management
```bash
# Zone signing with NSEC3
ldns-signzone -n -s random zone.db K*.key

# Verify zone file
ldns-verify-zone -V 2 zone.db

# Generate zone hash
ldns-nsec3-hash example.com
```

### 3. Key Management
```bash
# Convert DNSKEY to DS
ldns-key2ds -n zone.db

# Calculate key tag
ldns-keygen -a RSASHA256 -b 2048 example.com

# Verify key set
ldns-verify-zone -k keyfile zone.db
```

## Best Practices

### 1. Security
```bash
# Use DNSSEC validation
drill -D example.com

# Sign zones with strong algorithms
ldns-signzone -a RSASHA256 zone.db K*.key

# Generate secure keys
ldns-keygen -a RSASHA256 -b 2048 domain.com
```

### 2. Performance
```bash
# Minimize query overhead
drill +norecurse example.com

# Use TCP for large transfers
drill -t example.com

# Cache results
drill +ttlid example.com
```

### 3. Maintenance
```bash
# Regular zone verification
ldns-verify-zone zone.db

# Key rotation
ldns-keygen -a RSASHA256 -b 2048 domain.com
ldns-signzone -n zone.db K*.key

# Check expiration
ldns-verify-zone -e zone.db
```

## Common Scenarios

### 1. DNS Troubleshooting
```bash
# Trace resolution path
drill -T example.com

# Check DNSSEC chain
drill -S example.com

# Verify record presence
drill -t ANY example.com
```

### 2. Zone Management
```bash
# Sign new zone
ldns-signzone zone.db K*.key

# Update existing zone
ldns-signzone -u zone.db K*.key

# Verify zone after changes
ldns-verify-zone zone.db
```

### 3. DNSSEC Operations
```bash
# Generate new keys
ldns-keygen -a RSASHA256 -b 2048 example.com

# Create DS records
ldns-key2ds -2 zone.db

# Sign with new keys
ldns-signzone -n zone.db K*.key
```

## Troubleshooting

### Common Issues
1. DNS Resolution Problems
   ```bash
   # Check nameservers
   drill -t NS example.com

   # Trace resolution
   drill -T example.com
   ```

2. DNSSEC Validation Failures
   ```bash
   # Verify chain of trust
   drill -S example.com

   # Check DS records
   ldns-key2ds -n zone.db
   ```

3. Zone Signing Issues
   ```bash
   # Verify zone file
   ldns-verify-zone zone.db

   # Check key usage
   ldns-verify-zone -k keyfile zone.db
   ```

### Integration Tips
1. Azure Integration
   ```bash
   # Check Azure records
   drill @168.63.129.16 myapp.azurewebsites.net

   # Generate Azure DS records
   ldns-key2ds -2 azure-zone.db
   ```

2. Kubernetes Integration
   ```bash
   # Verify cluster DNS
   drill @10.96.0.10 kubernetes.default.svc.cluster.local

   # Check service records
   drill -t SRV _service._tcp.namespace.svc.cluster.local
   ```

3. DNSSEC Management
   ```bash
   # Update zone signatures
   ldns-signzone -u zone.db K*.key

   # Verify chain of trust
   ldns-verify-zone -V 2 zone.db
