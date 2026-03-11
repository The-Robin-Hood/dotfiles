#!/bin/bash

CURRENT_DIR="$1"
fg=$(tmux show -gv @thm_fg)
bg=$(tmux show -gv @thm_bg)
surface=$(tmux show -gv @thm_surface)
primary=$(tmux show -gv @thm_primary)

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

OUTPUT="#[fg=$primary]#[fg=#11111b,bg=$primary]󰊢 #[fg=$fg,bg=$surface] ${BRANCH}"

if [ "$STAGED" -gt 0 ] || [ "$MODIFIED" -gt 0 ] || [ "$UNTRACKED" -gt 0 ]; then
    
    if [ "$STAGED" -gt 0 ]; then
        OUTPUT+="#[fg=#a6e3a1,bg=$surface] S:${STAGED}"
    fi
    
    if [ "$MODIFIED" -gt 0 ]; then
        OUTPUT+="#[fg=#f9e2af,bg=$surface] M:${MODIFIED}"
    fi
    
    if [ "$UNTRACKED" -gt 0 ]; then
        OUTPUT+="#[fg=#89b4fa,bg=$surface] U:${UNTRACKED}"
    fi
fi

OUTPUT+="#[fg=$surface,bg=default]"
echo "$OUTPUT"
