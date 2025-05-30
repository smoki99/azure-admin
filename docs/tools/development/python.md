# Python Development Tools

## Overview

The Python development environment in the Azure Admin Container includes essential tools and libraries for cloud-native development, automation, and Azure service integration.

## Official Documentation
- [Python Azure SDK](https://docs.microsoft.com/en-us/python/azure/)
- [Python Documentation](https://docs.python.org/)
- [pip Documentation](https://pip.pypa.io/)

## Key Features
- Python Azure SDK
- Virtual environment support
- Package management with pip
- Development tools and linters
- Testing frameworks
- Azure CLI integration
- Cloud development utilities
- Container integration

## Basic Usage

### Virtual Environment
```bash
# Create virtual environment
python -m venv .venv

# Activate virtual environment
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows

# Deactivate virtual environment
deactivate
```

### Package Management
```bash
# Install packages
pip install azure-cli
pip install -r requirements.txt

# List installed packages
pip list

# Generate requirements file
pip freeze > requirements.txt

# Update packages
pip install --upgrade package_name
```

## Cloud/Container Use Cases

### 1. Azure SDK Integration

Work with Azure services:

```python
# Install Azure SDK components
pip install azure-identity azure-mgmt-resource azure-mgmt-compute

# Azure authentication and resource management
from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient

# Initialize credentials
credential = DefaultAzureCredential()

# Create resource management client
resource_client = ResourceManagementClient(
    credential,
    subscription_id
)

# List resource groups
for group in resource_client.resource_groups.list():
    print(group.name)
```

### 2. Container Development

Develop with containers:

```python
# Docker SDK integration
pip install docker

import docker

# Connect to Docker daemon
client = docker.from_env()

# List containers
containers = client.containers.list()

# Run container
container = client.containers.run(
    "nginx",
    detach=True,
    ports={'80/tcp': 8080}
)
```

### 3. Kubernetes Integration

Work with Kubernetes clusters:

```python
# Install Kubernetes client
pip install kubernetes

from kubernetes import client, config

# Load kube config
config.load_kube_config()

# Create API client
v1 = client.CoreV1Api()

# List pods
ret = v1.list_pod_for_all_namespaces()
for item in ret.items:
    print(f"{item.metadata.namespace}\t{item.metadata.name}")
```

## Common Scenarios

### 1. Azure Resource Management
```python
# Resource management example
from azure.mgmt.compute import ComputeManagementClient

# Create compute client
compute_client = ComputeManagementClient(
    credential,
    subscription_id
)

# List VMs
for vm in compute_client.virtual_machines.list_all():
    print(f"VM: {vm.name}")

# Start VM
compute_client.virtual_machines.begin_start(
    "myResourceGroup",
    "myVM"
)
```

### 2. Container Operations
```python
# Container management
import docker

client = docker.from_env()

# Build image
image, build_logs = client.images.build(
    path=".",
    tag="myapp:latest"
)

# Push to registry
client.images.push(
    "myregistry.azurecr.io/myapp",
    tag="latest"
)
```

### 3. Development Tools
```python
# Install development tools
pip install pylint pytest black

# Run linter
pylint myapp/

# Run tests
pytest tests/

# Format code
black .
```

## Azure-Specific Features

### 1. Azure Storage
```python
# Azure Storage operations
from azure.storage.blob import BlobServiceClient

# Create blob service client
blob_service_client = BlobServiceClient(
    account_url="https://mystorageaccount.blob.core.windows.net",
    credential=credential
)

# Upload file
with open("./myfile.txt", "rb") as data:
    blob_client = blob_service_client.get_blob_client(
        container="mycontainer",
        blob="myfile.txt"
    )
    blob_client.upload_blob(data)
```

### 2. Azure Functions
```python
# Azure Functions example
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    name = req.params.get('name', "World")
    return func.HttpResponse(f"Hello, {name}!")
```

### 3. Azure Monitor
```python
# Azure Monitor integration
from azure.monitor.query import LogsQueryClient

# Create client
logs_client = LogsQueryClient(credential)

# Query logs
response = logs_client.query_workspace(
    workspace_id="workspace_id",
    query="AzureActivity | limit 10"
)
```

## Best Practices

### 1. Development Setup
```bash
# Create project structure
mkdir myproject
cd myproject
python -m venv .venv
source .venv/bin/activate

# Install development tools
pip install pylint pytest black isort
pip install pre-commit

# Configure git hooks
cat << EOF > .pre-commit-config.yaml
repos:
-   repo: https://github.com/psf/black
    rev: stable
    hooks:
    - id: black
-   repo: https://github.com/pycqa/isort
    rev: 5.6.4
    hooks:
    - id: isort
EOF
```

### 2. Security
```python
# Use Azure Key Vault
from azure.keyvault.secrets import SecretClient

# Create client
key_vault_url = "https://my-keyvault.vault.azure.net/"
secret_client = SecretClient(
    vault_url=key_vault_url,
    credential=credential
)

# Get secret
secret = secret_client.get_secret("my-secret")
```

### 3. Performance
```python
# Use connection pooling
from azure.core.pipeline.transport import RequestsTransport

# Configure transport
transport = RequestsTransport(
    connection_pool_size=100
)

# Create client with transport
client = SecretClient(
    vault_url=key_vault_url,
    credential=credential,
    transport=transport
)
```

## Integration Examples

### 1. CI/CD Pipeline
```yaml
# Azure Pipelines example
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.9'

- script: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    pip install pytest pytest-cov
  displayName: 'Install dependencies'

- script: |
    pytest tests/ --doctest-modules --junitxml=junit/test-results.xml --cov=. --cov-report=xml
  displayName: 'Run tests'
```

### 2. Automation Script
```python
#!/usr/bin/env python3
"""Azure resource monitoring script."""

from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.monitor import MonitorManagementClient

def monitor_resources(subscription_id):
    """Monitor Azure resources."""
    credential = DefaultAzureCredential()
    
    # Create clients
    compute_client = ComputeManagementClient(credential, subscription_id)
    monitor_client = MonitorManagementClient(credential, subscription_id)
    
    # Monitor VMs
    for vm in compute_client.virtual_machines.list_all():
        metrics = monitor_client.metrics.list(
            vm.id,
            timespan="PT1H",
            interval="PT5M",
            metric_names=["Percentage CPU"]
        )
        print(f"VM {vm.name} metrics: {metrics}")

if __name__ == "__main__":
    monitor_resources("your-subscription-id")
```

### 3. Development Container
```dockerfile
FROM python:3.9-slim

# Install development tools
RUN pip install pylint pytest black isort pre-commit

# Install Azure tools
RUN pip install azure-cli azure-identity azure-mgmt-resource

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy source
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Command
CMD ["python", "app.py"]
