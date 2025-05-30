# helm

## Overview

Helm is the package manager for Kubernetes, helping you manage applications through Helm Charts. It simplifies the deployment and management of applications on Kubernetes clusters, especially in cloud environments like Azure Kubernetes Service (AKS).

## Official Documentation
- [Helm Documentation](https://helm.sh/docs/)
- [Helm Hub](https://artifacthub.io/)
- [Chart Development Guide](https://helm.sh/docs/chart_development/)

## Key Features
- Package management for Kubernetes
- Template rendering
- Release management
- Repository management
- Dependency handling
- Chart creation and sharing
- Rollback capabilities

## Basic Usage

### Chart Operations
```bash
# Add repository
helm repo add stable https://charts.helm.sh/stable

# Search for charts
helm search repo nginx

# Install chart
helm install my-release stable/nginx

# List releases
helm list

# Upgrade release
helm upgrade my-release stable/nginx
```

### Template Management
```bash
# Create new chart
helm create mychart

# Lint chart
helm lint mychart

# Template rendering
helm template mychart

# Package chart
helm package mychart
```

## Cloud/Container Use Cases

### 1. AKS Application Deployment

Deploy applications to Azure Kubernetes Service:

```bash
# Add Azure-specific repos
helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo

# Install Azure Monitor
helm install prometheus azure-marketplace/prometheus \
  --namespace monitoring \
  --create-namespace

# Deploy Azure-integrated app
cat << EOF > values.yaml
image:
  repository: myacr.azurecr.io/myapp
  tag: latest
azure:
  identity:
    enabled: true
  keyvault:
    enabled: true
EOF

helm install myapp ./myapp-chart -f values.yaml
```

### 2. Release Management

Handle application lifecycle:

```bash
# Check release status
helm status my-release

# View release history
helm history my-release

# Rollback to previous version
helm rollback my-release 1

# Upgrade with values
helm upgrade my-release stable/nginx \
  --set replicas=3 \
  --set resources.limits.memory=512Mi
```

### 3. Custom Chart Development

Create Azure-optimized charts:

```bash
# Create chart structure
helm create azure-app

# Edit Chart.yaml
cat << EOF > azure-app/Chart.yaml
apiVersion: v2
name: azure-app
version: 1.0.0
description: Azure-optimized application
dependencies:
  - name: redis
    version: 12.x.x
    repository: https://charts.bitnami.com/bitnami
EOF

# Create Azure-specific templates
cat << EOF > azure-app/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  template:
    metadata:
      labels:
        aadpodidbinding: {{ .Values.azure.identity.name }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
EOF
```

## Common Scenarios

### 1. Database Deployment
```bash
# Deploy Azure SQL
helm install db azure-marketplace/azure-sql \
  --set azure.location=westeurope \
  --set azure.resourceGroup=my-rg

# Deploy MongoDB
helm install mongodb bitnami/mongodb \
  --set auth.enabled=true \
  --set persistence.enabled=true
```

### 2. Ingress Setup
```bash
# Install NGINX Ingress
helm install ingress nginx-stable/nginx-ingress \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"=true

# Configure TLS
helm upgrade ingress nginx-stable/nginx-ingress \
  --set controller.extraArgs.default-ssl-certificate=default/tls-secret
```

### 3. Monitoring Stack
```bash
# Install Prometheus Stack
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.enabled=true \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=managed-premium
```

## Azure-Specific Features

### 1. Azure Integration
```bash
# Configure Azure AD integration
helm upgrade myapp ./myapp-chart \
  --set azure.identity.clientID=xxx \
  --set azure.identity.tenantID=xxx

# Setup Azure File storage
helm install myapp ./myapp-chart \
  --set persistence.storageClass=azurefile
```

### 2. AKS-Specific Configuration
```bash
# Enable Azure Monitor
helm upgrade myapp ./myapp-chart \
  --set azure.monitor.enabled=true \
  --set azure.monitor.workspace=xxx

# Configure Network Policy
helm upgrade myapp ./myapp-chart \
  --set networkPolicy.enabled=true
```

### 3. Azure Service Integration
```bash
# Redis Cache integration
helm upgrade myapp ./myapp-chart \
  --set azure.redis.host=xxx \
  --set azure.redis.key=xxx

# Azure Service Bus
helm upgrade myapp ./myapp-chart \
  --set azure.servicebus.connectionString=xxx
```

## Best Practices

### 1. Chart Design
- Use dependencies wisely
- Implement proper NOTES.txt
- Include proper documentation
- Follow naming conventions

### 2. Security Considerations
```bash
# Enable pod security
helm upgrade myapp ./myapp-chart \
  --set security.podSecurityContext.enabled=true

# Configure RBAC
helm upgrade myapp ./myapp-chart \
  --set rbac.create=true
```

### 3. Production Readiness
```bash
# Resource limits
helm upgrade myapp ./myapp-chart \
  --set resources.limits.cpu=1 \
  --set resources.limits.memory=1Gi

# High availability
helm upgrade myapp ./myapp-chart \
  --set replicaCount=3 \
  --set podAntiAffinity.enabled=true
```

## Integration Examples

### 1. CI/CD Pipeline
```yaml
# Azure DevOps pipeline
steps:
- task: HelmDeploy@0
  inputs:
    command: upgrade
    chartName: ./myapp-chart
    releaseName: myapp
    arguments: >
      --install 
      --set image.tag=$(Build.BuildId)
      --set azure.identity.clientID=$(AZURE_CLIENT_ID)
```

### 2. GitOps Configuration
```yaml
# Flux HelmRelease
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: myapp
spec:
  chart:
    spec:
      chart: ./myapp-chart
      sourceRef:
        kind: GitRepository
        name: myapp
  values:
    image:
      repository: myacr.azurecr.io/myapp
    azure:
      identity:
        enabled: true
```

### 3. Automated Testing
```bash
#!/bin/bash
# Test chart deployment

test_deployment() {
  helm upgrade --install test ./myapp-chart \
    --set image.tag=test \
    --wait
  
  kubectl run test-client \
    --image=busybox \
    --rm -it \
    --restart=Never \
    -- wget -qO- http://test-service
}

# Run tests
test_deployment
