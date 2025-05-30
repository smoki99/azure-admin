# Azure Admin Container Tools Documentation

This documentation covers all tools and utilities included in the Azure Admin Container environment. The tools are organized by category for easy reference.

## Getting Started
- [Container Setup and Configuration](container-setup.md) - Container setup, configuration, and usage

## Tool Categories

### [Network Tools](tools/network-analysis-tools.md)
- [iperf3](tools/network/iperf3.md) - Network bandwidth testing
- [mtr](tools/network/mtr.md) - Network diagnostics and troubleshooting
- [netcat](tools/network/netcat.md) - Network connection testing
- [socat](tools/network/socat.md) - Multipurpose relay tool
- [tcpdump](tools/network/tcpdump.md) - Packet analysis

### [Kubernetes Tools](tools/kubernetes-tools.md)
- [kubectl](tools/kubernetes/kubectl.md) - Kubernetes command-line tool
- [k9s](tools/kubernetes/k9s.md) - Terminal UI for Kubernetes
- [helm](tools/kubernetes/helm.md) - Kubernetes package manager
- [kustomize](tools/kubernetes/kustomize.md) - Kubernetes configuration management

### [Container Tools](tools/container-tools.md)
- [Podman](tools/containers/podman.md) - Container management
- [Buildah](tools/containers/buildah.md) - Container image building
- [Skopeo](tools/containers/skopeo.md) - Container image management
- [CNI Plugins](tools/containers/cni-plugins.md) - Container networking
- [nerdctl](tools/containers/nerdctl.md) - containerd CLI tool
- [lazydocker](tools/containers/lazydocker.md) - Docker TUI

### [DNS Tools](tools/dns-and-misc-tools.md)
- [dog](tools/dns/dog.md) - DNS lookup client
- [drill](tools/dns/drill.md) - DNS debugging tool

### [Development Tools](tools/development-tools.md)
- [Python](tools/development/python.md) - Python development environment
- [Node.js](tools/development/nodejs.md) - Node.js development environment

## Quick Start

### Container Setup
```bash
# Build container
podman build -t azure-admin-container .

# Run container
podman run -it \
  -v $HOME/.azure:/root/.azure \
  -v $HOME/.kube:/root/.kube \
  azure-admin-container
```

### Network Analysis
```bash
# Bandwidth testing
iperf3 -c server

# Network troubleshooting
mtr hostname

# Packet capture
tcpdump -i any port 80
```

### Container Management
```bash
# Run container
podman run -d nginx

# Build image
buildah bud -t myapp .

# Copy image
skopeo copy docker://source docker://destination

# Monitor containers
lazydocker
```

### Kubernetes Operations
```bash
# Get cluster info
kubectl cluster-info

# Deploy application
helm install myapp ./chart

# Monitor resources
k9s

# Apply configuration
kustomize build ./overlay | kubectl apply -f -
```

### DNS Operations
```bash
# DNS lookup
dog example.com

# DNS debugging
drill example.com

# Azure DNS query
dog @168.63.129.16 myapp.azurewebsites.net
```

### Development
```bash
# Python virtual environment
python -m venv .venv
source .venv/activate
pip install -r requirements.txt

# Node.js project
npm init -y
npm install
```

## Best Practices

### Container Operations
1. Use rootless containers when possible
2. Implement proper image tagging
3. Regular security scanning
4. Maintain proper logging
5. Use multi-stage builds

### Network Analysis
1. Regular bandwidth monitoring
2. Packet capture for debugging
3. Connection testing
4. Performance baseline establishment
5. Security monitoring

### Kubernetes Management
1. Use version control for manifests
2. Implement proper RBAC
3. Regular resource monitoring
4. Backup critical configurations
5. Use namespaces for isolation

### DNS Operations
1. Regular DNS health checks
2. DNSSEC validation
3. Multiple nameserver testing
4. Azure DNS integration
5. Service discovery validation

### Development
1. Use virtual environments
2. Maintain dependency documentation
3. Implement proper error handling
4. Regular security updates
5. Follow language-specific best practices

## Azure Integration

### Authentication
```bash
# Azure login
az login

# Set subscription
az account set --subscription <subscription-id>
```

### Container Registry
```bash
# Login to ACR
podman login myregistry.azurecr.io

# Push image
buildah push myregistry.azurecr.io/myapp:latest
```

### Kubernetes Service
```bash
# Get AKS credentials
az aks get-credentials --resource-group myRG --name myAKS

# Deploy to AKS
kubectl apply -f deployment.yaml
```

## Additional Resources

### Documentation
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Container Tools](https://github.com/containers)

### Community Resources
- [Azure Community](https://techcommunity.microsoft.com/t5/azure/ct-p/Azure)
- [Kubernetes Community](https://kubernetes.io/community/)
- [Python Community](https://www.python.org/community/)
- [Node.js Community](https://nodejs.org/en/get-involved/)

### Learning Resources
- [Azure Learn](https://docs.microsoft.com/en-us/learn/azure/)
- [Kubernetes Learn](https://kubernetes.io/training/)
- [Container Security](https://docs.docker.com/develop/security-best-practices/)
