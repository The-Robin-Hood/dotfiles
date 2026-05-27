#!/usr/bin/env zsh

STATUS=$(curl -s http://localhost:9842/status)

case "$STATUS" in
    idle) ICON="" ;;         
    recording) ICON="" ;;    
    processing) ICON=" " ;;   
    transcribing) ICON="󰆄" ;; 
    *) ICON="" ;;
esac

echo "{\"text\":\"$ICON\"}"



