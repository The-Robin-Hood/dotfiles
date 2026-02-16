#!/bin/bash

COMMAND="$1"
CURRENT_PATH="$2"
PANE_TITLE="$3"
HOME_DIR="$4"

case "$COMMAND" in
    vim|nvim)
        TITLE=$(basename "$PANE_TITLE" 2>/dev/null || echo "")
        if [ -n "$TITLE" ] && [ "$TITLE" != "$COMMAND" ]; then
            echo "$COMMAND $TITLE"
        else
            echo "$COMMAND"
        fi
        ;;
    zsh|bash|fish|sh)
        # Only show directory name if NOT in home
        if [ "$CURRENT_PATH" != "$HOME_DIR" ]; then
            DIR=$(basename "$CURRENT_PATH")
            echo "$DIR"
        else
            echo "home"
        fi
        ;;
    *)
        echo "$COMMAND"
        ;;
esac
