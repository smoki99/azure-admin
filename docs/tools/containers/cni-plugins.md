# CNI (Container Network Interface) Plugins

## Overview

CNI plugins are a collection of networking plugins that enable container runtime environments to configure network interfaces in Linux containers. They are crucial for container networking in Kubernetes and other container platforms.

## Official Documentation
- [CNI Specification](https://github.com/containernetworking/cni/blob/master/SPEC.md)
- [CNI Plugins GitHub](https://github.com/containernetworking/plugins)
- [CNI Documentation](https://www.cni.dev/)

## Key Features
- Network interface configuration
- IP address management (IPAM)
- Multiple network support
- Network policy enforcement
- Bridge networking
- VLAN support
- Host-local IPAM
- Multinetwork capabilities

## Basic Usage

### Plugin Configuration
```bash
# Basic bridge configuration
cat << EOF > /etc/cni/net.d/10-bridge.conf
{
    "cniVersion": "0.4.0",
    "name": "mybridge",
    "type": "bridge",
    "bridge": "cni0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.88.0.0/16",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ]
    }
}
EOF

# Test configuration
cd /opt/cni/bin
./bridge < /etc/cni/net.d/10-bridge.conf
```

### Network Management
```bash
# Create network namespace
ip netns add container1

# Add interface to namespace
CNI_COMMAND=ADD CNI_CONTAINERID=container1 \
CNI_NETNS=/var/run/netns/container1 \
CNI_IFNAME=eth0 \
CNI_PATH=/opt/cni/bin \
./bridge < /etc/cni/net.d/10-bridge.conf
```

## Cloud/Container Use Cases

### 1. AKS Network Configuration

Configure networking in Azure Kubernetes Service:

```bash
# Azure CNI configuration
cat << EOF > /etc/cni/net.d/10-azure.conf
{
    "cniVersion": "0.3.0",
    "name": "azure",
    "type": "azure-vnet",
    "mode": "bridge",
    "bridge": "azure0",
    "ipam": {
        "type": "azure-vnet-ipam"
    },
    "dns": {
        "nameservers": ["168.63.129.16"]
    }
}
EOF

# Configure multiple networks
cat << EOF > /etc/cni/net.d/20-multus.conf
{
    "cniVersion": "0.3.0",
    "name": "multus-demo",
    "type": "multus",
    "delegates": [
        {
            "type": "azure-vnet",
            "name": "azure-vnet"
        },
        {
            "type": "bridge",
            "name": "secondary"
        }
    ]
}
EOF
```

### 2. Network Policy Implementation

Implement network policies:

```bash
# Calico policy configuration
cat << EOF > /etc/cni/net.d/10-calico.conf
{
    "name": "k8s-pod-network",
    "cniVersion": "0.3.1",
    "plugins": [
        {
            "type": "calico",
            "log_level": "info",
            "datastore_type": "kubernetes",
            "nodename": "node1",
            "ipam": {
                "type": "calico-ipam"
            },
            "policy": {
                "type": "k8s"
            },
            "kubernetes": {
                "kubeconfig": "/etc/cni/net.d/calico-kubeconfig"
            }
        }
    ]
}
EOF
```

### 3. Custom Network Configuration

Create custom network configurations:

```bash
# VLAN configuration
cat << EOF > /etc/cni/net.d/30-vlan.conf
{
    "cniVersion": "0.4.0",
    "name": "vlan-net",
    "type": "vlan",
    "master": "eth0",
    "vlanId": 100,
    "ipam": {
        "type": "host-local",
        "subnet": "10.1.100.0/24"
    }
}
EOF

# MACVLAN configuration
cat << EOF > /etc/cni/net.d/40-macvlan.conf
{
    "cniVersion": "0.4.0",
    "name": "macvlan-net",
    "type": "macvlan",
    "master": "eth0",
    "mode": "bridge",
    "ipam": {
        "type": "host-local",
        "subnet": "192.168.1.0/24",
        "rangeStart": "192.168.1.200",
        "rangeEnd": "192.168.1.250"
    }
}
EOF
```

## Common Scenarios

### 1. Troubleshooting Network Issues
```bash
# Check plugin status
ls -la /opt/cni/bin/
ls -la /etc/cni/net.d/

# Test plugin directly
CNI_COMMAND=ADD CNI_CONTAINERID=test \
CNI_NETNS=/var/run/netns/test \
CNI_IFNAME=eth0 \
CNI_PATH=/opt/cni/bin \
./bridge < /etc/cni/net.d/10-bridge.conf

# Debug logs
journalctl -u kubelet | grep cni
```

### 2. Network Performance
```bash
# MTU configuration
cat << EOF > /etc/cni/net.d/10-bridge-mtu.conf
{
    "cniVersion": "0.4.0",
    "name": "bridge-net",
    "type": "bridge",
    "mtu": 9000,
    "ipam": {
        "type": "host-local",
        "subnet": "10.88.0.0/16"
    }
}
EOF
```

### 3. Multiple Networks
```bash
# Configure multiple interfaces
cat << EOF > /etc/cni/net.d/99-multus.conf
{
    "cniVersion": "0.3.1",
    "name": "multus-demo",
    "type": "multus",
    "kubeconfig": "/etc/kubernetes/admin.conf",
    "delegates": [
        {
            "type": "bridge",
            "name": "primary"
        },
        {
            "type": "macvlan",
            "name": "secondary",
            "master": "eth1"
        }
    ]
}
EOF
```

## Azure-Specific Features

### 1. Azure CNI Configuration
```bash
# Basic Azure CNI setup
cat << EOF > /etc/cni/net.d/10-azure.conf
{
    "cniVersion": "0.3.0",
    "name": "azure",
    "type": "azure-vnet",
    "mode": "bridge",
    "bridge": "azure0",
    "ipam": {
        "type": "azure-vnet-ipam",
        "subnet": "10.240.0.0/16",
        "routes": [
            {
                "dst": "0.0.0.0/0"
            }
        ]
    }
}
EOF
```

### 2. Network Policy Integration
```bash
# Azure Network Policy
cat << EOF > /etc/cni/net.d/20-azure-policy.conf
{
    "cniVersion": "0.3.0",
    "name": "azure-policy",
    "type": "azure-npm",
    "mode": "transparent",
    "ipam": {
        "type": "azure-vnet-ipam"
    }
}
EOF
```

### 3. Custom Routes
```bash
# Azure custom routing
cat << EOF > /etc/cni/net.d/30-custom-routes.conf
{
    "cniVersion": "0.3.0",
    "name": "azure-custom",
    "type": "azure-vnet",
    "ipam": {
        "type": "azure-vnet-ipam"
    },
    "routes": [
        {
            "dst": "10.0.0.0/8",
            "gw": "10.240.0.1"
        }
    ]
}
EOF
```

## Best Practices

### 1. Configuration Management
```bash
# Version control configurations
git add /etc/cni/net.d/*.conf
git commit -m "Update CNI configurations"

# Use configuration templates
cat << EOF > cni-template.conf
{
    "cniVersion": "0.4.0",
    "name": "NETWORK_NAME",
    "type": "PLUGIN_TYPE",
    "ipam": {
        "type": "host-local",
        "subnet": "SUBNET_RANGE"
    }
}
EOF
```

### 2. Security
```bash
# Set proper permissions
chmod 600 /etc/cni/net.d/*.conf
chown root:root /etc/cni/net.d/*.conf

# Isolate networks
cat << EOF > /etc/cni/net.d/isolated-network.conf
{
    "cniVersion": "0.4.0",
    "name": "isolated",
    "type": "bridge",
    "isGateway": false,
    "ipMasq": false,
    "ipam": {
        "type": "host-local",
        "subnet": "10.99.0.0/16"
    }
}
EOF
```

### 3. Performance
```bash
# Optimize MTU
cat << EOF > /etc/cni/net.d/10-optimized.conf
{
    "cniVersion": "0.4.0",
    "name": "optimized",
    "type": "bridge",
    "mtu": 9000,
    "ipam": {
        "type": "host-local",
        "subnet": "10.88.0.0/16"
    }
}
EOF
```

## Integration Examples

### 1. Kubernetes Integration
```yaml
# NetworkAttachmentDefinition
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-conf
spec:
  config: '{
    "cniVersion": "0.3.0",
    "type": "macvlan",
    "master": "eth0",
    "mode": "bridge",
    "ipam": {
        "type": "host-local",
        "subnet": "192.168.1.0/24"
    }
}'
```

### 2. Automation Script
```bash
#!/bin/bash
# CNI configuration deployment

PLUGINS=("bridge" "host-local" "loopback" "portmap")
CNI_VERSION="v0.9.1"
CNI_DIR="/opt/cni/bin"

# Download and install plugins
for plugin in "${PLUGINS[@]}"; do
    curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/${plugin}" \
        -o "${CNI_DIR}/${plugin}"
    chmod +x "${CNI_DIR}/${plugin}"
done
```

### 3. Monitoring Setup
```bash
#!/bin/bash
# CNI monitoring script

check_network() {
    local ns=$1
    local interface=$2
    
    ip netns exec $ns ip addr show $interface
    ip netns exec $ns ping -c 1 8.8.8.8
}

# Monitor container networks
for ns in $(ip netns list); do
    check_network $ns eth0
done
