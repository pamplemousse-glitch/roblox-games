# Catch a Cryptid — One-Day Build Plan

**Date:** June 7, 2026 (8 AM → 11 PM)
**Goal:** Soft-launched (unlisted) playable demo by 11 PM. Public launch June 8 morning.
**Why one day:** Front-run *Catch a Brainrot* (launches June 26). The pre-launch search wave for "Catch a *" starts ~June 20.

## Reality Check

Honest expectation by 11 PM: **playable single-biome demo with 3-4 cryptids, persistent saves, 1 gamepass wired, soft-launched (unlisted)**. Public launch is tomorrow morning after sleep + a smoke pass, not tonight. Trying to ship public tonight = launch broken = burn the algorithm boost.

## Scope Cuts vs. GAME_DESIGN.md

| Cut | Reason |
|---|---|
| 4 biomes → **1 biome (Forest)** | Each biome is 1-2hr of map work |
| 16 cryptids → **3 cryptids (Jackalope, Chupacabra, Mothman Cub)** | 15-30 min per voxel model |
| 3 traps → **1 trap (Snare)** | Skip workbench, ranger sells it |
| 3 minigames → **1 (mash bar)** | Hold + QTE deferred |
| Trophy wall → **counter only** | UI cost too high |
| Weather/day-night → **deferred** | Pure cost, no MVP value |
| 7 gamepasses → **1 (2x Coins)** | Standard SKU, fastest to wire |
| Bait system → **auto-bait** | Inventory UI is a half-day on its own |
| Enclosure tiers/happiness → **single tier, no decay** | Cut FOMO mechanic for v1 |
| Social plot visits → **deferred** | Solo MVP |

## Hour-by-Hour Plan

| Time | Block | Deliverable | Verification gate |
|------|-------|-------------|-------------------|
| **8:00-8:30** | Setup | Rojo serving, Studio + MCP connected, hello-world sync test | Print "sync ok" from Common module via `execute_luau` |
| **8:30-9:30** | Data model | `Constants.luau`, `Types.luau`, `PlayerData.server.luau` with DataStore save/load | Save → kick → rejoin → coin balance persists |
| **9:30-10:30** | Base Camp + Forest map | Spawn lobby with ranger NPC stub. 100×100 Forest with trees, fog, teleport pad | Walk lobby → forest → back; FogEnd verified |
| **10:30-12:30** | **3 cryptid voxel models + AI** | Jackalope, Chupacabra, Mothman Cub built in Studio. `CryptidSpawner.server.luau` patrols them around Forest | Run audit: 3 cryptids visible, wandering, not falling through floor |
| **12:30-1:00** | LUNCH | | |
| **1:00-2:30** | Trap system | Place trap (E key), ghost preview, server-validated drop, cryptid proximity trigger | Place trap → walk away → cryptid lured → cage closes |
| **2:30-3:30** | Catch minigame | Mash-bar UI, server validates inputs, success → captured ball over head, fail → escape | Catch a Jackalope end-to-end, win and lose paths both work |
| **3:30-4:30** | Plot + Enclosure | Per-player plot tile, 2 enclosure pads, `EnclosureCash.server.luau` ticking coins/sec | Place cryptid → coins tick → walk to vault → wallet updates |
| **4:30-5:30** | HUD + shop | Coin counter, held-cryptid indicator, shop button → buy extra Snare | Buy 3 traps over a play session, cash math correct |
| **5:30-6:00** | DINNER | | |
| **6:00-7:00** | Monetization | 1 gamepass: 2x Coins. MarketplaceService wired, multiplier applied to enclosure tick | Studio test purchase flow, multiplier appears in cash logs |
| **7:00-8:00** | Polish + bug pass | Full solo run-through. Fix top 3 bugs found. 1 ambient track, 3 SFX (place trap, catch success, catch fail) | Solo loop: spawn → catch → place → coins → buy → catch again. No errors in Output. |
| **8:00-9:00** | Thumbnail + store page | Studio camera pose with cryptid + fog + neon trap. Title overlay. Store description. **Publish UNLISTED.** | Open the place URL on phone, mobile camera works |
| **9:00-10:00** | Friends smoke test | DM 2-3 friends the unlisted link. Watch them play. Note bugs. | Two players in server simultaneously, both DataStores save |
| **10:00-11:00** | Buffer + sleep prep | Fix any critical issue from friends test. Write tomorrow's launch checklist. **Stop.** | |

## "Done" at 11 PM Means

- Unlisted Roblox place URL exists
- Player can: spawn → walk to forest → see a cryptid → trap it → catch minigame → bring to enclosure → coins tick → buy another trap → repeat
- 2x Coins gamepass purchasable, multiplier works
- Friends can play and progress saves between sessions
- Thumbnail and game icon uploaded
- Store description written

## Tomorrow (June 8) — Launch Day

- Public launch toggle flipped
- TikTok clip recorded from a friend's mythic catch
- Reddit post in r/roblox + r/RobloxDev
- Watch CCU + first revenue numbers
- Hotfix anything that broke at scale

## Three Threats to Timeline (and mitigations)

1. **DataStore bugs eat 2 hours.** Have a `pcall` fallback to in-memory if DataStore times out — kick player politely with a save warning rather than crash.
2. **Cryptid AI feels bad.** Don't perfect it. Patrol points + random wander = good enough for v1. Resist the urge to write proper pathfinding.
3. **The mash minigame feels unfair.** Tune mash threshold low (10 clicks in 5s). Better to ship "too easy to catch" than "rage-quit hard." Tune up after launch data.

## Discipline Rules (per project memory)

- **One fix per commit.** No stacking debugging fixes. Verify each before the next.
- **Falsifiable test before commit.** Every hypothesis = one-line `execute_luau` predicate before shipping.
- **Test between merges, not after all of them.** Smoke playtest after each hour block, not at 7 PM.
- **No hardcoded coordinates.** Look up live every time. Studio state drifts.
- **No blanket `GetDescendants` loops without modeling side effects.** Especially around `CanCollide`.
- **Voxel/blocky Studio primitives only.** No Blender, no external mesh pipelines.
