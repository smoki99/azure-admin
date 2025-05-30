# Setting up Automated System Backups

## Problem Statement
You need to implement an automated backup system for critical system files and data, ensuring regular backups with proper retention and verification.

## Solution
Use a combination of rsync, tar, and systemd timers to create automated, incremental backups with compression and verification.

## Tools Used
- rsync
- tar
- systemd
- find
- sha256sum
- gpg (optional encryption)
- cron

## Implementation

### 1. Basic Backup Script
```bash
#!/bin/bash
# backup.sh

# Configuration
BACKUP_DIR="/backup"
SOURCE_DIRS=("/etc" "/var/www" "/home")
DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/backup.log"

# Create backup directory
mkdir -p "$BACKUP_DIR/$DATE"

# Backup function
backup_directory() {
    local source=$1
    local dest="$BACKUP_DIR/$DATE"
    
    rsync -av --delete \
        --link-dest="$BACKUP_DIR/latest" \
        "$source" "$dest" >> "$LOG_FILE" 2>&1
}

# Execute backups
for dir in "${SOURCE_DIRS[@]}"; do
    echo "Backing up $dir..." >> "$LOG_FILE"
    backup_directory "$dir"
done

# Update latest symlink
ln -snf "$BACKUP_DIR/$DATE" "$BACKUP_DIR/latest"

# Cleanup old backups (keep last 7 days)
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;
```

### 2. Systemd Service Setup
```bash
# Create systemd service
cat > /etc/systemd/system/backup.service <<EOF
[Unit]
Description=System Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
User=root
Nice=19
IOSchedulingClass=best-effort
IOSchedulingPriority=7

[Install]
WantedBy=multi-user.target
EOF

# Create systemd timer
cat > /etc/systemd/system/backup.timer <<EOF
[Unit]
Description=Daily System Backup

[Timer]
OnCalendar=daily
AccuracySec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF
```

### 3. Backup Verification
```bash
#!/bin/bash
# verify_backup.sh

BACKUP_DIR="/backup/latest"
VERIFY_LOG="/var/log/backup_verify.log"

# Check backup existence
check_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Backup directory not found!" >> "$VERIFY_LOG"
        exit 1
    fi
}

# Verify file integrity
verify_files() {
    find "$BACKUP_DIR" -type f -exec sha256sum {} \; > checksums.txt
    
    # Compare with previous checksums if they exist
    if [ -f checksums.prev ]; then
        diff checksums.txt checksums.prev >> "$VERIFY_LOG"
    fi
    
    mv checksums.txt checksums.prev
}

# Test file recovery
test_recovery() {
    local test_file=$(find "$BACKUP_DIR" -type f | head -n 1)
    local test_dir="/tmp/backup_test"
    
    mkdir -p "$test_dir"
    cp "$test_file" "$test_dir/"
    
    if [ $? -eq 0 ]; then
        echo "Recovery test successful" >> "$VERIFY_LOG"
    else
        echo "Recovery test failed!" >> "$VERIFY_LOG"
    fi
}

check_backup
verify_files
test_recovery
```

## Advanced Configuration

### 1. Incremental Backups
```bash
# Create incremental backup script
cat > /usr/local/bin/incremental_backup.sh <<EOF
#!/bin/bash

SOURCE_DIR="/data"
BACKUP_DIR="/backup/incremental"
DATE=$(date +%Y%m%d)

# Full backup on Sundays, incremental otherwise
if [ $(date +%u) -eq 7 ]; then
    tar -czf "$BACKUP_DIR/full_$DATE.tar.gz" "$SOURCE_DIR"
    ln -sf "full_$DATE.tar.gz" "$BACKUP_DIR/latest_full"
else
    LATEST_FULL=$(readlink -f "$BACKUP_DIR/latest_full")
    tar -czf "$BACKUP_DIR/inc_$DATE.tar.gz" \
        --newer-than "$LATEST_FULL" "$SOURCE_DIR"
fi
EOF
```

### 2. Remote Backup
```bash
# Set up remote backup script
cat > /usr/local/bin/remote_backup.sh <<EOF
#!/bin/bash

# Configuration
REMOTE_HOST="backup.example.com"
REMOTE_USER="backup"
REMOTE_DIR="/backup"
SOURCE_DIR="/backup/latest"

# Sync to remote
rsync -avz --delete \
    -e "ssh -i /root/.ssh/backup_key" \
    "$SOURCE_DIR/" \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"
EOF
```

### 3. Encrypted Backups
```bash
# Create encrypted backup script
cat > /usr/local/bin/encrypted_backup.sh <<EOF
#!/bin/bash

SOURCE_DIR="/sensitive_data"
BACKUP_DIR="/backup/encrypted"
GPG_RECIPIENT="backup@example.com"

tar -cz "$SOURCE_DIR" | \
    gpg --encrypt --recipient "$GPG_RECIPIENT" \
    > "$BACKUP_DIR/backup_$(date +%Y%m%d).tar.gz.gpg"
EOF
```

## Common Issues

### 1. Space Management
```bash
# Monitor backup space
#!/bin/bash

BACKUP_DIR="/backup"
THRESHOLD=90

usage=$(df -h "$BACKUP_DIR" | tail -n 1 | awk '{print $5}' | tr -d '%')

if [ "$usage" -gt "$THRESHOLD" ]; then
    echo "Backup space critical: $usage%" | \
        mail -s "Backup Space Alert" admin@example.com
fi
```

### 2. Permission Problems
```bash
# Fix backup permissions
find /backup -type d -exec chmod 750 {} \;
find /backup -type f -exec chmod 640 {} \;
chown -R root:backup /backup
```

### 3. Network Issues
```bash
# Test remote connectivity
nc -zv backup.example.com 22

# Check bandwidth
iperf3 -c backup.example.com

# Monitor transfer
rsync -avz --progress /backup remote:/backup
```

## Additional Notes

### Best Practices
1. Always verify backups
2. Implement retention policies
3. Use compression for storage efficiency
4. Monitor backup logs
5. Test recovery regularly

### Backup Strategy
```bash
# Multiple backup levels
daily_backup() {
    rsync -a --delete /data /backup/daily
}

weekly_backup() {
    rsync -a --delete /data /backup/weekly/$(date +%U)
}

monthly_backup() {
    rsync -a --delete /data /backup/monthly/$(date +%Y%m)
}
```

### Monitoring
```bash
# Create monitoring script
cat > /usr/local/bin/monitor_backups.sh <<EOF
#!/bin/bash

check_backup_age() {
    find /backup -type f -mtime +1 | grep -q .
    if [ $? -eq 0 ]; then
        echo "Backup older than 24 hours!"
    fi
}

check_backup_size() {
    size=$(du -s /backup | awk '{print $1}')
    if [ "$size" -lt 1000 ]; then
        echo "Backup size suspiciously small!"
    fi
}

check_backup_logs() {
    grep -i "error\|fail" /var/log/backup.log
}

check_backup_age
check_backup_size
check_backup_logs
EOF
