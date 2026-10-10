#!/bin/sh
# skip suspend while an incoming ssh session is established
# (hypridle refires this listener every 1200s while idle, so it retries
#  once the ssh connection drops)
ss -H -tn state established '( sport = :22 )' | grep -q . && exit 0
systemctl suspend
