# Container Network Troubleshooting with Netcat and Tcpdump

## Problem Statement
Containers intermittently lose network connectivity or fail to communicate with external services. You need to diagnose packet flows, identify dropped packets, and verify port accessibility from inside and outside containers.

## Solution Overview
Use `tcpdump` inside podman containers to capture traffic, and `netcat` for simple port listening and connectivity tests. Execute captures both on the host and within containers.

## Tools Used
- podman
- tcpdump
- netcat (nc)

## Implementation

### 1. Capture Traffic on Host Interface
```bash
# Identify container network interface
CONTAINER_IF=$(podman exec mycontainer ip -o link | awk -F': ' '/eth0/ {print $2}')

# Start host-side capture on veth pair
sudo tcpdump -i "$CONTAINER_IF" -w /tmp/container-traffic.pcap
```

### 2. Capture Traffic Inside Container
```bash
# Install tcpdump if necessary
podman exec mycontainer apk add --no-cache tcpdump

# Run tcpdump inside container
podman exec -d mycontainer tcpdump -i eth0 -w /tmp/inside-traffic.pcap

# Retrieve capture file
podman cp mycontainer:/tmp/inside-traffic.pcap ./inside-traffic.pcap
```

### 3. Test Port Connectivity with Netcat
```bash
# On container: listen on a port
podman exec -d mycontainer nc -l -p 8080 -e /bin/sh -c 'echo "OK"'

# On host: connect to container port
CONTAINER_IP=$(podman inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mycontainer)
nc -v "$CONTAINER_IP" 8080

# Expect response "OK"
```

### 4. Check Firewall/NAT Rules
```bash
# On host: list iptables nat rules
sudo iptables -t nat -L -v

# Verify port-forwarding for Podman rootless
iptables -t nat -n -L | grep "$CONTAINER_IP"
```

## Validation
1. Confirm packets captured contain expected flows:
   ```bash
   tcpdump -r /tmp/container-traffic.pcap host "$CONTAINER_IP"
   ```
2. Netcat connection succeeds from host and other containers.
3. No dropped packets detected in tcpdump logs.

## Common Issues
- **Permissions**: tcpdump requires CAP_NET_RAW; use `--cap-add=NET_RAW` when running container.
- **Interface naming**: podman may use veth pairs; inspect `ip link` to find correct interface.
- **Firewall blocking**: disable host firewall rules temporarily to isolate issue.

## Additional Notes
- Use Wireshark GUI to analyze pcap files.  
- Combine with `iftop` or `nethogs` for bandwidth usage.  
- For Kubernetes, use `kubectl port-forward` and `kubectl exec` similarly.
