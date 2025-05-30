# System Tools

This section covers the system utilities included in the Azure Admin Container for file management, text processing, and system operations.

## Available Tools

### File and Text Processing
- [tree](tree.md) - Directory structure visualization
- [jq](jq.md) - JSON processor and manipulator
- [ripgrep](ripgrep.md) - Fast text search tool

### Terminal and Remote Access
- [mosh](mosh.md) - Mobile shell with roaming support
- [w3m](w3m.md) - Text-based web browser

## Common Use Cases

1. JSON Processing:
```bash
# Parse Azure CLI output
az vm list | jq '.[].name'

# Format and filter JSON logs
cat logfile.json | jq 'select(.level == "error")'
```

2. Directory Navigation:
```bash
# View project structure
tree -L 2 ./project

# List only directories
tree -d ./config
```

3. Text Search:
```bash
# Search for pattern in files
rg "azure" ./src

# Search with file type filter
rg -t yaml "kind: Deployment"
```

4. Remote Access:
```bash
# Connect to remote server
mosh user@server

# Browse documentation
w3m https://docs.microsoft.com
```

## Integration Examples

### 1. Azure Resource Management
```bash
# List resource groups and format output
az group list | jq -r '.[] | {name: .name, location: .location}'

# Search Azure CLI command history
rg "az vm create" ~/.azure/commands
```

### 2. Container Development
```bash
# View container filesystem
tree /var/lib/containers

# Search container logs
rg "error" /var/log/containers/
```

### 3. Documentation Access
```bash
# Browse Azure docs offline
w3m /docs/README.md

# Search documentation
rg "kubectl" /docs/
```

## Best Practices

1. JSON Processing:
   - Use jq for structured data manipulation
   - Format output for readability
   - Filter data efficiently

2. File Navigation:
   - Use tree for project overview
   - Filter unnecessary directories
   - Export structure to documentation

3. Text Search:
   - Use ripgrep for fast searches
   - Leverage file type filtering
   - Use proper search patterns

4. Remote Access:
   - Use mosh for unstable connections
   - Configure proper terminal settings
   - Handle connection persistence

## Further Reading
- [JSON Processing Guide](https://stedolan.github.io/jq/manual/)
- [Ripgrep User Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)
- [Mosh Documentation](https://mosh.org/#techinfo)
- [W3M User Manual](https://w3m.sourceforge.net/MANUAL)
