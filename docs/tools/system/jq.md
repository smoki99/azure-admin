# jq - JSON Processor

## Overview
`jq` is a lightweight command-line JSON processor. It's particularly useful for processing JSON output from Azure CLI commands, working with container configurations, and parsing API responses.

## Official Documentation
[jq Manual](https://stedolan.github.io/jq/manual/)

## Basic Usage

### Simple Filtering
```bash
# Get specific field
echo '{"name": "test", "value": 123}' | jq '.name'

# Get multiple fields
echo '{"name": "test", "value": 123}' | jq '{name: .name, val: .value}'

# Format JSON
echo '{"name":"test","value":123}' | jq '.'
```

### Array Operations
```bash
# Get array elements
echo '[1,2,3,4]' | jq '.[]'

# Select array element
echo '[1,2,3,4]' | jq '.[2]'

# Array slicing
echo '[1,2,3,4]' | jq '.[1:3]'

# Filter array
echo '[1,2,3,4]' | jq '.[] | select(. > 2)'
```

## Cloud/Container Use Cases

### 1. Azure Resource Management
```bash
# List VM names and sizes
az vm list | jq '.[] | {name: .name, size: .hardwareProfile.vmSize}'

# Get resource group locations
az group list | jq -r '.[] | {name: .name, location: .location}'

# Filter by tag
az resource list | jq '.[] | select(.tags.environment == "production")'
```

### 2. Container Configuration
```bash
# Parse container config
cat config.json | jq '.spec.containers[].image'

# Extract environment variables
podman inspect container | jq '.[].Config.Env'

# Filter container ports
docker inspect container | jq '.[].NetworkSettings.Ports'
```

### 3. API Processing
```bash
# Parse REST API response
curl api.example.com | jq '.data.items[]'

# Filter and transform
curl api.example.com | jq '.[] | {id: .id, status: .state.status}'

# Conditional filtering
curl api.example.com | jq '.[] | select(.status == "running")'
```

## Advanced Features

### 1. Data Transformation
```bash
# Convert string to number
echo '{"value": "123"}' | jq '.value | tonumber'

# Create new structure
jq '{new_name: .name, status: .state.status}'

# Combine multiple files
jq -s '.[0] * .[1]' file1.json file2.json
```

### 2. Complex Filtering
```bash
# Multiple conditions
jq 'select(.type == "vm" and .state == "running")'

# Nested filtering
jq '.items[] | select(.metadata.namespace == "default")'

# Value comparison
jq 'select(.price < 100 and .status != "deleted")'
```

### 3. Output Formatting
```bash
# Raw output (no quotes)
jq -r '.name'

# Compact output
jq -c '.'

# Custom formatting
jq '.[] | "\(.name): \(.value)"'
```

## Best Practices

### 1. Error Handling
```bash
# Check if field exists
jq 'select(.field != null)'

# Provide default value
jq '.field // "default"'

# Error messages to stderr
jq 'if .field == null then empty else . end'
```

### 2. Performance
```bash
# Stream large files
jq -c '.[]' large.json

# Select specific fields
jq '{name, id}' # Instead of '.'

# Use raw output when possible
jq -r # When parsing strings
```

### 3. Azure Integration
```bash
# Format Azure CLI output
az group list | jq -r '.[] | [.name, .location] | @tsv'

# Filter Azure resources
az resource list | jq 'map(select(.type | contains("compute")))'

# Extract credentials
az aks get-credentials | jq -r '.kubeconfig'
```

## Common Scenarios

### 1. Resource Management
```bash
# Get all resource types
az resource list | jq -r '.[].type' | sort -u

# Count resources by type
az resource list | jq 'group_by(.type) | map({type: .[0].type, count: length})'
```

### 2. Container Analysis
```bash
# List container mounts
podman inspect container | jq '.[].Mounts'

# Get container environment
docker inspect container | jq '.[].Config.Env'
```

### 3. Configuration Processing
```bash
# Merge config files
jq -s '.[0] * .[1]' base.json overlay.json

# Extract specific sections
jq '.spec.template.spec.containers[]' deployment.yaml
```

## Troubleshooting

### Common Issues
1. Invalid JSON input
   ```bash
   # Validate JSON
   jq 'type' input.json
   ```

2. Missing fields
   ```bash
   # Check field existence
   jq 'has("field")' input.json
   ```

3. Type mismatches
   ```bash
   # Check value type
   jq '.field | type' input.json
   ```

### Integration Tips
1. Use with Azure CLI
   ```bash
   # Error handling
   az vm list 2>/dev/null | jq 'select(length > 0)'
   ```

2. Container logs
   ```bash
   # Parse JSON logs
   podman logs container | jq 'select(.level == "error")'
   ```

3. Configuration management
   ```bash
   # Validate config
   jq 'has("required_field")' config.json || echo "Missing required field"
