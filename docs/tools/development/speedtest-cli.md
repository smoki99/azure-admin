# speedtest-cli - Command Line Internet Speed Test

## Overview
`speedtest-cli` is a command-line interface for testing internet bandwidth using speedtest.net. It's useful for automated network testing, monitoring, and troubleshooting connectivity issues.

## Official Documentation
[speedtest-cli GitHub](https://github.com/sivel/speedtest-cli)

## Basic Usage

### Simple Tests
```bash
# Run basic speed test
speedtest-cli

# Show simple results
speedtest-cli --simple

# Use bytes instead of bits
speedtest-cli --bytes
```

### Server Selection
```bash
# List servers
speedtest-cli --list

# Use specific server
speedtest-cli --server-id 1234

# Find closest server
speedtest-cli --local
```

## Cloud/Container Use Cases

### 1. Container Network Testing
```bash
# Test container connectivity
docker run --net=host speedtest-cli

# Monitor container bandwidth
while true; do
  speedtest-cli --simple >> container_speed.log
  sleep 300
done

# Test specific network
docker run --network=test-net speedtest-cli
```

### 2. Cloud Instance Testing
```bash
# Test cloud VM bandwidth
speedtest-cli --json > bandwidth.json

# Monitor multiple regions
for region in eu-west us-east ap-south; do
  ssh $region "speedtest-cli --simple"
done

# Test load balancer throughput
while true; do
  speedtest-cli --server-id $LB_SERVER
  sleep 60
done
```

### 3. Network Monitoring
```bash
# Continuous monitoring
speedtest-cli --csv >> speed_log.csv

# Alert on low speed
speedtest-cli --simple | awk '$2 < 50 {exit 1}'

# Generate report
speedtest-cli --json | jq '.download,.upload'
```

## Advanced Features

### 1. Output Formats
```bash
# CSV output
speedtest-cli --csv

# JSON output
speedtest-cli --json

# CSV headers
speedtest-cli --csv-header
```

### 2. Test Configuration
```bash
# Set timeout
speedtest-cli --timeout 10

# Specify minimum server count
speedtest-cli --mini 5

# Share results
speedtest-cli --share
```

### 3. Server Selection
```bash
# List all servers
speedtest-cli --list

# Test specific server
speedtest-cli --server-id 1234

# Use mini server
speedtest-cli --mini URL
```

## Best Practices

### 1. Regular Testing
```bash
# Schedule regular tests
*/30 * * * * speedtest-cli --simple >> /var/log/speedtest.log

# Monitor with timestamps
while true; do
  date +%Y-%m-%d-%H:%M:%S
  speedtest-cli --simple
  sleep 1800
done
```

### 2. Data Collection
```bash
# Save detailed results
speedtest-cli --json | jq '.' > results.json

# Create CSV log
speedtest-cli --csv >> bandwidth.csv

# Monitor trends
speedtest-cli --csv | awk -F',' '{print $7,$8}'
```

### 3. Error Handling
```bash
# Basic error handling
speedtest-cli || echo "Test failed"

# Retry on failure
until speedtest-cli; do
  echo "Retrying..."
  sleep 60
done

# Timeout handling
timeout 30 speedtest-cli
```

## Common Scenarios

### 1. Network Monitoring
```bash
# Regular testing
while true; do
  speedtest-cli --simple
  sleep 300
done

# Alert on low speed
speedtest-cli --simple | awk '$2 < 10 {system("send_alert.sh")}'

# Log with timestamp
speedtest-cli --json | jq '. + {timestamp: now}'
```

### 2. Performance Testing
```bash
# Multiple server test
for server in $(speedtest-cli --list | grep -i local | cut -f1 -d:); do
  speedtest-cli --server $server --simple
done

# Compare locations
for location in site1 site2 site3; do
  ssh $location "speedtest-cli --simple"
done

# Bandwidth baseline
speedtest-cli --json > baseline.json
```

### 3. Troubleshooting
```bash
# Debug mode
speedtest-cli --debug

# Check specific server
speedtest-cli --server-id 1234 --debug

# Test with different configs
speedtest-cli --secure --no-upload
```

## Integration Examples

### 1. With Monitoring Systems
```bash
# Prometheus format
speedtest-cli --json | ./to_prometheus.sh

# Grafana dashboard
speedtest-cli --csv >> /var/lib/grafana/speed.csv

# Nagios check
speedtest-cli --simple | awk '$2 < 50 {exit 2}'
```

### 2. With Cloud Tools
```bash
# AWS CloudWatch
speedtest-cli --json | aws cloudwatch put-metric-data

# Azure Metrics
speedtest-cli --json | az monitor metrics put

# GCP Monitoring
speedtest-cli --json | gcloud monitoring write
```

### 3. With Container Platforms
```bash
# Docker healthcheck
HEALTHCHECK CMD speedtest-cli --simple || exit 1

# Kubernetes probe
livenessProbe:
  exec:
    command: ["speedtest-cli", "--simple"]

# Docker compose
services:
  speedtest:
    image: speedtest-cli
    network_mode: host
```

## Troubleshooting

### Common Issues
1. Connection failures
   ```bash
   # Check DNS
   speedtest-cli --debug 2>&1 | grep DNS
   
   # Test specific server
   speedtest-cli --server-id 1234
   
   # Check firewall
   speedtest-cli --debug 2>&1 | grep "Connection failed"
   ```

2. Slow speeds
   ```bash
   # Test multiple servers
   speedtest-cli --list | head -5 | while read server; do
     speedtest-cli --server-id $server
   done
   
   # Check at different times
   for i in {1..24}; do
     speedtest-cli --simple
     sleep 3600
   done
   ```

3. Timeout issues
   ```bash
   # Increase timeout
   speedtest-cli --timeout 30
   
   # Debug timeouts
   speedtest-cli --debug 2>&1 | grep timeout
   
   # Check connectivity
   speedtest-cli --server-id 1234 --debug
   ```

### Best Practices
1. Regular testing
   ```bash
   # Schedule tests
   crontab -e
   0 */1 * * * speedtest-cli --simple >> /var/log/speedtest.log
   ```

2. Data collection
   ```bash
   # Structured logging
   speedtest-cli --json | jq '. + {timestamp: now}' >> speeds.json
   ```

3. Error handling
   ```bash
   # Robust script
   while true; do
     speedtest-cli --simple || echo "Failed" >> errors.log
     sleep 300
   done
