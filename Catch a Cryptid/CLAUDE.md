# Catch a Cryptid — Project Context

Shared Roblox dev context (Luau, Rojo, MCP, coding rules) is in the parent `Roblox/CLAUDE.md`.

## Why This Game Exists
Front-running the **Catch a Brainrot** launch (June 26, 2026). Roblox algorithmic search floods "Catch a *" the week of the 26th — any Catch-a-X clone live before that date catches the discovery wave for free.

**Ship deadline: June 20, 2026.** 5-7 day build budget.

Template provenance: Catch-a-X is the next dominant `[verb] a [noun]` formula on Roblox after Grow-a-X and Steal-a-X. Currently only *Catch and Tame* (~20K CCU) is climbing organically.

## Pitch
Hunt cryptids in foggy biomes (forest, swamp, snowy mountains, suburban sewers). Set traps, catch the creature, keep it in an enclosure on your plot. Cryptids generate cash per second. Rarer cryptids = more cash = better traps = rarer cryptids.

## Core Game Loop
1. Spawn at base camp with a starter trap
2. Walk into a biome → find tracks → bait + set trap → wait for trigger
3. Catch a cryptid (escape mini-game; tap-to-secure or lose it)
4. Return to your plot → place cryptid in an enclosure
5. Enclosure ticks coins/sec based on cryptid rarity
6. Spend coins on better traps, more plots, rarer-biome access

## Cryptid Roster (royalty-free)
Tier 1 (common): Jackalope, Chupacabra, Loch Ness, Mothman cub
Tier 2 (uncommon): Bigfoot, Jersey Devil, Yeti, Wendigo
Tier 3 (rare): Mothman adult, Skinwalker, Mokele-mbembe, Thunderbird
Tier 4 (mythic): Black Shuck, Owlman, Flatwoods Monster, Beast of Bray Road
Ship with 8-12 at launch. Add 2-4 per weekly update.

## Monetization (post 15-min gate)
- **2x Coins** gamepass (~$99 Robux) — standard SKU
- **Lucky Trap** gamepass (~$149 Robux) — higher rarity rolls
- **Auto-Collect** gamepass (~$199 Robux) — enclosure cash auto-deposits
- **Mythic Bait** dev product (~$99-399 Robux) — guarantees tier-4 spawn next trap
- **VIP Plot Slot** gamepass (~$249 Robux) — +2 enclosure slots
- Never sell cryptids directly for Robux (preserves trade economy)

## Art Style
**Voxel/blocky Studio primitives only.** Stack `Part` instances for cryptid bodies. No Blender, no external mesh pipelines (see parent memory `feedback_art_style`). Each cryptid ~100-300 primitives, ~15-30 min to model in Studio.

Visual mood: dark forest, neon trap UI, glowing eye-cubes on cryptids.

## Dev Commands
- Rojo sync: `cd ~/Roblox/Catch\ a\ Cryptid && rojo serve`
- MCP: studio must be open with this `.rbxl` active

## Open Decisions
- Title test before launch: "Catch a Cryptid" vs "Trap a Cryptid" vs "Catch a Monster"
- Trap mechanic: timer-based vs minigame-based capture
- PvP: pure single-player plot, or allow steal mechanics like Steal-a-Brainrot?
