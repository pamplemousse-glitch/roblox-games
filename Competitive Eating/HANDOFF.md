# Competitive Eating — Session Handoff

## Project State: MVP COMPLETE — ALL SCREENS BUILT, LOOP VERIFIED 3×

Full game loop verified end-to-end multiple times: Queue → NPC backfill → Countdown (Shea intro) → Active (rings fire, live scoreboard with NPC bites) → Results overlay (places + coins + Shea outro) → back to Queue. Coins accumulate across contests. Shop opens/closes correctly.

---

## Save Protocol

- **Source files (`src/`)** are the source of truth — every edit goes directly to disk.
- **Studio .rbxl** is secondary. Rojo syncs disk → Studio.
- After major work, human should Cmd+S in Studio and File → Publish to Roblox.

---

## What's Built

### File tree (all synced to Studio via Rojo)
```
src/
├── Common/
│   ├── Constants.luau     ✓ All game constants
│   ├── Types.luau         ✓ Luau type exports
│   └── Utils.luau         ✓ Math helpers
├── Server/
│   ├── Main.server.luau   ✓ Entry point — creates RemoteEvents, inits services
│   └── Services/
│       ├── DataManager.luau    ✓ DataStore load/save/cache, auto-save 60s
│       ├── PlayerService.luau  ✓ PlayerAdded/Removing, fires StatsUpdate
│       ├── ContestService.luau ✓ Full arena state machine (3 arenas)
│       ├── NpcService.luau     ✓ NPC fill simulation, pause mechanic
│       └── UpgradeService.luau ✓ PurchaseUpgrade handler, rate-limited
└── Client/
    ├── Main.client.luau   ✓ Entry point — waits for Remotes, inits controllers
    └── Controllers/
        ├── ContestController.luau    ✓ Ring UI + input + SkillCheckResult
        ├── HudController.luau        ✓ Full HUD: fill meter, scoreboard, timer,
        │                               results overlay, coin counter, DQ label,
        │                               bite counter, danger pulse, queue/countdown
        ├── ShopController.luau       ✓ Upgrade shop UI + buy flow
        └── OnboardingController.luau ✓ First-play tutorial overlay
```

### Rojo config: `default.project.json`
- `src/Server/` → ServerScriptService
- `src/Common/` → ReplicatedStorage/Common
- `src/Client/` → StarterPlayer/StarterPlayerScripts

---

## Core Game Loop (fully working)

Queue(15s) → Countdown(5s) → Active(90s) → Results(15s) → repeat

- 3 arenas staggered 42s apart (always a contest starting within ~30s)
- Hot Dog Ring skill check: rotating needle, tap to land in green arc
- Fill meter: server-authoritative, replicated every 0.5s
- DQ at 100% fill; win by most bites
- 4 stats: StomachCapacity, JawSpeed, SwallowRate, Focus (levels 0–50)
- NPC backfill at T-10s of queue; 3 difficulty tiers
- Coin economy + upgrade shop
- Daily first-win bonus, win streak multiplier (up to 1.5×)

---

## RemoteEvents (created by Main.server.luau at runtime, folder = ReplicatedStorage/Remotes)
- `SkillCheckStart` — server → client: ring parameters
- `SkillCheckResult` — client → server: hit/alignment/isGreat
- `FillUpdate` — server → client: fill snapshot every 0.5s
- `ContestPhaseChanged` — server → client: state transitions + announcements
- `ShowResults` — server → client: final places + coins earned
- `JoinQueue` / `LeaveQueue` — client → server
- `PurchaseUpgrade` — client → server: stat name
- `StatsUpdate` — server → client: updated stats/coins/tier

---

## MCP Setup (complete)

- Official Roblox Studio MCP: `mcp__Roblox_Studio__*` (stdio, not HTTP)
- Binary: `/Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`
- Configured globally via `claude mcp add`
- Studio: "Enable Studio as MCP server" toggled ON in Assistant → MCP Servers
- Community @BoshyDx plugin: DELETED
- `~/Roblox/.mcp.json` also exists as backup project-scoped config
- Always call `list_roblox_studios` → `set_active_studio` first in each session

---

## Dev Environment

- Rojo: `rojo serve` auto-starts via SessionStart hook when in `~/Roblox/*`
- Rojo plugin in Studio: enabled (green toggle in Plugin Management)
- Studio file: `/Users/antoinewiley/Documents/Competitive Eating.rbxl`
- `export PATH="$HOME/.rokit/bin:$PATH"` needed for rojo/wally CLI tools
- **Note**: Rojo sync only applies in edit mode, not during play mode. Stop the playtest before expecting edits to sync.

---

## All Screens (complete)

### Active phase
- Ring skill-check UI (green arc, gold great-zone, red needle)
- Fill meter (left bar, color-coded: green/yellow/red)
- **Danger pulse**: at 90%+ fill, bar pulses red (TweenService loop)
- **DISQUALIFIED** label on overflow (auto-hides when Results start)
- Bite counter above fill meter
- Live scoreboard (right side, sorted by bites desc)
- Timer showing seconds remaining
- SHOP button hidden during Active

### Queuing phase
- "Arena X • Waiting (N/4 seated)" status label
- Local countdown timer (syncs every 3s from server re-broadcasts)
- SHOP button visible

### Countdown phase
- George Shea intro line displayed
- 5-4-3-2-1 local timer

### Results phase (15s overlay)
- "RESULTS" title
- George Shea outro quote
- Full leaderboard: place, name, bites (local player highlighted in blue/gold)
- "+ N coins earned!" or "Better luck next time!"
- Auto-dismisses after RESULTS_DURATION

### Always visible
- Coin counter (top-right, updates on every StatsUpdate)
- SHOP button (bottom-right, hidden during Active)

---

## Bug Fixes Applied (across sessions)
1. **Player never entered contests** — client received Queuing phase but never fired JoinQueue; fixed
2. **All skill check hits rejected** — biteIndex missing from client result payload; fixed
3. **HUD race condition** — server broadcast "Queuing" once before client listeners connected; fixed by re-broadcasting every 3s
4. **DataStore crash** — GetDataStore() outside pcall; fixed with nil guards
5. **NPC biteCount always 0** — `math.floor(fillRate * dt / BASE + 0.5)` with dt=0.05s always rounded to 0; fixed to `math.floor(fillValue / FILL_PER_BITE_BASE)`
6. **Player didn't rejoin contests** — `alreadyQueued` flag got stuck true when Arena 2 broadcast fired while player was in Arena 1; removed flag entirely (server handles deduplication)

---

## Known Remaining Gaps (post-MVP polish)

### Not yet built (low priority for MVP)
- Art assets, ImageLabels with textures, particle effects
- Sound effects (SoundService)
- Tier 2/3/4 content (Tier 1 only so far)
- Global leaderboard (needs separate DataStore schema)
- Monetization UI (VIP, game passes, Style Bucks)

### DataStore in Studio
- DataStore API is not available in Studio without enabling "Enable Studio Access to API Services"
- Game falls back gracefully to default player data (0 coins, base stats)
- To test persistent data: Settings → Security → Enable Studio Access to API Services, OR publish to Roblox and test live

---

## Constants Quick Reference
- `QUEUE_DURATION = 15` | `COUNTDOWN_DURATION = 5` | `CONTEST_DURATION = 90` | `RESULTS_DURATION = 15`
- `FILL_OVERFLOW = 1.0` | `FILL_DANGER = 0.90` | `FILL_CAUTION = 0.75`
- `RING_SPEED_BASE = 240°/s` | `RING_ARC_BASE = 54°` | `RING_DURATION = 1.5s`
- `STAT_MAX_LEVEL = 50` | `UPGRADE_COST_BASE = 50` (cost = base × level²)
- `COIN_BY_PLACE = {60, 40, 25, 15}` | `COIN_FIRST_WIN_DAILY = 100`
- `ARENA_COUNT = 3` | `SEATS_PER_ARENA = 4` | `ARENA_STAGGER = 42s`
