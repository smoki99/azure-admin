# ripgrep - Fast Line-Oriented Search Tool

## Overview
`ripgrep` (rg) is a highly efficient search tool that recursively searches directories for a regex pattern. It respects gitignore rules and automatically skips hidden files, binary files, and version control directories.

## Official Documentation
[ripgrep Documentation](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)

## Basic Usage

### 1. Simple Pattern Matching
```bash
# Basic text search
rg "pattern"

# Case insensitive search
rg -i "pattern"

# Search specific file types
rg -t py "pattern"  # Python files
rg -t js "pattern"  # JavaScript files

# Exclude file types
rg -T py "pattern"  # Exclude Python files
```

### 2. File and Directory Control
```bash
# Search specific directory
rg "pattern" path/to/dir

# Search multiple file types
rg -t py -t js "pattern"

# Include hidden/dot files
rg --hidden "pattern"

# Follow symbolic links
rg -L "pattern"
```

### 3. Output Control
```bash
# Show line numbers
rg -n "pattern"

# Show context lines
rg -C 2 "pattern"     # 2 lines before and after
rg -B 2 "pattern"     # 2 lines before
rg -A 2 "pattern"     # 2 lines after
```

## Cloud/Container Use Cases

### 1. Code Analysis
```bash
# Find Azure resource definitions
rg "azurerm_" --type terraform

# Search Kubernetes manifests
rg -t yaml "kind: Deployment"

# Find Docker configurations
rg --type dockerfile "FROM"
```

### 2. Configuration Management
```bash
# Search environment variables
rg -g '*.env*' '^[A-Z_]+'

# Find configuration patterns
rg -g '*.conf' 'listen.*443'

# Search for IP addresses
rg -g '*.yaml' '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
```

### 3. Log Analysis
```bash
# Search error logs
rg -g 'error*.log' 'Exception|Error|Failed'

# Find Kubernetes pod issues
rg -g '*.log' 'CrashLoopBackOff'

# Search Azure diagnostic logs
rg -g 'azure*.log' 'ResourceNotFound'
```

## Advanced Features

### 1. Pattern Matching
```bash
# Regular expressions
rg '\w+@\w+\.\w+'  # Find email addresses

# Fixed strings (no regex)
rg -F "special.chars.*"

# Word boundaries
rg -w "word"
```

### 2. Output Formatting
```bash
# Only print file names
rg -l "pattern"

# Only print matched parts
rg -o "pattern"

# JSON output
rg --json "pattern"
```

### 3. Performance Options
```bash
# Disable all smart filtering
rg -uu "pattern"

# Search compressed files
rg -z "pattern"

# Use multiple threads
rg --threads 8 "pattern"
```

## Best Practices

### 1. Search Configuration
```bash
# Use .rgignore file
echo "*.log" > .rgignore
echo "temp/" >> .rgignore

# Configure type definitions
rg --type-add 'web:*.{html,css,js}'

# Use configuration file
rg --config /path/to/config
```

### 2. Performance
```bash
# Limit search depth
rg --max-depth 3 "pattern"

# Set file size limit
rg --max-filesize 1M "pattern"

# Use memory buffers
rg --mmap "pattern"
```

### 3. Output Control
```bash
# Custom output format
rg --format '{file}:{line}:{text}'

# Replace matches
rg -r 'replacement' "pattern"

# Count matches only
rg --count "pattern"
```

## Common Scenarios

### 1. Code Search
```bash
# Find function definitions
rg '^(def|function).*'

# Search specific file extensions
rg -g '*.{js,ts}' "pattern"

# Exclude test files
rg -g '!*_test.go' "pattern"
```

### 2. Security Auditing
```bash
# Find API keys
rg '[A-Za-z0-9]{32}'

# Search for passwords
rg -i 'password.*=.*'

# Find IP addresses
rg '\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'
```

### 3. Configuration Management
```bash
# Find environment variables
rg '^export \w+='

# Search for URLs
rg 'https?://[^\s"]+'

# Find port numbers
rg 'port.*=.*\d+'
```

## Troubleshooting

### Common Issues
1. Performance Problems
   ```bash
   # Limit search depth
   rg --max-depth 2 "pattern"

   # Skip large files
   rg --max-filesize 1M "pattern"

   # Debug info
   rg --debug "pattern"
   ```

2. Pattern Matching Issues
   ```bash
   # Escape special characters
   rg -F "pattern[.*]"

   # Test pattern
   rg --debug-regex "pattern"

   # Use word boundaries
   rg -w "pattern"
   ```

3. File Type Issues
   ```bash
   # List supported types
   rg --type-list

   # Create custom type
   rg --type-add 'custom:*.{ext1,ext2}'

   # Force binary search
   rg -a "pattern"
   ```

### Integration Tips
1. Version Control
   ```bash
   # Search uncommitted changes
   rg "pattern" $(git ls-files)

   # Ignore .gitignore
   rg --no-ignore "pattern"

   # Search specific branch
   git checkout branch && rg "pattern"
   ```

2. CI/CD Pipelines
   ```bash
   # Search for TODOs
   rg "TODO|FIXME" --stats

   # Find deprecated code
   rg "@deprecated"

   # Check coding standards
   rg -g '*.{js,ts}' 'console\.log'
   ```

3. Development Workflow
   ```bash
   # Find unused imports
   rg -g '*.py' '^import.*' -l

   # Check error handling
   rg 'try|catch|except'

   # Find debug code
   rg 'debugger|console\.log|print'
