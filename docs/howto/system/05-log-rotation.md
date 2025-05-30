# Managing Log Rotation and Archiving

## Problem Statement
You need to implement efficient log rotation and archiving to manage system logs, prevent disk space issues, and maintain log history for compliance and troubleshooting.

## Solution
Use logrotate and related tools to configure log rotation, compression, and archiving policies for system and application logs.

## Tools Used
- logrotate
- find
- tar
- systemd-journald
- gzip/xz
- cron

## Implementation

### 1. Basic Logrotate Configuration
```bash
# Create logrotate configuration
cat > /etc/logrotate.d/custom-logs <<EOF
/var/log/application/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        systemctl reload application >/dev/null 2>&1 || true
    endscript
}
EOF
```

### 2. Systemd Journal Configuration
```bash
# Configure journal storage
cat > /etc/systemd/journald.conf <<EOF
[Journal]
Storage=persistent
Compress=yes
SystemMaxUse=2G
SystemKeepFree=20%
MaxRetentionSec=1month
ForwardToSyslog=yes
EOF

# Restart journald
systemctl restart systemd-journald
```

### 3. Log Archive Management
```bash
#!/bin/bash
# archive-logs.sh

ARCHIVE_DIR="/var/log/archive"
DATE=$(date +%Y%m)

# Create archive directory
mkdir -p "$ARCHIVE_DIR/$DATE"

# Archive logs older than 30 days
find /var/log -type f -name "*.log.*" -mtime +30 \
    -exec mv {} "$ARCHIVE_DIR/$DATE/" \;

# Compress archive
cd "$ARCHIVE_DIR"
tar -czf "$DATE.tar.gz" "$DATE/"
rm -rf "$DATE/"

# Clean old archives (keep 12 months)
find "$ARCHIVE_DIR" -type f -name "*.tar.gz" -mtime +365 -delete
```

## Advanced Configuration

### 1. Custom Log Rotation Patterns
```bash
# Size-based rotation
cat > /etc/logrotate.d/large-logs <<EOF
/var/log/large-app/*.log {
    size 100M
    rotate 10
    compress
    dateext
    dateformat -%Y%m%d-%H%M%S
    missingok
    notifempty
    sharedscripts
    postrotate
        kill -HUP \`cat /var/run/large-app.pid\`
    endscript
}
EOF

# Weekly rotation with specific day
cat > /etc/logrotate.d/weekly-logs <<EOF
/var/log/weekly/*.log {
    weekly
    rotate 52
    compress
    missingok
    rotate 12
    weekly
    create
    dateext
    dateformat -%Y%m%d
    rotate 12
}
EOF
```

### 2. Log Monitoring and Alerting
```bash
#!/bin/bash
# monitor-logs.sh

# Check log sizes
check_log_size() {
    local max_size=$((1024 * 1024 * 1024))  # 1GB
    
    find /var/log -type f -name "*.log" -exec du -b {} \; | \
    while read size file; do
        if [ "$size" -gt "$max_size" ]; then
            echo "Warning: $file exceeds 1GB" | \
                mail -s "Log Size Alert" admin@example.com
        fi
    done
}

# Check rotation status
check_rotation_status() {
    if ! grep -q "^success" /var/lib/logrotate/status; then
        echo "Logrotate failure detected" | \
            mail -s "Logrotate Alert" admin@example.com
    fi
}

check_log_size
check_rotation_status
```

### 3. Compression Settings
```bash
# Configure different compression methods
cat > /etc/logrotate.d/compression-example <<EOF
/var/log/app1/*.log {
    daily
    rotate 7
    compress
    compresscmd /usr/bin/gzip
    compressext .gz
}

/var/log/app2/*.log {
    daily
    rotate 30
    compress
    compresscmd /usr/bin/xz
    compressext .xz
}
EOF
```

## Common Issues

### 1. Permission Problems
```bash
# Fix logrotate permissions
chmod 644 /etc/logrotate.d/*
chown root:root /etc/logrotate.d/*

# Fix log directory permissions
chmod 750 /var/log/custom-logs
chown syslog:adm /var/log/custom-logs

# Fix archived logs
chmod 640 /var/log/archive/*
chown root:adm /var/log/archive/*
```

### 2. Disk Space Issues
```bash
# Emergency log cleanup
#!/bin/bash

# Find and compress old logs
find /var/log -type f -name "*.log.*" -mtime +7 \
    -exec gzip -9 {} \;

# Remove ancient logs
find /var/log -type f -name "*.log.*" -mtime +90 -delete

# Clear journal logs
journalctl --vacuum-time=7d
```

### 3. Process Signal Problems
```bash
# Handle process signals
cat > /etc/logrotate.d/signal-handling <<EOF
/var/log/application/*.log {
    daily
    rotate 7
    compress
    delaycompress
    postrotate
        if [ -f /var/run/app.pid ]; then
            kill -USR1 \`cat /var/run/app.pid\`
        fi
    endscript
}
EOF
```

## Additional Notes

### Best Practices
1. Regular log review and cleanup
2. Retention policy documentation
3. Compression strategy planning
4. Access control implementation
5. Backup consideration for important logs

### Log Organization Strategy
```bash
# Create log hierarchy
mkdir -p /var/log/{apps,system,security,archive}

# Set up log symlinks
ln -s /var/log/apps/app.log /var/log/app.log

# Configure rsyslog categories
cat > /etc/rsyslog.d/categories.conf <<EOF
local0.*    /var/log/apps/
local1.*    /var/log/system/
local2.*    /var/log/security/
EOF
```

### Automated Maintenance
```bash
# Create maintenance script
cat > /usr/local/bin/log-maintain.sh <<EOF
#!/bin/bash

# Compress old logs
find /var/log -type f -name "*.log.*" -mtime +7 \
    -not -name "*.gz" -exec gzip {} \;

# Archive logs
tar -czf /var/log/archive/\$(date +%Y%m).tar.gz \
    \$(find /var/log -type f -mtime +30)

# Clean old archives
find /var/log/archive -type f -mtime +365 -delete

# Check disk space
df -h /var/log | awk 'NR==2 {print $5}' | cut -d'%' -f1 | \
    xargs -I {} test {} -gt 90 && \
    echo "Log partition above 90%" | \
    mail -s "Log Space Alert" admin@example.com
EOF

chmod +x /usr/local/bin/log-maintain.sh
