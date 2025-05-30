# Finding and Replacing Text Across Multiple Configuration Files

## Problem Statement
You need to search for and replace specific configuration settings across multiple files in various directories, ensuring changes are made safely and consistently.

## Solution
Use a combination of `ripgrep` for searching and `sed` for replacements, with validation steps to ensure safety and correctness.

## Tools Used
- ripgrep (rg)
- sed
- tree
- bash

## Implementation

### 1. Search for Configuration Pattern
```bash
# Search for specific configuration
rg "old_setting" /etc/

# List all affected files
rg -l "old_setting" /etc/ > affected_files.txt

# Show context for matches
rg -C 2 "old_setting" /etc/
```

### 2. Backup Files
```bash
# Create backup directory
backup_dir="/tmp/config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# Backup each file
while read -r file; do
    cp --parents "$file" "$backup_dir/"
done < affected_files.txt
```

### 3. Perform Replacement
```bash
# Test replacement first
rg -l "old_setting" /etc/ | xargs sed -i.bak 's/old_setting/new_setting/g'

# Verify changes
rg "new_setting" /etc/

# Compare with backups
diff -r /etc/ "$backup_dir/etc/"
```

### 4. Version Control Integration
```bash
# If using git for configuration management
git add -A
git commit -m "Update configuration: old_setting to new_setting"

# Create patch file
git diff > config_changes.patch
```

## Validation

### 1. Check File Integrity
```bash
# Verify file contents
for file in $(cat affected_files.txt); do
    echo "Checking $file..."
    grep -A 2 -B 2 "new_setting" "$file"
done

# Verify syntax for specific file types
for file in *.conf; do
    config_test "$file"
done
```

### 2. Service Impact Check
```bash
# List affected services
systemctl list-units --type=service | rg -f affected_files.txt

# Test configuration
systemctl try-reload-or-restart affected_service
```

### 3. Monitoring
```bash
# Watch for errors in logs
tail -f /var/log/syslog | rg -i "error|warning"

# Monitor service status
watch -n 1 'systemctl status affected_service'
```

## Common Issues

### 1. Partial Replacements
```bash
# Verify all instances were replaced
rg "old_setting" /etc/

# Check for similar patterns
rg -i "old.?setting" /etc/
```

### 2. Permission Problems
```bash
# Check file permissions
ls -l $(cat affected_files.txt)

# Fix permissions if needed
chmod 644 /etc/affected_file
```

### 3. Service Disruptions
```bash
# Rollback changes if needed
while read -r file; do
    cp "$backup_dir/$file" "/$file"
done < affected_files.txt

# Restart affected services
systemctl restart affected_service
```

## Additional Notes

### Best Practices
1. Always create backups before making changes
2. Test changes in a staging environment first
3. Use version control when possible
4. Document all changes made
5. Create rollback plan before starting

### Alternative Approaches
1. Using `find` and `sed`:
   ```bash
   find /etc -type f -exec sed -i.bak 's/old_setting/new_setting/g' {} \;
   ```

2. Using `perl`:
   ```bash
   perl -pi.bak -e 's/old_setting/new_setting/g' $(rg -l "old_setting" /etc/)
   ```

3. Using configuration management tools:
   ```bash
   ansible-playbook update_config.yml
   ```

### Safety Checks
1. Always verify backups exist and are valid
2. Test changes on a single file first
3. Use `sed` with `-i.bak` for automatic backups
4. Keep detailed logs of all changes
5. Test service functionality after changes
