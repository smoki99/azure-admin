# Network Analysis Tools

This document covers the network analysis tools included in the container environment, their use cases, and practical examples for cloud/container troubleshooting.

## Core Network Utilities

### iperf3
**What it does:**  
Network performance measurement tool that can test bandwidth between two points.

**Example Usage:**
```bash
# Start iperf3 server
iperf3 -s

# Run client test
iperf3 -c server-ip
```

**Cloud/K8s Use Case:**  
When experiencing slow pod-to-pod communication or service latency in AKS:
1. Deploy iperf3 server as a pod in one namespace
2. Run iperf3 client from another namespace
3. Measure actual network throughput to identify if it's a network bottleneck
4. Compare results against Azure's documented network performance limits

### mtr-tiny
**What it does:**  
Combines ping and traceroute into a single tool that continuously monitors path and latency.

**Example Usage:**
```bash
mtr -n azure.microsoft.com
```

**Cloud/K8s Use Case:**  
Troubleshooting AKS to Azure service connectivity:
1. Monitor network path between pods and Azure services
2. Identify latency spikes and packet loss
3. Determine if issues are within AKS network policy or external routing
4. Use results to optimize Azure network security group rules

### netcat (nc)
**What it does:**  
Swiss army knife for TCP/UDP connections and port testing.

**Example Usage:**
```bash
# Test if port is open
nc -zv my-service 80

# Create quick test server
nc -l 8080
```

**Cloud/K8s Use Case:**  
Testing service connectivity in Kubernetes:
1. Verify service port accessibility between pods
2. Debug service mesh configurations
3. Test load balancer endpoints
4. Validate network policies

### socat
**What it does:**  
Multipurpose relay for bidirectional data transfer and port forwarding.

**Example Usage:**
```bash
# Port forwarding
socat TCP-LISTEN:8080,fork TCP:destination:80

# TLS testing
socat -v OPENSSL-LISTEN:443,cert=server.pem TCP:internal-service:80
```

**Cloud/K8s Use Case:**  
Advanced service debugging in AKS:
1. Create temporary port forwards for debugging services
2. Test TLS termination
3. Relay traffic between different network segments
4. Debug ingress controller issues

### iftop
**What it does:**  
Real-time bandwidth monitoring per connection.

**Example Usage:**
```bash
iftop -i eth0
```

**Cloud/K8s Use Case:**  
Monitoring container network usage:
1. Identify containers with unexpected network usage
2. Monitor bandwidth consumption per connection
3. Detect potential network-related performance issues
4. Validate network quotas and limits

### nethogs
**What it does:**  
Per-process network bandwidth monitoring.

**Example Usage:**
```bash
nethogs eth0
```

**Cloud/K8s Use Case:**  
Debugging high network usage in AKS:
1. Identify which processes are consuming bandwidth
2. Monitor container network usage patterns
3. Detect potentially misbehaving applications
4. Validate application network behavior

### tcpdump
**What it does:**  
Network packet analyzer that can capture and analyze network traffic.

**Example Usage:**
```bash
# Capture HTTP traffic
tcpdump -i any port 80 -w capture.pcap

# Monitor DNS queries
tcpdump -i any port 53
```

**Cloud/K8s Use Case:**  
Deep debugging of service communication:
1. Capture traffic between microservices
2. Debug service mesh behavior
3. Analyze DNS resolution issues
4. Troubleshoot load balancer behavior

## Advanced Networking Tools

### bridge-utils
**What it does:**  
Tools for configuring network bridges.

**Example Usage:**
```bash
brctl show
```

**Cloud/K8s Use Case:**  
Container networking troubleshooting:
1. Inspect container network bridges
2. Debug CNI plugin issues
3. Validate network configurations
4. Troubleshoot pod-to-pod communication

### iptables/ipset
**What it does:**  
Network packet filtering and manipulation tools.

**Example Usage:**
```bash
# List all rules
iptables -L

# Check specific chain
iptables -L KUBE-SERVICES
```

**Cloud/K8s Use Case:**  
Kubernetes network policy debugging:
1. Inspect service routing rules
2. Debug network policies
3. Validate load balancer configurations
4. Troubleshoot service mesh implementations

## Best Practices

1. **Security First:**
   - Always use these tools with caution in production environments
   - Get necessary approvals before running intensive network tests
   - Be mindful of captured data sensitivity

2. **Resource Impact:**
   - Monitor resource usage when running network tests
   - Schedule intensive tests during maintenance windows
   - Clean up test pods and captures when done

3. **Documentation:**
   - Keep logs of all tests performed
   - Document findings and solutions
   - Share knowledge with team members

4. **Azure-Specific Considerations:**
   - Be aware of Azure network quotas and limits
   - Consider Azure Network Watcher complementary tools
   - Understand AKS networking model specifics
