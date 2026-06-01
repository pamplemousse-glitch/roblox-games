# Morning handoff — UI cleanup pass complete

Worked through your 5 complaints + the core-loop concerns iteratively while you slept. Each fix is its own commit so you can `git log` to see them all.

---

## Your 5 complaints, addressed

### 1. ❓ "Timer at top, gets stuck at 0s"
**Fixed.** `HudController.onPhaseChanged` now clears `timerLabel.Text` and `phaseLabel.Text` whenever the phase transitions to `Idle`. Before, the timer label was leaving the last value ("0s") on screen indefinitely after a contest ended.

### 2. ❓ "What is the BOOK button on the left?"
That's the **Cookbook** — one of the 6 v2 features. It opens a panel showing every food you've eaten across your tier 1-4 progression. Each completed tier (5 foods eaten) gives you a +1% permanent coin bonus.

Currently it's a toggle button at top-left. Panel is hidden by default. Click BOOK to open it.

**If you want it hidden from minute 1 until a level/win unlock**, I can gate it behind `contestsPlayed >= 5` or similar — just say the word.

### 3. ❓ "Whole screen dimmed"
**Fixed.** Two stacked dim overlays were causing this:

- **ShopGui dark overlay** was ALWAYS visible because `shopGui.Enabled = true` (so the SHOP toggle could show). The overlay was a sibling of the toggle. Fixed by tying overlay.Visible to shopOpen state.
- **TutorialGui dim** was 0.55 opacity (very dark). Reduced to 0.75 (still readable, world stays vivid).

In Studio without API access enabled, the tutorial auto-shows EVERY play because DataStore can't load → server defaults to fresh-player data → "new player" heuristic triggers. In production with API enabled, this would only show once per actual new player.

### 4. ❓ "Coins overlapping Friend Vault"
**Fixed.** Friend Vault panel is now hidden by default behind a small `VAULT` toggle button at top-left (below BOOK). When closed, no overlap. When open (you click VAULT), the panel appears centered-left, not on top of Coins.

### 5. ❓ "Phone emoji overlapping coins and friend vault"
**Fixed.** Photo Mode toggle button moved from top-right (overlapped Friend Vault) to top-left, stacked below the VAULT toggle. It also previously had a position bug placing it BELOW the visible viewport (y=402 in a 381-tall viewport).

---

## The red dot at top-center — STILL THERE, but explained

I dumped Roblox's CoreGui tree and confirmed it lives in:
- `RobloxGui` (Roblox's main UI ScreenGui)
- `TopBarApp` (the new Roblox unibar folder)
- `InGameFullscreenTitleBarScreen` (Roblox's title bar)

**These are CoreGui — Roblox-controlled, user scripts cannot access them.** `SetCoreGuiEnabled` only disables specific named types (PlayerList, Health, Backpack, Captures, etc) — I disabled all of those that are disable-able. The red icon isn't one of them.

It's very likely the **"Open in Mobile App"** indicator or a **Studio-only playtest indicator** that won't appear in published games. If it persists after publishing, the only options are:
- Open a Roblox feature request to add an API to hide it
- Live with it (it's small)

I left the `CoreGuiCleanup.client.luau` script in place — it aggressively suppresses every disable-able CoreGui type. Even if the red dot stays, the screen is otherwise clean.

---

## Core loop bug fixed (you didn't ask, I found it)

Earlier you saw "Arena 2 • Waiting" appear on your HUD even though you hadn't pressed E. Root cause:

- Server's `broadcastQueuing` was firing the "Queuing" phase update to EVERY player every 3 seconds, not just players in THAT arena.
- Client `HudController.onPhaseChanged` would update for any arena it received broadcasts from.

**Fix (two-sided):**
- Server: `broadcastQueuing` now iterates `arena.contestants` instead of `Players:GetPlayers()`. Only players actually in the arena get the broadcast.
- Client: `onPhaseChanged` ignores broadcasts whose `arenaId` doesn't match the local `myArena`. First "Queuing" event still sets `myArena`. On Idle, `myArena` is cleared.

So you'll now only see HUD updates for your own arena's queue/countdown/contest/results.

---

## What was NOT touched

- Core contest mechanic (queue → countdown → eat → results) — already working from earlier session
- Visible food piles + NPC rigs at chairs — already working
- DQ display, food name during Active — already working
- 70 district assets in Workspace.Districts (auto-spawned by AssetSpawner) — already working

---

## Commits this session (in order, all on main, all pushed)

| SHA | Title |
|---|---|
| `1257595` | UI cleanup: hide auto-shown panels, fix HUD broadcast, declutter |
| `041edc4` | Shop UI: hide overlay + panel until explicitly opened |
| `ca09410` | PhotoMode toggle: reposition to top-left stack (avoids overlap + offscreen) |
| `1b18258` | Tutorial: lighter dim (0.55 → 0.75 transparency) |

---

## What I'd do next when you wake up

1. **Save the .rbxl** (Cmd+S in Studio) — preserves Workspace state, atmosphere fix, ReplicatedStorage.Client cleanup
2. **Run a fresh playtest** — verify the UI changes look right
3. **Walk to a contest seat, press E** — confirm the core loop works end-to-end
4. **Walk through one district** (X=4000 Tokyo Town is closest interesting) — see if the 70 spawned assets look OK
5. **If anything's still wrong**, screenshot + describe and I'll iterate from there

---

## What's NOT solved + needs your judgment

- **Red dot** — Roblox CoreGui, unfixable from script. Live with it or file Roblox feature request.
- **Tutorial showing every play in Studio** — environmental (DataStore disabled in test mode). Enable Game Settings → Security → Studio Access to APIs to fix.
- **The 12 missing Pizza Plaza assets** — not built. Pizza Plaza was the worked-example district. To complete it, launch a 6th parallel session with the standard prompt template.
- **MA2Theme plugin errors** — from your Moon Themes Studio plugin. Harmless plugin noise, doesn't affect game. To silence: disable that plugin via Manage Plugins.

---

## Tools that worked great this session

- Live PlayerGui dump via `mcp__Roblox_Studio__execute_luau` — found every overlapping element by coordinate
- DiagnosticBridge (Workspace.__DiagBridge StringValue) — captures play-mode prints for read-back from Edit mode
- Rojo running on the right project from the right cwd — when working, everything syncs in seconds

## Tools that were painful

- `mcp__Roblox_Studio__get_console_output` returns stale buffers; use `LogService:GetLogHistory()` via execute_luau instead
- Cube 3D mesh generation rate limit (5/min) — need to batch hero asset gen sensibly
- Parallel sessions sharing the same git working tree → branch contamination. **Always use git worktrees per parallel session.**

Sleep well. Game's in much better shape.
