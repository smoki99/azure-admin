# yq - YAML/XML Processor

## Overview
`yq` is a lightweight command-line YAML/XML processor and JSON parser. It's particularly useful for processing YAML configurations in Kubernetes, Docker Compose files, and other cloud-native applications. Written in Go, it aims to be for YAML what jq is for JSON.

## Official Documentation
[yq Documentation](https://mikefarah.gitbook.io/yq/)

## Basic Usage

### Simple Operations
```bash
# Read a value
yq '.key' file.yaml

# Update a value
yq '.key = "value"' -i file.yaml

# Convert YAML to JSON
yq -o=json '.' file.yaml

# Convert JSON to YAML
yq -P '.' file.json
```

### Array Operations
```bash
# Get array elements
yq '.array[]' file.yaml

# Select array element
yq '.array[2]' file.yaml

# Array length
yq '.array | length' file.yaml

# Filter array
yq '.array[] | select(.value > 100)' file.yaml
```

## Cloud/Container Use Cases

### 1. Kubernetes Configuration
```bash
# Get container images
yq '.spec.containers[].image' deployment.yaml

# Update image tag
yq '.spec.containers[0].image = "nginx:latest"' -i deployment.yaml

# Set resource limits
yq '.spec.containers[0].resources.limits.memory = "512Mi"' -i deployment.yaml
```

### 2. Docker Compose
```bash
# List services
yq '.services | keys' docker-compose.yml

# Update service version
yq '.services.webapp.image = "nginx:1.21"' -i docker-compose.yml

# Add environment variable
yq '.services.app.environment.NEW_VAR = "value"' -i docker-compose.yml
```

### 3. Configuration Management
```bash
# Merge configurations
yq '. *= load("overlay.yaml")' base.yaml

# Extract specific sections
yq '.metadata' config.yaml

# Update multiple fields
yq '.spec.replicas = 3 | .spec.template.spec.containers[0].image = "new:tag"' -i deploy.yaml
```

## Advanced Features

### 1. Data Transformation
```bash
# Convert strings to numbers
yq '.version |= tonumber' file.yaml

# Create new structure
yq '. *= {"new_key": .old_key}' file.yaml

# Merge multiple files
yq '. *= load("other.yaml")' base.yaml
```

### 2. Complex Operations
```bash
# Recursive descent
yq '.. | select(has("image"))' file.yaml

# Multiple file processing
yq eval-all '. as $item ireduce ({}; . * $item )' *.yaml

# Conditional updates
yq 'select(.kind == "Deployment").spec.replicas = 3' -i file.yaml
```

### 3. Format Control
```bash
# Pretty print
yq -P '.' file.yaml

# JSON output
yq -o=json '.' file.yaml

# XML processing
yq -p=xml '.' file.xml
```

## Best Practices

### 1. File Handling
```bash
# Backup before in-place updates
cp config.yaml config.yaml.bak
yq '.key = "value"' -i config.yaml

# Validate YAML syntax
yq '.' config.yaml >/dev/null

# Use explicit document markers
yq -P '.' file.yaml > file.yaml
```

### 2. Performance
```bash
# Process large files
yq --split-exp '.items[]' large.yaml

# Stream processing
yq --stream '.' large.yaml

# Targeted updates
yq '.specific.path' # Instead of '.'
```

### 3. Cloud Native Integration
```bash
# Kubernetes manifest validation
yq 'select(.kind == "Deployment")' manifest.yaml

# Extract specific resources
yq 'select(.kind == "ConfigMap").data' manifests.yaml

# Update container images
yq '.spec.template.spec.containers[] |= select(.name == "app").image = "new:tag"' -i deploy.yaml
```

## Common Scenarios

### 1. Configuration Management
```bash
# Update multiple values
yq '.spec.template.spec.containers[0].resources.limits = {"memory": "1Gi", "cpu": "500m"}' -i deploy.yaml

# Extract configuration sections
yq '.data' configmap.yaml

# Merge configurations
yq '. *= load("overlay.yaml")' -i base.yaml
```

### 2. Multi-document Processing
```bash
# Process all documents
yq eval-all '.' multi-doc.yaml

# Filter specific documents
yq eval-all 'select(.kind == "Service")' k8s-manifests.yaml

# Update across documents
yq eval-all 'select(.kind == "Deployment").spec.replicas = 3' -i manifests.yaml
```

### 3. Format Conversion
```bash
# YAML to JSON
yq -o=json '.' config.yaml

# JSON to YAML
yq -P '.' config.json

# XML to YAML
yq -p=xml -o=yaml '.' config.xml
```

## Troubleshooting

### Common Issues
1. YAML Syntax Errors
   ```bash
   # Validate YAML
   yq '.' file.yaml
   ```

2. Path Resolution
   ```bash
   # Debug path navigation
   yq -v '.' file.yaml
   ```

3. Type Handling
   ```bash
   # Check value type
   yq '.field | type' file.yaml
   ```

### Integration Tips
1. Use with Kubernetes
   ```bash
   # Safe updates
   yq '.spec.replicas = 3' deploy.yaml | kubectl apply -f -
   ```

2. Docker Compose
   ```bash
   # Validate compose file
   yq '.' docker-compose.yml >/dev/null
   ```

3. Configuration Management
   ```bash
   # Environment-specific updates
   yq '. *= load("env/${ENV}.yaml")' base.yaml
