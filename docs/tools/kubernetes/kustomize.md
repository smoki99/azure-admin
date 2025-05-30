# kustomize

## Overview

kustomize is a powerful tool for Kubernetes configuration management that allows you to customize application configurations without modifying original YAML files. It's particularly useful for managing configurations across different environments in cloud deployments.

## Official Documentation
- [Kustomize GitHub](https://github.com/kubernetes-sigs/kustomize)
- [Kustomize Documentation](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/)
- [Examples Repository](https://github.com/kubernetes-sigs/kustomize/tree/master/examples)

## Key Features
- Template-free configuration customization
- Base and overlay management
- Resource patching
- Cross-cutting fields modification
- ConfigMap/Secret generation
- Resource composition
- Built into kubectl

## Basic Usage

### Project Structure
```bash
# Basic structure
./base
  kustomization.yaml
  deployment.yaml
  service.yaml
./overlays
  development
    kustomization.yaml
  production
    kustomization.yaml
```

### Common Commands
```bash
# Build kustomization
kustomize build overlays/production

# Apply kustomization
kubectl apply -k overlays/production

# View resources
kubectl kustomize overlays/production

# Edit kustomization
kustomize edit add resource deployment.yaml
```

## Cloud/Container Use Cases

### 1. AKS Environment Management

Manage configurations across AKS environments:

```bash
# Base kustomization.yaml
cat << EOF > base/kustomization.yaml
resources:
- deployment.yaml
- service.yaml
commonLabels:
  app: myapp
EOF

# Development overlay
cat << EOF > overlays/development/kustomization.yaml
bases:
- ../../base
namePrefix: dev-
patchesStrategicMerge:
- resources-patch.yaml
images:
- name: myapp
  newName: myacr.azurecr.io/myapp
  newTag: dev
EOF

# Production overlay
cat << EOF > overlays/production/kustomization.yaml
bases:
- ../../base
namePrefix: prod-
patchesStrategicMerge:
- resources-patch.yaml
- hpa-patch.yaml
images:
- name: myapp
  newName: myacr.azurecr.io/myapp
  newTag: stable
EOF
```

### 2. Resource Management

Handle different resource configurations:

```bash
# Base deployment
cat << EOF > base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  template:
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
EOF

# Production resource patch
cat << EOF > overlays/production/resources-patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  template:
    spec:
      containers:
      - name: myapp
        resources:
          requests:
            memory: "256Mi"
            cpu: "500m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
EOF
```

### 3. Azure Integration

Configure Azure-specific settings:

```bash
# Base pod identity
cat << EOF > base/pod-identity.yaml
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: myapp-identity
spec:
  type: 0
  resourceID: /subscriptions/xxx/resourcegroups/xxx/providers/Microsoft.ManagedIdentity/userAssignedIdentities/xxx
  clientID: xxx
EOF

# Environment-specific configuration
cat << EOF > overlays/production/identity-patch.yaml
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: myapp-identity
spec:
  resourceID: /subscriptions/xxx/resourcegroups/prod-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/prod-identity
  clientID: xxx
EOF
```

## Common Scenarios

### 1. ConfigMap Management
```bash
# Generate ConfigMap in kustomization.yaml
configMapGenerator:
- name: myapp-config
  files:
  - config.properties
  - settings.json
  literals:
  - ENVIRONMENT=production
  - LOG_LEVEL=info

# Automatic hash suffix
cat << EOF > kustomization.yaml
configMapGenerator:
- name: myapp-config
  behavior: create
  files:
  - application.properties
EOF
```

### 2. Secret Management
```bash
# Generate Secret
secretGenerator:
- name: myapp-secrets
  files:
  - secrets/tls.crt
  - secrets/tls.key
  type: kubernetes.io/tls

# Environment-specific secrets
cat << EOF > overlays/production/secrets-patch.yaml
apiVersion: v1
kind: Secret
metadata:
  name: myapp-secrets
stringData:
  API_KEY: "prod-key"
EOF
```

### 3. Namespace Management
```bash
# Base namespace
cat << EOF > base/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: myapp
EOF

# Environment namespaces
cat << EOF > overlays/development/namespace-patch.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: myapp
  labels:
    environment: development
EOF
```

## Azure-Specific Features

### 1. AKS Configuration
```bash
# Azure Load Balancer annotation
cat << EOF > overlays/production/service-patch.yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
    service.beta.kubernetes.io/azure-load-balancer-internal-subnet: "internal"
EOF
```

### 2. Storage Configuration
```bash
# Azure storage class
cat << EOF > overlays/production/storage-patch.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myapp-storage
spec:
  storageClassName: managed-premium
EOF
```

### 3. Network Policies
```bash
# Azure CNI policy
cat << EOF > overlays/production/network-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: myapp-policy
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Ingress
  - Egress
EOF
```

## Best Practices

### 1. Project Structure
- Keep base configurations minimal
- Use meaningful overlay names
- Maintain clear documentation
- Version control everything

### 2. Resource Management
```bash
# Use strategic merge patches
patchesStrategicMerge:
- deployment-resources.yaml
- service-annotations.yaml

# Use JSON patches for precise changes
patchesJson6902:
- target:
    group: apps
    version: v1
    kind: Deployment
    name: myapp
  path: patch.yaml
```

### 3. Version Control
```bash
# Use build output in CI/CD
kustomize build overlays/production > k8s-manifests.yaml

# Review changes
kustomize build overlays/production | kubectl diff -f -

# Apply changes
kustomize build overlays/production | kubectl apply -f -
```

## Integration Examples

### 1. CI/CD Pipeline
```yaml
# Azure DevOps pipeline
steps:
- script: |
    kustomize build overlays/$(Environment) > manifests.yaml
    kubectl apply -f manifests.yaml
  displayName: 'Deploy to AKS'
```

### 2. GitOps Configuration
```yaml
# Flux Kustomization
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: myapp
spec:
  interval: 1m
  path: ./overlays/production
  sourceRef:
    kind: GitRepository
    name: myapp
  validation: client
```

### 3. Development Workflow
```bash
#!/bin/bash
# Development workflow script

# Build and test locally
kustomize build overlays/development | kubectl apply -f -

# Validate production config
kustomize build overlays/production | kubectl apply --dry-run=client -f -

# Deploy to production
kustomize build overlays/production | kubectl apply -f -
