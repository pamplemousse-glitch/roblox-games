# FunGuy — Game Design Document
*Last updated: May 16, 2026*

---

## Concept

Cozy mushroom farming simulator with cave exploration, pet collection, combat, and cooperative brewing. Players grow mushrooms in a private cave, sell to a shared underground hub, and eventually unlock The Deep — a dangerous shared cavern with rare species, hostile mobs, and endgame content.

**Tone:** Bright cozy cave. Warm amber lighting, saturated mushroom colors, charming and whimsical. Not dark or horror. Think Stardew Valley meets Bee Swarm Simulator, underground.

**Target audience:** Roblox's near-50/50 gender split (51% male, 44% female), ages 9–24. Fastest growing segment: 17–24. Combat is optional — casual players never need to engage with it. Making combat mandatory would alienate a meaningful portion of the audience; Stardew Valley (optional combat, ~58/42 split) is the design reference.

---

## World Map

### Flow
```
[ SURFACE ]
  Mossy stone entrance, lantern, signpost. Nothing else.
        ↓ (portal down)
[ LEVEL 1 — SHARED HUB CAVERN ] ← Players spawn here
  Warm amber bioluminescent grotto. Social heart of the game.
  ├─ Merchant (permanent) — seeds, tools, basic upgrades
  ├─ Rotating Rare Vendor — spawns during cave events only
  ├─ Grand Vat — cooperative brewing station (2–3 players required)
  ├─ Leaderboard wall — glowing SurfaceGui, all-time + seasonal
  ├─ Mushroom Ring — social seating area, photo spot, emote zone
  ├─ [ YOUR CAVE PORTAL ] (left wall) → instanced personal cave
  └─ [ THE DEEP PORTAL ] (far back wall) — locked until unlocked, emits purple glow
        ↓ (portal)
[ LEVEL 2 — PERSONAL CAVE ] (instanced per player)
  Your private space. 6 growing plots, pet den, personal vat, fishing tunnel.
        ↓ (portal, gated)
[ LEVEL 3 — THE DEEP ] (shared, permanent hostile mobs)
  Central spine → 4 sub-chambers branching off:
  ├─ Bat Colony (left) — high ceiling, dark, bat pets
  ├─ Crystal Formation zone (center) — rare mushroom nodes
  ├─ Glowworm Ceiling (right) — bioluminescent, dense
  └─ Water Grotto (far back) — underground lake, axolotl pets
       └─ Future: Crystal Caverns portal (update content)
```

### Hub design principles
- Players spawn here every session — it must always feel alive
- Idle social presence matters: players visibly hanging around drives FOMO
- Grand Vat draws players together as a focal point
- The Deep portal is visible from day one — glowing purple, locked, aspirational
- No mobs here. Always safe.

---

## Core Farming Loop

1. Portal to personal cave
2. Tend mushrooms (press E at each plot — Water / Nutrients / Pollinate)
3. Mushrooms grow passively (spores/sec)
4. Collect spore orbs (5× passive value, physical pickup)
5. Portal back to hub → sell to merchant → buy seeds/upgrades
6. Return to cave → fish mole holes during Underground Spring → get fragments
7. Cave event fires (random) → capitalize or miss out (FOMO)
8. Accumulate fragments + catalysts → mutations → rarer species
9. Prestige (Sporulate) → reset + permanent multiplier

**Active engagement multiplier targets:**
- AFK: 1× passive
- Light active (orbs + tending): ~3×
- Fully engaged (tending + fishing + event + Deep): ~8×

---

## Species & Tiers

37 species at launch. Collected in a Mushroom Journal.

| Tier | Count | Base spores/sec | Unlock method |
|------|-------|-----------------|---------------|
| Common | 12 | 1–5 | Shop (spores) |
| Uncommon | 8 | 8–20 | Shop (spores) |
| Rare | 7 | 30–80 | Shop (spores) + mole fragments |
| Epic | 5 | 120–300 | Mole fragments + cave events |
| Mythic | 3 | 500–1500 | Deep-only nodes + rare events |
| Deep-exclusive | TBD | — | The Deep sub-chambers only |

All 37 species have appearance descriptions in `assets/mushrooms/SPECIES_DESCRIPTIONS.md`.

---

## Cave Events (replaces old weather system)

Fire randomly every 10–15 min in personal cave. Players never know which is coming.

| Event | Visual | Primary benefit | Secondary |
|-------|--------|-----------------|-----------|
| **Mycelium Surge** | Cave floor pulses, roots glow bright | Spore clusters bloom everywhere — collect or miss | Rotating Rare Vendor appears in hub |
| **Underground Spring** | Water drips from ceiling, mist fills cave | More mole holes, rarer moles surface | Cave leeches spawn (hostile, drops) |
| **Bioluminescent Bloom** | Every mushroom flares to full glow | Mutation chances spike, tending yields doubled | Spore beetles spawn (hostile, drops) |

Each event rewards a different playstyle: Surge → collectors, Spring → fishers, Bloom → tenders.

---

## Pets

### Personal Cave Pets (acquired in your cave)

| Pet | Acquisition | Active role | Passive role |
|-----|-------------|-------------|--------------|
| **Mole** | Mole fishing mini-game | Stuns ground mobs, digs bonus mushrooms | Detects buried rare spawns |
| **Cricket** | Found hiding under rocks/soil during harvest | Detects rare spawns (chirping intensifies near them) | Passive yield boost |

### The Deep Pets (acquired in The Deep)

| Pet | Sub-chamber | Active role | Passive role |
|-----|-------------|-------------|--------------|
| **Bat** | Bat Colony | Clears swarm mobs, echolocation reveals rare spawns | Reveal hidden mob positions |
| **Glowworm** | Glowworm Ceiling | Passive aura boosts yield in darkness | Lights cave, reveals hidden spawns |
| **Axolotl** | Water Grotto | Tank — absorbs one hit per encounter | Regenerates over time |

### Pet Den System
- All owned pets live in a visible **Pet Den** area of your personal cave
- Choose **2 active companions** at a time (follow you, fight for you)
- Swapping active pets is free and instant
- Pets are never deleted or lost permanently
- Rare pet variants exist (albino axolotl, giant glowworm) — drops from Deep endgame mobs

### Pet Health & Death
- Pets have their own HP bar in The Deep
- HP reaches zero → pet flees back to your cave automatically
- Rest time: 60 seconds (minor damage) to 3 minutes (near-death)
- Pets never die permanently

### On Player Death
- Player respawns in hub
- All active pets immediately retreat to personal cave
- 60-second rest cooldown before they're active again
- Player must portal back to cave to reunite with them

---

## Mole Fishing (signature mechanic)

- Tunnel branches off main cave with mole holes at varying depths
- Press **E** at a hole to cast a spore lure → wait for bite → timing mini-game
- Mini-game: hold/release to keep needle in green zone (Stardew Valley style)
- Common moles near entrance, rarer moles deeper
- **Rare mole drops:**
  - Species fragments (only way to unlock top-tier species)
  - Mutation catalysts (guarantee next mutation on a chosen mushroom)
- More mole holes + faster/rarer moles during Underground Spring event

---

## Mycelium Tending

- Walk to each RootSpot, press **E**
- Choose: Water / Nutrients / Pollinate
- Each slot refills every 10–15 minutes
- Tending all mushrooms actively = ~2.5× passive baseline
- Reason to log in and walk your cave daily

---

## Combat (optional — never required for casual players)

### Where mobs exist
| Zone | Mob presence |
|------|-------------|
| Hub cavern | None — always safe |
| Personal cave | Event-only (Bloom → spore beetles, Spring → cave leeches) |
| The Deep | Permanent ambient hostiles — always present |

Mobs in The Deep do not aggro unprovoked. You attack first, or they trigger when you harvest near them. Casual players can explore The Deep, collect mushrooms, and find pets without engaging combat.

### Deep mobs
| Mob | Type | Drops |
|-----|------|-------|
| Cave Beetles | Slow, tanky | Rare spores, chitin fragments |
| Blind Cave Fish | Swarm, fast, low HP | Slime drops, Deep currency |
| Shadow Spore Cloud | Passive until disturbed | Mutation catalysts, rare spore dust |

### Weapons (crafted at Mycology Vat)
Mob drops + mushroom harvests → craft at vat.

**Basic tier:**
| Weapon | Ingredients | Effect |
|--------|-------------|--------|
| Truffle Trowel | Common mob drops + Morel | Fast melee, digs up ambush mobs before they attack |
| Spore Launcher | Common drops + Button | Ranged, slows beetles |
| Flyagaric Flask | Common drops + Flyagaric | Throwable poison cloud, DOT |

**Mid tier:**
| Weapon | Ingredients | Effect |
|--------|-------------|--------|
| Mycelium Whip | Cave beetle drops + Oyster | AoE melee, stuns swarms |
| Puffball Bomb | Giantpuffball harvest | Throwable, massive AoE cloud |
| Ink Cap Grenade | Mid drops + Ink Cap | Blinds mobs, reduces aggro radius |
| Enoki Needles | Mid drops + Enoki | Rapid-fire ranged, shreds swarms |
| Mycelium Net | Mid drops + cave clay | Placeable trap, roots mobs |
| Spore Mine | Mid drops | Placeable, bursts on contact |
| Chanterelle Charm | Mid drops + Chanterelle | Aura that buffs pet damage |

**Deep tier (The Deep drops only):**
| Weapon | Ingredients | Effect |
|--------|-------------|--------|
| Glowshroom Staff | Deep drops + Starfire | Reveals hidden mobs, ranged beam |
| Deadman's Fingers | Deep drops + Violetweb | Summons fungal tendrils that attack nearby mobs |
| Morel Mortar | Deep drops + Morel | Long cooldown, massive AoE — only usable in The Deep |
| Crystal Shard | Crystal Formation drops | Pierces through multiple enemies in a line |

---

## Mycology Vat (crafting)

### Personal Vat (your cave)
- Basic potions and weapon crafting
- Available from early game
- Core crafting for the solo farming loop

### Grand Vat (hub cavern)
- Advanced brews requiring 2–3 players to contribute ingredients simultaneously
- Recipes impossible to make solo
- Social spectacle — visible to all hub players, draws crowds
- 2–3 cooperative recipes at launch, expanded in updates

### Potions
| Potion | Ingredients | Effect |
|--------|-------------|--------|
| Spore Surge | Puffball + beetle dust | 2× yield for 5 min |
| Fogveil | Ghostfungus + fog crystal | Invisible to mobs for 3 min |
| Deepblood | Axolotl scale + Violetweb | Required to enter Water Grotto; survive one hit |
| Glow Elixir | Glowworm silk + Enoki | Reveals hidden spawns for 3 min |
| Molten Mycelium | Flyagaric + lava beetle drop | Coats weapon in poison DOT |
| Rootbind Brew | Morel + cave clay | Auto-spawns Mycelium Net on mob contact |

---

## The Deep — Gating & Progression

### Entry gates
| Gate | Requirement | Unlocks |
|------|-------------|---------|
| The Deep portal | 500 total mushrooms grown | Entry to The Deep |
| Water Grotto | 20 Journal species + Deepblood potion | Axolotl sub-chamber |

Only two hard gates. Over-gating kills momentum.

### Why The Deep stays compelling
- Purple glow visible from hub on day one — aspirational before players can enter
- Rare mushroom nodes (Mythic-tier species only found here)
- Best weapon ingredients only drop here
- Pet variants (albino axolotl, giant glowworm) only in Deep endgame
- Social presence — see other veteran players farming Deep zones
- Grand Vat cooperative recipes require Deep-only ingredients — your friends need you

---

## Death Mechanic — Spore Debt

**On death:** Player respawns in hub. All active pets retreat to cave (60s rest).

**Spore Debt:** Die → your plots yield **15% less for the next 3 harvests**. Stacks slightly with repeated deaths in the same session. Clears automatically over time even without active play.

**Why this works:**
- Connects death in The Deep to your home cave — death has an echo
- Not currency loss (universally hated) or item loss (frustrating for casuals)
- Recoverable and visible — players see their plots yielding less and know why
- The "comeback moment" of farming off your debt feels satisfying
- Casual players who die once barely notice it. Reckless Deep runners feel it compound.

---

## Long-Term Progression Arc

**Weeks 1–2:** Filling the Mushroom Journal. 37 species, each with a rarity tier. Completionist drive. First mole caught, first pet bond formed.

**Weeks 2–6:** Optimization and mastery. Min-maxing plots, event timing, Deep runs. Discovering synergies (max-bond Glowworm + Bioluminescent Bloom = rare spawn window). Forum presence, sharing strats.

**Month 2–3:** Social stratification. The Deep unlocked. Showing off rare pet variants. Farm layout becoming an identity. Mentoring newer players.

**Month 3+:** Prestige loops, Journal completion, Crystal Caverns update hook. Veteran status in the hub. Grand Vat cooperative runs with regulars.

**Retention levers:**
- Daily: cave event RNG creates genuine excitement
- Weekly: rotating rare spawn windows for specific species
- Monthly: update cadence (bats, new pet, new zone)
- Long-term: 5-pet collection, Journal completion, Deep mastery

---

## Upgrade System

Three upgrade tracks, each with 20 levels.

| Upgrade | Effect per level | Base cost | Scaling |
|---------|-----------------|-----------|---------|
| Fertilizer | +15% spores/sec all species | 200 | ×1.8/level |
| Lighting | +10% spores/sec + glow effect | 500 | ×2.0/level |
| Humidity | +5% rare mutation chance | 1000 | ×2.2/level |

---

## Prestige — "Sporulate"

| Level | Requirement (lifetime spores) | Permanent multiplier |
|-------|-------------------------------|----------------------|
| 1 | 1B | ×2 |
| 2 | 10B | ×5 |
| 3 | 100B | ×12 |
| 4 | 1T | ×30 |
| 5+ | ×10 per level | previous ×2.5 |

On Sporulate: spore balance resets, upgrades reset, species reset to first Common. Multiplier persists. Exclusive prestige cosmetic per level.

---

## Offline Progression

- Spores accumulate while offline
- Cap: 8 hours of offline production (VIP: 16 hours)
- Shown as popup on return: "You grew X spores while away!"

---

## Monetization (nothing shown before 15 min play)

### VIP Subscription (199 R$/month)
- 2× offline cap (16 hours)
- +20% passive spores/sec
- Exclusive VIP cave skin
- Early access to new species drops

### Game Passes
| Pass | Effect | Price |
|------|--------|-------|
| Double Production | ×2 spores/sec permanent | 299 R$ |
| Auto-Collect | Spores auto-collect every 60s | 199 R$ |
| Extra Cave Slot | +2 growing plots | 499 R$ |
| Mythic Head Start | Start with 1 Mythic unlocked | 399 R$ |

### Developer Products (consumables)
| Product | Effect | Price |
|---------|--------|-------|
| Spore Boost | ×10 spores/sec for 1 hour | 49 R$ |
| Mutation Catalyst | Guaranteed mutation next event | 79 R$ |
| Deep Pass (temp) | 1-hour Deep access before unlock threshold | 29 R$ |

### Rewarded Ads
- "Watch ad for ×3 spores for 5 minutes" — opt-in, max 3/day

---

## Mushroom Journal

- Tracks all 37 species (+ Deep-exclusive species added in updates)
- Milestones unlock rewards and gates (20 species → Water Grotto access)
- Journal completion is a long-term social status goal
- Visible to other players in hub ("Antoine's Journal: 31/37")

---

## Multiplayer Design

- Players spawn in shared hub — always social
- Personal caves are instanced (private, no griefing)
- The Deep is shared — always populated by other players
- Leaderboard wall in hub: top growers, rarest species found
- Grand Vat requires real cooperation — builds community bonds
- MyceliumPulse: 3+ active players → +20% spores/sec server-wide

---

## Economy Balance Targets

- New player hits first prestige in ~3–4 hours active play
- Idle-only player hits first prestige in ~12 hours
- Each prestige cuts time to next by ~60%
- Mythic species should feel unreachable without prestige 3+ or Deep access
- No pay-to-win: all paid items are speed/convenience, not exclusive species

---

## Retention Benchmarks (Roblox simulator genre)

| Metric | Genre avg | Our target |
|--------|-----------|------------|
| D1 retention | 32% | 28–35% |
| D7 retention | 14% | 12–16% |
| Avg session time | 7 min | 12–17 min |
