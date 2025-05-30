# Securing SSH Access with Key-Based Authentication

## Problem Statement
You need to set up secure, key-based SSH authentication and disable password-based login to enhance system security.

## Solution
Use SSH key pairs and configure SSH daemon settings to enforce key-based authentication while disabling password login.

## Tools Used
- ssh-keygen
- ssh-copy-id
- vim/neovim
- sshd

## Implementation

### 1. Generate SSH Key Pair
```bash
# Generate RSA key pair
ssh-keygen -t rsa -b 4096 -C "user@example.com"

# Generate ED25519 key (more secure)
ssh-keygen -t ed25519 -C "user@example.com"

# Generate key with custom filename
ssh-keygen -t ed25519 -f ~/.ssh/custom_key -C "user@example.com"
```

### 2. Transfer Public Key to Server
```bash
# Using ssh-copy-id
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@remote_host

# Manual transfer
cat ~/.ssh/id_ed25519.pub | ssh user@remote_host \
    "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# Set correct permissions
ssh user@remote_host "chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"
```

### 3. Configure SSH Daemon
```bash
# Backup original configuration
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Edit SSH configuration
sudo vim /etc/ssh/sshd_config

# Key settings to modify
PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password
```

### 4. Test Configuration
```bash
# Test sshd configuration
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd

# Try connecting with key
ssh -i ~/.ssh/id_ed25519 user@remote_host
```

## Validation

### 1. Test Key Authentication
```bash
# Test normal connection
ssh user@remote_host

# Test with specific key
ssh -i ~/.ssh/custom_key user@remote_host

# Verify connection details
ssh -v user@remote_host
```

### 2. Test Security Settings
```bash
# Attempt password login (should fail)
ssh -o PubkeyAuthentication=no user@remote_host

# Check SSH daemon status
sudo systemctl status sshd

# Monitor authentication attempts
sudo tail -f /var/log/auth.log
```

### 3. Check Permissions
```bash
# Local SSH directory
ls -la ~/.ssh/

# Remote SSH directory
ssh user@remote_host "ls -la ~/.ssh/"

# Check SELinux context (if applicable)
ls -Z ~/.ssh/
```

## Common Issues

### 1. Permission Problems
```bash
# Fix local permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Fix remote permissions
ssh user@remote_host "chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"
```

### 2. Key Issues
```bash
# Check key format
ssh-keygen -l -f ~/.ssh/id_ed25519

# Verify key presence
ssh-keygen -l -f ~/.ssh/id_ed25519.pub

# Test key matching
diff <(ssh-keygen -y -f ~/.ssh/id_ed25519) ~/.ssh/id_ed25519.pub
```

### 3. Connection Problems
```bash
# Debug connection
ssh -vvv user@remote_host

# Check SSH agent
ssh-add -l

# Test with different key
ssh -i ~/.ssh/different_key user@remote_host
```

## Additional Notes

### Best Practices
1. Use ED25519 keys when possible
2. Always backup SSH configuration before changes
3. Keep private keys secure and never share them
4. Use different keys for different purposes
5. Regularly audit authorized_keys files

### Multi-User Setup
```bash
# Create new user
sudo useradd -m newuser

# Set up SSH directory
sudo -u newuser mkdir -p ~newuser/.ssh
sudo -u newuser chmod 700 ~newuser/.ssh

# Add authorized key
sudo -u newuser sh -c 'echo "ssh-ed25519 AAAA..." > ~/.ssh/authorized_keys'
sudo -u newuser chmod 600 ~newuser/.ssh/authorized_keys
```

### SSH Agent Configuration
```bash
# Start SSH agent
eval $(ssh-agent)

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# List added keys
ssh-add -l

# Configure agent in ~/.ssh/config
cat > ~/.ssh/config <<EOF
Host *
    AddKeysToAgent yes
    UseKeychain yes
EOF
```

### Key Rotation
```bash
# Generate new key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_new

# Add new key to authorized_keys
ssh-copy-id -i ~/.ssh/id_ed25519_new.pub user@remote_host

# Remove old key
ssh user@remote_host "grep -v '$(cat ~/.ssh/id_ed25519.pub)' \
    ~/.ssh/authorized_keys > ~/.ssh/authorized_keys.tmp && \
    mv ~/.ssh/authorized_keys.tmp ~/.ssh/authorized_keys"
```

### Security Hardening
```bash
# Configure SSH hardening options
cat >> /etc/ssh/sshd_config <<EOF
Protocol 2
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
EOF

# Set login grace time
echo "LoginGraceTime 30" >> /etc/ssh/sshd_config

# Enable strict mode
echo "StrictModes yes" >> /etc/ssh/sshd_config

# Set max auth tries
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
