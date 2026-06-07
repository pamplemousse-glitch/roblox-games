# Catch a Cryptid — Game Design

## The First 60 Seconds (the hook)

Player spawns at **Base Camp**: a small fog-wreathed cabin with a flickering bug zapper. A weathered ranger NPC (voxel guy in a Smokey hat) blocks the path: *"There's somethin' in the woods, kid. Take this trap. Catch me a Jackalope and I'll let you in."*

He hands the player a **Wooden Snare Trap** (single-use cage). The forest gate behind him opens, fog rolling out. A glowing **green paw print trail** appears, leading into the trees. The player follows it ~30 feet, sees a low-poly **Jackalope** (cube body + antler-wedges) nibbling a glowing mushroom. They sneak up, hit `E` to **place trap** on the ground, drop **carrot bait**, and back away.

10 seconds later: the Jackalope hops in, cage slams shut, screen shakes, a **golden "CATCH SECURED!"** banner pops. The Jackalope shrinks into a glowing ball that floats over their head. They return to the cabin. The ranger gives them their **first plot** — a tiny wooden fenced square — and a starter enclosure pen. They drop the Jackalope in. A counter starts: **+2 coins/sec**. The tutorial is over. They're hooked.

**Total tutorial time: 90 seconds. That's the entire onboarding.**

## The Core Loop (post-tutorial)

```
Hunt → Bait → Trap → Catch minigame → Return → Place in enclosure → Coins tick → Buy upgrades → Unlock harder biome → repeat
```

Five touchpoints, all <30 seconds each. The loop is *fast* by design — kids on a tablet on a school bus need to feel three "catches" per ride.

## The Hunt (mechanics in detail)

Each biome is a fog-shrouded ~200x200 stud open area. Cryptids spawn at random patrol points and walk pre-baked paths. The player sees them as **silhouettes in the fog at ~50 studs**, full color at ~20 studs. Visibility matters — you can't just camera-spin and spot every cryptid.

**Tracking:** every cryptid leaves a **colored particle trail** keyed to rarity:
- Common = green paw prints
- Uncommon = blue
- Rare = purple
- Mythic = gold with audio sting

Trails fade after 20 seconds, so fresh trails = nearby cryptid. This is the moment-to-moment gameplay: **scanning fog for color**.

**Bait:** different cryptids prefer different bait. Jackalopes like carrots, Chupacabras like raw meat, Mothmen like glowing lanterns. Wrong bait = creature ignores trap. Bait is consumed per use. Lucky Bait gamepass guarantees a hit.

## The Trap (the central skill check)

Trap is placed on the ground (3-second arming animation). Bait dropped on top. Player has to **move 30+ studs away** or the cryptid won't approach. Anxiety design: you can see the cryptid sniffing toward your trap from a distance — will it work?

**Three trap types at launch:**
1. **Snare Trap** (cheap, slow trigger, common cryptids only)
2. **Iron Cage** (medium, faster, uncommon+rare)
3. **Spirit Net** (gold-tier, instant trigger, required for mythic)

Trap quality gates progression. You can't catch a Mothman with a Snare — physical gating prevents pay-to-win shortcuts on early content.

## The Catch Minigame (the TikTok moment)

Trap closes → 5-second **escape minigame** activates. Three random mechanics rotate:

1. **Mash:** spam click/tap to keep the cage closed. Bar drains, you fill it.
2. **Hold:** hold the trigger button. Cryptid shakes the cage in pulses — release at wrong moment = escape.
3. **Quick-time chain:** 3-5 directional inputs in sequence.

Fail = cryptid escapes (and *flees the biome for the day* — soft penalty). Success = capture animation, particles, "**SECURED!**" banner, leaderboard ping if rare+.

**This minigame is the TikTok moment.** Mythic catches get a 4-second cinematic (camera zooms, cryptid screams, lightning flash, name banner). Players will clip these.

## The Plot (your base)

Each player gets a private **plot** at Base Camp — a 30x30 stud fenced square. Plots contain:
- **Enclosures** (start with 2 slots, max 12)
- **Trophy Wall** (mounts shadow-silhouettes of every species caught — collection bait)
- **Trap Workbench** (craft/upgrade traps)
- **Cash Vault** (collect accumulated coins — must visit to collect unless Auto-Collect gamepass)

Plots are visible to other players who can visit ("plot tours" are the social hook — Brookhaven-style hangout layer). They **cannot steal** at launch (single-player economy — see open-decisions doc). Visit-only.

## The Enclosure (the idle income engine)

Each enclosure holds one cryptid. Cash/sec scales with:
- **Rarity tier** (1/2/4/10 coins/sec base)
- **Enclosure quality** (Wooden → Iron → Reinforced → Glass Dome → Mythic Vault — multiplies output)
- **Happiness** (feed weekly with bait — neglected = -50% output, soft FOMO mechanic)

**Total max passive income** at endgame: ~120 coins/sec. Endgame trap costs ~50K. That's a ~7-minute idle session per top-tier upgrade — exactly the dopamine cadence proven by *Pet Sim 99* and *Grow a Garden*.

## The Cryptid Roster (16 launch + roadmap)

### Tier 1 — Common (2 coins/sec) — Forest biome
- **Jackalope** — bunny + antler wedges, hops in arcs
- **Chupacabra** — sickly green dog-thing, spits
- **Mini-Nessie** — small green serpent, lives in pond patches
- **Mothman Cub** — fuzzy orange ball with two glowing eye-cubes

### Tier 2 — Uncommon (4 coins/sec) — Swamp biome
- **Bigfoot** — big brown blocky humanoid, lumbers slowly
- **Jersey Devil** — winged red goat, hops + glides
- **Yeti** — white cube-Bigfoot, snow biome variant
- **Wendigo** — skeletal antlered cube-figure, screeches

### Tier 3 — Rare (10 coins/sec) — Mountain biome
- **Mothman (adult)** — 7ft tall, red eye-cubes light biome at night
- **Skinwalker** — shape-shifts between human/wolf/owl during chase
- **Mokele-mbembe** — long-necked swamp dragon, ground rumble cue
- **Thunderbird** — gold-and-black, summons lightning particles

### Tier 4 — Mythic (25 coins/sec) — Suburban Sewers biome (unlocked endgame)
- **Black Shuck** — black dog with glowing red eyes, only spawns at night
- **Owlman** — humanoid owl, only spawns under full-moon weather
- **Flatwoods Monster** — green hooded blob with metallic skirt, very rare
- **Beast of Bray Road** — wolfman, requires Spirit Net + meat bait

**Post-launch additions (weekly):** Mongolian Death Worm, Loveland Frogman, Goatman, Pope Lick Monster, Dover Demon — there are ~200 documented cryptids; the content pipeline is infinite and royalty-free.

## The Biomes (5 at launch)

| Biome | Aesthetic | Cryptids | Unlock cost |
|-------|-----------|----------|-------------|
| **Misty Forest** | Pine + fog + glowing mushrooms | T1 + occasional T2 | Free |
| **Drowned Swamp** | Cypress trees, green water, fireflies | T1-T2 | 500 coins |
| **Frostpeak Mountains** | Snow, ice cliffs, aurora sky | T2-T3 | 5K coins |
| **Suburban Sewers** | Stormdrains, neon graffiti, sodium lights | T3-T4 | 50K coins |
| **The Backrooms (event)** | Yellow liminal hallways | Special event cryptids | Event-gated |

Each biome has a distinct **time-of-day cycle** (day/night/storm) that affects which cryptids spawn. Mothman is night-only. Owlman is full-moon-only. **Weather creates FOMO** — kids will log in *just* to see if the moon is full.

## The Hub / Social Layer

Base Camp = social hub. Other players visible. Plots visitable. **Trophy walls** are the bragging surface — when you visit someone's plot you see silhouettes of every cryptid they've ever caught.

**Leaderboard wall** at Base Camp shows:
- Top 10 richest (current coins)
- Top 10 most species caught
- Daily catch-streak rankings

Leaderboards are the *real* monetization driver — kids buy 2x Coins to climb past the kid in front of them.

## Monetization Beats (the slop layer)

| Touchpoint | Trigger | Offer |
|------------|---------|-------|
| First catch | Tutorial complete | "Speed boots ($79) — find cryptids faster!" |
| First failed catch | Cryptid escapes | "Lucky Trap ($149) — never miss again!" |
| 2nd enclosure full | All slots used | "VIP Plot ($249) — +2 slots!" |
| 15 min session | Time-gate end | "2x Coins ($99) — grind less!" |
| First mythic sighting | See but don't catch | "Spirit Net ($199) — required for mythic!" |
| Daily login | Day 3 | "Auto-Collect ($199) — never lose coins!" |
| Rare bait stock 0 | Out of bait | "Mythic Bait pack ($99) — instant rare!" |

**Never sell cryptids directly.** Selling the catch undermines the entire chase. Sell *advantages in catching*.

## The Viral / TikTok Mechanics

Engineered for clippability:
1. **Mythic catch cinematic** (4 seconds, screen flash, name banner)
2. **"99% escape" near-miss** — random escape minigames are tuned so ~1 in 8 ends with a literal cinematic last-second save
3. **Trophy wall reveal** — endgame players unlock a full mythic wall, screenshot-perfect
4. **Cryptid encounter audio stings** — each tier has a distinct musical sting. Mythic = full orchestral. Becomes a meme audio on TikTok.
5. **Naming system** — players can name caught cryptids. "Bigfoot Joel" stays in your enclosure forever.

## Endgame (why they don't quit at hour 5)

- **Compendium** — catch every cryptid in every biome (200+ post-launch). Each entry unlocks lore text.
- **Shiny/Mythic variants** — every cryptid has a 1/500 alt-color variant. Black Jackalope. Albino Mothman.
- **Mythic Vault enclosure** — endgame cosmetic, glass-domed museum. Aesthetic flex.
- **Weekly events** — special spawn windows (Friday the 13th = ghost cryptids, Halloween = double rares, etc.)
- **Trading** (post-launch v1.1) — peer-to-peer cryptid trades. This is when *real* retention kicks in. Estimated 30 days post-launch.

## Visual Identity

- **Voxel/blocky everything.** All cryptids are 100-300 part-stacks built in Studio. No Blender, no Meshy.
- **Palette:** desaturated forest (deep greens/grays) + neon accents (cryptid glow eyes, trap UI). Think *Don't Starve* meets Minecraft.
- **Lighting:** heavy fog (`Lighting.FogEnd = 80`), low ambient, **moody**. Sets it apart from the bright-pastel Grow-a-Garden look. Differentiation matters.
- **UI:** parchment-and-leather "ranger field journal" aesthetic. Bestiary, trap inventory, plot manager all themed as torn notebook pages with tape.

## Audio Identity

- **Ambient:** wind, distant howls, owls, log creaks. Crucial — silence + sudden cryptid sting = dopamine.
- **Cryptid stings:** each tier has unique audio cue when sighted. T4 mythic = orchestral hit + thunderclap.
- **Catch success:** big "GOTCHA!" stinger, satisfying.
- **Failure:** cartoon "boing" — keep it light so failing doesn't feel punishing.

## What This Game Is NOT

- Not a combat game. Cryptids are *caught*, not killed. Avoids the violence-moderation tax.
- Not a building game. Plots are pre-shaped; only enclosures and trap workbenches go in. Reduces support burden.
- Not a hardcore RPG. No XP, no stats, no skill trees. Money + traps + bait = entire upgrade system.
- Not PvP at launch. Steal mechanic is a v2 consideration. (See CLAUDE.md open decisions.)
- Not a clicker. Active hunting is the loop — *Pet Sim 99* taught us pure click-and-AFK has a ceiling.

## The 5-Day Build Plan (rough)

| Day | Deliverable |
|-----|-------------|
| 1 | Data model (player profile, cryptid registry, plot, enclosure). DataStore. Base Camp lobby. |
| 2 | Forest biome map. Cryptid AI (patrol, flee, despawn). 4 T1 cryptids built. |
| 3 | Trap system (place, bait, trigger), catch minigame, enclosure cash tick. |
| 4 | Plot system, 3 more biomes (Swamp/Mountain/Sewers — reuse Forest assets with reskins), remaining 12 cryptids. |
| 5 | Monetization wiring (4 gamepasses, 2 dev products), UI polish, thumbnail art, store page. |
| 6 | Bug fixing, balance, soft launch. |
| 7 | Launch June 19. Pre-Catch-a-Brainrot wave starts June 20-25. |

## Reference Pitch (one-liner)

> *Steal a Brainrot's* monetization + *Pet Sim 99's* collection chase + *Pokémon Snap's* anxiety hunting + a *Don't Starve* mood, on a 6-day build budget.
