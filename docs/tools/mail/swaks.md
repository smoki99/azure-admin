# swaks - Swiss Army Knife for SMTP

## Overview
`swaks` (Swiss Army Knife for SMTP) is a versatile command-line tool for testing SMTP servers. It supports various authentication methods, TLS encryption, and provides detailed transaction analysis.

## Official Documentation
[Swaks Documentation](https://jetmore.org/john/code/swaks/docs.html)

## Basic Usage

### 1. Simple Email Test
```bash
# Basic email test
swaks --to recipient@example.com --from sender@example.com

# Custom subject and body
swaks --to recipient@example.com \
      --from sender@example.com \
      --subject "Test Email" \
      --body "This is a test."

# Use specific SMTP server
swaks --server smtp.example.com \
      --to recipient@example.com \
      --from sender@example.com
```

### 2. Authentication
```bash
# Basic authentication
swaks --auth-user username --auth-password password \
      --to recipient@example.com

# Specific auth type
swaks --auth LOGIN --auth-user username \
      --to recipient@example.com

# OAuth2 authentication
swaks --auth XOAUTH2 --auth-user user@example.com \
      --auth-oauth2-token "token_string"
```

### 3. TLS/SSL Options
```bash
# Force TLS
swaks --tls --server smtp.example.com

# Test STARTTLS
swaks --tls-optional --server smtp.example.com

# Specific TLS version
swaks --tls-protocol tlsv1_2 --server smtp.example.com
```

## Cloud/Container Use Cases

### 1. Azure Integration
```bash
# Test Azure SendGrid
swaks --server smtp.sendgrid.net \
      --port 587 \
      --tls \
      --auth-user apikey \
      --auth-password "YOUR_SENDGRID_API_KEY" \
      --to recipient@example.com

# Office 365 SMTP
swaks --server smtp.office365.com \
      --port 587 \
      --tls \
      --auth-user user@domain.com \
      --to recipient@example.com

# Azure Relay SMTP
swaks --server your-namespace.servicebus.windows.net \
      --port 587 \
      --tls \
      --auth-user "PolicyName" \
      --auth-password "SharedAccessKey"
```

### 2. Container Email Testing
```bash
# Test container SMTP service
swaks --server smtp-container \
      --port 25 \
      --to internal@example.com

# Debug mail routing
swaks --server mail-service.namespace \
      --port 25 \
      --show-raw-text

# Test with custom headers
swaks --server smtp-service \
      --add-header "X-Container-ID: container123"
```

### 3. Mail Server Verification
```bash
# Check SPF records
swaks --from sender@example.com \
      --server receiving-smtp.example.com

# Test DKIM signing
swaks --dkim-key /path/to/private.key \
      --dkim-domain example.com \
      --dkim-selector default

# Verify DMARC compliance
swaks --add-header "DMARC-Signature: v=DMARC1;" \
      --server smtp.example.com
```

## Advanced Features

### 1. Protocol Testing
```bash
# Test specific SMTP extensions
swaks --protocol ESMTP --server smtp.example.com

# Force specific commands
swaks --force-EHLO --quit-after EHLO

# Custom XCLIENT data
swaks --xclient-addr 192.168.1.1 \
      --xclient-name client.example.com
```

### 2. Message Customization
```bash
# Custom headers
swaks --add-header "X-Priority: 1" \
      --add-header "X-Custom: Value"

# HTML content
swaks --data content.html \
      --header "Content-Type: text/html"

# Attachments
swaks --attach-type "application/pdf" \
      --attach-name "document.pdf" \
      --attach /path/to/document.pdf
```

### 3. Transaction Analysis
```bash
# Detailed protocol trace
swaks --show-time-lapse \
      --show-raw-text

# Test timeout handling
swaks --timeout 30 \
      --show-time-stats

# Connection debugging
swaks --pipeline \
      --show-net-stats
```

## Best Practices

### 1. Security Testing
```bash
# Test STARTTLS
swaks --tls --tls-verify --tls-chain /path/to/ca.pem

# Auth method testing
swaks --auth-optional --auth-types LOGIN,PLAIN,CRAM-MD5

# Test submission ports
swaks --port 587 --tls
```

### 2. Performance Testing
```bash
# Multiple recipients
swaks --to-list recipients.txt

# Pipeline testing
swaks --pipeline --repeat 10

# Connection reuse
swaks --socket /path/to/socket --pipeline
```

### 3. Maintenance
```bash
# Regular server checks
swaks --test-mode --to postmaster

# Protocol compliance
swaks --protocol ESMTP --verify

# TLS certificate verification
swaks --tls --tls-verify
```

## Common Scenarios

### 1. Server Migration
```bash
# Test old server
swaks --server old-smtp.example.com --quit-after EHLO

# Test new server
swaks --server new-smtp.example.com --quit-after EHLO

# Compare capabilities
swaks --server-compare old-smtp.example.com,new-smtp.example.com
```

### 2. Configuration Testing
```bash
# Test new config
swaks --config new-config.conf

# Verify auth methods
swaks --auth-optional --auth-types ALL

# Check TLS settings
swaks --tls-optional --tls-verify
```

### 3. Troubleshooting
```bash
# Debug mode
swaks --debug --show-time-stats

# Test specific issues
swaks --force-EHLO --quit-after DATA

# Trace routing
swaks --show-routing --tls
```

## Troubleshooting

### Common Issues
1. Authentication Problems
   ```bash
   # Test auth methods
   swaks --auth-optional --auth-types ALL \
         --server smtp.example.com

   # Debug auth failures
   swaks --auth LOGIN --show-auth-pass
   ```

2. TLS Issues
   ```bash
   # Check TLS support
   swaks --tls-optional --tls-verify

   # Debug TLS handshake
   swaks --tls --debug --show-tls
   ```

3. Delivery Problems
   ```bash
   # Check routing
   swaks --show-routing

   # Test bounce handling
   swaks --data bounce-test.txt --show-raw-text
   ```

### Integration Tips
1. Azure Email Services
   ```bash
   # Test Azure SendGrid
   swaks --server smtp.sendgrid.net \
         --port 587 \
         --auth-user "azure_user"

   # Office 365 Integration
   swaks --server smtp.office365.com \
         --tls --auth XOAUTH2
   ```

2. Container Environment
   ```bash
   # Test container mail service
   swaks --server mail-service \
         --show-net-stats

   # Debug container routing
   swaks --xclient-addr container-ip \
         --show-routing
   ```

3. Security Verification
   ```bash
   # Test security features
   swaks --tls --auth LOGIN \
         --show-security

   # Verify DMARC/DKIM
   swaks --dkim --dmarc \
         --show-auth-pass
