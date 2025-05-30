# arptables - ARP Table Management

## Overview
`arptables` is a tool for ARP packet filtering and mangling. It allows you to set up and maintain rules that control ARP packet processing in the Linux kernel, helping to protect against ARP spoofing and manage ARP traffic.

## Official Documentation
[arptables Documentation](https://linux.die.net/man/8/arptables)

## Basic Usage

### 1. Rule Management
```bash
# List all rules
arptables -L

# Add rule to block ARP
arptables -A INPUT --source-ip 192.168.1.100 -j DROP

# Delete rule
arptables -D INPUT --source-ip 192.168.1.100
```

### 2. Chain Operations
```bash
# Create new chain
arptables -N custom_chain

# Delete chain
arptables -X custom_chain

# Clear all rules
arptables -F
```

### 3. Basic Filtering
```bash
# Block specific MAC
arptables -A INPUT --source-mac 00:11:22:33:44:55 -j DROP

# Allow specific IP range
arptables -A INPUT --source-ip 192.168.1.0/24 -j ACCEPT

# Match operation type
arptables -A INPUT --opcode Request -j ACCEPT
```

## Cloud/Container Use Cases

### 1. Network Security
```bash
# Protect gateway
arptables -A INPUT --destination-ip 192.168.1.1 -j DROP

# Container network protection
arptables -A INPUT --source-ip 172.17.0.0/16 --opcode Request -j ACCEPT

# Cloud interface protection
arptables -A OUTPUT --out-interface eth0 --opcode Reply -j ACCEPT
```

### 2. ARP Spoofing Prevention
```bash
# Lock MAC-IP pairs
arptables -A INPUT \
    --source-mac 00:11:22:33:44:55 \
    --source-ip 192.168.1.100 \
    -j ACCEPT

# Block unauthorized responses
arptables -A INPUT --opcode Reply \
    ! --source-mac 00:11:22:33:44:55 \
    --source-ip 192.168.1.1 -j DROP

# Gateway protection
arptables -A OUTPUT --opcode Reply \
    --source-mac $(cat /sys/class/net/eth0/address) \
    -j ACCEPT
```

### 3. Network Isolation
```bash
# Isolate container networks
arptables -A FORWARD \
    --source-ip 172.17.0.0/16 \
    --destination-ip 192.168.1.0/24 -j DROP

# VLAN separation
arptables -A INPUT \
    --in-interface eth0.100 \
    --destination-ip 192.168.2.0/24 -j DROP

# Segment protection
arptables -A FORWARD \
    --in-interface br0 \
    --out-interface br1 -j DROP
```

## Advanced Features

### 1. State Tracking
```bash
# Match ARP operation types
arptables -A INPUT --opcode Request -j LOG

# Track MAC changes
arptables -A INPUT \
    ! --source-mac 00:11:22:33:44:55 \
    --source-ip 192.168.1.100 \
    -j LOG --log-prefix "ARP_SPOOF: "

# Monitor responses
arptables -A INPUT \
    --opcode Reply \
    -j LOG --log-prefix "ARP_REPLY: "
```

### 2. MAC Filtering
```bash
# Lock MAC-IP bindings
arptables -A INPUT \
    --source-mac 00:11:22:33:44:55 \
    --source-ip 192.168.1.100 \
    -j ACCEPT

# Block MAC spoofing
arptables -A INPUT \
    ! --source-mac $(cat /sys/class/net/eth0/address) \
    --source-ip 192.168.1.1 \
    -j DROP

# Whitelist MACs
arptables -A INPUT \
    -s 00:11:22:33:44:55 \
    -j ACCEPT
```

### 3. Interface Control
```bash
# Interface specific rules
arptables -A INPUT -i eth0 -j DROP

# VLAN filtering
arptables -A INPUT -i eth0.100 -j ACCEPT

# Bridge control
arptables -A FORWARD -i br0 -o br1 -j DROP
```

## Best Practices

### 1. Security Setup
```bash
# Basic protection
arptables -A INPUT --opcode Request -j ACCEPT
arptables -A INPUT --opcode Reply -j ACCEPT
arptables -P INPUT DROP

# Gateway protection
arptables -A INPUT \
    --destination-ip $(ip route | grep default | awk '{print $3}') \
    --opcode Request \
    -j ACCEPT

# MAC binding
arptables -A INPUT \
    --source-mac $(arp -n | grep "^192.168.1.1" | awk '{print $3}') \
    --source-ip 192.168.1.1 \
    -j ACCEPT
```

### 2. Performance
```bash
# Limit logging
arptables -A INPUT \
    --opcode Request \
    -j LOG --log-prefix "ARP_REQ: " --log-level 7

# Optimize chains
arptables -A INPUT -j ACCEPT
arptables -A OUTPUT -j ACCEPT

# Rate limiting
arptables -A INPUT \
    --source-ip 192.168.1.0/24 \
    -m limit --limit 10/s \
    -j ACCEPT
```

### 3. Maintenance
```bash
# Save rules
arptables-save > /etc/arptables.rules

# Restore rules
arptables-restore < /etc/arptables.rules

# Clear all rules
arptables -F && arptables -X
```

## Common Scenarios

### 1. ARP Security
```bash
# Prevent ARP spoofing
arptables -A INPUT \
    --source-ip 192.168.1.1 \
    ! --source-mac $(arp -n | grep "^192.168.1.1" | awk '{print $3}') \
    -j DROP

# Gateway protection
arptables -A INPUT \
    --destination-ip 192.168.1.1 \
    --opcode Request \
    -j LOG --log-prefix "GW_ARP: "

# Lock critical servers
arptables -A INPUT \
    --source-ip 192.168.1.10 \
    --source-mac 00:11:22:33:44:55 \
    -j ACCEPT
```

### 2. Network Management
```bash
# VLAN isolation
arptables -A FORWARD \
    -i eth0.100 \
    -o eth0.200 \
    -j DROP

# DMZ setup
arptables -A FORWARD \
    --source-ip 192.168.2.0/24 \
    --destination-ip 192.168.1.0/24 \
    -j DROP

# Server protection
arptables -A INPUT \
    --destination-ip 192.168.1.100 \
    --opcode Request \
    -j ACCEPT
```

### 3. Debugging
```bash
# Monitor ARP traffic
arptables -A INPUT \
    -j LOG --log-prefix "ARP: "

# Track changes
arptables -A INPUT \
    --opcode Reply \
    -j LOG --log-prefix "ARP_CHANGE: "

# Debug interface issues
arptables -A INPUT \
    -i eth0 \
    -j LOG --log-prefix "ETH0_ARP: "
```

## Troubleshooting

### Common Issues
1. Rule Problems
   ```bash
   # List all rules
   arptables -L -v

   # Check specific chain
   arptables -L INPUT

   # View counters
   arptables -L -v -n
   ```

2. MAC Binding Issues
   ```bash
   # Verify bindings
   arptables -L | grep MAC

   # Check specific IP
   arptables -L | grep "192.168.1.1"

   # Test MAC matching
   arptables -A INPUT -s 00:11:22:33:44:55 -j LOG
   ```

3. Performance Issues
   ```bash
   # Check rule count
   arptables -L | wc -l

   # Monitor hits
   arptables -L -v -n

   # Track drops
   arptables -L DROP -v
   ```

### Integration Tips
1. System Integration
   ```bash
   # Startup script
   cat > /etc/network/if-up.d/arptables <<EOF
   #!/bin/sh
   arptables-restore < /etc/arptables.rules
   EOF

   # Monitoring setup
   arptables -A INPUT -j LOG --log-prefix "ARP: "

   # Auto-save rules
   arptables-save > /etc/arptables.rules
   ```

2. Security Integration
   ```bash
   # IDS integration
   arptables -A INPUT \
     -j LOG --log-prefix "ARP_IDS: "

   # SIEM logging
   arptables -A INPUT \
     --opcode Reply \
     -j LOG --log-prefix "ARP_ALERT: "

   # Monitoring integration
   arptables -A INPUT \
     -m limit --limit 1/min \
     -j LOG --log-prefix "ARP_MON: "
   ```

3. Automation Support
   ```bash
   # Script support
   arptables -L -n | grep -q "192.168.1.1"

   # Rule generation
   for ip in $(cat protected_ips.txt); do
     arptables -A INPUT --destination-ip $ip -j ACCEPT
   done

   # Backup/restore
   arptables-save > rules_$(date +%F).bak
