#!/bin/bash

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

toilet --metal "Azure Admin"

# Welcome message
echo -e "${BLUE}Welcome to the Azure Admin Container!${NC}"
echo -e "${GREEN}Documentation is available at: /docs${NC}"
echo

# Quick Start
echo -e "${YELLOW}Quick Start:${NC}"
echo -e "  1. View documentation index:     ${GREEN}glow /docs/README.md${NC}"
echo -e "  2. List available tools:         ${GREEN}ls /docs/tools${NC}"
echo -e "  3. View specific tool docs:      ${GREEN}glow /docs/tools/[category]/[tool].md${NC}"
echo

# Categories
echo -e "${YELLOW}Documentation Categories:${NC}"
echo -e "  - Network Tools:      ${BLUE}/docs/tools/network/${NC}"
echo -e "  - Kubernetes Tools:   ${BLUE}/docs/tools/kubernetes/${NC}"
echo -e "  - Container Tools:    ${BLUE}/docs/tools/containers/${NC}"
echo -e "  - DNS Tools:          ${BLUE}/docs/tools/dns/${NC}"
echo -e "  - Development:        ${BLUE}/docs/tools/development/${NC}"
echo

# Container Setup
echo -e "${YELLOW}Container Setup:${NC}"
echo -e "  View container setup:           ${GREEN}glow /docs/container-setup.md${NC}"
echo

# glow info
echo -e "${GREEN}Use 'glow' to read markdown files interactively${NC}"
echo -e "${GREEN}Navigation: arrows / PageUp / PageDown, 'q' to quit${NC}"
echo -e "${GREEN}Press '?' inside glow to view available commands${NC}"
echo

# tmux info
echo -e "${YELLOW}tmux is enabled. Common shortcuts:${NC}"
echo -e "  - ${GREEN}ctrl+b c${NC}   → Create a new window"
echo -e "  - ${GREEN}ctrl+b ,${NC}   → Rename current window"
echo -e "  - ${GREEN}ctrl+b &${NC}   → Close current window"
echo -e "  - ${GREEN}ctrl+b w${NC}   → List all windows"
echo -e "  - ${GREEN}ctrl+b p${NC}   → Previous window"
echo -e "  - ${GREEN}ctrl+b n${NC}   → Next window"
echo

# Auto-start tmux only if not already inside one
if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
  tmux attach-session -t default 2>/dev/null || tmux new-session -s default
fi