# magic-wormhole - Secure File Transfer Tool

## Overview
`magic-wormhole` provides a simple and secure way to transfer files and directories between computers. It generates a one-time code that allows secure peer-to-peer file transfer without requiring complex configuration.

## Official Documentation
[Magic Wormhole Documentation](https://magic-wormhole.readthedocs.io/)

## Basic Usage

### File Transfer
```bash
# Send file
wormhole send filename.txt

# Receive file
wormhole receive code-from-sender

# Send directory
wormhole send directory/
```

### Text Transfer
```bash
# Send text
wormhole send --text "secret message"

# Receive text
wormhole receive code-from-sender
```

## Cloud/Container Use Cases

### 1. Container Configuration
```bash
# Send container config
wormhole send docker-compose.yml

# Transfer secrets
wormhole send --text "$(cat .env)"

# Share certificates
wormhole send certs/
```

### 2. Cloud Credentials
```bash
# Send Azure credentials
wormhole send --text "$(az account show)"

# Transfer Kubernetes config
wormhole send ~/.kube/config

# Share SSH keys
wormhole send ~/.ssh/id_rsa.pub
```

### 3. Application Deployment
```bash
# Send deployment files
wormhole send deployment/

# Transfer configuration
wormhole send config/

# Share scripts
wormhole send scripts/*.sh
```

## Advanced Features

### 1. Custom Configuration
```bash
# Specify transit relay
wormhole --relay-url=wss://relay.example.com send file

# Use custom app ID
wormhole --appid=myapp send file

# Set timeout
wormhole --timeout=60 send file
```

### 2. Security Options
```bash
# Verify transfer
wormhole send --verify file

# Use custom code length
wormhole send --code-length=4 file

# No progressbar
wormhole send --hide-progress file
```

### 3. Directory Handling
```bash
# Send directory with filters
wormhole send --exclude="*.tmp" directory/

# Preserve permissions
wormhole send --mode=preserve directory/

# Include hidden files
wormhole send --include-hidden directory/
```

## Best Practices

### 1. Secure Transfer
```bash
# Use longer codes
wormhole send --code-length=6 sensitive-file

# Verify fingerprints
wormhole send --verify important-data

# Use timeouts
wormhole send --timeout=300 large-file
```

### 2. Large Transfers
```bash
# Monitor progress
wormhole send --progress large-file

# Handle interruptions
wormhole receive --accept-file code

# Resume transfer
wormhole receive --resume code
```

### 3. Batch Operations
```bash
# Send multiple files
tar czf - files/ | wormhole send

# Receive and extract
wormhole receive code | tar xzf -

# Stream transfer
wormhole send --text "$(backup_script)"
```

## Common Scenarios

### 1. DevOps Transfers
```bash
# Share configuration
wormhole send config.yaml

# Transfer scripts
wormhole send deploy.sh

# Share certificates
wormhole send --verify ssl/
```

### 2. Cloud Migration
```bash
# Transfer credentials
wormhole send --verify credentials/

# Share cloud config
wormhole send cloud-init.yaml

# Move templates
wormhole send templates/
```

### 3. Development Sharing
```bash
# Share code snippets
wormhole send --text "$(cat script.py)"

# Transfer project files
wormhole send project/

# Share dependencies
wormhole send requirements.txt
```

## Integration Examples

### 1. With Container Tools
```bash
# Share Docker context
wormhole send docker-context.tar

# Transfer compose files
wormhole send docker-compose*.yml

# Share container scripts
wormhole send container-init.sh
```

### 2. With Cloud Tools
```bash
# Share Azure templates
wormhole send azure-templates/

# Transfer AWS configs
wormhole send aws-config/

# Share Terraform files
wormhole send terraform/
```

### 3. With Development Tools
```bash
# Share git patches
git format-patch HEAD~1 | wormhole send

# Transfer database dumps
pg_dump database | wormhole send

# Share logs
journalctl | wormhole send --text
```

## Troubleshooting

### Common Issues
1. Connection problems
   ```bash
   # Check relay
   wormhole --relay-url=wss://relay.magic-wormhole.io send file
   
   # Use different relay
   wormhole --relay-url=wss://alternate.relay send file
   
   # Debug connection
   wormhole --debug send file
   ```

2. Transfer failures
   ```bash
   # Enable debug
   wormhole --debug receive code
   
   # Check network
   wormhole --dump-timing receive code
   
   # Verify transfer
   wormhole --verify send file
   ```

3. Timeout issues
   ```bash
   # Increase timeout
   wormhole --timeout=600 send large-file
   
   # Check progress
   wormhole --progress send file
   
   # Monitor status
   wormhole --debug send file
   ```

### Best Practices
1. Security
   ```bash
   # Always verify sensitive data
   wormhole --verify send sensitive-file
   
   # Use longer codes
   wormhole --code-length=6 send important-file
   
   # Check fingerprints
   wormhole --verify receive code
   ```

2. Performance
   ```bash
   # Compress large transfers
   tar czf - directory/ | wormhole send
   
   # Monitor progress
   wormhole --progress send large-file
   
   # Handle timeouts
   wormhole --timeout=300 send huge-file
   ```

3. Reliability
   ```bash
   # Enable debug for issues
   wormhole --debug send file
   
   # Use stable relay
   wormhole --relay-url=wss://reliable.relay send file
   
   # Handle interruptions
   wormhole --accept-file receive code
