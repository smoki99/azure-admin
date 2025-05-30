#!/bin/bash

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Welcome message
echo -e "${BLUE}Welcome to Azure Admin Container!${NC}"
echo -e "${GREEN}Documentation is available in /docs${NC}"
echo
echo -e "${YELLOW}Quick Start:${NC}"
echo "1. View documentation index:    glow /docs/README.md"
echo "2. List available tools:        ls /docs/tools"
echo "3. View specific tool docs:     glow /docs/tools/[category]/[tool].md"
echo
echo -e "${YELLOW}Documentation Categories:${NC}"
echo "- Network Tools:     /docs/tools/network/"
echo "- Kubernetes Tools:  /docs/tools/kubernetes/"
echo "- Container Tools:   /docs/tools/containers/"
echo "- DNS Tools:        /docs/tools/dns/"
echo "- Development:      /docs/tools/development/"
echo
echo -e "${YELLOW}Container Setup:${NC}"
echo "View container setup details:    glow /docs/container-setup.md"
echo
echo -e "${GREEN}Use 'glow' to read documentation files${NC}"
echo -e "${GREEN}Navigation: arrows/page up/down, q to quit${NC}"
echo -e "${GREEN}Press '?' in glow for more commands${NC}"
echo
