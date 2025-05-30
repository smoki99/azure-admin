# httpie - User-friendly HTTP Client

## Overview
`httpie` is a modern command-line HTTP client that makes CLI interaction with web services as human-friendly as possible. It provides syntax highlighting, formatted output, and intuitive command syntax.

## Official Documentation
[HTTPie Documentation](https://httpie.io/docs)

## Basic Usage

### Simple Requests
```bash
# GET request
http get example.com

# POST request
http post example.com name=value

# PUT request
http put example.com name=value
```

### Authentication
```bash
# Basic auth
http -a username:password example.com

# Bearer token
http example.com 'Authorization: Bearer token'

# API key
http example.com 'apikey: key123'
```

## Cloud/Container Use Cases

### 1. Kubernetes API
```bash
# List pods
http :8001/api/v1/namespaces/default/pods \
  "Authorization: Bearer ${TOKEN}"

# Create resource
http post :8001/api/v1/namespaces/default/pods \
  @pod.json

# Watch resources
http --stream :8001/api/v1/namespaces/default/pods
```

### 2. Container Registry API
```bash
# List images
http get registry.example.com/v2/_catalog \
  "Authorization: Basic ${AUTH}"

# Check tags
http get registry.example.com/v2/image/tags/list

# Get manifest
http get registry.example.com/v2/image/manifests/latest
```

### 3. Cloud API Interactions
```bash
# Azure API
http get management.azure.com/subscriptions \
  "Authorization: Bearer ${AZURE_TOKEN}"

# AWS API
http get api.aws.amazon.com \
  "X-Amz-Date:${DATE}" \
  "Authorization:${AWS_AUTH}"
```

## Advanced Features

### 1. Request Customization
```bash
# Custom headers
http example.com \
  User-Agent:custom \
  Accept:application/json

# Query parameters
http example.com q==search p==1

# File upload
http post example.com file@/path/to/file
```

### 2. Response Processing
```bash
# Format output
http --pretty=all example.com

# Download file
http --download example.com/file.zip

# Show only headers
http --headers example.com
```

### 3. Session Management
```bash
# Save session
http --session=login -a user:pass example.com

# Use session
http --session=login example.com/api

# List sessions
http --session-list
```

## Best Practices

### 1. API Testing
```bash
# Test endpoints
http --verify=no localhost:8080/health

# Check response codes
http --check-status example.com

# Validate JSON
http --json POST example.com
```

### 2. Debugging
```bash
# Verbose output
http -v example.com

# Show request/response
http --print=HBhb example.com

# Debug mode
http --debug example.com
```

### 3. Security
```bash
# SSL verification
http --verify=ssl_cert example.com

# Client certificate
http --cert=client.pem example.com

# Ignore SSL
http --verify=no example.com
```

## Common Scenarios

### 1. REST API Testing
```bash
# CRUD operations
http post api/users name=test
http get api/users/1
http put api/users/1 name=updated
http delete api/users/1
```

### 2. Monitoring
```bash
# Health checks
http get service/health

# Metrics endpoint
http get service/metrics

# Status check
http -h service/status
```

### 3. Data Transfer
```bash
# Upload JSON
http post api/data @data.json

# Download file
http --download api/files/doc.pdf

# Stream data
http --stream api/events
```

## Integration Examples

### 1. With Container Platforms
```bash
# Docker API
http --unix-socket /var/run/docker.sock \
  get http://localhost/containers/json

# Kubernetes API
http get :8001/api/v1/nodes \
  "Authorization: Bearer ${TOKEN}"

# Container registry
http get registry/v2/_catalog
```

### 2. With Cloud Services
```bash
# Azure REST API
http get https://management.azure.com/subscriptions \
  "Authorization: Bearer ${TOKEN}"

# AWS API Gateway
http get api.gateway.url \
  "x-api-key:${API_KEY}"

# GCP API
http get https://compute.googleapis.com/compute/v1/projects \
  "Authorization: Bearer ${GCP_TOKEN}"
```

### 3. With Development Tools
```bash
# GitHub API
http get api.github.com/repos/user/repo \
  "Authorization: token ${GITHUB_TOKEN}"

# GitLab API
http get gitlab.com/api/v4/projects \
  "PRIVATE-TOKEN: ${GITLAB_TOKEN}"

# npm registry
http get registry.npmjs.org/package
```

## Troubleshooting

### Common Issues
1. SSL/TLS problems
   ```bash
   # Skip verification
   http --verify=no example.com
   
   # Specify cert
   http --cert=/path/to/cert.pem example.com
   
   # Debug SSL
   http --debug --verify=no example.com
   ```

2. Authentication issues
   ```bash
   # Check auth headers
   http -v example.com
   
   # Test with curl syntax
   http --curl example.com
   
   # Session debug
   http --session-debug=login example.com
   ```

3. API errors
   ```bash
   # Show full response
   http -v --all example.com
   
   # Check status code
   http --check-status example.com
   
   # Debug request
   http --print=HBhb example.com
   ```

### Best Practices
1. Use sessions for persistent auth
2. Enable verbose mode for debugging
3. Save common commands as aliases
4. Validate JSON responses
5. Handle SSL properly
