# iptables & Related Tools - Network Packet Filtering

## Overview
The `iptables` suite and related tools (`ipset`, `ebtables`, `arptables`) provide comprehensive network packet filtering, Network Address Translation (NAT), and packet mangling for Linux systems. These tools are essential for container networking, security, and traffic management.

## Official Documentation
- [iptables Manual](https://netfilter.org/documentation/)
- [ipset Documentation](https://ipset.netfilter.org/)
- [ebtables Documentation](http://ebtables.netfilter.org/)

## Basic Usage

### iptables Fundamentals
```bash
# List rules
iptables -L

# List rules with details
iptables -L -v -n

# Add basic rule
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

### Common Rule Sets
```bash
# Allow SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Drop everything else
iptables -P INPUT DROP
```

## Cloud/Container Use Cases

### 1. Container Network Security
```bash
# Allow container network
iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT

# Container NAT
iptables -t nat -A POSTROUTING -s 172.17.0.0/16 -j MASQUERADE

# Container port forwarding
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j DNAT --to 172.17.0.2:8080
```

### 2. Kubernetes Network Policies
```bash
# Allow pod communication
iptables -A FORWARD -s 10.244.0.0/16 -j ACCEPT

# Pod isolation
iptables -A FORWARD -i cni0 -o cni0 -j DROP

# Service routing
iptables -t nat -A PREROUTING -p tcp -d 10.96.0.1 --dport 443 -j DNAT --to-destination 10.244.0.10:8443
```

### 3. Cloud Security Groups
```bash
# Simulate security group
iptables -N CLOUD_SG_WEB
iptables -A CLOUD_SG_WEB -p tcp --dport 80 -j ACCEPT
iptables -A CLOUD_SG_WEB -p tcp --dport 443 -j ACCEPT

# Apply to interface
iptables -A INPUT -i eth0 -j CLOUD_SG_WEB
```

## Advanced Features

### 1. ipset Usage
```bash
# Create IP set
ipset create blacklist hash:ip

# Add IPs to set
ipset add blacklist 192.168.1.100
ipset add blacklist 192.168.1.101

# Use in iptables
iptables -A INPUT -m set --match-set blacklist src -j DROP
```

### 2. ebtables for Bridge Control
```bash
# Filter bridge traffic
ebtables -A FORWARD -p IPv4 --ip-proto tcp --ip-dport 80 -j DROP

# MAC address filtering
ebtables -A INPUT -s 00:11:22:33:44:55 -j DROP

# VLAN filtering
ebtables -A FORWARD -p 802_1Q --vlan-id 100 -j DROP
```

### 3. arptables for ARP Control
```bash
# Block ARP spoofing
arptables -A INPUT --source-mac 00:11:22:33:44:55 --source-ip 192.168.1.100 -j DROP

# Allow specific ARP
arptables -A INPUT --source-mac 00:11:22:33:44:55 -j ACCEPT

# Drop unknown
arptables -P INPUT DROP
```

## Best Practices

### 1. Basic Security Setup
```bash
# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
```

### 2. Container Security
```bash
# Container isolation
iptables -A FORWARD -i docker0 -o docker0 -j DROP

# Container NAT
iptables -t nat -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE

# Container logging
iptables -A FORWARD -i docker0 -j LOG --log-prefix "DOCKER: "
```

### 3. Rate Limiting
```bash
# Limit SSH connections
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m limit --limit 3/min -j ACCEPT

# Limit HTTP requests
iptables -A INPUT -p tcp --dport 80 -m limit --limit 20/second -j ACCEPT

# ICMP rate limiting
iptables -A INPUT -p icmp -m limit --limit 1/second -j ACCEPT
```

## Common Scenarios

### 1. Web Server Protection
```bash
# Allow HTTP/HTTPS
iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

# Rate limit connections
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 20 -j DROP

# Block common attacks
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
```

### 2. Database Security
```bash
# Allow specific clients
iptables -A INPUT -p tcp --dport 5432 -s 192.168.1.0/24 -j ACCEPT

# Rate limit connections
iptables -A INPUT -p tcp --dport 5432 -m connlimit --connlimit-above 50 -j DROP

# Log rejected
iptables -A INPUT -p tcp --dport 5432 -j LOG --log-prefix "DB_REJECT: "
```

### 3. Container Network Security
```bash
# Inter-container communication
iptables -A FORWARD -i docker0 -o docker0 -j ACCEPT

# External access
iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o docker0 -m state --state ESTABLISHED,RELATED -j ACCEPT
```

## Integration Examples

### 1. With Kubernetes
```bash
# Allow pod communication
iptables -A FORWARD -s 10.244.0.0/16 -d 10.244.0.0/16 -j ACCEPT

# Service routing
iptables -t nat -A PREROUTING -p tcp -d 10.96.0.0/16 -j KUBE-SERVICES

# Pod isolation
iptables -A FORWARD -s 10.244.0.0/16 -j KUBE-FORWARD
```

### 2. With Docker
```bash
# Container NAT
iptables -t nat -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE

# Port publishing
iptables -t nat -A DOCKER -p tcp --dport 80 -j DNAT --to-destination 172.17.0.2:80

# Container networks
iptables -A DOCKER-USER -j RETURN
```

### 3. With Cloud Infrastructure
```bash
# VPC routing
iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.0/8 -j MASQUERADE

# Load balancing
iptables -t nat -A PREROUTING -p tcp --dport 80 -m statistic --mode nth --every 3 --packet 0 -j DNAT --to-destination 10.0.1.10:80

# Security groups
iptables -A FORWARD -m set --match-set aws-security-group src -j ACCEPT
```

## Troubleshooting

### Common Issues
1. Connection tracking issues
   ```bash
   # Clear conntrack table
   conntrack -F
   
   # Monitor connections
   watch -n1 'cat /proc/net/nf_conntrack | wc -l'
   ```

2. Rule ordering problems
   ```bash
   # List rules with numbers
   iptables -L --line-numbers
   
   # Insert rule at specific position
   iptables -I INPUT 3 -p tcp --dport 80 -j ACCEPT
   ```

3. NAT debugging
   ```bash
   # Show NAT rules
   iptables -t nat -L -v -n
   
   # Track NAT connections
   conntrack -E -n
   ```

### Best Practices
1. Save rules properly
   ```bash
   # Save current rules
   iptables-save > /etc/iptables/rules.v4
   
   # Restore rules
   iptables-restore < /etc/iptables/rules.v4
   ```

2. Use atomic updates
   ```bash
   # Atomic file update
   iptables-restore-translate < rules.v4 | iptables-restore -n
   ```

3. Implement logging
   ```bash
   # Log dropped packets
   iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: "
   
   # Monitor logs
   tail -f /var/log/syslog | grep IPTables-Dropped
