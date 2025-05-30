# curl - Command Line Tool for Data Transfer

## Overview
`curl` is a powerful command-line tool for transferring data using various protocols including HTTP, HTTPS, FTP, SMTP, and more. It supports complex operations with headers, cookies, authentication, and SSL/TLS.

## Official Documentation
[curl Documentation](https://curl.se/docs/)

## Basic Usage

### 1. HTTP Methods
```bash
# GET request
curl https://api.example.com/data

# POST request
curl -X POST https://api.example.com/create \
     -d '{"name": "example"}'

# PUT request
curl -X PUT https://api.example.com/update/1 \
     -d '{"status": "active"}'

# DELETE request
curl -X DELETE https://api.example.com/delete/1
```

### 2. Headers and Data
```bash
# Custom headers
curl -H "Content-Type: application/json" \
     -H "Authorization: Bearer token123" \
     https://api.example.com

# Form data
curl -F "file=@document.pdf" \
     -F "name=myfile" \
     https://api.example.com/upload

# JSON data
curl -H "Content-Type: application/json" \
     -d '{"key": "value"}' \
     https://api.example.com/data
```

### 3. Authentication
```bash
# Basic auth
curl -u username:password https://api.example.com

# Bearer token
curl -H "Authorization: Bearer token123" \
     https://api.example.com

# OAuth2
curl -H "Authorization: OAuth oauth_token=token123" \
     https://api.example.com
```

## Cloud/Container Use Cases

### 1. Azure Integration
```bash
# Azure REST API
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
     https://management.azure.com/subscriptions/{id}

# Azure Container Registry
curl -u "$USERNAME:$PASSWORD" \
     https://myregistry.azurecr.io/v2/

# Azure Storage
curl -X PUT \
     -H "x-ms-blob-type: BlockBlob" \
     -H "x-ms-date: $(date -u)" \
     --data-binary "@file.txt" \
     "https://myaccount.blob.core.windows.net/container/file.txt"
```

### 2. Kubernetes API
```bash
# List pods
curl -H "Authorization: Bearer $TOKEN" \
     https://kubernetes/api/v1/namespaces/default/pods

# Create resource
curl -X POST \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/yaml" \
     --data-binary "@deployment.yaml" \
     https://kubernetes/apis/apps/v1/namespaces/default/deployments

# Watch resources
curl -H "Authorization: Bearer $TOKEN" \
     "https://kubernetes/api/v1/pods?watch=true"
```

### 3. Container Registry Operations
```bash
# Registry authentication
curl -u "username:password" \
     https://registry.example.com/v2/

# List repositories
curl -s https://registry.example.com/v2/_catalog

# Get image tags
curl -s https://registry.example.com/v2/image/tags/list
```

## Advanced Features

### 1. SSL/TLS Options
```bash
# Skip certificate verification
curl -k https://example.com

# Specify certificate
curl --cacert ca.crt https://example.com

# Client certificate
curl --cert client.crt --key client.key \
     https://example.com
```

### 2. Cookie Handling
```bash
# Save cookies
curl -c cookies.txt https://example.com

# Use saved cookies
curl -b cookies.txt https://example.com

# Set specific cookie
curl -b "session=123" https://example.com
```

### 3. Output Control
```bash
# Save output to file
curl -o output.json https://api.example.com

# Download with original filename
curl -O https://example.com/file.zip

# Multiple downloads
curl -O https://example.com/file[1-10].txt
```

## Best Practices

### 1. Debugging
```bash
# Verbose output
curl -v https://api.example.com

# Trace data
curl --trace debug.txt https://api.example.com

# Show timing data
curl -w "Time: %{time_total}\n" https://api.example.com
```

### 2. Performance
```bash
# Use HTTP/2
curl --http2 https://example.com

# Compress data
curl --compressed https://example.com

# Limit bandwidth
curl --limit-rate 1000K https://example.com/large-file
```

### 3. Security
```bash
# Verify host
curl --resolve example.com:443:1.2.3.4 \
     https://example.com

# Pin public key
curl --pinnedpubkey sha256//key-hash \
     https://example.com

# Use specific TLS version
curl --tlsv1.2 https://example.com
```

## Common Scenarios

### 1. API Testing
```bash
# Test endpoints
curl -X POST \
     -H "Content-Type: application/json" \
     -d @request.json \
     https://api.example.com/endpoint

# GraphQL query
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"query": "{ users { id name } }"}' \
     https://api.example.com/graphql

# API versioning
curl -H "Accept-Version: 2.0" \
     https://api.example.com/data
```

### 2. File Operations
```bash
# Resume download
curl -C - -O https://example.com/large-file

# Upload file
curl -F "file=@document.pdf" \
     https://example.com/upload

# Multiple files
curl -F "files[]=@file1.txt" \
     -F "files[]=@file2.txt" \
     https://example.com/upload
```

### 3. Web Testing
```bash
# Check status code
curl -I https://example.com

# Follow redirects
curl -L https://example.com

# Test different user agents
curl -A "Mozilla/5.0" https://example.com
```

## Troubleshooting

### Common Issues
1. SSL Problems
   ```bash
   # Check certificate
   curl -vI https://example.com

   # Force TLS version
   curl --tlsv1.2 https://example.com

   # Ignore SSL errors (testing only)
   curl -k https://example.com
   ```

2. Network Issues
   ```bash
   # Use proxy
   curl -x proxy:8080 https://example.com

   # Set timeout
   curl --connect-timeout 10 https://example.com

   # Retry on failure
   curl --retry 3 https://example.com
   ```

3. Authentication Problems
   ```bash
   # Debug auth headers
   curl -v -u user:pass https://example.com

   # Test OAuth token
   curl -v -H "Authorization: Bearer $TOKEN" \
        https://api.example.com
   ```

### Integration Tips
1. Cloud Services
   ```bash
   # Azure Storage upload
   curl -X PUT \
        -H "x-ms-blob-type: BlockBlob" \
        -T localfile.txt \
        "$STORAGE_URL/$CONTAINER/file.txt"

   # AWS S3 operations
   curl -X PUT \
        -H "Authorization: AWS $AWS_AUTH" \
        -T file.txt \
        "https://s3.amazonaws.com/bucket/file.txt"
   ```

2. CI/CD Pipelines
   ```bash
   # Webhook triggers
   curl -X POST \
        -H "Content-Type: application/json" \
        -d '{"event":"deploy"}' \
        https://ci.example.com/trigger

   # Status updates
   curl -X PATCH \
        -H "Authorization: token $GH_TOKEN" \
        -d '{"state":"success"}' \
        https://api.github.com/repos/owner/repo/statuses/$SHA
   ```

3. Load Testing
   ```bash
   # Measure response time
   curl -w "@curl-format.txt" -o /dev/null -s \
        https://example.com

   # Multiple requests
   for i in {1..10}; do
     curl -w "%{time_total}\n" -o /dev/null -s \
          https://example.com
   done
