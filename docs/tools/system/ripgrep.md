# ripgrep (rg) - Fast Text Search Tool

## Overview
`ripgrep` (rg) is a line-oriented search tool that recursively searches directories for a regex pattern. It's significantly faster than traditional tools like grep and has better defaults for developers.

## Official Documentation
[ripgrep User Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)

## Basic Usage

### Simple Searching
```bash
# Search for pattern in current directory
rg "pattern"

# Search in specific file
rg "pattern" file.txt

# Case insensitive search
rg -i "pattern"
```

### File Type Filtering
```bash
# List supported file types
rg --type-list

# Search only in YAML files
rg -t yaml "kind: Deployment"

# Search in Python files
rg -t py "def main"

# Exclude file types
rg -T js "function"
```

## Cloud/Container Use Cases

### 1. Kubernetes Configuration
```bash
# Search in all YAML files
rg -t yaml "containerPort: 80"

# Find all services
rg -t yaml "kind: Service"

# Search for specific labels
rg -t yaml 'labels:.*environment: production'
```

### 2. Log Analysis
```bash
# Search container logs
rg "Error|Exception" /var/log/containers/

# Find authentication failures
rg "authentication failed" /var/log/

# Search compressed logs
rg -z "ERROR" /var/log/archive/
```

### 3. Code Analysis
```bash
# Find Azure SDK usage
rg "azure.mgmt" ./src

# Search for security tokens
rg -i "api[_-]key|secret|password"

# Find TODO comments
rg -t py "TODO|FIXME"
```

## Advanced Features

### 1. Context Control
```bash
# Show 3 lines before and after match
rg -C 3 "error"

# Show 2 lines before match
rg -B 2 "error"

# Show 2 lines after match
rg -A 2 "error"
```

### 2. Output Control
```bash
# Show only matched text
rg -o "pattern"

# Include line numbers
rg -n "pattern"

# Show files that would be searched
rg --files

# Count matches
rg --count "pattern"
```

### 3. Pattern Matching
```bash
# Multiple patterns
rg "error|warning|critical"

# Word boundaries
rg -w "error"

# Regular expressions
rg '\d{3}-\d{2}-\d{4}'
```

## Best Practices

### 1. Performance
```bash
# Respect gitignore
rg --no-ignore "pattern"

# Search hidden files
rg -. "pattern"

# Follow symlinks
rg -L "pattern"
```

### 2. Search Scope
```bash
# Exclude directories
rg -g '!node_modules/' "pattern"

# Include only specific files
rg -g '*.{yaml,yml}' "pattern"

# Multiple file types
rg -t yaml -t json "pattern"
```

### 3. Output Format
```bash
# JSON output
rg --json "pattern"

# Only file names
rg -l "pattern"

# Replace matches
rg -r 'replacement' "pattern"
```

## Common Scenarios

### 1. Configuration Management
```bash
# Find environment variables
rg -t dockerfile 'ENV '
rg -t yaml 'environment:'

# Search for IP addresses
rg -w '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
```

### 2. Security Auditing
```bash
# Find exposed credentials
rg -i 'password|secret|key'

# Check file permissions
rg '0777|chmod 777'

# Find TODO security items
rg 'TODO.*security'
```

### 3. Development Tasks
```bash
# Find unused imports
rg -t py '^import.*' --files-without-match

# Search for deprecated features
rg 'DEPRECATED|TODO.*remove'

# Find debug statements
rg 'console\.log|print|debug'
```

## Integration Examples

### 1. With Version Control
```bash
# Search uncommitted changes
git status -s | rg '^.M' | xargs rg "pattern"

# Search specific branch
git show branch:file | rg "pattern"
```

### 2. With Container Tools
```bash
# Search container files
podman export container | tar -t | rg "pattern"

# Search Docker files
rg -t dockerfile 'FROM.*alpine'
```

### 3. With Azure Tools
```bash
# Search Azure templates
rg -t json '"type": "Microsoft.+'

# Find resource dependencies
rg -t json '"dependsOn":'
```

## Troubleshooting

### Common Issues
1. Too many matches
   ```bash
   # Narrow search with type
   rg -t specific_type "pattern"
   
   # Use word boundaries
   rg -w "pattern"
   ```

2. Performance issues
   ```bash
   # Exclude large directories
   rg --ignore-dir=node_modules "pattern"
   
   # Limit depth
   rg --max-depth 3 "pattern"
   ```

3. Missing matches
   ```bash
   # Check ignored files
   rg --debug "pattern"
   
   # Include hidden files
   rg -. "pattern"
   ```

### Best Practices
1. Use type filtering
2. Leverage .gitignore
3. Be specific with patterns
4. Consider context needs
5. Choose appropriate output format
