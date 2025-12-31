#!/bin/bash
# Environment Shamer - Because your API keys deserve better than public GitHub
# Usage: Run this before committing to avoid eternal shame

# Colors for maximum shame impact
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Common sensitive patterns (because regex is hard, but shame is easy)
PATTERNS=(
    "API_KEY"
    "SECRET"
    "PASSWORD"
    "TOKEN"
    "PRIVATE_KEY"
    "AWS_ACCESS"
    "AWS_SECRET"
    "DATABASE_URL"
    "CREDENTIALS"
    "AUTH_TOKEN"
)

# Files to check (config files are the usual suspects)
FILES=(
    ".env"
    ".env.local"
    "config.json"
    "settings.py"
    "*.config"
)

# The shame counter
SHAME_COUNT=0

# Welcome to shame town
printf "${YELLOW}🔍 Environment Shamer is scanning for secrets...${NC}\n\n"

# Check each file pattern
for file_pattern in "${FILES[@]}"; do
    for file in $(find . -name "$file_pattern" -type f 2>/dev/null); do
        printf "Checking ${file}...\n"
        
        # Look for shameful patterns
        for pattern in "${PATTERNS[@]}"; do
            if grep -qi "$pattern" "$file" 2>/dev/null; then
                printf "${RED}  ✗ Found '$pattern' in $file${NC}\n"
                SHAME_COUNT=$((SHAME_COUNT + 1))
                
                # Show the offending line (for extra shame)
                grep -i "$pattern" "$file" | head -3 | while read line; do
                    printf "    ${YELLOW}→${NC} ${line:0:60}...\n"
                done
            fi
        done
    done
done

# Deliver the verdict
printf "\n${YELLOW}=== SHAME REPORT ===${NC}\n"
if [ $SHAME_COUNT -eq 0 ]; then
    printf "${GREEN}✅ No secrets found! You may commit with dignity.${NC}\n"
else
    printf "${RED}🚨 ${SHAME_COUNT} potential secrets found!${NC}\n"
    printf "${YELLOW}Your future self (and security team) thanks you for fixing these.${NC}\n"
    exit 1  # Fail the check - shame must have consequences
fi
