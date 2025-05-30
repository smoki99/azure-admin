# w3m - Text-based Web Browser

## Overview
`w3m` is a text-based web browser and pager that allows viewing web content and HTML documents directly in the terminal. It's particularly useful for reading documentation, checking web services, and viewing HTML-formatted output.

## Official Documentation
[w3m Manual](https://w3m.sourceforge.net/MANUAL)

## Basic Usage

### Browsing
```bash
# Open URL
w3m https://docs.microsoft.com/azure

# Open local file
w3m documentation.html

# Open man page
w3m /usr/share/man/man1/w3m.1
```

### Navigation
```bash
# Key commands
H - Help
Q - Quit
B - Back
U - Show URL
T - New tab
```

## Cloud/Container Use Cases

### 1. Documentation Access
```bash
# View Azure docs offline
w3m /docs/README.md

# Browse Kubernetes docs
w3m https://kubernetes.io/docs/

# Check container registry
w3m https://registry.hub.docker.com/
```

### 2. Service Monitoring
```bash
# Check web service
w3m http://localhost:8080/health

# View API documentation
w3m http://localhost:8080/swagger

# Monitor metrics endpoint
w3m http://localhost:9090/metrics
```

### 3. Cloud Resource Management
```bash
# View Azure portal (text mode)
w3m https://portal.azure.com

# Check cloud status
w3m https://status.azure.com

# Access Kubernetes dashboard
w3m http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/
```

## Advanced Features

### 1. File Operations
```bash
# Save page
w3m -dump https://example.com > page.txt

# Download file
w3m -dump_source https://example.com/file.txt > file.txt

# Print to stdout
w3m -dump documentation.html
```

### 2. Display Control
```bash
# Monochrome display
w3m -M

# Show line numbers
w3m -l

# Specify columns
w3m -cols 80
```

### 3. Cookie Management
```bash
# Use cookie file
w3m -cookie

# Specify cookie file
w3m -cookie_file ~/.w3m/cookie

# Disable cookies
w3m -no-cookie
```

## Best Practices

### 1. Documentation Viewing
```bash
# Format output
w3m -dump -cols 80 doc.html

# Generate TOC
w3m -dump -T text/html -cols 80 doc.html

# Strip HTML
w3m -dump -T text/html
```

### 2. Web Testing
```bash
# Check HTTP headers
w3m -dump_head https://api.example.com

# Verify SSL
w3m -ssl_verify https://secure.example.com

# Test auth
w3m -auth user:pass https://private.example.com
```

### 3. Integration
```bash
# Pipe to less
w3m -dump doc.html | less

# Filter content
w3m -dump page.html | grep "pattern"

# Save formatted
w3m -dump page.html > formatted.txt
```

## Common Scenarios

### 1. Documentation Management
```bash
# Generate docs index
w3m -dump /docs/index.html > docs.txt

# Create searchable docs
w3m -dump docs/*.html | grep -r "pattern"

# Extract code examples
w3m -dump tutorial.html | awk '/```/{p=!p;next} p'
```

### 2. Service Verification
```bash
# Check endpoint
w3m -dump http://service/health

# Monitor metrics
watch -n 60 "w3m -dump http://service/metrics"

# Verify API docs
w3m -dump http://service/swagger
```

### 3. Content Extraction
```bash
# Get API response
w3m -dump http://api/endpoint

# Extract table data
w3m -dump table.html | awk '/^|/'

# Save formatted content
w3m -dump -cols 80 content.html > readable.txt
```

## Integration Examples

### 1. With Container Tools
```bash
# View container docs
podman run image w3m /usr/share/doc/

# Check container web service
w3m http://localhost:$(podman port container)

# View registry docs
w3m https://docs.docker.com/
```

### 2. With Development Tools
```bash
# View API documentation
w3m http://localhost:3000/docs

# Check test coverage
w3m coverage/index.html

# Read package docs
w3m node_modules/package/README.md
```

### 3. With Cloud Tools
```bash
# View Azure documentation
w3m https://docs.microsoft.com/azure/

# Check service status
w3m https://status.azure.com

# Read Kubernetes docs
w3m https://kubernetes.io/docs/
```

## Troubleshooting

### Common Issues
1. Display problems
   ```bash
   # Set terminal type
   TERM=xterm-256color w3m
   
   # Force character set
   w3m -I UTF-8
   ```

2. SSL errors
   ```bash
   # Skip verification
   w3m -no-verify-ssl
   
   # Specify cert file
   w3m -ssl_ca_file /path/to/cert
   ```

3. Navigation issues
   ```bash
   # Show link numbers
   w3m -N
   
   # Enable mouse
   w3m -mouse
   ```

### Best Practices
1. Use appropriate options for content type
2. Handle SSL properly
3. Set correct character encoding
4. Configure proper terminal settings
5. Save useful content locally
