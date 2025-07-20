#!/bin/zsh 

STATE_FILE="$HOME/.wraith/states/brightness.state"
LOCK_FILE="/tmp/brightness.lock"
DEFAULT_STEP=5
DEFAULT_FALLBACK=10

set -e #saying that exit script immediately if something goes wrong 

show_usage() {
    echo "Usage: $0 <command> [value]"
    echo ""
    echo "Commands:"
    echo "  get                   Get current brightness (JSON format)"
    echo "  set <value>           Set brightness to specific value (0-100)"
    echo "  set +<value>          Increase brightness by value"
    echo "  set -<value>          Decrease brightness by value"
    echo "  set +                 Increase by $DEFAULT_STEP% (default step)"
    echo "  set -                 Decrease by $DEFAULT_STEP% (default step)"
    echo ""
    echo "Examples:"
    echo "  $0 get"
    echo "  $0 set 75"
    echo "  $0 set +10"
    echo "  $0 set -5"
    echo "  $0 set +"
    echo "  $0 set -"
}

cleanup() {
    rm -f "$LOCK_FILE"
}

trap cleanup EXIT 

acquire_lock() {
    local operation="$1"
    
    if [[ -f "$LOCK_FILE" ]]; then
        # If lock file is older than 10 seconds, remove it (stale lock)
        if [[ $(($(date +%s) - $(stat -c %Y "$LOCK_FILE" 2>/dev/null || echo 0))) -gt 10 ]]; then
            rm -f "$LOCK_FILE"
        else
            if [[ "$operation" == "set" ]]; then
                echo "Another brightness operation is in progress..." >&2
                exit 1
            else
                # For get operations, wait briefly then continue
                sleep 1
                [[ -f "$LOCK_FILE" ]] && return 1
            fi
        fi
    fi
    
    touch "$LOCK_FILE"
    return 0
}

init_brightness() {
    echo "Initializing brightness from monitor..." >&2
    
    brightness=$(ddcutil getvcp 10 --brief 2>/dev/null | awk '{print $4}'| sed 's/[^0-9]*//g')
    if [[ -z "$brightness" ]] || [[ ! "$brightness" =~ ^[0-9]+$ ]]; then
        echo "Error: ddcutil failed. Install ddcutil" >&2;
        exit 1;
    else
        echo "Initial brightness detected: $brightness%" >&2
    fi
    
    mkdir -p "$(dirname "$STATE_FILE")"
    echo "$brightness" > "$STATE_FILE"
    echo "$brightness"
}

validate_brightness() {
    local value="$1"
    
    if [[ ! "$value" =~ ^[0-9]+$ ]]; then
        return 1
    fi
    
    if [[ $value -lt 0 || $value -gt 100 ]]; then
        return 1
    fi
    
    return 0
}

get_brightness() {
    if [[ ! -f "$STATE_FILE" ]]; then
        if ! acquire_lock "get"; then
            sleep 1
            if [[ -f "$STATE_FILE" ]]; then
                brightness=$(cat "$STATE_FILE")
            else
                brightness=$(init_brightness)
            fi
        else
            brightness=$(init_brightness)
        fi
    else
      
        brightness=$(cat "$STATE_FILE" 2>/dev/null)

        if ! validate_brightness "$brightness"; then
            if acquire_lock "get"; then
                brightness=$(init_brightness)
            else
                echo "Error occured: brightness file state corrupted";
                exit 1;
            fi
        fi
    fi
    echo "{\"percentage\": $brightness}"
}

set_brightness() {
    local change="$1"
    
    if [[ -z "$change" ]]; then
        echo "Error: No value provided for set command" >&2
        show_usage
        exit 1
    fi
    
    if ! acquire_lock "set"; then
        exit 1
    fi
    
    if [[ ! -f "$STATE_FILE" ]]; then
        echo "State file doesn't exist, initializing..." >&2
        init_brightness >/dev/null
    fi
    
    current=$(cat "$STATE_FILE" 2>/dev/null)
    if ! validate_brightness "$current"; then
        current= $DEFAULT_FALLBACK
        echo "Warning: Invalid state file, using fallback value: $DEFAULT_FALLBACK%" >&2
    fi
    
    local new_brightness
    if [[ "$change" == "+" ]]; then
        new_brightness=$((current + DEFAULT_STEP))
    elif [[ "$change" == "-" ]]; then
        new_brightness=$((current - DEFAULT_STEP))
    elif [[ "$change" == +* ]]; then
        local step="${change:1}"
        if [[ "$step" =~ ^[0-9]+$ ]]; then
            new_brightness=$((current + step))
        else
            echo "Error: Invalid increment value: $change" >&2
            exit 1
        fi
    elif [[ "$change" == -* ]]; then
        local step="${change:1}"
        if [[ "$step" =~ ^[0-9]+$ ]]; then
            new_brightness=$((current - step))
        else
            echo "Error: Invalid decrement value: $change" >&2
            exit 1
        fi
    elif [[ "$change" =~ ^[0-9]+$ ]]; then
        new_brightness="$change"
    else
        echo "Error: Invalid argument: $change" >&2
        show_usage
        exit 1
    fi
    
    if [[ $new_brightness -lt 0 ]]; then
        new_brightness=0
    elif [[ $new_brightness -gt 100 ]]; then
        new_brightness=100
    fi
    
    if [[ $new_brightness -eq $current ]]; then
        echo "Brightness already at $new_brightness%, no change needed" >&2
        echo "{\"percentage\": $new_brightness}"
        return 0
    fi
    
    echo "Setting brightness from $current% to $new_brightness%..." >&2
    
    if ddcutil setvcp 10 $new_brightness --brief >/dev/null 2>&1; then
        echo "$new_brightness" > "$STATE_FILE"
        echo "✓ Brightness set to $new_brightness%" >&2
        
        # if command -v notify-send >/dev/null 2>&1; then
        #     notify-send "Brightness" "$new_brightness%" -t 3000 -h int:value:$new_brightness -h string:synchronous:brightness 2>/dev/null
        # fi

        echo "{\"percentage\": $new_brightness}"
    else
        echo "✗ Failed to set brightness with ddcutil" >&2
        exit 1
    fi
}

# Main script logic
case "$1" in
    "get")
        if [[ $# -ne 1 ]]; then
            echo "Error: 'get' command takes no arguments" >&2
            show_usage
            exit 1
        fi
        get_brightness
        ;;
    "set")
        if [[ $# -ne 2 ]]; then
            echo "Error: 'set' command requires exactly one argument" >&2
            show_usage
            exit 1
        fi
        set_brightness "$2"
        ;;
    "reset")
        set_brightness "$DEFAULT_FALLBACK"
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    "")
        show_usage
        exit 1
        ;;
    *)
        echo "Error: Unknown command: $1" >&2
        exit 1
        ;;
esac