# Node.js Development Tools

## Overview

The Node.js development environment in the Azure Admin Container provides tools and libraries for cloud-native development, serverless functions, and Azure service integration.

## Official Documentation
- [Node.js Documentation](https://nodejs.org/docs/)
- [npm Documentation](https://docs.npmjs.com/)
- [Azure SDK for Node.js](https://docs.microsoft.com/en-us/azure/developer/javascript/)

## Key Features
- Node.js runtime
- npm package manager
- Azure SDK integration
- Development tools and linters
- Testing frameworks
- Azure Functions support
- Container integration
- TypeScript support

## Basic Usage

### Environment Setup
```bash
# Check Node.js version
node --version

# Check npm version
npm --version

# Initialize project
npm init -y

# Install TypeScript
npm install -g typescript
```

### Package Management
```bash
# Install package
npm install package-name

# Install development dependencies
npm install --save-dev package-name

# Install global package
npm install -g package-name

# Update packages
npm update

# List outdated packages
npm outdated
```

## Cloud/Container Use Cases

### 1. Azure SDK Integration

Work with Azure services:

```javascript
// Install Azure SDK
npm install @azure/identity @azure/storage-blob

// Azure Storage example
const { BlobServiceClient } = require("@azure/storage-blob");
const { DefaultAzureCredential } = require("@azure/identity");

async function uploadBlob() {
  const accountName = "mystorageaccount";
  const credential = new DefaultAzureCredential();
  
  const blobService = new BlobServiceClient(
    `https://${accountName}.blob.core.windows.net`,
    credential
  );
  
  const containerClient = blobService.getContainerClient("mycontainer");
  const blockBlobClient = containerClient.getBlockBlobClient("myfile.txt");
  
  await blockBlobClient.upload("Hello, World!", Buffer.byteLength("Hello, World!"));
}
```

### 2. Container Development

Work with containers:

```javascript
// Install Docker SDK
npm install dockerode

const Docker = require('dockerode');
const docker = new Docker();

// List containers
async function listContainers() {
  const containers = await docker.listContainers();
  console.log('Containers:', containers);
}

// Run container
async function runContainer() {
  const container = await docker.createContainer({
    Image: 'nginx',
    ExposedPorts: { '80/tcp': {} },
    HostConfig: {
      PortBindings: { '80/tcp': [{ HostPort: '8080' }] }
    }
  });
  await container.start();
}
```

### 3. Kubernetes Integration

Work with Kubernetes clusters:

```javascript
// Install Kubernetes client
npm install @kubernetes/client-node

const k8s = require('@kubernetes/client-node');

// Load cluster config
const kc = new k8s.KubeConfig();
kc.loadFromDefault();

// Create client
const k8sApi = kc.makeApiClient(k8s.CoreV1Api);

// List pods
async function listPods() {
  const res = await k8sApi.listNamespacedPod('default');
  console.log('Pods:', res.body.items);
}
```

## Common Scenarios

### 1. Azure Functions
```javascript
// Azure Function example
module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    const name = (req.query.name || (req.body && req.body.name));
    const responseMessage = name
        ? "Hello, " + name
        : "Please pass a name in the query string or request body";

    context.res = {
        status: 200,
        body: responseMessage
    };
}
```

### 2. API Development
```javascript
// Express API example
const express = require('express');
const app = express();

app.get('/api/status', (req, res) => {
    res.json({ status: 'healthy' });
});

app.listen(3000, () => {
    console.log('API server running on port 3000');
});
```

### 3. Azure Service Integration
```javascript
// Azure Key Vault integration
const { DefaultAzureCredential } = require("@azure/identity");
const { SecretClient } = require("@azure/keyvault-secrets");

async function getSecret() {
    const credential = new DefaultAzureCredential();
    const client = new SecretClient(
        "https://myvault.vault.azure.net",
        credential
    );
    
    const secret = await client.getSecret("my-secret");
    return secret.value;
}
```

## Azure-Specific Features

### 1. Azure Storage
```javascript
// Azure Blob Storage operations
const { BlobServiceClient } = require("@azure/storage-blob");

async function listBlobs() {
    const blobService = new BlobServiceClient(
        `https://${accountName}.blob.core.windows.net`,
        credential
    );
    
    const containerClient = blobService.getContainerClient("mycontainer");
    for await (const blob of containerClient.listBlobsFlat()) {
        console.log(blob.name);
    }
}
```

### 2. Azure CosmosDB
```javascript
// CosmosDB operations
const { CosmosClient } = require("@azure/cosmos");

const client = new CosmosClient({
    endpoint: process.env.COSMOS_ENDPOINT,
    key: process.env.COSMOS_KEY
});

async function queryItems() {
    const { resources } = await client
        .database("mydb")
        .container("mycollection")
        .items
        .query("SELECT * FROM c")
        .fetchAll();
    
    return resources;
}
```

### 3. Azure Service Bus
```javascript
// Service Bus messaging
const { ServiceBusClient } = require("@azure/service-bus");

async function sendMessage() {
    const sbClient = new ServiceBusClient(connectionString);
    const sender = sbClient.createSender("myqueue");
    
    await sender.sendMessages({
        body: "Hello, Service Bus!"
    });
    
    await sender.close();
    await sbClient.close();
}
```

## Best Practices

### 1. Development Setup
```bash
# Initialize TypeScript project
npm init -y
npm install --save-dev typescript @types/node
npx tsc --init

# Install development tools
npm install --save-dev eslint prettier jest
npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin

# Configure ESLint
cat << EOF > .eslintrc.js
module.exports = {
    parser: '@typescript-eslint/parser',
    plugins: ['@typescript-eslint'],
    extends: ['plugin:@typescript-eslint/recommended'],
    rules: {}
};
EOF
```

### 2. Security
```javascript
// Use environment variables
require('dotenv').config();

// Secure configuration
const config = {
    database: {
        host: process.env.DB_HOST,
        password: process.env.DB_PASSWORD
    },
    azure: {
        tenantId: process.env.AZURE_TENANT_ID,
        clientId: process.env.AZURE_CLIENT_ID
    }
};
```

### 3. Error Handling
```javascript
// Async error handling
async function handleOperation() {
    try {
        await someAsyncOperation();
    } catch (error) {
        if (error.code === 'AuthorizationFailed') {
            // Handle auth errors
        } else {
            // Handle other errors
        }
        throw error;
    }
}

// Global error handler
process.on('unhandledRejection', (error) => {
    console.error('Unhandled rejection:', error);
    process.exit(1);
});
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
- task: NodeTool@0
  inputs:
    versionSpec: '16.x'

- script: |
    npm ci
    npm run build
    npm test
  displayName: 'Build and test'

- task: PublishTestResults@2
  inputs:
    testResultsFormat: 'JUnit'
    testResultsFiles: '**/junit.xml'
```

### 2. Development Container
```dockerfile
FROM node:16-slim

# Install development tools
RUN npm install -g typescript eslint prettier

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build TypeScript
RUN npm run build

# Set environment variables
ENV NODE_ENV=production

# Command
CMD ["node", "dist/index.js"]
```

### 3. Monitoring Script
```javascript
// Azure resource monitoring
const { DefaultAzureCredential } = require("@azure/identity");
const { MonitorClient } = require("@azure/arm-monitor");

async function monitorResources() {
    const credential = new DefaultAzureCredential();
    const client = new MonitorClient(credential, subscriptionId);
    
    // Get metrics
    const metrics = await client.metrics.list(
        resourceUri,
        {
            timespan: "PT1H",
            interval: "PT1M",
            metricnames: "Percentage CPU"
        }
    );
    
    console.log("Metrics:", metrics);
}
