# Azure Admin Container Setup

## Documentation Access

### Inside Container
The documentation is available inside the container at `/docs` and can be viewed using the `glow` Markdown reader:
```bash
# View documentation index
glow /docs/README.md

# List tool documentation
ls /docs/tools

# View specific tool documentation
glow /docs/tools/containers/podman.md
```

### Welcome Message
A welcome message is displayed when starting the container, showing:
- Documentation location
- Quick start guide
- Available documentation categories
- How to view documentation files

### Documentation Navigation
1. Use `glow` to read documentation files:
   ```bash
   glow /docs/README.md
   ```

2. Inside `glow`:
   - Use arrow keys to navigate
   - Use Page Up/Down for faster scrolling
   - Press `?` for help with commands
   - Press `q` to quit

3. Navigate documentation structure:
   ```bash
   # List categories
   ls /docs/tools/

   # List specific category
   ls /docs/tools/containers/

   # View specific tool
   glow /docs/tools/containers/podman.md
   ```

### Documentation Features with Glow
- Syntax highlighting
- Table formatting
- Code block highlighting
- Terminal-based styling
- Light/dark theme support
- Search functionality
