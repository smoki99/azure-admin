# lazydocker

## Overview

lazydocker is a terminal UI for both Docker and Docker Compose, making it easier to manage containers, images, volumes, and networks through an intuitive interface. It's particularly useful for real-time monitoring and debugging of container environments.

## Official Documentation
- [Lazydocker GitHub](https://github.com/jesseduffield/lazydocker)
- [Configuration Guide](https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md)
- [Keybindings](https://github.com/jesseduffield/lazydocker/blob/master/docs/keybindings/Keybindings_en.md)

## Key Features
- Terminal user interface
- Real-time monitoring
- Container management
- Log viewing
- Resource usage stats
- Docker Compose support
- Custom commands
- Configurable keybindings

## Basic Usage

### Navigation
```bash
# Start lazydocker
lazydocker

# Common keyboard shortcuts
# ? - show keybindings
# Tab - next panel
# h/j/k/l - vim-style navigation
# Ctrl+c - exit
```

### Basic Operations
```
# Container operations
[c] - view containers
[enter] - focus container
[s] - stop container
[r] - restart container
[d] - remove container
[l] - view logs

# Image operations
[i] - view images
[enter] - select image
[d] - remove image
[p] - pull latest version
```

## Cloud/Container Use Cases

### 1. Container Monitoring

Monitor containers in real-time:

```bash
# Start monitoring
lazydocker

# Common monitoring tasks:
- View container stats (CPU, Memory, Network)
- Check container logs
- Monitor container health
- View environment variables
```

### 2. Development Workflow

Manage development containers:

```bash
# Start development environment
cd /path/to/project
docker-compose up -d

# Monitor with lazydocker
lazydocker

# Common tasks:
- View service logs
- Restart services
- Check build status
- Debug networking issues
```

### 3. Troubleshooting

Debug container issues:

```bash
# Start lazydocker
lazydocker

# Troubleshooting workflow:
1. Select problematic container
2. View logs (l)
3. Check resource usage
4. Inspect container details
5. Execute commands in container (e)
```

## Common Scenarios

### 1. Log Analysis
```bash
# View logs
1. Select container
2. Press 'l' for logs
3. Use '/' to search
4. Press 'f' to follow

# Export logs
1. Select container
2. Press 'l'
3. Press 'e' to export
```

### 2. Resource Monitoring
```bash
# Monitor resources
1. Select container
2. View stats panel
3. Sort by CPU/Memory
4. Check network I/O

# Performance analysis
- Check CPU spikes
- Monitor memory leaks
- Track network usage
```

### 3. Service Management
```bash
# Manage services
1. Navigate to services panel
2. Select service
3. Available actions:
   - Restart (r)
   - Stop (s)
   - View logs (l)
   - Scale (ctrl+s)
```

## Azure-Specific Features

### 1. Azure Container Instances
```bash
# Monitor ACI containers
1. Configure Docker context for ACI
2. Start lazydocker
3. View container status
4. Monitor logs and performance
```

### 2. Azure Container Registry
```bash
# Work with ACR images
1. View images panel
2. Check image details
3. Monitor pull/push operations
4. View image layers
```

### 3. Multi-Container Apps
```bash
# Monitor Azure multi-container apps
1. View service dependencies
2. Check connection status
3. Monitor resource usage
4. Debug networking issues
```

## Best Practices

### 1. Configuration Setup
```yaml
# ~/.config/lazydocker/config.yml
gui:
  scrollHeight: 2
  theme:
    activeBorderColor:
      - blue
      - bold
  showAllContainers: true
logs:
  timestamps: true
  since: '60m'
commandTemplates:
  restartContainer: docker restart {{ .Container.ID }}
```

### 2. Custom Commands
```yaml
# Add custom commands
customCommands:
  containers:
    - name: bash
      command: docker exec -it {{ .Container.ID }} bash
    - name: top
      command: docker exec -it {{ .Container.ID }} top
```

### 3. Navigation Tips
```bash
# Efficient navigation
1. Use keyboard shortcuts
2. Set up custom filters
3. Configure preferred views
4. Use split panes effectively
```

## Integration Examples

### 1. Development Setup
```bash
#!/bin/bash
# Development environment script

# Start services
docker-compose up -d

# Configure lazydocker
cat << EOF > ~/.config/lazydocker/config.yml
gui:
  showAllContainers: true
logs:
  timestamps: true
customCommands:
  containers:
    - name: debug
      command: docker exec -it {{ .Container.ID }} sh
EOF

# Launch monitoring
lazydocker
```

### 2. Monitoring Script
```bash
#!/bin/bash
# Container monitoring script

# Function to check container health
check_containers() {
  echo "Container Status Report"
  echo "======================"
  docker ps --format "{{.Names}}: {{.Status}}"
}

# Monitor containers
while true; do
  clear
  check_containers
  sleep 30
done
```

### 3. Troubleshooting Setup
```bash
#!/bin/bash
# Troubleshooting environment

# Set up logging
mkdir -p ~/container-logs

# Configure log collection
cat << EOF > ~/.config/lazydocker/config.yml
logs:
  timestamps: true
  since: '24h'
  tail: 1000
customCommands:
  containers:
    - name: export-logs
      command: docker logs {{ .Container.ID }} > ~/container-logs/{{ .Container.Name }}.log
    - name: inspect
      command: docker inspect {{ .Container.ID }} > ~/container-logs/{{ .Container.Name }}-inspect.json
EOF

# Start monitoring
lazydocker
```

### 4. Custom Views
```yaml
# ~/.config/lazydocker/config.yml
gui:
  expandedViews:
    containers: true
    images: false
  containerColumnOrder:
    - name
    - status
    - cpu
    - memory
  containerFilters:
    - label=environment=production
