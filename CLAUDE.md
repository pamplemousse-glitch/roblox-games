# Roblox Dev — Shared Context

Applies to every game under this folder. Game-specific details are in each project's own CLAUDE.md.

## Language / Runtime
- Luau (NOT standard Lua). `.server.luau` = server only. `.client.luau` = client only. `.luau` = shared module.
- All game logic in `src/`, synced to Studio via Rojo.

## Architecture
- `src/Server/` — authoritative logic, DataStore, never trust client
- `src/Client/` — UI, input, visual feedback only
- `src/Common/` — constants, types, utility modules (imported via `require()`)
- RemoteEvents/RemoteFunctions in ReplicatedStorage for all server↔client calls

## Key APIs
- `game:GetService("Players")` — player management
- `game:GetService("ReplicatedStorage")` — shared remotes/assets
- `game:GetService("DataStoreService")` — persistence (server only, pcall-wrapped)
- `game:GetService("RunService")` — IsServer/IsClient, frame loops
- `game:GetService("TweenService")` — animations

## Coding Rules
- Validate everything on server — client input is untrusted
- `task.spawn()` not `coroutine.wrap()` | `task.wait()` not `wait()`
- All DataStore calls in pcall
- Scripts ≤ 300 lines — split into modules if larger
- No monetization UI before 15 min of play

## Dev Environment (Intel Mac)
- Rokit tools at `~/.rokit/bin/` — `export PATH="$HOME/.rokit/bin:$PATH"` before using rojo/wally
- SessionStart hook auto-starts `rojo serve` if not already running
- Studio must be open with Rojo plugin connected before testing

## MCP (Claude → Studio control)
- **Transport: stdio** — the official MCP binary is `/Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`
- **NOT HTTP/port 58741** — that was the old community plugin (@BoshyDx). The official MCP does NOT use a port.
- **Namespace: `mcp__Roblox_Studio__*`** (uppercase, matches server name in `.mcp.json`)
- Config is in `~/Roblox/.mcp.json` — inherited by all Roblox project sessions
- **Always call `mcp__Roblox_Studio__list_roblox_studios` then `mcp__Roblox_Studio__set_active_studio` before any other MCP tool**
- Studio must have "AI-Powered Code Assistant & MCP" beta enabled, and MCP server toggled on via: Assistant → … → Manage MCP Servers → Enable Studio as MCP server

### Available tool categories
- **Scripts**: `script_read`, `multi_edit`, `script_search`, `script_grep`
- **Execution**: `execute_luau`
- **Data model**: `explore_subagent`, `search_game_tree`, `inspect_instance`
- **Playtesting**: `start_stop_play`, `console_output`, `screen_capture`, `playtest_subagent`
- **Player input**: `character_navigation`, `keyboard_input`, `mouse_input`
- **Asset gen**: `generate_mesh`, `generate_material`, `insert_from_creator_store`
- **Session**: `list_roblox_studios`, `set_active_studio`
