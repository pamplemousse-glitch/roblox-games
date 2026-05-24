# FunGuy — Project Context

Shared Roblox dev context (language, architecture, MCP, coding rules) is in the parent `Roblox/CLAUDE.md`.

## Project
Mushroom idle/AFK cave game. Low-poly, dark bioluminescent aesthetic. First-mover in empty niche on Roblox.
Goal: playable MVP → published game → $20-30K/mo long-term.

## Core Game Loop
1. Player enters cave → mushrooms grow passively (AFK spore loop)
2. Collect spores → spend in shop on upgrades/new species
3. Weather events (10-min windows) trigger rare mutations → multiplicative value boost
4. Daily login streak + quests → reasons to return
5. Prestige (Sporulate) → resets progress, multiplies future earnings

## Monetization (post 15-min gate)
- Subscription (recurring Robux): VIP cave perks — highest priority
- Rewarded video ads: opt-in spore boosts
- Limited cosmetic drops: seasonal timed events
- Developer Products: consumable boosts
- Game Passes: 2x production, exclusive species, VIP access

## Species Plan
- Launch: 35 species (5 tiers: Common → Mythic)
- Updates add batches → 350+ total target
- See RESEARCH.md for full species list and update roadmap

## Status
- All Phases 0–11 complete. Game is playable end-to-end.
- 36 mushroom models in Studio (Root+Cap+GlowLight, scaled to tier heights, anchored)
- Floor-level Neon root tendrils replace the old pedestal look (MushroomManager)
- Physical sign plaques (ZoneSigns) replace all BillboardGuis — no more wall bleed-through
- The Deep gate currently removed for testing — restore to 12 mushrooms before launch
- Next priorities: tutorial/onboarding, personal cave instancing, The Deep gate restore

## Dev Notes
- Rojo sync: `cd ~/Roblox/my-roblox-clicker-game && rojo serve build.project.json`
- Full dev pipeline (with darklua): `sh scripts/dev.sh`
