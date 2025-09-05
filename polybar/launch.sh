#!/usr/bin/env bash

killall -q polybar

echo "---" | tee -a /tmp/polybar.log

polybar main-top 2>&1 | tee -a /tmp/polybar-top.log & disown
polybar main-bottom 2>&1 | tee -a /tmp/polybar-bottom.log & disown

echo "Bars launched"
