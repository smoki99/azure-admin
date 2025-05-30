# Cloud-Native and Container Operations Cookbook

This directory contains 100 practical scenarios focused on container, Kubernetes, and cloud operations using the tools available in this container environment.

## Categories

### [Container Operations](./containers/) (25 scenarios)
Advanced container management scenarios using:
- buildah - Container image building
- podman - Container management and orchestration
- skopeo - Container image operations and registry management
- CNI plugins - Container networking
- nerdctl - Container runtime operations
- regctl - Registry operations

### [Kubernetes Operations](./kubernetes/) (25 scenarios)
Kubernetes administration and management using:
- kubectl - Kubernetes cluster management
- helm - Package management
- k9s - Cluster monitoring and management
- kustomize - Configuration management
- Azure-specific Kubernetes tooling

### [Cloud Infrastructure](./cloud/) (25 scenarios)
Azure cloud native operations focusing on:
- az CLI - Azure resource management
- AKS management
- Azure Container Registry
- Azure Key Vault integration
- Azure networking and security

### [Network Operations](./network/) (15 scenarios)
Container and cluster networking using:
- tcpdump - Network packet analysis
- iptables - Network policy management
- iperf3 - Network performance testing
- netcat - Network debugging
- socat - Network tunneling and forwarding
- mtr - Network path analysis

### [Security Operations](./cloud/) (10 scenarios)
Security-focused scenarios using:
- OpenSSL - Certificate management
- Container security tools
- Network security tools
- Azure security features
- Kubernetes security features

## Structure
Each scenario follows this structure:
```markdown
# Scenario Title

## Problem Statement
Clear description of the problem to solve

## Solution Overview
High-level solution approach

## Tools Used
List of specific tools from the container

## Implementation
Step-by-step solution with examples

## Validation
How to verify the solution works

## Common Issues
Potential problems and solutions

## Additional Notes
Best practices and alternatives
```

## Tool Categories Used

### Container Tools
- podman
- buildah
- skopeo
- nerdctl
- regctl
- CNI plugins

### Kubernetes Tools
- kubectl
- helm
- k9s
- kustomize

### Cloud Tools
- az (Azure CLI)
- aks
- az keyvault

### Network Analysis Tools
- tcpdump
- iperf3
- netcat
- socat
- mtr
- iptables
- bridge-utils

### Security Tools
- OpenSSL
- container security features
- network security tools

## Progress Tracking
Progress for each category is tracked in the [Active Context](../../memory-bank/activeContext.md) file.
