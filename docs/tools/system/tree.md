# tree - Directory Structure Visualization

## Overview
`tree` is a recursive directory listing program that produces a depth-indented listing of files. It's particularly useful for understanding project structures, documenting filesystem layouts, and visualizing container contents.

## Official Documentation
[tree Manual](http://mama.indstate.edu/users/ice/tree/tree.1.html)

## Basic Usage

### Simple Listing
```bash
# List current directory
tree

# List specific directory
tree /path/to/directory

# Limit depth
tree -L 2
```

### Filtering Output
```bash
# Show only directories
tree -d

# Show files with specific pattern
tree -P "*.yaml"

# Exclude patterns
tree -I "node_modules|*.pyc"
```

## Cloud/Container Use Cases

### 1. Kubernetes Project Structure
```bash
# View k8s manifests structure
tree -P "*.yaml" ./k8s

# Show only directories in helm chart
tree -d ./charts

# Document project layout
tree -L 3 > project-structure.txt
```

### 2. Container Filesystem
```bash
# View container filesystem
tree /var/lib/containers

# Show configuration directories
tree -L 2 /etc/containers

# List mounted volumes
tree /mnt
```

### 3. Project Documentation
```bash
# Generate project structure
tree -L 3 --dirsfirst > README.md

# Document source code
tree ./src -P "*.{js,ts,py}"

# Show configuration files
tree -P "*.{yaml,json,conf}"
```

## Advanced Features

### 1. Output Formatting
```bash
# JSON output
tree -J

# HTML output
tree -H "title" -o output.html

# Show file size and permissions
tree -pugh
```

### 2. Pattern Matching
```bash
# Multiple file patterns
tree -P "*.{yaml,json}"

# Exclude multiple patterns
tree -I "node_modules|dist|*.pyc"

# Case insensitive patterns
tree -P "*.yaml" -i
```

### 3. File Information
```bash
# Show file size
tree -h

# Show last modified time
tree -D

# Show owner/group
tree -ug
```

## Best Practices

### 1. Documentation
```bash
# Include in README
tree -L 2 >> README.md

# Document configuration
tree /etc/containers -L 3 > container-config.txt

# Export project structure
tree --dirsfirst -I "node_modules|venv" > structure.txt
```

### 2. Analysis
```bash
# Find large directories
tree -h --du

# Check permissions
tree -pug

# Find specific files
tree -P "*.log" -f
```

### 3. Reporting
```bash
# Count files/directories
tree --noreport

# Summary only
tree -L 1 --summ

# File size summary
tree -h --du -L 2
```

## Common Scenarios

### 1. Project Management
```bash
# Document new project
tree -L 3 --dirsfirst > PROJECT.md

# Check deployment files
tree -P "deploy*.yaml"

# Verify gitignore
tree -I "$(cat .gitignore | tr '\n' '|')"
```

### 2. Container Analysis
```bash
# Check volume mounts
tree /mnt -L 2

# View container layers
tree /var/lib/containers/storage

# List configuration
tree /etc/containers -P "*.conf"
```

### 3. Documentation Generation
```bash
# Generate HTML docs
tree -H "Project Structure" -o structure.html

# Create JSON structure
tree -J > structure.json

# Document with sizes
tree -h --du > space-usage.txt
```

## Integration Examples

### 1. With Container Tools
```bash
# List container contents
podman export container | tar -tvf - | tree --fromfile

# Check image layers
skopeo inspect --raw image | jq -r '.[] | tree'
```

### 2. With Development Tools
```bash
# Document source code
tree -P "*.{js,ts,py}" --prune

# Show test files
tree -P "*test*.{js,py}" --matchdirs
```

### 3. With Documentation
```bash
# Generate markdown
echo "## Project Structure" > README.md
tree -L 3 >> README.md

# Create HTML docs
tree -H "Documentation" -P "*.md" -o docs.html
```

## Troubleshooting

### Common Issues
1. Too much output
   ```bash
   # Limit depth
   tree -L 2
   
   # Show only directories
   tree -d
   ```

2. Missing files
   ```bash
   # Show hidden files
   tree -a
   
   # Check patterns
   tree -P "pattern" --debug
   ```

3. Performance issues
   ```bash
   # Limit recursion
   tree -L 3
   
   # Exclude large directories
   tree -I "node_modules|dist"
   ```

### Best Practices
1. Use appropriate depth limits
2. Filter unnecessary files
3. Choose proper output format
4. Include in documentation
5. Combine with other tools
