# scapy - Interactive Packet Manipulation Program

## Overview
`scapy` is a powerful interactive packet manipulation program and library that enables users to send, sniff, dissect, and forge network packets. It's particularly useful for network testing, debugging, and security assessments.

## Official Documentation
[Scapy Documentation](https://scapy.readthedocs.io/)

## Basic Usage

### Interactive Shell
```python
# Start scapy shell
scapy

# List available protocols
ls()

# Show protocol fields
ls(IP)
```

### Packet Creation
```python
# Create IP packet
ip_pkt = IP(dst="8.8.8.8")

# Create TCP packet
tcp_pkt = TCP(dport=80)

# Combine layers
pkt = ip_pkt/tcp_pkt
```

## Cloud/Container Use Cases

### 1. Container Network Testing
```python
# Test container connectivity
pkt = IP(dst="172.17.0.2")/ICMP()
send(pkt)

# Trace container route
traceroute(["172.17.0.2"], maxttl=20)

# Monitor container traffic
sniff(iface="docker0", filter="host 172.17.0.2")
```

### 2. Service Discovery
```python
# Port scanning
for p in range(1,1024):
    sr1(IP(dst="target")/TCP(dport=p,flags="S"),timeout=1)

# Service detection
ans,unans = sr(IP(dst="target")/TCP(dport=[80,443])/"GET / HTTP/1.0\r\n\r\n")

# DNS enumeration
ans = sr1(IP(dst="8.8.8.8")/UDP()/DNS(qd=DNSQR(qname="example.com")))
```

### 3. Network Debugging
```python
# Path MTU discovery
ans,unans = sr(IP(dst="target",flags="DF")/ICMP()/("X"*1500))

# Network latency
ans,unans = sr(IP(dst="target")/ICMP(),inter=0.1,retry=2)

# Protocol testing
ans = sr1(IP(dst="target")/TCP(dport=80,flags="S"))
```

## Advanced Features

### 1. Packet Manipulation
```python
# Custom packet fields
pkt = IP(dst="target",ttl=64)

# Raw packet data
raw(pkt)

# Packet summary
pkt.summary()
```

### 2. Traffic Capture
```python
# Capture packets
pkts = sniff(count=100)

# Filter capture
pkts = sniff(filter="tcp and port 80")

# Save capture
wrpcap("capture.pcap", pkts)
```

### 3. Protocol Analysis
```python
# Analyze packets
pkts[0].show()

# Extract fields
pkts[0][IP].src

# Follow stream
sessions = pkts.sessions()
```

## Best Practices

### 1. Network Testing
```python
# Reliable sending
send(pkt, retry=2, timeout=1)

# Rate limiting
send(pkt, inter=0.1)

# Error handling
try:
    ans = sr1(pkt)
except:
    print("Failed")
```

### 2. Packet Crafting
```python
# Layer 2 frame
Ether()/IP()/TCP()

# Custom payload
Raw(load="test")

# Protocol stack
IP()/TCP()/HTTP()
```

### 3. Data Analysis
```python
# Filter packets
pkts = sniff(lfilter=lambda p: p.haslayer(TCP))

# Export data
wrpcap("filtered.pcap", pkts)

# Statistical analysis
print(packet_stats(pkts))
```

## Common Scenarios

### 1. Network Discovery
```python
# ARP scanning
ans,unans = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(), timeout=2)

# TCP SYN scan
sr1(IP(dst="target")/TCP(dport=80,flags="S"))

# ICMP sweep
ans,unans = sr(IP(dst="192.168.1.0/24")/ICMP())
```

### 2. Service Testing
```python
# HTTP testing
req = IP(dst="server")/TCP(dport=80)/Raw(load="GET / HTTP/1.0\r\n\r\n")
ans = sr1(req)

# DNS query
dns = IP(dst="8.8.8.8")/UDP()/DNS(rd=1,qd=DNSQR(qname="example.com"))
ans = sr1(dns)

# SMTP test
smtp = IP(dst="server")/TCP(dport=25)/Raw(load="HELO test\r\n")
```

### 3. Security Testing
```python
# SYN flood
send(IP(dst="target")/TCP(dport=80,flags="S"), loop=1)

# DNS amplification test
dns = IP(dst="target")/UDP()/DNS(rd=1,qd=DNSQR(qname="example.com"))

# ICMP flood
send(IP(dst="target")/ICMP(), loop=1)
```

## Integration Examples

### 1. With Container Tools
```python
# Docker network testing
conf.iface = "docker0"
sniff(filter="port 80")

# Container connectivity
sr1(IP(dst="container_ip")/ICMP())

# Service discovery
sr(IP(dst="container_ip")/TCP(dport=[80,443,8080]))
```

### 2. With Network Tools
```python
# Wireshark integration
wireshark(pkts)

# Tcpdump comparison
sniff(filter="tcpdump filter")

# Custom dissector
bind_layers(TCP, MyProtocol, dport=1234)
```

### 3. With Security Tools
```python
# Nmap-like scan
sr(IP(dst="target")/TCP(dport=(1,1024),flags="S"))

# IDS testing
send(IP(dst="target")/TCP(dport=80)/Raw(load="ATTACK"))

# Fuzzing
fuzz(IP()/TCP())
```

## Troubleshooting

### Common Issues
1. Permission problems
   ```python
   # Run as root
   conf.L3socket=L3RawSocket
   
   # Use specific interface
   conf.iface = "eth0"
   
   # Check privileges
   checkIPsrc()
   ```

2. Network issues
   ```python
   # Check routing
   conf.route
   
   # Test connectivity
   sr1(IP(dst="8.8.8.8")/ICMP())
   
   # Debug packets
   conf.debug_match = True
   ```

3. Protocol errors
   ```python
   # Check packet structure
   pkt.show2()
   
   # Verify checksums
   conf.checkIPsrc = True
   
   # Layer binding
   conf.layers.ls()
   ```

### Best Practices
1. Error Handling
   ```python
   # Timeout handling
   ans = sr1(pkt, timeout=2)
   if ans:
       process(ans)
   
   # Retry logic
   ans = sr1(pkt, retry=3)
   
   # Exception handling
   try:
       send(pkt)
   except Exception as e:
       print(f"Error: {e}")
   ```

2. Performance
   ```python
   # Batch processing
   ans,unans = sr(pkts, timeout=2)
   
   # Rate limiting
   send(pkts, inter=0.1)
   
   # Memory management
   del pkts
   ```

3. Security
   ```python
   # Validate input
   if not valid_ip(target):
       raise ValueError
   
   # Rate limiting
   time.sleep(0.1)
   
   # Clean up
   conf.reset()
