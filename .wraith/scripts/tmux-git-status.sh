#!/bin/bash

CURRENT_DIR="$1"

# Check if we're in a git repo
cd "$CURRENT_DIR" || exit 1
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo ""
    exit 0
fi

# Get branch name
BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

# Get status counts
STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

OUTPUT="#[fg=#fab387]#[fg=#181825,bg=#fab387]#[fg=#11111b,bg=#fab387]󰊢 #[fg=#fab387,bg=#292a3b]#[fg=#cdd6f4,bg=#292a3b] ${BRANCH}"

if [ "$STAGED" -gt 0 ] || [ "$MODIFIED" -gt 0 ] || [ "$UNTRACKED" -gt 0 ]; then
    
    if [ "$STAGED" -gt 0 ]; then
        OUTPUT+=" #[fg=#a6e3a1,bg=#292a3b]S:${STAGED}"
    fi
    
    if [ "$MODIFIED" -gt 0 ]; then
        OUTPUT+=" #[fg=#f9e2af,bg=#292a3b]M:${MODIFIED}"
    fi
    
    if [ "$UNTRACKED" -gt 0 ]; then
        OUTPUT+=" #[fg=#89b4fa,bg=#292a3b]U:${UNTRACKED}"
    fi
fi

OUTPUT+="#[fg=#292a3b,bg=#181825]"
echo "$OUTPUT"
