# gh - GitHub CLI Tool

## Overview
`gh` is GitHub's official command-line tool that brings GitHub to your terminal. It facilitates managing GitHub workflows, including issues, pull requests, repositories, and more.

## Official Documentation
[GitHub CLI Manual](https://cli.github.com/manual/)

## Basic Usage

### Authentication
```bash
# Login to GitHub
gh auth login

# View authentication status
gh auth status

# Logout from GitHub
gh auth logout
```

### Repository Operations
```bash
# Clone repository
gh repo clone owner/repo

# Create repository
gh repo create my-project

# Fork repository
gh repo fork owner/repo
```

## Cloud/Container Use Cases

### 1. CI/CD Integration
```bash
# View workflow runs
gh workflow list

# Run workflow
gh workflow run workflow.yml

# Watch workflow status
gh run watch
```

### 2. Container Registry
```bash
# List container packages
gh package list

# View container details
gh package view container-name

# Delete container version
gh package delete container-name --version-id xxx
```

### 3. Release Management
```bash
# Create release
gh release create v1.0.0

# Upload artifacts
gh release upload v1.0.0 ./dist/*

# List releases
gh release list
```

## Advanced Features

### 1. Issue Management
```bash
# Create issue
gh issue create --title "Bug" --body "Description"

# List issues
gh issue list --state open

# Close issue
gh issue close 123
```

### 2. Pull Request Operations
```bash
# Create PR
gh pr create --title "Feature" --body "Description"

# Review PR
gh pr review 123 --approve

# Merge PR
gh pr merge 123
```

### 3. GitHub Actions
```bash
# List workflows
gh workflow list

# Enable workflow
gh workflow enable workflow.yml

# View workflow run
gh run view
```

## Best Practices

### 1. Repository Management
```bash
# Initialize with best practices
gh repo create --template owner/template

# Clone with submodules
gh repo clone owner/repo -- --recursive

# Setup remote
gh repo set-default
```

### 2. Workflow Automation
```bash
# Create workflow
gh workflow init

# Enable required status checks
gh api /repos/:owner/:repo/branches/:branch/protection \
  -F required_status_checks=true

# Set branch protection
gh api /repos/:owner/:repo/branches/:branch/protection \
  -F enforce_admins=true
```

### 3. Collaboration
```bash
# Add collaborators
gh api /repos/:owner/:repo/collaborators/:username -X PUT

# Create team
gh api /orgs/:org/teams -F name=team-name

# Manage permissions
gh api /repos/:owner/:repo/teams/:team_slug -X PUT
```

## Common Scenarios

### 1. Project Setup
```bash
# Create from template
gh repo create --template owner/template new-project

# Setup branch protection
gh api /repos/:owner/:repo/branches/main/protection \
  -F required_status_checks=true

# Configure CI/CD
gh workflow enable ci.yml
```

### 2. Issue Management
```bash
# Create labeled issue
gh issue create --label bug,urgent

# Assign issue
gh issue edit 123 --assignee username

# Add to project
gh issue edit 123 --project "Project Name"
```

### 3. Code Review
```bash
# Create PR from branch
gh pr create --base main --head feature

# Request review
gh pr edit 123 --reviewer username

# Add labels
gh pr edit 123 --label ready,reviewed
```

## Integration Examples

### 1. With Container Tools
```bash
# Push container
gh package create container-name

# Tag release
gh release create v1.0.0 --generate-notes

# Update packages
gh api /repos/:owner/:repo/packages
```

### 2. With CI/CD
```bash
# Deploy workflow
gh workflow run deploy.yml

# Monitor deployment
gh run watch

# View logs
gh run view --log
```

### 3. With Development Tools
```bash
# Setup dev container
gh codespace create

# Configure environment
gh codespace edit

# Port forwarding
gh codespace ports forward 8080:80
```

## Troubleshooting

### Common Issues
1. Authentication problems
   ```bash
   # Check auth status
   gh auth status
   
   # Reset credentials
   gh auth refresh
   
   # Update token
   gh auth login --scopes 'repo,read:org'
   ```

2. API rate limiting
   ```bash
   # Check rate limit
   gh api /rate_limit
   
   # Use different token
   gh auth login --with-token < token.txt
   ```

3. Permission issues
   ```bash
   # Check access
   gh api /repos/:owner/:repo
   
   # Request access
   gh api /repos/:owner/:repo/collaborators/:username
   ```

### Best Practices
1. Token Management
   ```bash
   # Use SSH auth
   gh auth login --git-protocol ssh
   
   # Secure token storage
   gh auth status --show-token > token.txt
   ```

2. Workflow Security
   ```bash
   # Enable security features
   gh secret set GITHUB_TOKEN
   
   # Review permissions
   gh api /repos/:owner/:repo/hooks
   ```

3. Error Handling
   ```bash
   # Verbose output
   gh --verbose
   
   # Debug mode
   GH_DEBUG=1 gh command
   
   # API debugging
   gh api --include endpoint
