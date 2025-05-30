# Kubernetes Tools

This document covers the Kubernetes-related tools included in the container environment, their use cases, and practical examples for cloud-native development and operations.

## Core Kubernetes Tools

### kubectl (v1.30)
**What it does:**  
The official command-line tool for interacting with Kubernetes clusters.

**Example Usage:**
```bash
# Get cluster information
kubectl cluster-info

# View all resources in a namespace
kubectl get all -n my-namespace

# Debug pod issues
kubectl describe pod my-pod
kubectl logs my-pod -f
```

**Cloud/K8s Use Case:**  
Daily AKS cluster management:
1. Deploy and manage applications
2. Troubleshoot pod issues
3. Monitor cluster health
4. Manage configurations and secrets

### k9s
**What it does:**  
Terminal-based UI for managing Kubernetes clusters with real-time updates.

**Example Usage:**
```bash
# Start k9s
k9s

# Start in a specific namespace
k9s -n kube-system
```

**Cloud/K8s Use Case:**  
Real-time cluster monitoring and management:
1. Monitor pod status across namespaces
2. Quick access to logs and shell
3. Watch resource utilization
4. Rapid troubleshooting of deployments

### Helm
**What it does:**  
Package manager for Kubernetes that helps you manage applications and resources.

**Example Usage:**
```bash
# Add official stable repository
helm repo add stable https://charts.helm.sh/stable

# Install a chart
helm install my-release stable/nginx-ingress

# List all releases
helm list

# Upgrade a release
helm upgrade my-release stable/nginx-ingress
```

**Cloud/K8s Use Case:**  
Application deployment and management in AKS:
1. Deploy complex applications with dependencies
2. Manage multiple environment configurations
3. Implement consistent deployment patterns
4. Handle application upgrades and rollbacks

### Kustomize
**What it does:**  
Template-free way to customize Kubernetes resource configurations.

**Example Usage:**
```bash
# Create base resources
kustomize create

# Build final manifests
kustomize build overlays/production

# Apply kustomized resources
kustomize build . | kubectl apply -f -
```

**Cloud/K8s Use Case:**  
Managing environment-specific configurations in AKS:
1. Maintain base configurations with environment-specific overlays
2. Manage multiple cluster configurations
3. Implement GitOps workflows
4. Handle configuration variations across environments

## Best Practices

### 1. Resource Management
- Use namespaces to organize resources
- Implement resource quotas and limits
- Follow least privilege principle for RBAC
- Regular audit of cluster resources

### 2. Configuration Management
- Use ConfigMaps and Secrets appropriately
- Implement proper secret management
- Version control all configurations
- Use Helm for complex deployments

### 3. Monitoring and Debugging
- Set up proper logging and monitoring
- Use k9s for quick troubleshooting
- Implement health checks and readiness probes
- Monitor cluster and application metrics

### 4. Security Considerations
- Regular security audits
- Network policy implementation
- Container image scanning
- RBAC review and maintenance

### 5. Azure-Specific Tips
- Use AKS-specific features when available
- Implement proper node pool management
- Utilize Azure Monitor for containers
- Follow Azure security best practices

## Common Troubleshooting Scenarios

### 1. Pod Issues
```bash
# Check pod status
kubectl get pod my-pod -o yaml
kubectl describe pod my-pod
kubectl logs my-pod --previous

# Debug with temporary debug container
kubectl debug my-pod -it --image=ubuntu
```

### 2. Service Connectivity
```bash
# Test service DNS
kubectl run temp-shell --rm -it --image=busybox -- nslookup my-service

# Check service endpoints
kubectl get endpoints my-service
```

### 3. Resource Constraints
```bash
# Check node resources
kubectl top nodes

# Check pod resources
kubectl top pods -n my-namespace
```

### 4. Configuration Problems
```bash
# View ConfigMaps
kubectl get configmap my-config -o yaml

# Check Secrets (encoded)
kubectl get secret my-secret -o yaml
```

## Integration with Azure

### 1. AKS-Specific Commands
```bash
# Get AKS credentials
az aks get-credentials --resource-group my-rg --name my-cluster

# Scale node pool
az aks scale --resource-group my-rg --name my-cluster --node-count 5
```

### 2. Azure Monitor Integration
- Use `kubectl top` with Azure Monitor
- View container insights in Azure Portal
- Set up alerts based on metrics
- Configure log analytics workspace

### 3. Azure Identity Integration
- Pod identity configuration
- Managed identities setup
- Service principal rotation
- Access to Azure resources
