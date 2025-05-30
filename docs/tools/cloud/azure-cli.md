# Azure CLI Tools (az, aks, keyvault)

## Overview
The Azure Command-Line Interface (CLI) provides a comprehensive set of tools for managing Azure resources. This includes the core `az` command, Azure Kubernetes Service (AKS) management, and Azure Key Vault operations.

## Official Documentation
[Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)

## Basic Usage

### 1. Azure CLI (az)
```bash
# Login to Azure
az login

# Select subscription
az account set --subscription "subscription-name"

# List resources
az resource list

# Create resource group
az group create \
    --name myResourceGroup \
    --location eastus
```

### 2. AKS Management
```bash
# Create AKS cluster
az aks create \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --node-count 3

# Get credentials
az aks get-credentials \
    --resource-group myResourceGroup \
    --name myAKSCluster

# Scale cluster
az aks scale \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --node-count 5
```

### 3. Key Vault Operations
```bash
# Create Key Vault
az keyvault create \
    --name myKeyVault \
    --resource-group myResourceGroup \
    --location eastus

# Add secret
az keyvault secret set \
    --vault-name myKeyVault \
    --name mySecret \
    --value mySecretValue

# Get secret
az keyvault secret show \
    --vault-name myKeyVault \
    --name mySecret
```

## Cloud/Container Use Cases

### 1. Infrastructure Management
```bash
# Create virtual network
az network vnet create \
    --name myVNet \
    --resource-group myResourceGroup \
    --subnet-name mySubnet

# Deploy VM
az vm create \
    --resource-group myResourceGroup \
    --name myVM \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys

# Manage storage
az storage account create \
    --name mystorageaccount \
    --resource-group myResourceGroup \
    --sku Standard_LRS
```

### 2. Kubernetes Integration
```bash
# Enable monitoring
az aks enable-addons \
    --addons monitoring \
    --resource-group myResourceGroup \
    --name myAKSCluster

# Upgrade cluster
az aks upgrade \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --kubernetes-version 1.25.0

# Add node pool
az aks nodepool add \
    --resource-group myResourceGroup \
    --cluster-name myAKSCluster \
    --name mynodepool \
    --node-count 3
```

### 3. Security Management
```bash
# Configure RBAC
az role assignment create \
    --assignee user@example.com \
    --role "Contributor" \
    --scope /subscriptions/{id}

# Enable MSI
az vm identity assign \
    --resource-group myResourceGroup \
    --name myVM

# Configure Key Vault access
az keyvault set-policy \
    --name myKeyVault \
    --object-id {object-id} \
    --secret-permissions get list
```

## Advanced Features

### 1. Resource Management
```bash
# Deploy ARM template
az deployment group create \
    --resource-group myResourceGroup \
    --template-file template.json \
    --parameters parameters.json

# Tag resources
az resource tag \
    --tags Environment=Production \
    --ids /subscriptions/{id}/resourceGroups/myResourceGroup

# Lock resources
az lock create \
    --name myLock \
    --resource-group myResourceGroup \
    --lock-type CanNotDelete
```

### 2. Network Configuration
```bash
# Configure load balancer
az network lb create \
    --resource-group myResourceGroup \
    --name myLoadBalancer \
    --frontend-ip-name myFrontEndPool \
    --backend-pool-name myBackEndPool

# Set up peering
az network vnet peering create \
    --name myPeering \
    --resource-group myResourceGroup \
    --vnet-name myVNet1 \
    --remote-vnet myVNet2

# Configure firewall
az network firewall create \
    --name myFirewall \
    --resource-group myResourceGroup
```

### 3. Container Registry
```bash
# Create registry
az acr create \
    --resource-group myResourceGroup \
    --name myRegistry \
    --sku Standard

# Build container
az acr build \
    --registry myRegistry \
    --image myapp:v1 .

# Grant AKS access
az aks update \
    --name myAKSCluster \
    --resource-group myResourceGroup \
    --attach-acr myRegistry
```

## Best Practices

### 1. Security Configuration
```bash
# Enable MFA
az account login --use-device-code

# Configure service principal
az ad sp create-for-rbac \
    --name myServicePrincipal \
    --role Contributor

# Set up monitoring
az monitor diagnostic-settings create \
    --name myDiagnostics \
    --resource myResource
```

### 2. Resource Organization
```bash
# Create resource groups
az group create \
    --name myResourceGroup \
    --location eastus \
    --tags Environment=Production

# Apply tags
az resource tag \
    --tags Department=IT \
    --ids $(az resource list --query "[].id" -o tsv)

# Set up policies
az policy assignment create \
    --name myPolicy \
    --policy "Require tag on resource group"
```

### 3. Cost Management
```bash
# Get cost analysis
az consumption usage list \
    --start-date 2025-01-01 \
    --end-date 2025-01-31

# Set budget alerts
az consumption budget create \
    --name myBudget \
    --amount 1000

# View pricing
az vm list-sizes \
    --location eastus \
    --output table
```

## Common Scenarios

### 1. DevOps Integration
```bash
# Set up CI/CD
az pipelines create \
    --name myPipeline \
    --repository myRepo

# Configure webhooks
az webapp deployment container config \
    --enable-cd true \
    --name myApp

# Manage secrets
az keyvault secret download \
    --file secrets.env \
    --name mySecret \
    --vault-name myKeyVault
```

### 2. Disaster Recovery
```bash
# Create backup
az backup vault create \
    --name myVault \
    --resource-group myResourceGroup

# Set up replication
az site-recovery vault create \
    --name myRecoveryVault \
    --resource-group myResourceGroup

# Configure DR policy
az backup policy create \
    --name myPolicy \
    --vault-name myVault
```

### 3. Monitoring Setup
```bash
# Enable insights
az monitor app-insights component create \
    --app myApp \
    --resource-group myResourceGroup

# Set up alerts
az monitor alert create \
    --name myAlert \
    --resource-group myResourceGroup

# Configure log analytics
az monitor log-analytics workspace create \
    --workspace-name myWorkspace \
    --resource-group myResourceGroup
```

## Troubleshooting

### Common Issues
1. Authentication Problems
   ```bash
   # Clear credentials
   az account clear

   # Verify login
   az account show

   # Test service principal
   az login --service-principal \
       --username APP_ID \
       --password PASSWORD \
       --tenant TENANT_ID
   ```

2. Resource Issues
   ```bash
   # Check resource status
   az resource show \
       --ids /subscriptions/{id}/resourceGroups/myGroup/providers/Microsoft.Web/sites/myApp

   # Validate template
   az deployment group validate \
       --resource-group myResourceGroup \
       --template-file template.json

   # View activity log
   az monitor activity-log list \
       --resource-group myResourceGroup
   ```

3. Network Problems
   ```bash
   # Test connectivity
   az network watcher test-ip-flow \
       --direction Inbound \
       --protocol TCP \
       --local 10.0.0.4:80 \
       --remote 100.0.0.4:80

   # Check DNS
   az network dns record-set list \
       --resource-group myResourceGroup \
       --zone-name myzone.com

   # Verify peering
   az network vnet peering list \
       --resource-group myResourceGroup \
       --vnet-name myVNet
   ```

### Integration Tips
1. CI/CD Setup
   ```bash
   # Configure deployment credentials
   az webapp deployment user set \
       --user-name myUsername \
       --password myPassword

   # Set up deployment source
   az webapp deployment source config \
       --name myApp \
       --resource-group myResourceGroup \
       --repo-url https://github.com/myrepo

   # Configure build
   az webapp config set \
       --resource-group myResourceGroup \
       --name myApp \
       --linux-fx-version "NODE|14-lts"
   ```

2. Kubernetes Integration
   ```bash
   # Connect to cluster
   az aks get-credentials \
       --resource-group myResourceGroup \
       --name myAKSCluster \
       --admin

   # Configure monitoring
   az aks enable-addons \
       --addons monitoring \
       --resource-group myResourceGroup \
       --name myAKSCluster

   # Set up registry
   az aks update \
       --resource-group myResourceGroup \
       --name myAKSCluster \
       --attach-acr myRegistry
   ```

3. Security Configuration
   ```bash
   # Configure Key Vault access
   az keyvault set-policy \
       --name myKeyVault \
       --spn APP_ID \
       --secret-permissions get list

   # Enable MSI
   az webapp identity assign \
       --resource-group myResourceGroup \
       --name myApp

   # Set up firewall rules
   az keyvault network-rule add \
       --name myKeyVault \
       --ip-address 1.2.3.4/32
