# mosh - Mobile Shell

## Overview
`mosh` (mobile shell) is a remote terminal application that supports intermittent connectivity, roaming, and intelligent local echo. It's particularly useful for cloud administration over unreliable network connections.

## Official Documentation
[Mosh Website](https://mosh.org/)

## Basic Usage

### Connection
```bash
# Basic connection
mosh username@server

# Specify SSH port
mosh -p 2222 username@server

# Connect with specific key
mosh --ssh="ssh -i ~/.ssh/key" username@server
```

### Server Control
```bash
# Start mosh-server manually
mosh-server

# Specify server port
mosh-server new -p 60001

# Show server process
pgrep mosh-server
```

## Cloud/Container Use Cases

### 1. Azure VM Management
```bash
# Connect to Azure VM
mosh azureuser@vm-ip

# Use with Azure Bastion
mosh --ssh="ssh -o ProxyCommand='az network bastion ssh -n bastion-name -g rg --target-resource-id vm-id'" azureuser@vm-ip

# Multiple VM management
tmux new-session \; split-window "mosh user@vm1" \; split-window "mosh user@vm2"
```

### 2. Container Administration
```bash
# Connect to container host
mosh admin@container-host

# Monitor container logs
mosh user@host -- tail -f /var/log/containers/*

# Long-running container operations
mosh user@host -- podman build -t image .
```

### 3. Kubernetes Management
```bash
# Connect to k8s node
mosh user@node

# Monitor pods
mosh user@master -- watch kubectl get pods

# Debug workloads
mosh user@node -- kubectl debug pod/myapp -it
```

## Advanced Features

### 1. Screen Management
```bash
# Set screen size
mosh --predict=experimental user@host

# Force 256 colors
mosh --colors=256 user@host

# Handle Unicode properly
mosh --unicode-version=9 user@host
```

### 2. Network Settings
```bash
# Specify port range
mosh -p 60000:60010 user@host

# Use specific network interface
mosh --bind-server=192.168.1.2 user@host

# Network debugging
mosh --netcat=/bin/nc user@host
```

### 3. SSH Integration
```bash
# Use specific SSH config
mosh --ssh="ssh -F ~/.ssh/config" user@host

# Forward SSH agent
mosh --ssh="ssh -A" user@host

# Use SSH multiplexing
mosh --ssh="ssh -M" user@host
```

## Best Practices

### 1. Connection Management
```bash
# Use connection persistence
mosh --predict=adaptive user@host

# Handle high latency
mosh --predict=always user@host

# Enable SSH keepalive
mosh --ssh="ssh -o ServerAliveInterval=60" user@host
```

### 2. Security
```bash
# Use specific key
mosh --ssh="ssh -i ~/.ssh/secure_key" user@host

# Restrict client IP
mosh --bind-server=internal-ip user@host

# Secure port range
mosh -p 60000:60001 user@host
```

### 3. Performance
```bash
# Optimize for slow networks
mosh --predict=adaptive user@host

# Reduce bandwidth usage
mosh --predict=never user@host

# Handle packet loss
mosh --predict=experimental user@host
```

## Common Scenarios

### 1. Cloud Administration
```bash
# Multiple cloud instances
tmux new-session \; \
  split-window "mosh user@cloud1" \; \
  split-window "mosh user@cloud2"

# Long-running operations
mosh user@host -- "ansible-playbook deploy.yml"

# Monitoring
mosh user@host -- "top -b"
```

### 2. Container Operations
```bash
# Build containers
mosh user@host -- "podman build -t app ."

# Monitor services
mosh user@host -- "watch podman ps"

# Debug containers
mosh user@host -- "podman debug container"
```

### 3. Development Tasks
```bash
# Remote development
mosh dev@server -- "code-server"

# Git operations
mosh user@host -- "git pull && make deploy"

# Log monitoring
mosh user@host -- "tail -f /var/log/*"
```

## Integration Examples

### 1. With tmux
```bash
# Start tmux session
mosh user@host -- tmux new -s work

# Attach to existing session
mosh user@host -- tmux attach -t work

# Split window setup
mosh user@host -- "tmux new-session \; split-window -h"
```

### 2. With Kubernetes
```bash
# Multiple cluster management
mosh user@host -- "kubectl config use-context cluster1"

# Pod debugging
mosh user@host -- "kubectl exec -it pod/myapp -- bash"

# Log streaming
mosh user@host -- "kubectl logs -f deploy/myapp"
```

### 3. With Azure Tools
```bash
# Azure CLI operations
mosh user@host -- "az vm list-sizes"

# Resource management
mosh user@host -- "az group deployment create"

# Monitor resources
mosh user@host -- "az monitor metrics list"
```

## Troubleshooting

### Common Issues
1. Connection failures
   ```bash
   # Check UDP ports
   nc -zu host 60000-61000
   
   # Verify server
   mosh-server
   ```

2. Display problems
   ```bash
   # Force terminal type
   TERM=xterm-256color mosh user@host
   
   # Reset terminal
   mosh user@host -- reset
   ```

3. Performance issues
   ```bash
   # Disable predictions
   mosh --predict=never user@host
   
   # Check network
   mosh --network-path-mtu=1000 user@host
   ```

### Best Practices
1. Use persistent connections
2. Configure proper SSH settings
3. Monitor network conditions
4. Handle terminal settings
5. Implement security measures
