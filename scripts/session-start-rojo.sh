#!/bin/bash
# Auto-start rojo serve when opening a Roblox project session.
# Runs as an async SessionStart hook — silent on success.
case "$PWD" in
  /Users/antoinewiley/Roblox/*)
    export PATH="$HOME/.rokit/bin:$PATH"
    if ! pgrep -f 'rojo serve' > /dev/null; then
      LOG="/tmp/rojo-$(basename "$PWD" | tr ' ' '-').log"
      nohup rojo serve > "$LOG" 2>&1 &
    fi
  ;;
esac
