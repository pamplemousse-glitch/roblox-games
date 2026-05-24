#!/bin/bash
# Check if Roblox Studio is running (official MCP uses stdio, not HTTP).
# Exits 2 (asyncRewake) if Studio is running → wakes Claude to run init sequence.
# Exits 0 silently if Studio is not open.
case "$PWD" in
  /Users/antoinewiley/Roblox/*)
    sleep 2
    pgrep -x "RobloxStudio" > /dev/null 2>&1 && exit 2 || exit 0
  ;;
esac
