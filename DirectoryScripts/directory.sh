#!/bin/sh

# Font styles & colors
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current directory path
current_dir=$(pwd)

# Clear screen for cleaner output
clear

# Print header
echo "${BLUE}${BOLD}=====================================${NC}"
echo "${GREEN}${BOLD}      YOUR LOCATION INFO${NC}"
echo "${BLUE}${BOLD}=====================================${NC}"
echo
echo "${BOLD}📂 Current directory:${NC}"
echo "${GREEN}$current_dir${NC}"
echo
echo "${BOLD}📊 Directory details:${NC}"
ls -lh | head -n 1
echo "Total files: $(ls -1 | wc -l)"
echo
echo "${BLUE}${BOLD}=====================================${NC}"
