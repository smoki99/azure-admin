# OpenSSL - SSL/TLS Toolkit

## Overview
`openssl` is a versatile command-line tool and toolkit for SSL/TLS, providing functionality for key generation, certificate management, encryption/decryption, and SSL/TLS connection testing.

## Official Documentation
[OpenSSL Documentation](https://www.openssl.org/docs/)

## Basic Usage

### 1. Key Generation
```bash
# Generate private key
openssl genrsa -out private.key 2048

# Generate public key from private key
openssl rsa -in private.key -pubout -out public.key

# Generate key pair with encryption
openssl genrsa -aes256 -out encrypted.key 2048
```

### 2. Certificate Operations
```bash
# Generate CSR (Certificate Signing Request)
openssl req -new -key private.key -out cert.csr

# Generate self-signed certificate
openssl req -x509 -new -key private.key -out cert.crt -days 365

# View certificate information
openssl x509 -in cert.crt -text -noout
```

### 3. SSL Connection Testing
```bash
# Test SSL/TLS connection
openssl s_client -connect example.com:443

# Show SSL/TLS certificates
openssl s_client -connect example.com:443 -showcerts

# Test specific TLS version
openssl s_client -connect example.com:443 -tls1_2
```

## Cloud/Container Use Cases

### 1. Azure Certificate Management
```bash
# Generate key for Azure service
openssl genrsa -out azure-service.key 2048

# Create CSR for Azure certificate
openssl req -new \
      -key azure-service.key \
      -out azure-service.csr \
      -subj "/CN=myapp.azurewebsites.net"

# Export certificate for Azure Key Vault
openssl pkcs12 -export \
      -in azure-service.crt \
      -inkey azure-service.key \
      -out azure-service.pfx
```

### 2. Container Security
```bash
# Generate TLS certificates for registry
openssl req -newkey rsa:4096 -nodes \
      -sha256 -keyout registry.key \
      -out registry.csr

# Create certificate for local registry
openssl x509 -req -days 365 \
      -in registry.csr \
      -signkey registry.key \
      -out registry.crt

# Verify registry certificate
openssl verify -CAfile ca.crt registry.crt
```

### 3. Kubernetes TLS
```bash
# Generate certificates for Kubernetes
openssl genrsa -out kube-admin.key 2048
openssl req -new -key kube-admin.key \
      -out kube-admin.csr \
      -subj "/CN=kube-admin/O=system:masters"

# Sign Kubernetes certificates
openssl x509 -req -in kube-admin.csr \
      -CA ca.crt -CAkey ca.key \
      -CAcreateserial -out kube-admin.crt
```

## Advanced Features

### 1. Certificate Chain Operations
```bash
# Verify certificate chain
openssl verify -CAfile ca-chain.crt cert.crt

# Create certificate chain
cat cert.crt intermediate.crt root.crt > chain.crt

# Extract certificates from chain
openssl crl2pkcs7 -nocrl -certfile chain.crt | \
      openssl pkcs7 -print_certs -out separated.crt
```

### 2. Key Management
```bash
# Convert key formats
openssl rsa -in key.pem -outform DER -out key.der

# Check private key
openssl rsa -in private.key -check

# Extract public key from certificate
openssl x509 -in cert.crt -pubkey -noout > pubkey.pem
```

### 3. Encryption/Decryption
```bash
# Encrypt file
openssl enc -aes-256-cbc -salt \
      -in plaintext.txt -out encrypted.txt

# Decrypt file
openssl enc -aes-256-cbc -d \
      -in encrypted.txt -out decrypted.txt

# Create message digest
openssl dgst -sha256 -sign private.key \
      -out signature.sig message.txt
```

## Best Practices

### 1. Key Security
```bash
# Generate strong key
openssl genrsa -aes256 -out secure.key 4096

# Protect key with passphrase
openssl rsa -aes256 \
      -in unencrypted.key -out encrypted.key

# Check key strength
openssl rsa -in private.key -text -noout
```

### 2. Certificate Management
```bash
# Check expiration
openssl x509 -in cert.crt -noout -enddate

# Verify certificate purpose
openssl x509 -purpose -in cert.crt -noout

# Check revocation
openssl ocsp -issuer issuer.crt \
      -cert cert.crt -url http://ocsp.example.com
```

### 3. TLS Configuration
```bash
# Test server configuration
openssl s_client -connect example.com:443 \
      -tls1_3 -status

# Check supported ciphers
openssl ciphers -v 'HIGH:!aNULL'

# Verify protocol support
openssl s_client -connect example.com:443 \
      -tls1_2 -tls1_3
```

## Common Scenarios

### 1. SSL Server Testing
```bash
# Test server certificate
openssl s_client -connect example.com:443 \
      -servername example.com

# Check SSL/TLS versions
openssl s_client -connect example.com:443 \
      -tls1_2 -status

# Verify cipher support
openssl s_client -connect example.com:443 \
      -cipher 'ECDHE-RSA-AES256-GCM-SHA384'
```

### 2. Certificate Creation
```bash
# Create self-signed certificate
openssl req -x509 -newkey rsa:4096 \
      -keyout key.pem -out cert.pem \
      -days 365 -nodes

# Generate CSR with config
openssl req -new -config req.conf \
      -key private.key -out request.csr

# Create multi-domain certificate
openssl req -new -key domain.key \
      -out domain.csr -config san.cnf
```

### 3. PKI Management
```bash
# Create CA hierarchy
openssl genrsa -out ca.key 4096
openssl req -new -x509 -key ca.key \
      -out ca.crt -days 3650

# Sign certificate with CA
openssl x509 -req -in cert.csr \
      -CA ca.crt -CAkey ca.key \
      -CAcreateserial -out cert.crt
```

## Troubleshooting

### Common Issues
1. Certificate Problems
   ```bash
   # Check certificate match
   openssl x509 -noout -modulus -in cert.crt | openssl md5
   openssl rsa -noout -modulus -in key.pem | openssl md5

   # Verify trust chain
   openssl verify -verbose -CAfile ca.crt cert.crt
   ```

2. Connection Issues
   ```bash
   # Debug SSL/TLS connection
   openssl s_client -connect example.com:443 \
         -debug -msg

   # Check protocol support
   openssl s_client -connect example.com:443 \
         -tls1_2 -tls1_3 -status
   ```

3. Key Problems
   ```bash
   # Verify key integrity
   openssl rsa -check -in private.key

   # Test key pair match
   openssl rsa -in private.key -pubout | \
         diff - <(openssl x509 -in cert.crt -pubkey -noout)
   ```

### Integration Tips
1. Azure Integration
   ```bash
   # Create Azure certificate
   openssl req -new -x509 \
         -key azure.key -out azure.crt \
         -subj "/CN=*.azurewebsites.net"

   # Export for Azure
   openssl pkcs12 -export \
         -in azure.crt -inkey azure.key \
         -out azure.pfx
   ```

2. Container Security
   ```bash
   # Generate registry cert
   openssl req -newkey rsa:4096 \
         -nodes -sha256 \
         -keyout registry.key \
         -x509 -days 365 \
         -out registry.crt

   # Trust certificate
   openssl x509 -in registry.crt \
         -out registry.pem -outform PEM
   ```

3. Development Environment
   ```bash
   # Create development CA
   openssl genrsa -out devca.key 2048
   openssl req -new -x509 \
         -key devca.key -out devca.crt

   # Sign development certs
   openssl x509 -req \
         -in dev.csr -CA devca.crt \
         -CAkey devca.key -CAcreateserial
