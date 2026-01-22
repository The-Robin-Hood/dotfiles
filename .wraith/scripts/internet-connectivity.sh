#!/usr/bin/zsh

STATE=$(nmcli -t -f STATE g)
CONNECTIVITY=$(nmcli -t -f CONNECTIVITY g)


if [[ "$STATE" != "connected" ]]; then
    echo "󰢿 Disconnected"
    exit 0
fi

# If connected, check how
if [[ "$CONNECTIVITY" == "full" ]]; then
    ICON="󰢾"   # full connectivity
elif [[ "$CONNECTIVITY" == "limited" ]]; then
    ICON="󰤧"   # limited connectivity
else
    ICON="󰤦"   # no connectivity
fi

SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
echo "{\"text\": \"$ICON\", \"tooltip\": \"$SSID\"}"