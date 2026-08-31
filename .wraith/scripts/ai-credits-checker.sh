#!/usr/bin/env zsh

SERVER="http://secret.arpa/api/env"
OPENROUTER_API="https://openrouter.ai/api/v1/credits"

ICONS=(
    "󱚥 "
    "󱜙 "
    "󱚝 "
    "󱚟 "
    "󱚡 "
)

error() {
    notify-send "$1" "$2"
    exit 1
}

API_KEY=$(curl -fsS "$SERVER" | jq -er '.openrouter // empty') ||
    error "Error Loading .env" "Check the server and try again."

[[ -n "$API_KEY" ]] ||
    error "Error Loading .env" "OpenRouter API key is missing."

RESPONSE=$(curl -fsS \
    -H "Authorization: Bearer $API_KEY" \
    "$OPENROUTER_API") ||
    error "Error Requesting Credits" "Check the server and try again."

# Extract values
TOTAL_CREDS=$(jq -er '.data.total_credits' <<< "$RESPONSE") ||
    error "Invalid Response" "Could not read total credits."

TOTAL_USAGE=$(jq -er '.data.total_usage' <<< "$RESPONSE") ||
    error "Invalid Response" "Could not read total usage."

# Calculate percentages + icon in one awk call
read PERCENTAGE REM_PERCENTAGE ICON_INDEX <<< "$(
    awk -v total="$TOTAL_CREDS" -v usage="$TOTAL_USAGE" '
        BEGIN {
            if (total <= 0) {
                exit 1
            }

            used = (usage / total) * 100
            remaining = 100 - used

            if      (remaining > 80) icon = 0
            else if (remaining > 60) icon = 1
            else if (remaining > 40) icon = 2
            else if (remaining > 20) icon = 3
            else                     icon = 4

            printf "%.2f %.1f %d\n", used, remaining, icon
        }
    '
)" || error "Invalid Credits" "Total credits is zero or unavailable."

ICON="${ICONS[$((ICON_INDEX + 1))]}"

printf '{"text":"%s %.1f%%","tooltip":"Available Credits: %s\\nUsed: %s"}\n' \
    "$ICON" \
    "$REM_PERCENTAGE" \
    "$TOTAL_CREDS" \
    "$TOTAL_USAGE"
