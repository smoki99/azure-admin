# k9s

## Overview

k9s is a powerful terminal-based UI to interact with Kubernetes clusters. It provides a more intuitive way to navigate, observe and manage your applications and resources in real-time.

## Official Documentation
- [k9s GitHub](https://github.com/derailed/k9s)
- [k9s Documentation](https://k9scli.io/)

## Key Features
- Real-time cluster monitoring
- Resource management
- Container log viewing
- Port forwarding
- Resource editing
- Custom resource views
- Extensible hotkey system
- Context switching

## Basic Usage

### Starting k9s
```bash
# Launch k9s
k9s

# Start in a specific namespace
k9s -n kube-system

# Use specific context
k9s --context my-context

# Read-only mode
k9s --readonly
```

### Navigation Commands
```bash
# Hot keys
:       # Command mode
Esc     # Back/Clear
Ctrl-a  # Select all
/       # Start filtering
?       # Help menu
```

## Cloud/Container Use Cases

### 1. AKS Cluster Management

Monitor and manage Azure Kubernetes Service:

```bash
# Launch k9s in AKS cluster
az aks get-credentials --resource-group my-rg --name my-cluster
k9s

# Common operations:
- Press 0 to view all resources
- Press :pods to view pods
- Press :nodes to view nodes
- Press :deploy to view deployments
```

### 2. Application Monitoring

Monitor application deployments:

```bash
# View application logs
1. Navigate to pods (:pods)
2. Select pod
3. Press l for logs
4. Press s to toggle auto-scroll
5. Press f to filter logs

# Check container status
1. Navigate to pods
2. Press d to describe pod
3. View container statuses and events
```

### 3. Resource Management

Handle resources in real-time:

```bash
# Scale deployments
1. Navigate to deployments (:deploy)
2. Select deployment
3. Press s to scale
4. Enter desired replicas

# Delete resources
1. Navigate to resource
2. Press Ctrl-k to delete
3. Confirm deletion
```

## Common Troubleshooting Scenarios

### 1. Pod Issues
```bash
# Check pod status
1. :pods
2. Filter with /error
3. Press l for logs
4. Press d for details

# Container shell access
1. Select pod
2. Press s for shell
3. Execute commands
```

### 2. Resource Monitoring
```bash
# Watch resource metrics
1. :pulses
2. Monitor CPU/Memory

# View resource usage
1. :top to view resource consumers
2. Sort by CPU/MEM
```

### 3. Configuration Management
```bash
# Edit resources
1. Select resource
2. Press e to edit
3. Make changes
4. Save and exit

# View events
1. :events
2. Filter relevant events
```

## Azure-Specific Features

### 1. AKS Resource Views
```bash
# View Azure resources
:storage    # Storage classes
:sc         # Storage classes
:pvc        # Persistent volume claims
:secrets    # Azure secrets

# Monitor Azure services
1. :services
2. Filter Azure services
3. Check external IPs
```

### 2. AKS Troubleshooting
```bash
# Node issues
1. :nodes
2. Check node status
3. View node details

# Network issues
1. :endpoints
2. Verify service endpoints
3. Check load balancers
```

### 3. Azure Integration
```bash
# Azure identity
1. :sa for service accounts
2. Check Azure identities
3. Verify bindings

# Storage
1. :pv for persistent volumes
2. Check Azure disk status
3. Monitor volume claims
```

## Best Practices

### 1. Efficiency Tips
- Learn keyboard shortcuts
- Use command aliases
- Create custom views
- Set up preferred filters

### 2. Resource Management
```bash
# Resource organization
1. Use namespace filters
2. Create resource groups
3. Set up aliases

# Monitoring setup
1. Configure metrics
2. Set up port forwards
3. Save common filters
```

### 3. Security
```bash
# Access control
1. Use read-only mode when needed
2. Monitor privileged resources
3. Review RBAC settings

# Audit operations
1. Monitor events
2. Track changes
3. Review logs
```

## Integration Examples

### 1. Custom Shell Aliases
```bash
# Add to .bashrc or .zshrc
alias k9s-prod="k9s --context production"
alias k9s-dev="k9s --context development"
alias k9s-system="k9s -n kube-system"
```

### 2. Custom Views Configuration
```yaml
# $HOME/.k9s/views.yml
k9s:
  views:
    - name: myapp
      command: pods
      args:
      - -l
      - app=myapp
    - name: system
      command: pods
      args:
      - -n
      - kube-system
```

### 3. Custom Skin
```yaml
# $HOME/.k9s/skin.yml
k9s:
  body:
    fgColor: dodgerblue
    bgColor: black
    logoColor: orange
  prompt:
    fgColor: cadetblue
    bgColor: black
  info:
    fgColor: orange
    sectionColor: white
```

## Kubernetes Context Management

### 1. Multiple Clusters
```bash
# Switch contexts
1. Press Ctrl-c
2. Select context
3. Press enter

# View current context
:contexts
```

### 2. Resource Monitoring
```bash
# Monitor multiple namespaces
1. :ns
2. Mark namespaces
3. Switch between them

# Track resources
1. Create custom views
2. Save filters
3. Use hotkeys
```

### 3. Batch Operations
```bash
# Bulk actions
1. Select multiple resources
2. Apply actions
3. Confirm changes

# Resource management
1. Filter resources
2. Select matching
3. Execute operations
