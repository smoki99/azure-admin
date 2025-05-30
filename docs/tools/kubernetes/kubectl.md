# kubectl

## Overview

kubectl is the official command-line tool for interacting with Kubernetes clusters. It allows you to deploy applications, inspect and manage cluster resources, and view logs.

## Official Documentation
- [kubectl Overview](https://kubernetes.io/docs/reference/kubectl/overview/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [kubectl Commands](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)

## Key Features
- Cluster management
- Application deployment
- Resource inspection and modification
- Log viewing and container execution
- Port forwarding
- Cluster monitoring
- Configuration management

## Basic Usage

### Cluster Operations
```bash
# View cluster information
kubectl cluster-info

# Check node status
kubectl get nodes

# View all namespaces
kubectl get namespaces

# Switch context
kubectl config use-context my-context
```

### Resource Management
```bash
# List all resources in namespace
kubectl get all -n my-namespace

# Describe resource
kubectl describe pod my-pod

# Delete resource
kubectl delete pod my-pod

# Apply manifest
kubectl apply -f manifest.yaml
```

## Cloud/Container Use Cases

### 1. AKS Cluster Management

Handle Azure Kubernetes Service operations:

```bash
# Get AKS credentials
az aks get-credentials --resource-group my-rg --name my-cluster

# Check AKS node status
kubectl get nodes -o wide

# View AKS system pods
kubectl get pods -n kube-system

# Monitor AKS metrics
kubectl top nodes
```

### 2. Application Deployment

Deploy and manage applications in AKS:

```bash
# Deploy application
cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myregistry.azurecr.io/myapp:latest
        ports:
        - containerPort: 80
EOF

# Create service
kubectl expose deployment myapp --type=LoadBalancer --port=80

# Scale deployment
kubectl scale deployment myapp --replicas=5

# Update image
kubectl set image deployment/myapp myapp=myregistry.azurecr.io/myapp:v2
```

### 3. Troubleshooting

Debug issues in AKS:

```bash
# Check pod logs
kubectl logs pod/myapp-pod -f

# Execute command in pod
kubectl exec -it myapp-pod -- /bin/bash

# Check pod details
kubectl describe pod myapp-pod

# Port forward to pod
kubectl port-forward pod/myapp-pod 8080:80
```

## Common Troubleshooting Scenarios

### 1. Pod Issues
```bash
# Check pod status
kubectl get pod myapp-pod -o yaml

# View previous logs
kubectl logs --previous myapp-pod

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Debug with temporary pod
kubectl debug myapp-pod -it --image=ubuntu
```

### 2. Service Problems
```bash
# Check service endpoints
kubectl get endpoints myservice

# Test DNS resolution
kubectl run temp --rm -it --image=busybox -- nslookup myservice

# View service details
kubectl describe service myservice
```

### 3. Node Problems
```bash
# Check node status
kubectl describe node problem-node

# View node metrics
kubectl top node problem-node

# Drain node
kubectl drain problem-node --ignore-daemonsets
```

## Azure-Specific Features

### 1. AKS Integration
```bash
# Get AKS versions
kubectl get nodes -o custom-columns=NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion

# View AKS load balancer
kubectl get service -o wide

# Check AKS storage classes
kubectl get storageclass
```

### 2. Azure Monitor Integration
```bash
# Get container insights
kubectl top pods --containers=true

# View container logs
kubectl logs -l app=myapp -c mycontainer

# Check container metrics
kubectl get --raw /apis/metrics.k8s.io/v1beta1/pods
```

### 3. Azure Identity Management
```bash
# View service accounts
kubectl get serviceaccount

# Check pod identity
kubectl describe pod myapp-pod | grep -A 5 Annotations
```

## Best Practices

### 1. Resource Management
- Use labels and selectors
- Implement resource quotas
- Follow naming conventions
- Regular resource cleanup

### 2. Security
```bash
# View RBAC roles
kubectl get roles --all-namespaces

# Check pod security context
kubectl get pod myapp-pod -o jsonpath='{.spec.securityContext}'

# View network policies
kubectl get networkpolicies
```

### 3. Monitoring
```bash
# Watch resource changes
kubectl get pods -w

# Monitor deployments
kubectl rollout status deployment/myapp

# Check resource usage
kubectl top pods --containers
```

## Integration Examples

### 1. Deployment Script
```bash
#!/bin/bash
# Application deployment script

deploy_app() {
  local name=$1
  local image=$2
  local replicas=$3
  
  kubectl create deployment $name \
    --image=$image \
    --replicas=$replicas
  
  kubectl expose deployment $name \
    --port=80 \
    --type=LoadBalancer
}

# Deploy applications
deploy_app "frontend" "myregistry.azurecr.io/frontend:v1" 3
deploy_app "backend" "myregistry.azurecr.io/backend:v1" 2
```

### 2. Monitoring Integration
```python
import subprocess
import json

def get_pod_metrics():
    result = subprocess.run([
        'kubectl', 'get', '--raw',
        '/apis/metrics.k8s.io/v1beta1/pods'
    ], capture_output=True, text=True)
    
    return json.loads(result.stdout)

def monitor_pods():
    metrics = get_pod_metrics()
    # Process and alert on metrics
```

### 3. GitOps Pipeline
```yaml
name: Deploy to AKS
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy to AKS
      run: |
        az aks get-credentials --resource-group ${{ secrets.RG_NAME }} --name ${{ secrets.CLUSTER_NAME }}
        kubectl apply -k overlays/production/
        kubectl rollout status deployment/myapp
