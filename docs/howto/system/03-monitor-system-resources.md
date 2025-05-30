# Monitoring System Resource Usage and Identifying Bottlenecks

## Problem Statement
You need to monitor system resources (CPU, memory, disk, network) and identify performance bottlenecks in a Linux system.

## Solution
Use a combination of system monitoring tools to track resource usage, identify bottlenecks, and analyze system performance.

## Tools Used
- top/htop
- iftop
- iotop
- nethogs
- vmstat
- iostat
- sar
- dstat

## Implementation

### 1. Real-time System Monitoring
```bash
# Basic system monitoring
top

# Enhanced monitoring with htop
htop --sort-key PERCENT_CPU

# Process tree view
htop -t

# Monitor specific user
htop -u username
```

### 2. Memory Analysis
```bash
# View memory usage
free -h

# Detailed memory statistics
vmstat 1 10

# Track memory by process
ps aux --sort=-%mem | head -n 11

# Memory usage over time
sar -r 1 60
```

### 3. CPU Monitoring
```bash
# CPU usage by core
mpstat -P ALL 1

# Process CPU usage
top -b -n 1 | head -n 20

# Load average history
sar -q 1 60

# CPU temperature
sensors
```

### 4. Disk I/O Analysis
```bash
# Monitor disk I/O
iostat -xz 1

# I/O by process
iotop -o

# Disk usage
df -h

# Directory sizes
du -sh /* | sort -hr
```

## Advanced Monitoring

### 1. Network Usage
```bash
# Monitor bandwidth by interface
iftop -i eth0

# Network usage by process
nethogs eth0

# Network statistics
netstat -tulpn

# Detailed network analysis
iptraf-ng
```

### 2. System Load Investigation
```bash
# Process resource usage
pidstat 1

# System activity report
sar -u 1 60

# Context switches and interrupts
vmstat -w 1

# Run queue length
sar -q 1 60
```

### 3. Advanced Analysis
```bash
# System events monitoring
dmesg -w

# Track system calls
strace -p PID

# Profile CPU usage
perf top

# Track file system access
fatrace
```

## Bottleneck Identification

### 1. CPU Bottlenecks
```bash
# High CPU processes
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head

# CPU saturation check
mpstat -P ALL 1 | grep -v CPU

# Process wait time
pidstat -u 1 10
```

### 2. Memory Bottlenecks
```bash
# Memory pressure check
vmstat 1 | awk '{print $3,$4}'

# Page faults
sar -B 1 10

# Swap usage
swapon --show
free -h
```

### 3. I/O Bottlenecks
```bash
# Disk I/O wait time
iostat -xz 1 | grep -v '^$' | grep -v Device

# Block device statistics
blockstat 1

# File system latency
iostat -x 1
```

## Common Issues

### 1. High Load Average
```bash
# Check load average
uptime

# Identify CPU-intensive processes
top -b -n 1 -o %CPU

# Memory consumers
ps aux --sort=-%mem | head -n 5
```

### 2. Memory Issues
```bash
# Check available memory
free -m

# Memory usage by process
smem -tk

# Cache usage
vmstat -s | grep cache
```

### 3. I/O Problems
```bash
# Check I/O wait
iostat -x 1 5

# Identify I/O heavy processes
iotop -b -n 2

# File system status
df -i
```

## Additional Notes

### Best Practices
1. Regular monitoring baseline establishment
2. Alert thresholds configuration
3. Historical data collection
4. Performance metric correlation
5. Resource usage trending

### Monitoring Configuration
```bash
# Set up resource monitoring
cat > /etc/sysstat/sysstat <<EOF
ENABLED="true"
HISTORY=7
COMPRESSAFTER=10
SA_DIR="/var/log/sysstat"
EOF

# Configure data collection
cat > /etc/sysstat/sysstat.cron <<EOF
*/10 * * * * root /usr/lib/sysstat/sa1 1 1
53 23 * * * root /usr/lib/sysstat/sa2 -A
EOF
```

### Automated Monitoring
```bash
# Create monitoring script
cat > monitor.sh <<EOF
#!/bin/bash
while true; do
    date >> system_stats.log
    uptime >> system_stats.log
    free -h >> system_stats.log
    iostat >> system_stats.log
    sleep 300
done
EOF

# Schedule with cron
echo "*/5 * * * * /path/to/monitor.sh" >> /etc/crontab
```

### Performance Tuning
```bash
# Adjust swappiness
echo "vm.swappiness=10" >> /etc/sysctl.conf

# I/O scheduler settings
echo "deadline" > /sys/block/sda/queue/scheduler

# Network tuning
cat >> /etc/sysctl.conf <<EOF
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
EOF
