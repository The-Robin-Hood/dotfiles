#!/usr/bin/env zsh

STATE_DIR="/tmp/have-to-go"
PID_FILE="$STATE_DIR/pid"
TIME_FILE="$STATE_DIR/target"
GRACE_MINUTES=3

mkdir -p "$STATE_DIR"

# -------------------------
# Print remaining time
# -------------------------
print_remaining() {
  [[ -f "$TIME_FILE" ]] || { echo '{"text":"","msg":"no active timer"}'; return }

  REMAIN=$(( $(cat "$TIME_FILE") - $(date +%s) ))

  if (( REMAIN <= 0 )); then
    echo "Timer expired."
    return
  fi

  printf '{"text":"T-minus: %02d:%02d:%02d","tooltip":"Move your ass"}\n' \
    $((REMAIN/3600)) $(( (REMAIN%3600)/60 )) $((REMAIN%60))
}

# -------------------------
# Handle special commands
# -------------------------
case "$1" in
  remaining)
    print_remaining
    exit 0
    ;;
  kill)
    if [[ -f "$PID_FILE" ]]; then
      PID=$(<"$PID_FILE")
      kill -0 "$PID" 2>/dev/null && kill "$PID"
      rm -f "$PID_FILE" "$TIME_FILE"
      echo "Timer killed."
    else
      echo "No active timer."
    fi
    exit 0
    ;;
esac

# -------------------------
# Check existing timer
# -------------------------
if [[ -f "$PID_FILE" ]]; then
  PID=$(<"$PID_FILE")
  if kill -0 "$PID" 2>/dev/null; then
    print_remaining
    exit 0
  else
    rm -f "$PID_FILE" "$TIME_FILE"
  fi
fi

if [[ -z "$1" ]]; then
  if command -v rofi >/dev/null 2>&1; then
    INPUT=$(echo "" | rofi -dmenu -p "Butt Out in:"  -theme-str 'listview {lines:0;}')
  else
    echo "Usage: have-to-go <10m | 2h | 4:15>"
    exit 1
  fi

  [[ -n "$INPUT" ]] || { echo "No input provided."; exit 1 }
else
  INPUT="$1"
fi


get_seconds() {
  NOW=$(date +%s)

  if [[ "$INPUT" == <->m ]]; then
    echo $(( ${INPUT%m} * 60 ))
    return
  elif [[ "$INPUT" == <->h ]]; then
    echo $(( ${INPUT%h} * 3600 ))
    return
  elif [[ "$INPUT" == <->:<-> ]]; then
    hour=${INPUT%%:*}
    min=${INPUT##*:}
    candidates=()

    for add in 0 12; do
      h=$(( (hour % 12) + add ))
      TARGET=$(date -d "today $h:$min" +%s 2>/dev/null) || continue
      (( TARGET > NOW )) && candidates+=($TARGET)
    done

    if (( ${#candidates[@]} > 0 )); then
      # Pick earliest future candidate
      TARGET=$candidates[1]
      for t in "${candidates[@]}"; (( t < TARGET )) && TARGET=$t
    else
      TARGET=$(date -d "tomorrow $((hour % 12)):$min" +%s)
    fi

    echo $(( TARGET - NOW ))
    return
  fi

  return 1
}

SECONDS_TO_WAIT=$(get_seconds)
[[ -n "$SECONDS_TO_WAIT" ]] || { echo "Invalid format. Use 10m | 2h | 4:15"; exit 1 }

# -------------------------
# Schedule timer
# -------------------------
TARGET_TIME=$(( $(date +%s) + SECONDS_TO_WAIT ))
echo "$TARGET_TIME" > "$TIME_FILE"

(
  sleep "$SECONDS_TO_WAIT" || exit

  zenity --question \
    --title="Have To Go" \
    --text="Time's up.\n\nShutdown now?\n\nCancel = 3 min delay"

  if (( $? == 0 )); then
    shutdown now
  else
    shutdown +$GRACE_MINUTES &>/dev/null
  fi

  rm -f "$PID_FILE" "$TIME_FILE"
) &

echo $! > "$PID_FILE"
disown
