# Development Tools Overview

This document provides an overview of development tools included in the Azure Admin Container environment. These tools are essential for cloud-native development, automation, and Azure service integration.

## Tool Categories

### Programming Languages and Runtimes

#### [Python](development/python.md)
- Python runtime environment
- pip package manager
- Virtual environment support
- Development tools and linters
- Azure SDK integration

#### [Node.js](development/nodejs.md)
- Node.js runtime
- npm package manager
- TypeScript support
- Development tools and linters
- Azure SDK integration

## Language Comparison

### Basic Setup

#### Python
```bash
# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Install packages
pip install -r requirements.txt
```

#### Node.js
```bash
# Initialize project
npm init -y

# Install packages
npm install
```

## Common Use Cases

### 1. Azure Service Integration

#### Python
```python
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

credential = DefaultAzureCredential()
blob_service = BlobServiceClient(account_url, credential)
```

#### Node.js
```javascript
const { DefaultAzureCredential } = require("@azure/identity");
const { BlobServiceClient } = require("@azure/storage-blob");

const credential = new DefaultAzureCredential();
const blobService = new BlobServiceClient(accountUrl, credential);
```

### 2. Container Development

#### Python
```python
import docker

client = docker.from_env()
container = client.containers.run("nginx", detach=True)
```

#### Node.js
```javascript
const Docker = require('dockerode');
const docker = new Docker();

const container = await docker.createContainer({
  Image: 'nginx',
  ExposedPorts: { '80/tcp': {} }
});
```

### 3. Kubernetes Integration

#### Python
```python
from kubernetes import client, config

config.load_kube_config()
v1 = client.CoreV1Api()
pods = v1.list_pod_for_all_namespaces()
```

#### Node.js
```javascript
const k8s = require('@kubernetes/client-node');

const kc = new k8s.KubeConfig();
kc.loadFromDefault();
const k8sApi = kc.makeApiClient(k8s.CoreV1Api);
```

## Feature Comparison

### Language Features

| Feature              | Python | Node.js | Notes                                |
|---------------------|--------|---------|--------------------------------------|
| Azure SDK           | ✓      | ✓       | Both have comprehensive SDK support  |
| Container Support   | ✓      | ✓       | Docker/Kubernetes integration        |
| Async Support       | ✓      | ✓       | Native async/await                   |
| Type Support        | Optional| ✓       | TypeScript in Node.js, typing in Python |
| Package Manager     | pip    | npm     | Both with lock file support         |
| Environment Mgmt    | venv   | nvm     | Isolation and version management    |

### Development Tools

| Tool Type           | Python | Node.js | Notes                                |
|---------------------|--------|---------|--------------------------------------|
| Linting            | pylint | eslint  | Code quality and style checking      |
| Formatting         | black  | prettier| Code formatting tools                |
| Testing           | pytest | jest    | Unit and integration testing         |
| Type Checking     | mypy   | tsc     | Static type analysis                 |
| Task Running      | make   | npm     | Build and automation tasks           |

## Best Practices

### Python Development
1. Always use virtual environments
2. Maintain requirements.txt
3. Use type hints when possible
4. Implement proper error handling
5. Follow PEP 8 style guide

### Node.js Development
1. Use TypeScript for large projects
2. Maintain package-lock.json
3. Implement proper error handling
4. Use async/await consistently
5. Follow ESLint configurations

## Common Scenarios

### 1. Azure Functions

#### Python
```python
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse("Hello from Python!")
```

#### Node.js
```javascript
module.exports = async function (context, req) {
    return {
        body: "Hello from Node.js!"
    };
};
```

### 2. API Development

#### Python
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/status")
async def get_status():
    return {"status": "healthy"}
```

#### Node.js
```javascript
const express = require('express');
const app = express();

app.get('/status', (req, res) => {
    res.json({ status: 'healthy' });
});
```

## Integration Examples

### 1. CI/CD Pipeline

#### Python
```yaml
# Azure Pipelines
steps:
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.9'
- script: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    pytest tests/
```

#### Node.js
```yaml
# Azure Pipelines
steps:
- task: NodeTool@0
  inputs:
    versionSpec: '16.x'
- script: |
    npm ci
    npm run build
    npm test
```

### 2. Development Container

#### Python
```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
CMD ["python", "app.py"]
```

#### Node.js
```dockerfile
FROM node:16-slim

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
CMD ["node", "app.js"]
```

## Additional Resources

### Documentation
- [Python Azure SDK](https://docs.microsoft.com/en-us/python/azure/)
- [Node.js Azure SDK](https://docs.microsoft.com/en-us/javascript/azure/)
- [Azure Functions Documentation](https://docs.microsoft.com/en-us/azure/azure-functions/)

### Tools and Extensions
- [Visual Studio Code](https://code.visualstudio.com/)
- [Azure Tools Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack)
- [Python Extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [Node.js Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.node-debug2)
