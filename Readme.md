# Azure Admin Container

A comprehensive container environment for Azure administration, containing essential tools for cloud, container, and network management.

## Quick Start

### Using Docker

1. Build the container:
```bash
# Build with Docker
docker build -t azure-admin .

# Or build with Buildah
buildah bud -t azure-admin .
```

2. Run the container:
```bash
# Run with Docker (privileged mode required for Podman/Buildah)
docker run -it --privileged \
  -v $HOME/.azure:/root/.azure \
  -v $HOME/.kube:/root/.kube \
  azure-admin bash

# Or run with Podman (privileged mode required)
podman run -it --privileged \
  -v $HOME/.azure:/root/.azure \
  -v $HOME/.kube:/root/.kube \
  azure-admin bash
```

### Using Kubernetes

1. Push the container to a registry:
```bash
# Tag for your registry
docker tag azure-admin smoki99/azure-admin:lastest
docker tag azure-admin smoki99/azure-admin:1.0.x

# Push to registry
docker push smoki99/azure-admin:latest
docker push smoki99/azure-admin:1.0.x
```

2. Create a Pod YAML:
```yaml
# admin-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: azure-admin
spec:
  containers:
  - name: azure-admin
    image: myregistry.azurecr.io/azure-admin-container:latest
    command: ["sleep", "infinity"]
    volumeMounts:
    - name: azure-config
      mountPath: /root/.azure
    - name: kube-config
      mountPath: /root/.kube
  volumes:
  - name: azure-config
    hostPath:
      path: /home/user/.azure
  - name: kube-config
    hostPath:
      path: /home/user/.kube
```

3. Deploy and access the Pod:
```bash
# Create the pod
kubectl apply -f admin-pod.yaml

# Access the container
kubectl exec -it azure-admin -- bash
```

## Features

- Documentation viewer (glow)
- Network analysis tools
- Kubernetes tools
- Container management
- DNS tools
- Development environments

## Documentation

Full documentation is available inside the container and can be accessed using:

```bash
# View documentation index
glow /docs/README.md

# View container setup guide
glow /docs/container-setup.md
```

## Tool Categories

- Network Tools (iperf3, mtr, netcat, socat, tcpdump)
- Kubernetes Tools (kubectl, k9s, helm, kustomize)
- Container Tools (Podman, Buildah, Skopeo, CNI plugins)
- DNS Tools (dog, drill)
- Development Tools (Python, Node.js)

## Directory Structure

```
/docs/
├── README.md
├── container-setup.md
└── tools/
    ├── network/
    ├── kubernetes/
    ├── containers/
    ├── dns/
    └── development/
```

## Security Notes

1. Mount sensitive configurations carefully
2. Use registry authentication
3. Keep container updated
4. Review mounted volumes
5. Use RBAC in Kubernetes

## Support

For more information, view the documentation inside the container using:
```bash
glow /docs/README.md
