# FunGuy — Research & Strategy Notes
*Compiled May 13, 2026*

---

## Market Research

### Top Roblox Genres by Revenue/Players (2026)

| Genre | Complexity | MVP Time | Profit Potential |
|-------|-----------|----------|-----------------|
| Meme/Viral Social | Simple | 1-3 weeks | Massive if viral |
| Idle/Farming Sim | Simple | 4-8 weeks | High ($20-30K/mo solo) |
| Obby/Parkour | Simple | 1-2 weeks | Low-Medium (oversaturated) |
| Tycoon | Simple-Medium | 3-6 weeks | Reliable long-tail |
| Horror | Medium | 6-10 weeks | High per player |
| Pet Simulator | Medium | 2-3 months | High if unique |
| Survival/Fishing | Medium | 6-10 weeks | Emerging fast |
| FPS/Shooter | Medium-Complex | 2-4 months | High (18-34 audience growing) |
| Anime RPG | Complex | 6-12 months | Huge but don't attempt solo |

### Key Data Points
- Grow a Garden: 21.6M concurrent players (July 2025), $12M in one month
- Steal a Brainrot: 25M concurrent players (Sept 2025) — built by a teen
- Blox Fruits: 211,000 daily concurrent, consistently top-3 earner
- Pet Simulator 99: tens of millions annually
- Top solo devs in idle/farming genre: $20-30K/month
- Roblox 18-34 demographic growing 50%+ annually, monetizes 40% higher than under-18s
- Starting June 8 2026: R15 avatars get 42% higher DevEx rate for verified US players 18+

---

## Competitive Analysis — Mushroom Idle Niche

**Result: Niche is EMPTY.** No dominant title exists.

Existing games (all tiny, no chart presence):
- Mushroom Collecting Simulator (~1.8M lifetime visits, no 2026 activity)
- Mushrooming! (offline income mechanic, no notable players)
- Mushroom Harvesting Simulator, Mushroom Farm, Mushroom Hunter — all negligible

**Closest competitor:** Grow a Garden (generic farming) — proves the idle farming loop works but doesn't touch mushrooms.

---

## Why Mushroom Idle / FunGuy

- Mycology is massive on TikTok/cottagecore — zero quality Roblox idle games represent it
- Grow a Garden proved cozy/idle has a massive untapped Roblox audience
- First-mover advantage in a proven genre
- Natural rare-drop monetization (legendary spores, golden mushrooms)
- Visually distinctive — easy to stand out in browse menu
- Wide appeal: cottagecore audience + gaming crossover

---

## Retention & Monetization Best Practices

### What Makes Idle Games Sticky
1. **Offline progression** — resources accumulate while you're gone
2. **Weather/event windows** — timed random events (Grow a Garden's #1 retention driver). Players check back to catch rare mutation windows
3. **Daily login streaks** — 7-day escalating rewards
4. **Quests with multi-day windows** — always a reason to return tomorrow
5. **Prestige layers** — games without prestige see D7 retention collapse below 10%

### Monetization (ranked by conversion rate)
1. **In-experience subscriptions** (recurring Robux) — outperform one-time passes, smooth revenue
2. **Rewarded video ads** — opt-in ads for in-game currency, converts non-payers (live in Grow a Garden now)
3. **Limited cosmetic drops** — timed to events, no gameplay advantage, drives impulse buys
4. **Developer Products** (consumables) — repeat purchases from converted players
5. **Game Passes** — 2x production, VIP access, exclusive species

**Critical rule:** Do NOT surface monetization before 15-20 minutes of play. Early prompts cause immediate bounce and Roblox algorithm penalties.

### Social/Multiplayer Impact
- Social mechanics increase revenue 3-5x over solo experiences
- Grow a Garden's Trading World update dramatically extended lifecycle
- Beanstalk Event (collaborative leaderboard) drove peak to 22.3M concurrent — highest in Roblox history
- Pet Simulator 99 built entire economy on peer-driven FOMO
- Status games (showing off rare items to other players) monetize far better than solo progression games

### FOMO Mechanics (ranked by impact)
1. Weather/event windows (10-min mutation windows)
2. Seasonal limited items with countdown timer
3. Token price escalation ("costs more tomorrow")
4. Collaborative leaderboards with expiry
5. Trading RAP system (price speculation)

### Viral Growth Mechanics
- **Compounding mutations** (not additive — multiplicative): creates billion-value items that players screenshot and post
- **Pets as visible income amplifiers**: clear measurable ROI makes them the easiest monetization sell
- **Third-party ecosystem**: encourage Discord, price trackers, wikis — free retention infrastructure
- Rare glowing/mythic items = free marketing via social sharing

### #1 Mistake That Kills Retention
Linear scaling that's too fast — players hit a ceiling in 1-3 hours with no visible next goal. Fix: prestige layers that multiply future earnings.

---

## Competitor Stack Research

### Best AI Tools for Roblox Development
- **Claude Code + boshyxd/robloxstudio-mcp** — gold standard, 43 tools, direct Studio read/write
- **@weppy/roblox-mcp** — most powerful (paid tier), supports terrain/UI/animations
- **Official Roblox MCP** (built into Studio) — use Roblox Assistant for 3D/mesh generation
- **Rojo** — file sync standard, no serious challengers
- **Rokit** — toolchain manager, superseded Foreman and Aftman
- **Selene + StyLua** — still the standard linter/formatter

### Workflow That Works
1. Rojo syncs local .luau files to Studio in real time
2. Claude Code edits files locally
3. MCP server gives AI direct read/write access to live Studio session
4. CLAUDE.md with Roblox/Luau context prevents AI hallucinations
5. Use Roblox Assistant (built-in) for 3D scenes, terrain, mesh generation

### Key Dev Lessons from Articles/Videos
- AI is strong on logic/scripting, weak on 3D placement and visuals
- Keep scripts under 300 lines — AI becomes unreliable above that
- Feed Studio error messages directly to Claude — paste them, don't describe them
- Write design docs with specific formulas and numbers before touching code
- Use `execute_luau` for batch/procedural Studio operations
- Always ask Claude to explain code before implementing it
- Back up before AI overwrites anything

---

## Monetization Notes

- R15 avatars mandatory for adult audience (42% higher DevEx rate from June 8, 2026)
- Game Passes: 70% revenue share, one-time
- Developer Products: consumables, repeatable purchases
- Subscriptions: new recurring model, outperforms passes
- Premium Payouts: passive income from Premium subscribers
- Benchmark: 100+ developers earned $1M+ in past 12 months

---

---

## Game Design Overhaul — May 16, 2026

### Stardew Valley as design reference
Stardew's retention comes from three interlocking active mechanics that each feed a *different* progression system — fishing → cooking/relationships, mining → tools/zones, tending → crop output. They're not redundant. Each gives a different type of player a reason to be present.

FunGuy's new mechanics follow this model exactly:
- **Mole fishing** → species fragments + mutation catalysts (collection + long-term progression)
- **Mycelium Tending** → spore output multiplier (short-term income)
- **Cave events** → massive spore bursts + mutation windows (FOMO + event-driven engagement)

### Skill + Luck balance (researched May 16)
Framework: *luck sets the stakes, skill determines the payoff.*
- **Mole fishing:** luck = mole type that bites (Common→Rare), skill = timing the reel
- **Tending:** luck = which slots refilled, skill = route optimization across mushrooms
- **Cave events:** luck = which event fires, skill = being present and reacting fast

Pity mechanic applies to mole fishing: guaranteed rare mole drop after N failed attempts per Spring event.
Skill improves luck over time: upgrades widen the reel "safe zone" and increase rare mole spawn rate.

### Cave events (replace weather system)
"Weather" was wrong — you're in a cave. Three cave-native events:
1. **Mycelium Surge** — spore clusters bloom, collect them physically
2. **Underground Spring** — water seeps through soil, moles surface (more holes, rarer moles)
3. **Bioluminescent Bloom** — all mushrooms flare, mutation chances spike, tending doubled

Each rewards a different playstyle. Fires randomly every 10-15 min — unpredictability is the FOMO hook.

### Rare mole drops
Rare moles (only during Underground Spring) drop:
- **Species fragments** — only way to unlock top-tier species (not in shop)
- **Mutation catalysts** — apply to a mushroom to guarantee its next mutation

This makes Spring events the most strategically important moments in the game.

### Art direction pivot (May 16)
Moving from dark bioluminescent to bright cozy cave. Reason: mole fishing + tunnel exploration + mushroom collecting all feel inherently whimsical/cozy. Dark aesthetic was chosen for differentiation but conflicts with the game's actual tone. Mushroom FBX geometry is reusable — only lighting and material palette changes in Studio.

---

## Active Mechanics Research — Is FunGuy Too AFK?

*Added May 15, 2026*

### Short answer: Yes, the current build is too AFK. Here's the fix.

The genre benchmark is: AFK = 1× baseline, Light active = ~3×, Fully engaged = ~8×. Games that make AFK and active identical see D14 retention collapse (~70% dropout).

### How top games solve the AFK problem

**Bee Swarm Simulator** — NOT AFK. Core mechanic is physical movement: "Movement Collection" means walking ON flowers collects pollen. Players run optimized routes through fields. Standing still is always suboptimal. Bear quests require specific activities in specific zones. The game is fundamentally a traversal game with idle dressing.

**Grow a Garden** — Mostly idle but has:
- Seasonal mini-games (Beanstalk event: physically climb a beanstalk, quests at the top)
- Egg hatching (active collect/incubate/hatch loop)
- Trading hub (real-time player negotiation)
- Weather mutations that reward watching and reacting in real time

**Pet Simulator 99** — Strong active layer on top of idle base:
- Seasonal mini-games (Red Light/Green Light, Glass Bridge, TNT Dodge)
- Time trials with leaderboard
- RNG event rolls (active clicking)
- Mining with pickaxes (active gathering, not passive)

**2026 meta insight:** The strongest simulators compete on depth. Minimum viable: two interlocking loops at launch. Trading hubs + seasonal events = where late-game retention lives. Players who never engage socially drop within 60 days.

---

### What FunGuy Needs: The Active Layer

Priority 2 mechanics (already planned, not built) are exactly the fix:

| Missing mechanic | Equivalent in top games | Active multiplier |
|---|---|---|
| Tending actions (water/nutrient/pollinate per mushroom) | BSS movement collection routes | ~2.5× |
| Weather event collectibles (physical spawns during events) | BSS sparkle patches / GaG weather mutations | ~4× when active |
| Wild mushroom foraging in tunnels | BSS new zone exploration | Medium — progression hook |
| Mutation mini-game (timing challenge in storm events) | Pet Sim 99 mini-games | Up to 8× |

### Specific Mechanic Designs

**"Mycelium Tending" (highest priority active mechanic)**
- Walk up to each mushroom pedestal and press E (or click model directly)
- Each mushroom has 3 tending slots, refill every 10–15 min
  - Water: +25% spores/sec for 2 min from that mushroom
  - Nutrients: +50% yield boost for next weather event from that mushroom
  - Pollinate: +5% mutation chance this weather cycle
- Active player tending all mushrooms every cycle = ~2.5× passive baseline
- Skill expression: rare species + tending + weather window = compounding multipliers

**"Spore Burst" events during weather windows**
- Physical glowing spore clusters spawn in the cave during weather events (like BSS sparkle patches)
- Walk through them to collect bonus spores
- Despawn when the event ends — FOMO active window
- During Golden Flush: physical clusters worth 10× normal orbs
- Creates a reason to be online during specific events, not just leave game running

**Tunnel Foraging (medium priority)**
- Secondary tunnel area off each grotto with wild mushroom spawns every 5 min
- Walk up to collect (no clicking needed — proximity trigger)
- Only source of certain rare reagents needed for top-tier Merchant stock
- Forces players to leave their grotto and walk the map

---

## Physical Billboard Leaderboard

*Decision: Build this instead of (or in addition to) the flat UI panel*

A tall glowing bioluminescent billboard Part in The Deep (shared social hub). Uses `SurfaceGui` on a Part for rendered content.

**Design:**
- Two sides: All-Time / Season (30-day, already tracked via MemoryStoreSortedMap)
- Each row: player name, spore count formatted (1.2B), mutation star icons (★★★), prestige crown
- Animated: player row pulses when rank changes
- The `LeaderboardUpdated` and `SeasonLeaderboardUpdated` remotes already fire every 60s — just need a SurfaceGui client-side renderer

**Why this beats a flat UI:**
- Other players see it updating in real time while physically standing in the same space
- Creates social moments (checking if you moved up while friends watch)
- "My name is on that board" is far more motivating than a menu panel nobody walks past

**Implementation approach:**
- Server places a `Part` named `LeaderboardBillboard` in The Deep workspace area
- Client script reads `LeaderboardUpdated` and sets `SurfaceGui` TextLabels on the Part
- Mutation badges use BillboardGui or ImageLabels (star icons per mutation count)

---

## Art Style Research & Direction

*Added May 15, 2026*

### Dominant Roblox Art Styles (2026)

Three clusters dominate the platform:

- **Bright saturated cartoony** — the Roblox default. Grow a Garden (32B+ visits), Pet Simulator 99, Bee Swarm Simulator. Soft pastels, warm colors, calming rural aesthetic. Dominates the idle/simulator genre.
- **High-detail fantasy realism** — Royale High, Blox Fruits (anime-adjacent). Heavy per-world detail investment.
- **Dark atmospheric** — Deepwoken (1.5B plays, 82K peak concurrent), Pressure. Proven viable but skews 14–25 male, requires strong mechanical hooks, lower initial CTR on discovery feed.

### The Core Tension for FunGuy

Dark thumbnails recede in Roblox's bright browse feed — direct CTR disadvantage at launch. But dark worlds retain players who do click far better than bright ones.

**The fix: "dark-world, bioluminescent-accent"** — not "dark game."

This is how Deepwoken, Hollow Knight, and Hades all solve it: near-black world + vivid self-illuminated accent colors (neon, bioluminescent cyan/violet/gold/green). The glow against dark creates *more* contrast at small thumbnail sizes than flat bright games.

### FunGuy Art Direction (Final)

**Style: Dark Stylized Organic with Bioluminescent Accents**

- **Cave environment:** Near-black backgrounds, deep blue-gray stone, minimal ambient light. No bright overhead lighting.
- **Mushroom shapes:** Smooth, rounded organic forms — real species silhouettes (funnel chanterelle, spiny lion's mane, sphere puffball). NOT low-poly faceted, NOT chibi. Readable shape > texture detail at Roblox icon sizes.
- **Color language:** Each species = one signature glow color. Players recognize species by their light before their shape.
- **Tier progression = glow intensity:**
  - Common: subtle warm rim light (barely glowing)
  - Uncommon: soft ambient glow visible in cave
  - Rare: fills immediate area with color
  - Epic: dramatic multi-color or particle effects
  - Mythic: floods the entire grotto, particles drifting like spores in space
- **Thumbnail strategy:** 1–2 massive glowing mushrooms filling the frame on dark background. Max 2 words of text, bold with drop shadow.

### What to Avoid

- Full photorealism — wrong genre, wrong audience, dev cost not justified
- Muddy dark with nothing popping — every screen needs at least one vivid glow region
- Flat bright cartoony — Grow a Garden's lane, would be competing directly
- Heavy textures — silhouette and glow matter more at Roblox display sizes

### Why This Works

- Genuinely new territory on Roblox — no dominant dark simulator exists in this aesthetic
- Bioluminescent mushrooms are already a real phenomenon — authenticity + visual drama
- Cottagecore audience responds to mushroom subject matter regardless of palette
- "Dark-world, bioluminescent-accent" is the formula used by the most visually successful indie games (Hollow Knight, Hades, Ori) applied to Roblox for the first time

---

## Resource Links

- [Rojo](https://github.com/rojo-rbx/rojo)
- [Rokit](https://github.com/rojo-rbx/rokit)
- [boshyxd/robloxstudio-mcp](https://github.com/boshyxd/robloxstudio-mcp)
- [weppy-roblox-mcp](https://github.com/hope1026/weppy-roblox-mcp)
- [grilme99 template](https://github.com/grilme99/roblox-project-template)
- [Vibecoding in Roblox (video)](https://www.youtube.com/watch?v=zKElbLUjk0I)
- [How to Make Roblox Games with Cursor (video)](https://www.youtube.com/watch?v=B5NCPSNDZl4)
- [I Built a Roblox Game Using Only AI Agents (article)](https://medium.com/@andy.a.g/i-built-a-roblox-game-using-only-ai-agents-heres-what-happened-ed57b553facc)
- [Vibecoding in Roblox (blog)](https://blog.justforward.co/vibecoding-in-roblox-mcp-cursor-ai-rojo-88be3f1d4035)
- [RoMonitor Stats](https://romonitorstats.com)
- [Roblox DevForum — Studio MCP](https://devforum.roblox.com/t/introducing-the-open-source-studio-mcp-server/3649365)

---

## Species Research — Full Update Roadmap
*Compiled May 16, 2026. 90+ species/concepts across 8 themed update batches. Designed for 2 years of content.*

### How to Read This Document

Each entry has:
- **Common name** / *Latin name*
- Flavor text (in FunGuy's dark cave voice)
- **Tier**: Common / Uncommon / Rare / Epic / Mythic
- **Mechanic hook**: the gameplay behavior that makes this species distinct
- **Batch**: which named update it belongs in

Launch species (36 already built) are not listed here. This document covers updates only.

---

## Update Roadmap Overview

| # | Name | Theme | Species Count | ETA |
|---|---|---|---|---|
| Batch 1 | **The Glowing Dark** | Full bioluminescent roster, glowshroom event | 18 | Month 2 |
| Batch 2 | **Roots of the World** | Extremophiles, cave-adapted, radiation fungi | 15 | Month 4 |
| Batch 3 | **The Old Lore** | Folkloric, mythological, dark-name species | 16 | Month 6 |
| Batch 4 | **Spore War** | Parasitic, zombie, cordyceps family | 14 | Month 8 |
| Batch 5 | **The Market** | Culinary royalty, luxury species, truffle season | 15 | Month 10 |
| Batch 6 | **Colossal** | Record-breakers, extreme forms, alien morphology | 14 | Month 12 |
| Batch 7 | **The Apothecary** | Medicinal, nootropic, consciousness-adjacent | 13 | Month 14 |
| Batch 8 | **Myconid Rising** | Fictional, mythological, D&D/game universe species | 14 | Month 16–18 |

**Running total after Batch 8:** 36 (launch) + 119 (batches) = 155 species. Repeat pattern for Year 2 (Batches 9–16) to reach 350+ target.

---

## BATCH 1 — "THE GLOWING DARK"
*Theme: All bioluminescent real-world species. The cave's first native residents. These are the species that justify the entire aesthetic.*
*Launch event: "Bioluminescent Bloom" cave event fires every 10 min, multiplying all Batch 1 species output 5x.*

---

### 1. Mycena chlorophos / Glowcap Fairy
*"In the forests of Japan, priests have worshipped its light for centuries — in your cave, it is merely the first candle."*
- **Tier:** Uncommon
- **Mechanic:** Passive aura — illuminates a small radius of cave floor with animated green-white light. Other mushrooms within range get +10% spore output. Reward for clustering species.
- **Real basis:** Genuinely bioluminescent (mycenoid green glow). Found in Japan and Taiwan.

### 2. Panellus stipticus / Bitter Lantern
*"It tastes of iron and bitterness, yet its glow has guided lost miners home. Do not eat it. Do not extinguish it."*
- **Tier:** Uncommon
- **Mechanic:** Generates "Cave Light" resource passively — spent to unlock deeper cave zones. One of two non-spore resource generators at launch.
- **Real basis:** One of the brightest naturally bioluminescent fungi in North America. Green glow.

### 3. Omphalotus olearius / Jack-o-Lantern
*"It lures foragers with its golden cap and orange glow, then punishes their hunger. The cave does not apologize."*
- **Tier:** Rare
- **Mechanic:** "Deceptive Yield" — every 5th spore harvest gives 3x output but triggers a 30-second "toxin debuff" that halves all other mushrooms' output. High risk/reward.
- **Real basis:** Toxic look-alike for chanterelle. Grows in clusters, bioluminescent orange-green at the gills.

### 4. Omphalotus nidiformis / Ghost Fungus (AU)
*"Australians learned to leave it alone. You have no such luxury."*
- **Tier:** Rare
- **Mechanic:** "Phantom Spore" — produces a secondary invisible spore type (Ghost Spores) only collectible during Bioluminescent Bloom events. Used to unlock Ghost-tier cosmetics.
- **Real basis:** White-cream bracket, vivid green-white bioluminescence. Toxic. Native to Australia/Asia.

### 5. Mycena luxaeterna / Eternal Light
*"Named for eternal light. Found only in Brazil's dying forests. It outlasts everything around it."*
- **Tier:** Epic
- **Mechanic:** "Undying Glow" — never fully sleeps between cave events. Produces 15% base output even during cave downtime when all other mushrooms pause. The one steady income floor.
- **Real basis:** Discovered 2009 in Brazil's Atlantic Forest. Small, glows continuously for days.

### 6. Neonothopanus gardneri / Amazon Lantern
*"The locals call it 'flor de coco.' It blooms at night on coconut husks like stars that fell underground."*
- **Tier:** Epic
- **Mechanic:** "Night Cycle Bonus" — game tracks real-world time (UTC). This species produces 3x spores between 8 PM and 6 AM local time. Rewards players in different time zones.
- **Real basis:** One of the brightest bioluminescent fungi. Found in Piauí state, Brazil. Glows green.

### 7. Mycena haematopus / Bleeding Fairy Helmet
*"It bleeds when broken — dark red from its stem, like a tiny wound that refuses to close. The cave floor is stained beneath it."*
- **Tier:** Rare
- **Mechanic:** "Blood Spore" — when harvested manually (Tending action), releases 5x spores in one burst plus a red particle effect that lingers. Manual harvest only; passive rate is 20% of normal.
- **Real basis:** Small wine-red Mycena. Bleeds dark reddish latex when cut. Real bioluminescence disputed but possible.

### 8. Panellus pusillus / Whisper Lantern
*"So small it is almost insulting. Yet clusters of ten thousand make a forest floor look like the Milky Way."*
- **Tier:** Common
- **Mechanic:** "Colony Bonus" — output scales with how many Whisper Lanterns are owned. Each additional copy adds +8% per copy, up to 10 copies (+80%). The first species with a stacking mechanic.
- **Real basis:** Tiny bioluminescent oyster-like mushroom. Widespread. Faint but real glow.

### 9. Mycena chlorantha / Chlor Ghost
*"It smells faintly of bleach. Biologists aren't sure how it glows or why. Neither are we."*
- **Tier:** Uncommon
- **Mechanic:** "Erratic Output" — produces between 0.5x and 4x base spores each harvest, fully randomized. High variance. Appeals to gamblers. Feeds into the pity mechanic if players track it.
- **Real basis:** Small Mycena, pale green-white. Genuine bioluminescence.

### 10. Filoboletus manipularis / Tropical Crown
*"Found across Malaysia and the Philippines in scattered glowing patches. The jungle floor remembers where it stood."*
- **Tier:** Uncommon
- **Mechanic:** "Spore Trail" — leaves a brief glowing path on the cave floor when harvested; other players walking through the trail get +5% spores from their next harvest for 60 sec.
- **Real basis:** Bioluminescent species found in Southeast Asian tropical forests. Yellow-brown caps.

### 11. Mycena chlorineura / Vein Glow
*"The veins of the cap carry the light, not the flesh. It is a map to somewhere you do not want to go."*
- **Tier:** Common
- **Mechanic:** "Vein Network" — passively links to adjacent mushrooms on the pedestal grid. When one is tended, all linked Vein Glows get 50% of the tending bonus. Early introduction to the adjacency system.

### 12. Gerronema viridilucens / Verdant Ember
*"Green fire on a fallen log. You wonder if it is alive or if the log simply refuses to accept death."*
- **Tier:** Common
- **Mechanic:** "Deadwood Bonus" — if placed in a cave slot adjacent to any Uncommon-or-lower species, it gets +25% output. Rewards thoughtful placement.
- **Real basis:** Bioluminescent species from Borneo. Small green-glowing fruiting bodies.

### 13. Mycena epipterygia / Pin Lantern
*"It grows pinned against leaves and bark like a lantern someone forgot to take down."*
- **Tier:** Common
- **Mechanic:** "Ambient Light" — generates passive Cave Light even without tending. The lowest-output Cave Light generator, but available earliest.
- **Real basis:** Widespread Mycena. Possible weak bioluminescence.

### 14. Omphalotus japonicus / Tsukiyo-take (Moon Night Mushroom)
*"Japanese folklore says it only glows on moonless nights. In your cave, every night is moonless."*
- **Tier:** Rare
- **Mechanic:** "Lunar Sync" — during Underground Spring events (the cave's equivalent of night activity), this species doubles output and emits particle flares visible to all players in the cave.
- **Real basis:** Japanese bioluminescent species. Toxic. Used in folklore.

### 15. Mycena lux-coeli / Heaven Light
*"A temporary visitor — it appears after rain events, glows for three days, and vanishes. The cave remembers its outline."*
- **Tier:** Rare
- **Mechanic:** "Bloom Only" — only produces spores during active Bioluminescent Bloom cave events. But during Bloom, output is 10x any other species at the same tier. Teaches the value of being online for events.
- **Real basis:** Japanese species found after rainfall. Brief bioluminescence.

### 16. Mycena kentingensis / Coral Lantern
*"Found once, in Taiwan. Named for the park where it was discovered. The cave adopted it."*
- **Tier:** Uncommon
- **Mechanic:** "Rare Visitor" — appears in the shop for 24 hours once per real-world week. Creates buying pressure and FOMO without being permanently unavailable.
- **Real basis:** Recently described bioluminescent species. Taiwan.

### 17. Lampteromyces japonicus / Dagger Light
*"In the dark it burns amber-orange from gills you cannot see. The cap hides the source of its own light."*
- **Tier:** Rare
- **Mechanic:** "Hidden Glow" — spore output not visible in the UI counter. Players must manually observe the cave (ambient light on floor) to know when it's ready to harvest. Rewards attention and presence.
- **Real basis:** Japanese bioluminescent species. Formerly Pleurotus japonicus. Vivid glow.

### 18. Mycena chlorina / Acid Glow
*"The botanists argue over whether the glow is chemical or biological. The cave does not care about their argument."*
- **Tier:** Epic
- **Mechanic:** "Corrosive Spores" — produces Acid Spores (secondary currency) usable only to dissolve locked tier requirements, letting players unlock one species one rank earlier. Rare resource, limited use.

---

## BATCH 2 — "ROOTS OF THE WORLD"
*Theme: Fungi that survive the unsurvivable. Extremophiles, cave natives, radiation eaters, endolithic rock-dwellers. These mushrooms predate civilization.*
*Launch event: "The Deep Pulse" — hidden zone unlocks temporarily, spawning extremophile wild mushrooms.*

---

### 19. Cladosporium sphaerospermum / Chernobyl Shade
*"When the reactor core melted, every organism fled. This one moved closer. It ate the radiation and asked for more."*
- **Tier:** Epic
- **Mechanic:** "Radiotrophic" — passively generates Radiation Spores (a new premium secondary currency) at a slow rate without any tending. When the cave has a full Bioluminescent Bloom active, it generates 5x Radiation Spores. The only species that benefits from other species' event bonuses.
- **Real basis:** Found on Chernobyl reactor walls in 1991. Uses melanin for radiosynthesis (like photosynthesis with gamma rays). Peer-reviewed science.

### 20. Aspergillus niger / Ironmold
*"It was found growing inside jet fuel tanks in the 1940s. It ate the fuel. It is growing in your cave now. It is fine."*
- **Tier:** Uncommon
- **Mechanic:** "Corrosion" — produces a moderate passive income with no tending needed, but slowly reduces the output of any mushroom placed within 2 slots of it by 5% per real-world hour. Forces players to manage placement.
- **Real basis:** Black mold. Survives extreme pH, temperature, and nutrients. Found in plane fuel tanks.

### 21. Paracoccidioides brasiliensis / Stone Sleeper
*"It can survive dormant in dry rock for decades. When the rains came, so did it. There are no rains in your cave. It woke up anyway."*
- **Tier:** Uncommon
- **Mechanic:** "Dormancy" — if not tended for 12+ real-world hours, shifts to "dormant" state and produces zero spores. But the first harvest after dormancy gives 20x stored output. Rewards returning players.

### 22. Cryptococcus neoformans / Shade Root
*"Found in bird droppings, desert soil, and tree hollows across six continents. It does not need an invitation."*
- **Tier:** Common
- **Mechanic:** "Opportunist" — when any other mushroom in the player's cave finishes a harvest, this species steals 2% of that harvest as bonus output. Always beneficial in high-density caves.

### 23. Geomyces destructans / White Nose (Cave Bat Blight)
*"It coats cave walls white and kills bats by the millions. In your cave, there are no bats. Lucky."*
- **Tier:** Rare
- **Mechanic:** "Cave Native" — produces 2x spores when placed in the deepest unlocked cave zone. Gets +50% output bonus for every other species in the same zone. The anchor species for late-zone builds.
- **Real basis:** Actual cave-adapted species. Causes White-Nose Syndrome in bats. Psychrophilic (cold-adapted).

### 24. Rhodotorula mucilaginosa / Void Yeast (Antarctic Strain)
*"Discovered in Antarctic ice cores, alive after 420,000 years. It was not impressed with the discovery."*
- **Tier:** Rare
- **Mechanic:** "Cryogenic" — output increases as players unlock colder/deeper cave zones. At max zone depth, produces 5x normal output. Grows most efficiently where nothing else survives.
- **Real basis:** Psychrotolerant yeast found in Antarctic ice. Survives extreme cold.

### 25. Wollemia-adjacent cave endolith / Stone Eater
*"It grows inside rock. Not on rock. Inside it. Biologists stopped asking how. You have not yet thought to ask."*
- **Tier:** Epic
- **Mechanic:** "Endolithic Growth" — does not occupy a mushroom pedestal. Instead, placed directly on the cave wall as a decoration that passively generates slow income. The only species that functions without a plot.

### 26. Exophiala dermatitidis / Reactor Ghost
*"It was found at Chernobyl, in spacecraft, and growing on the walls of nuclear cooling pools. It is not afraid of you."*
- **Tier:** Rare
- **Mechanic:** "Adaptive" — every 24 real-world hours, permanently gains +1% base spore output, stacking indefinitely. Long-term investment species; weak early, overwhelming late.
- **Real basis:** Radiotolerant black yeast. Found in extreme environments globally.

### 27. Thelebolus microsporus / Permafrost Bloom
*"The permafrost microbiome contains fungi that have never seen sunlight. This one adjusted to cave light in three days. It was disappointed."*
- **Tier:** Uncommon
- **Mechanic:** "Cold Adapted" — immune to any debuffs applied by other species' negative mechanics (like Ironmold's corrosion or Jack-o-Lantern's toxin debuff). The defensive anchor of any cave build.

### 28. Morchella tridentina / Fire Morel
*"After a wildfire burns the forest above, morels erupt from the scorched earth in thousands. The cave has never seen fire. That is about to change."*
- **Tier:** Rare
- **Mechanic:** "Ash Bloom" — when any player in the cave server triggers a Mycelium Surge event, all Fire Morels across the entire server get +200% output for 5 minutes. Server-wide social mechanic.
- **Note:** Fire morel is a real post-wildfire fruiting phenomenon. Different from the base Morel at launch.

### 29. Pseudogymnoascus destructans (cave form) / Pale Shroud
*"Cave walls, cave air, cave soil. It colonizes substrates others ignore. It does not need a host. It is already home."*
- **Tier:** Common
- **Mechanic:** "Cave Colonist" — generates a small amount of Cave Light resource passively. Identical function to Panellus stipticus but unlocked earlier and at lower cost.

### 30. Thaumatomyces sinensis / Deep Silk
*"Found at 3,000 meters below sea level in hydrothermal vents. Adapted to pressure that would crush steel. Your cave is pleasant by comparison."*
- **Tier:** Epic
- **Mechanic:** "Pressure Bonus" — functions as a depth multiplier. The more cave zones a player has unlocked, the higher its output multiplier. At max depth, functions as a 4x passive multiplier to all species in the same zone.
- **Note:** Deep-sea fungi are real and actively studied; specific species names in this niche are still being described.

### 31. Cave Truffle-Like Hypogeous Fungus / The Buried Thing
*"No cap. No stem. No light. Just a nodule underground, releasing spores into soil no sunlight has ever touched. Perfectly suited."*
- **Tier:** Uncommon
- **Mechanic:** "Hypogeous" — never visible on the pedestal (appears as bare dirt). Output is invisible until you dig it up manually (Tending action). Highest single-click yield of any Uncommon tier species but requires active play.
- **Real basis:** Genuinely underground truffle-like hypogeous fungi exist in caves (Elaphomyces and others).

### 32. Arthrinium saccharicola / Sugar Mold
*"It was found feeding on stored grain in Egyptian tombs sealed for four thousand years. The tombs were not supposed to have anything living in them."*
- **Tier:** Common
- **Mechanic:** "Stored Yield" — accumulates spores over time even when offline, at a rate 50% higher than standard offline income. The best species for players who take long breaks.

### 33. Sporothrix schenckii (cave strain concept) / Thornveil
*"Most spore clouds are harmless. This one finds open wounds. The cave is not responsible for your safety."*
- **Tier:** Uncommon
- **Mechanic:** "Thorn Spore" — occasionally triggers a "contamination" effect on a random adjacent mushroom, dropping its output by 30% for 30 minutes. But when the contamination ends, that mushroom gets +50% output for 60 minutes. Risk management mechanic.

---

## BATCH 3 — "THE OLD LORE"
*Theme: Every culture on Earth has stories about mushrooms. This batch brings those stories underground.*
*Launch event: "Fairy Ring Night" — a glowing ring of mushrooms appears in the shared social hub. Players inside the ring get +15% output for 10 minutes.*

---

### 34. Marasmius oreades / Fairy Ring Sprite
*"Stand in the ring and you'll hear music. Step out of the ring and you won't remember why you went in."*
- **Tier:** Common
- **Mechanic:** "Fairy Ring" — when exactly 6 Fairy Ring Sprites are placed in a circular pattern on the cave grid, they form an active ring that grants all mushrooms inside +25% output. Layout puzzle mechanic.
- **Real basis:** The classic fairy ring mushroom. Tough, edible, forms large rings. Core of Celtic/European mushroom folklore.

### 35. Clathrus archeri / Devil's Fingers
*"It arrives as a white egg buried in soil. When it hatches — and it hatches — red arms reach toward you like something that wants to hold your hand."*
- **Tier:** Epic
- **Mechanic:** "Emergence" — starts as a Common-tier white egg form that grows over 6 real-world hours into its full Epic form. Rewards patience. Players who buy it see it visibly develop in their cave.
- **Real basis:** The devil's fingers stinkhorn. Native to Australasia, now invasive in Europe. Stinks of rotting flesh.

### 36. Tremella mesenterica / Witch's Butter
*"Medieval farmers found it on their gateposts after milk curdled and cattle fell ill. They blamed witches. They were not entirely wrong."*
- **Tier:** Uncommon
- **Mechanic:** "Curse Deflect" — absorbs one negative mechanic (debuff) from any adjacent species per hour, converting it into 2x bonus spores. Passive protection utility.
- **Real basis:** Bright golden-yellow brain-like jelly fungus. Appears on dead wood. Common worldwide.

### 37. Xylaria polymorpha / Dead Man's Fingers
*"It grows in clusters from buried wood, charcoal-black, finger-shaped, reaching upward from the soil. It knows what is down there."*
- **Tier:** Rare
- **Mechanic:** "Graveyard Tap" — generates bonus spores from any adjacent empty cave plot (plots where a mushroom has been removed or not yet filled). Rewards partially built caves, not penalizing gaps.
- **Real basis:** Common woodland species worldwide. Black, finger-shaped fruiting bodies. Striking.

### 38. Gyromitra esculenta / Brain Cap (False Morel)
*"It looks like a morel. It is not a morel. Eating it causes 'gyromitrin poisoning.' The cave does not offer refunds."*
- **Tier:** Rare
- **Mechanic:** "Deceptive" — displays false spore count (shows 2x actual output) but delivers actual output. Players must track actual currency gain to know real value. The only species that actively misleads the player.
- **Real basis:** Edible when correctly prepared, toxic raw. Contains gyromitrin. Wrinkled brain-like cap.

### 39. Hydnellum peckii / Bleeding Tooth (Lore Entry)
*"It weeps blood. Scientists call it guttation. The cave calls it beautiful."*
- **Tier:** Epic (second Epic entry; first was at launch)
- **Note:** Already in launch roster. This is the lore-expanded Epic form — "Ancient Bleeding Tooth" — a Batch 3 reskin with new mechanics.
- **Mechanic (Batch 3 upgrade version):** "Blood Offering" — once per day, sacrifice 5% of total spore stockpile to give all mushrooms +100% output for 10 minutes. High-stakes ritual mechanic.

### 40. Claviceps purpurea / Ergot (Witch Blight)
*"In 1692, Salem's accusers described visions, convulsions, and the certainty that something was watching them. The rye was contaminated. The cave grows it deliberately."*
- **Tier:** Epic
- **Mechanic:** "Mass Hysteria" — when active during a server-wide event, Ergot converts 10% of normal spore income across all players in the server into a shared "Panic Spores" pool. Pool is distributed at event end to the most active players. Server coordination mechanic.
- **Real basis:** Fungal parasite of rye. Contains lysergic acid derivatives. Historically linked to Salem witch trials and St. Anthony's Fire epidemics.

### 41. Amanita phalloides / Destroying Angel
*"Responsible for 90% of fungal poisoning deaths worldwide. Pure white. Delicate. The most dangerous thing in the cave."*
- **Tier:** Mythic
- **Mechanic:** "Angel's Gift" — passively generates the highest spore income of any Mythic species, but every 30 minutes has a 10% chance of triggering "Death Cap Event" — all species in the cave stop producing for 5 minutes. Players must manage this risk.
- **Real basis:** The death cap (Amanita phalloides) / destroying angel (Amanita bisporigera). Amatoxin poisoning. Responsible for most fatal mushroom poisonings globally.

### 42. Entoloma sinuatum / Poison Pie
*"It looks edible. It tastes good, reportedly, for the first twenty minutes. Ask anyone who survived."*
- **Tier:** Rare
- **Mechanic:** "False Plenty" — delivers spore output in large irregular bursts (every 45 minutes instead of continuously), making it hard to include in timed strategies. But each burst is 8x a normal mushroom's 45-min accumulation.

### 43. Amanita muscaria (Shamanic Form) / Siberian Oracle
*"Siberian shamans fed it to their reindeer and then drank the reindeer's urine. The dosing was more reliable that way. The cave offers a more direct supply chain."*
- **Tier:** Mythic
- **Note:** Fly Agaric is in the launch roster as Rare. Siberian Oracle is the Mythic-tier evolved/lore version.
- **Mechanic:** "Shamanic Trance" — once per real-world day, click to enter a 3-minute "Trance Mode" where all spore collection is manual (clicking mushrooms) but each click yields 50x normal output. Active engagement window.
- **Lore note:** The Santa Claus theory (red/white mushroom, reindeer, flying, gifts from the north) makes this an obvious seasonal tie-in.

### 44. Inocybe erubescens / Red Stainer
*"Norse warriors may have eaten it before battle. May have. There are no surviving witnesses."*
- **Tier:** Rare
- **Mechanic:** "Berserker" — during Mycelium Surge events, output multiplies by 6x but the animation becomes frantic/chaotic (purely cosmetic). Adds personality and drama to event windows.
- **Lore note:** Muscarine poisoning historically speculated as the source of Viking berserker behavior. Controversial but widely discussed.

### 45. Fomes fomentarius / Tinder Conk (Norse Otzi)
*"Ötzi the Iceman carried it in 3,300 BCE. It was found with his corpse in the Alps. He never got to use it."*
- **Tier:** Uncommon
- **Mechanic:** "Ancient Stock" — generates a small amount of "Ancient Spores" (cosmetic currency for lore items in the shop) passively. Primarily a lore-content feeder species.
- **Real basis:** Tinder bracket fungus used for fire-starting since the Stone Age. Found with Ötzi.

### 46. Marasmius rotula / Wheel Spoke (Celtic Wheel Fairy)
*"In Celtic tradition the wheel represents eternal cycles: life, death, return. This mushroom has no opinion. It simply spins."*
- **Tier:** Common
- **Mechanic:** "Cycle Bonus" — output increases by 10% for each prestige level the player has completed. Zero value at start; strongest species post-prestige.
- **Real basis:** Tiny Marasmius with a distinctive wagon-wheel gill pattern.

### 47. Cordyceps ophioglossoides / Golden Thread (Aztec Gold)
*"Aztec physicians kept records of a golden fungal thread that grew from underground truffles. The records do not say what they used it for."*
- **Tier:** Rare
- **Mechanic:** "Mycelial Thread" — when paired with any underground/hypogeous species in the same zone, doubles the output of both. Requires specific pairing for its bonus.
- **Real basis:** Parasitizes underground Elaphomyces truffles. Legitimately interesting and visually dramatic.

### 48. Psilocybe semilanceata / Liberty Cap (Mushroom Folklore UK)
*"It dots British hillsides every autumn. Farmers know what it is. They do not remove it. The cave is similarly discreet."*
- **Tier:** Uncommon
- **Mechanic:** "Perspective Shift" — periodically (every 20 min) rearranges the visual layout of the cave UI temporarily (colors invert, mushrooms appear larger) for 30 seconds. Purely cosmetic prank mechanic. No output effect.
- **Note:** Psilocybin mushroom. Roblox-safe implementation is purely cosmetic — no drug references in flavor text, just UK folklore.

### 49. Gyroporus cyanescens / Bluing Bolete (Druidic Blue)
*"Cut it, and the flesh turns instantly, violently blue — as if ashamed of what it is. The cave does not ask why."*
- **Tier:** Rare
- **Mechanic:** "Oxidative Burst" — when manually harvested (Tending), triggers an instant visual effect (bright blue flash) and 3x spore yield. No bonus from passive harvesting. Skill/presence reward.
- **Real basis:** Instantly turns deep blue when cut due to oxidation of variegatic acid. Dramatic and real.

---

## BATCH 4 — "SPORE WAR"
*Theme: Parasites, zombie makers, body-snatchers. The darkest biology in mycology, now weaponized.*
*Launch event: "The Infection" — zombie effects applied to players' mushrooms temporarily; tending cures them and rewards bonus spores.*

---

### 50. Ophiocordyceps unilateralis / Zombie Ant Cord
*"It hijacks the ant's motor cortex. Drives it to the highest point it can reach. Makes it bite. Then it is finished with the ant."*
- **Tier:** Mythic
- **Mechanic:** "Zombie Harvest" — once per hour, "infects" a random adjacent species, hijacking its next three harvests and directing 50% of that output to the Zombie Ant Cord's own counter. The adjacent species still produces normally but is visually altered (spore particles change to orange).
- **Real basis:** The zombie ant fungus. One of the most documented examples of parasite behavioral manipulation.

### 51. Cordyceps militaris / War Cord
*"A beautiful orange growth from a dead larva. The larva ran out of war. The fungus did not."*
- **Tier:** Epic
- **Mechanic:** "Combat Spores" — generates War Spores used to trigger the "Spore War" seasonal event (a server-wide competition for highest combined War Spore contribution). Drives social engagement.
- **Real basis:** Bright orange Cordyceps on lepidopteran pupae. Commercially cultivated for medicinal use.

### 52. Entomophthora muscae / Zombie Fly Crown
*"It makes flies climb walls, extend their wings, and die in exactly the right position for its spores to rain down. The care it takes is remarkable."*
- **Tier:** Epic
- **Mechanic:** "Precision Spread" — once per day, selects the lowest-performing species in the cave and transfers 20% of its base output permanently to all other species equally. Effectively absorbs one weak link and redistributes it.
- **Real basis:** Manipulates flies to die in high-traffic positions, maximizing spore dispersal. Dramatic biology.

### 53. Massospora cicadina / Cicada Puppet
*"It removes the cicada's abdomen and replaces it with a white spore mass. The cicada continues attempting to mate. The fungus has excellent priorities."*
- **Tier:** Rare
- **Mechanic:** "Compulsion Loop" — during Underground Spring events, this species automatically triggers a Tending action on all adjacent species without player input. The player didn't do it. The species did.
- **Real basis:** Contains cathinone (a Schedule I stimulant) and psilocybin. The cicada mates more aggressively while infected, maximizing fungal dispersal.

### 54. Elaphocordyceps capitata / Truffle Parasite
*"It found a truffle underground, wrapped itself around it, consumed it slowly, and then presented itself to you as if it had always been the plan."*
- **Tier:** Rare
- **Mechanic:** "Deep Parasite" — must be placed adjacent to any underground/hypogeous species. Permanently reduces the host's output by 25% but grants itself 4x the host's original output. The only species that grows by weakening another.

### 55. Beauveria bassiana / White Muscardine
*"Medieval silk farmers called it 'muscardine.' The silkworms turned white and stiff. The silk industry collapsed. The fungus didn't notice."*
- **Tier:** Uncommon
- **Mechanic:** "Silkworm Bonus" — when placed adjacent to any Common species, increases that Common species' output by 30% while slowly extracting 5% of it as bonus yield. Mutually beneficial symbiosis appearance; actually extractive.

### 56. Isaria farinosa / Ghost Moth Cord
*"The caterpillar it killed is still in the soil. You can dig it up. You won't find much worth keeping."*
- **Tier:** Common
- **Mechanic:** "Buried Host" — once per day, consuming 1 spore from stockpile activates a 2-hour 25% output boost. The "feeding" mechanic — spores beget spores.

### 57. Hypocrella bambusicola / Bamboo Crown
*"It parasitizes scale insects on bamboo, forming bright orange knobs. The forest above uses bamboo for everything. The insects have fewer options."*
- **Tier:** Uncommon
- **Mechanic:** "Scale Tap" — passively generates 1 Cave Light per hour. Primarily a Cave Light feeder for zone unlocking.

### 58. Metacordyceps chlamydosporia / Root Weave
*"It colonizes nematode eggs. It does not kill them. It waits inside them until they hatch. Then it decides."*
- **Tier:** Rare
- **Mechanic:** "Patient Predator" — generates no output for the first 24 hours after purchase. After 24 hours, permanently activates at 3x a normal Rare-tier species' output. The delayed gratification species.

### 59. Ophiocordyceps camponoti-rufipedis / Carpenter Ant Cord
*"A sister species to the zombie ant cord. It prefers carpenter ants specifically. The taxonomy matters more to the fungus than to the ants."*
- **Tier:** Rare
- **Mechanic:** "Specialist" — output increases by 50% for every other Cordyceps/zombie-family species the player owns. Requires building a zombie-themed collection to maximize.

### 60. Nomuraea rileyi / Lime Silk
*"It grows on caterpillars and turns them pale green. Agricultural scientists use it as a pesticide. The caterpillars have not been consulted."*
- **Tier:** Common
- **Mechanic:** "Pesticide" — cancels any negative effect applied by parasitic mechanics (like Elaphocordyceps' drain or Entomophthora's reassignment) on adjacent species. A parasitic-batch counter.

### 61. Laboulbeniales (order) / Face Fungus (Beetle Parasite)
*"It grows specifically on beetle faces. Just the face. Scientists are unsure why it chose the face. The beetles are unavailable for comment."*
- **Tier:** Uncommon
- **Mechanic:** "Specific Target" — randomly selects one mushroom in the cave at purchase time. That species produces 2x output permanently. Cannot be changed. The randomness of which species it chooses is the mechanic.

### 62. Cordyceps tuberculata (wasp form) / Wasp Rider
*"It finds wasps. It makes wasps fly erratically, collide with plants, and die gripping a leaf at exactly the right height. The wasps were busy before this."*
- **Tier:** Epic
- **Mechanic:** "Erratic Flight" — triggers a server-wide visual effect during Spore War event (orange spore clouds across all players' caves). Purely cosmetic but server-wide. Social presence mechanic.

### 63. Harposporium anguillulae / Nematode Trap
*"It grows in the soil and produces hook-shaped spores that nematodes swallow — then hatch inside them. The hooks were designed for this."*
- **Tier:** Rare
- **Mechanic:** "Hook Spore" — once per day produces a "Hooked Spore" tradeable item. Players can trade Hooked Spores to receive random species fragments. Feeds the trading economy.

---

## BATCH 5 — "THE MARKET"
*Theme: The most commercially valuable fungi on Earth. Players are now treasure hunters in a global black market of rare ingredients.*
*Launch event: "The Merchant's Season" — a traveling trader appears in the social hub offering rare species for premium currency.*

---

### 64. Tuber melanosporum / Périgord Black Truffle
*"Dogs and pigs have died for less. The going rate is $1,500 per kilogram. Your cave produces them free, which the market has not yet processed."*
- **Tier:** Epic
- **Mechanic:** "Black Market" — generates "Truffle Coins" (a premium secondary currency) at a slow rate, spendable at the Merchant NPC for exclusive season-only items.
- **Real basis:** The most commercially valuable culinary fungus. Up to $3,000/kg. Périgord, France.

### 65. Tuber magnatum / White Alba Truffle
*"The white truffle of Alba has sold at auction for $100,000 per kilogram. Your cave does not offer auction pricing. It offers worse: no pricing at all."*
- **Tier:** Mythic
- **Mechanic:** "Auction Piece" — every 3 real-world days, produces a "White Truffle" tradeable item. No other way to obtain it. Market price is player-determined. The anchor of the player-driven economy.
- **Real basis:** The most expensive truffle. Only found in Piedmont, Italy. Cannot be cultivated — only wild-harvested.

### 66. Tuber aestivum / Summer Truffle
*"Less prestigious than its winter cousins. Available June through August. The cave does not observe seasons. You have found a loophole."*
- **Tier:** Rare
- **Mechanic:** "Seasonal Output" — in the real world months of June, July, and August, produces 3x normal output. Off-season, produces 0.5x. Teaches seasonal engagement habits.
- **Real basis:** Summer truffle. Less aromatic than Périgord but widely available.

### 67. Tricholoma matsutake / Matsutake Sovereign
*"$600 per kilogram in Japan. Grown only under specific pine species after decades of relationship. In your cave, the relationship took three minutes."*
- **Tier:** Epic
- **Mechanic:** "Pine Bond" — if placed adjacent to any conifer-themed decoration (a new decoration type added with this batch), output doubles. Introduces the decoration-interaction system.
- **Real basis:** The most expensive mushroom in Japan. $600+/kg. Requires specific forest conditions.

### 68. Cantharellus cibarius / Royal Chanterelle
*"The queen of European markets. Found after rain in oak forests by people who will not tell you where. The cave has no secrets from you."*
- **Tier:** Uncommon
- **Mechanic:** "Market Favorite" — generates bonus output when server population is above 50 players. Social engagement incentive.
- **Real basis:** Golden chanterelle. Most commercially important wild mushroom globally by volume.

### 69. Craterellus cornucopioides / Horn of Plenty
*"The French call it 'trumpette de la mort' — trumpet of death. The name refers to its shape, not its effect. Probably."*
- **Tier:** Rare
- **Mechanic:** "Cornucopia" — once per real-world day produces a random bonus (could be spores, currency, a tradeable item, or a debuff with 20% chance). Unpredictable treasure mechanic.
- **Real basis:** The black trumpet — one of the finest edible wild fungi. Highly prized despite its name.

### 70. Cantharellus lateritius / Smooth Chanterelle
*"Indistinguishable from its more famous cousin until you taste it. The cave cannot tell the difference. Neither can most of your customers."*
- **Tier:** Common
- **Mechanic:** "Mimic Bonus" — if placed adjacent to Royal Chanterelle, adopts its current mechanic (copies its output rate). The first "mimic" mechanic — lets players double-up a strategy cheaply.

### 71. Boletus edulis / Emperor Porcini
*"The king of Italian markets. Used in risotto by emperors, soldiers, and grandmothers with equal reverence. It does not care who eats it."*
- **Tier:** Uncommon
- **Mechanic:** "Empire" — output scales with the number of unique species the player owns. +1% per unique species owned. Rewards collectors.
- **Real basis:** King bolete / porcini. Most commercially important bolete. Globally prized.

### 72. Cantharellus californicus / Giant California Chanterelle
*"Found only under California oaks, growing in clusters of enormous single specimens. It is not subtle. The cave adopted it without apology."*
- **Tier:** Rare
- **Mechanic:** "Cluster Growth" — every 48 hours, produces a second copy of its spore harvest that deposits directly into stockpile without requiring a harvest action. Passive bonus accumulation.
- **Real basis:** World's largest chanterelle species. Single specimens up to 2 pounds.

### 73. Sparassis crispa / Cauliflower of the Kings
*"A single specimen can weigh ten kilograms. Chefs weep when they find one. The cave produces them in multiples."*
- **Tier:** Uncommon
- **Mechanic:** "Bulk Yield" — produces 2x the spores of a standard Uncommon but requires 2 tending actions (not 1) to unlock each harvest. Output gated behind effort.
- **Real basis:** Cauliflower mushroom. Up to 10+ kg per specimen. Choice edible.

### 74. Hericium coralloides / Coral Tooth (Culinary Form)
*"Chefs discovered it late. Foragers had known about it for centuries and weren't telling anyone. The cave tells everyone."*
- **Tier:** Uncommon
- **Mechanic:** "Forager's Find" — spawns as a wild mushroom in the tunnel foraging zone at 2x normal Uncommon spawn rate, but rarely appears in the shop. Rewards active players who explore.

### 75. Lactarius deliciosus / Saffron Sovereign
*"Romans ate it. Eighteenth-century Spanish nobles named paintings after it. It bleeds saffron milk when cut, and the cave floor is orange around it."*
- **Tier:** Rare
- **Mechanic:** "Noble Blood" — when manually harvested, produces a "Saffron Drop" cosmetic particle effect visible to all players in the cave zone. Status display mechanic — shows off to others.

### 76. Laccaria amethystina / Amethyst Market Cap
*"Vivid purple, edible, found in European markets alongside the more famous chanterelle. Nobody explains why. Nobody needs to."*
- **Tier:** Uncommon
- **Mechanic:** "Market Rare" — doubles output during "The Merchant's Season" event window specifically. Value tied entirely to event timing.

### 77. Agaricus bisporus 'Portobello King' / Grand Portobello
*"The evolved form of your starter mushroom. The same genetics, forty years of cultivation, and a new name. The cave respects the hustle."*
- **Tier:** Rare
- **Mechanic:** "Evolved Form" — starts at a 10% bonus if the player owns a Portobello (launch species). Grows by 5% per day, up to a 50% bonus. Rewards long-term ownership.

---

## BATCH 6 — "COLOSSAL"
*Theme: The largest, strangest, most extreme fungi on Earth. Size is the mechanic. Players discover what the cave can actually contain.*
*Launch event: "The Deep Emergence" — a giant procedurally-placed mushroom structure grows in the shared cave over 48 hours, collectively tended by all players.*

---

### 78. Armillaria ostoyae / Humongous Fungus
*"Single organism. 2,385 acres. 8,000 years old. The cave is smaller than it. This is a piece of it. A very small piece."*
- **Tier:** Mythic
- **Mechanic:** "Colony Network" — connects to every other mushroom in the cave invisibly. 0.5% of all other species' output flows to the Humongous Fungus passively. At max cave size, this becomes the highest passive income source in the game.
- **Real basis:** The Humongous Fungus in Malheur National Forest, Oregon. Largest organism on Earth by area.

### 79. Calvatia gigantea / Soccer Ball Puffball
*"A white sphere the size of a soccer ball. You cannot tell it from a soccer ball until it erupts in a cloud of billions of spores. Both events are inadvisable indoors."*
- **Tier:** Epic
- **Mechanic:** "Eruption" — passively fills to a "spore charge" over 4 hours. At full charge, the player must manually "pop" it (click) to release a burst of 20x accumulated spores at once. High-yield manual mechanic. Visual effect: massive spore cloud.
- **Real basis:** Giant puffball. Produces up to 7 trillion spores per fruiting body. Truly impressive.

### 80. Phallus indusiatus / Veiled Lady
*"It grows a lace skirt from its cap. No other organism does this. Scientists have not fully explained why. The cave does not need an explanation."*
- **Tier:** Epic
- **Mechanic:** "Display" — the Veiled Lady's lace skirt expands in real time over 30 minutes after spawning. The longer it has been since last harvested, the larger its accumulated bonus. Visual progression feeds into harvest timing skill.
- **Real basis:** The veiled lady stinkhorn. Dramatically beautiful. Found in tropical forests globally.

### 81. Clathrus ruber / Red Cage Fungus
*"A latticed red sphere from a buried egg. Europeans discovered it in 1560. They had no idea what to do with it. Neither do you, but you can sell it."*
- **Tier:** Epic
- **Mechanic:** "Cage Trap" — once per day, "catches" a free random Common species from the shop and adds it to the player's cave inventory at no cost. The cage provides; the cage takes nothing.
- **Real basis:** Stinkhorn species. Latticed red globe. Found in Europe, naturalized in North America.

### 82. Dictyophora duplicata / Bamboo Fungus (The Bride)
*"In China it is a delicacy. At market it wears a white veil. The cave does not distinguish between brides and merchants."*
- **Tier:** Rare
- **Mechanic:** "Veil Display" — when tended, the veil animation extends visibly on the model. Each tending action accumulates "Veil Bonus" up to 5 stacks; harvesting collects all stacks as bonus output. Tending micro-game.
- **Real basis:** Bamboo fungus / crinoline stinkhorn. Edible. Commercially cultivated in China.

### 83. Mutinus elegans / Elegant Stinkhorn
*"Its name is elegant. Its scent is not. Its shape invites no description in polite company. The cave is not polite company."*
- **Tier:** Uncommon
- **Mechanic:** "Fly Lure" — attracts fictional cave flies that briefly appear as an animation, then disappear carrying away "fly tokens" — collectible 3x spore boosts earned passively.
- **Real basis:** Slender pink-red stinkhorn. Common in North America. Attracts flies with carrion scent.

### 84. Laetiporus sulphureus / Sulphur Shelf (Cliff Face)
*"Orange brackets the size of dinner plates cascading down a cliff face. From a distance you might mistake it for a fire. You would not be entirely wrong."*
- **Tier:** Rare
- **Mechanic:** "Cliff Anchor" — bonus output when placed in the highest unlocked cave zone. Rewards vertical exploration.
- **Real basis:** Chicken of the Woods (orange bracket variant). Grows on standing trees, also cliffs.

### 85. Aseroe rubra / Anemone Stinkhorn (Sea Floor Form)
*"Red arms radiating from a white stalk, smelling of carrion. It looks like something from the sea floor. The cave is not the sea floor. It adjusted."*
- **Tier:** Rare
- **Mechanic:** "Carrion Call" — occasionally generates a "Carrion Spore" item that, when used, causes a visual swarm animation in another player's cave (with their permission, opt-in). Social prank system.

### 86. Mycenastrum corium / Earth Shield
*"It grows underground and surfaces as a flat brown shield. Farmers have mistaken it for leather. One farmer ate it. The farmer is not available to comment."*
- **Tier:** Uncommon
- **Mechanic:** "Underground Shield" — absorbs the first debuff applied to the cave each real-world day. Passive protection for exactly one negative event daily.

### 87. Geastrum saccatum / Earth Star
*"Its outer skin peels back into star-shaped rays, standing the spore sac upright like a tiny alien monument. It is not from space. Probably."*
- **Tier:** Rare
- **Mechanic:** "Star Chart" — generates "Star Fragments" once per day. Collecting 7 Star Fragments unlocks a special cosmetic item. Long-term collection mechanic independent of main progression.
- **Real basis:** Earth star puffball. Peristome-based spore dispersal. Widespread and distinctive.

### 88. Podaxis pistillaris / Desert Shaggy Mane
*"Found in Arabian deserts, Australian outback, and Saharan sand. It produces ink when it dissolves. Bedouin used the ink for writing. The cave uses it for decoration."*
- **Tier:** Uncommon
- **Mechanic:** "Desert Ink" — once per harvest, drops "Desert Ink" (a cosmetic craft material for cave decoration items). Feeds the decoration crafting system.
- **Real basis:** Desert-adapted ink cap. Found in arid environments worldwide. Bedouin did use it as ink.

### 89. Hericium abietis / Cascade Tooth (Grand)
*"Massive cascading white spines, each arm as long as a child's forearm. Found in old-growth Pacific Northwest forests. The cave is old enough."*
- **Tier:** Rare
- **Mechanic:** "Old Growth" — output increases by 1% for each day the species has been in the cave, capping at +100% after 100 days. Long-term loyalty reward.

### 90. Phellinus igniarius / Fire Bracket (Ancient Conk)
*"Found growing on willows Ötzi passed on his way to die. Carbon-dated at 5,000 years of individual growth. The one in your cave started last week. It'll be fine."*
- **Tier:** Rare
- **Mechanic:** "Ancient Growth" — identical to Hericium abietis' mechanic but also generates 1 Tinder material per day (used in crafting cave campfire decorations).

---

## BATCH 7 — "THE APOTHECARY"
*Theme: Fungi humanity has used for healing, consciousness, and ritual across every civilization. Premium tier unlock.*
*Launch event: "The Apothecary Opens" — special NPC arrives offering crafted mushroom blends tradeable for exclusive cosmetics.*

---

### 91. Ganoderma lucidum / Reishi — Mushroom of Immortality
*"Two thousand years of Chinese emperors sought it. The emperor is dead. The reishi persists."*
- **Tier:** Epic
- **Mechanic:** "Immortal" — never permanently dies (most mushrooms can be "wilted" by neglect). Always produces at least 5% base output regardless of any debuff or neglect state.
- **Real basis:** "Lingzhi" in Chinese. Used in TCM for 2,000 years. Ganoderic acids studied for anti-tumor properties.

### 92. Inonotus obliquus / Chaga Forge
*"Siberian shamans made tea from it. Aleksandr Solzhenitsyn wrote about it. It tastes of charcoal and ancient forest. The cave smells like it constantly."*
- **Tier:** Rare
- **Mechanic:** "Charcoal Reserve" — accumulates "Forge Fuel" over time. Forge Fuel is spent to permanently upgrade any other species' output by 5% (one-time per species). The crafting-upgrade species.
- **Real basis:** Chaga. Grows on birch trees in Siberia, Canada, northern Europe. Beta-glucan content studied for immune support.

### 93. Trametes versicolor / Turkey Tail Rainbow
*"It grows in concentric bands of brown, grey, tan, and cream, like a turkey's tail frozen mid-display. Researchers at NIH funded trials on it. The turkey was not consulted."*
- **Tier:** Common
- **Mechanic:** "Spectrum Bonus" — output increases by 3% for each different tier of species the player owns (Common through Mythic = +15% when all five tiers represented). Rewards diverse collections.
- **Real basis:** Most studied medicinal mushroom in Western science. PSK (polysaccharide K) approved as a cancer adjunct therapy in Japan.

### 94. Lentinula edodes / Shiitake Master (Medicinal Form)
*"Ancient China cultivated it on logs deliberately 1,000 years before the West accepted mushrooms as food. The cave is unimpressed with the timeline."*
- **Tier:** Uncommon
- **Note:** Shiitake is in the launch roster (Common). Shiitake Master is the elevated Batch 7 form — a medicinal lentinula variant with a different mechanic.
- **Mechanic:** "Cultivation Memory" — generates bonus output proportional to the player's lifetime total spore production. Late-game power spike for veteran players.
- **Real basis:** Lentinan from shiitake is approved as an anti-tumor therapy in Japan.

### 95. Wolfiporia extensa / Poria (Cloud Mushroom)
*"Underground. Invisible. A white mass of mycelium that can reach five meters across without ever fruiting. The cave has not seen its fruit. It has felt it."*
- **Tier:** Uncommon
- **Mechanic:** "Hidden Root" — appears as bare cave floor (no visible model). Generates output invisibly. Players discover it only by checking their income log. Finding it feels like discovering a secret.
- **Real basis:** Poria cocos. Used in TCM for anxiety, insomnia. Grows as a large underground sclerotium.

### 96. Psilocybe cubensis / Golden Emperor (Elevated Form)
*"The most studied psychedelic organism on Earth. Clinical trials at Johns Hopkins. The cave runs its own trials. Ethics board: pending."*
- **Tier:** Mythic
- **Mechanic:** "Perspective" — once per 6 real-world hours, triggers a 2-minute "Perspective Shift" where the cave UI temporarily displays in a different color palette and all mushroom models glow differently. Purely cosmetic. Highest output Mythic species at base rate.
- **Note:** Roblox-safe. No drug references in tooltip. Flavor text kept mystery-focused.

### 97. Amanita muscaria (muscimol focus) / Muscimol Crown
*"Muscimol is not psilocybin. Different receptor. Different effect. The researchers argue about which is more important. The cave grows both."*
- **Tier:** Rare
- **Mechanic:** "GABA Pulse" — every 30 minutes, pulses a +25% output bonus to all adjacent species for 10 minutes. Reliable, rhythmic, predictable. The opposite of Siberian Oracle's chaos.
- **Note:** This is distinct from the Shamanic Form (Batch 3 Mythic) and the launch Fly Agaric. Three aspects of one species = collectible lore set.

### 98. Cordyceps sinensis (now Ophiocordyceps) / Himalayan Gold
*"$20,000 per kilogram. Found only in high-altitude Tibetan meadows inside dead caterpillars. Harvest season: 2 weeks per year. The cave runs on a different schedule."*
- **Tier:** Epic
- **Mechanic:** "Ultra Rare Harvest" — produces once per real-world week. That single harvest equals 10 days of standard Epic output compressed into one event. Rewards players who log in on scheduled days.
- **Real basis:** Yarsagumba. Most expensive mushroom in the world by weight. $20,000/kg+. Massive industry in Nepal/Tibet.

### 99. Hericium erinaceus (nootropic form) / NGF Crown
*"Nerve growth factor stimulation. Cognitive enhancement. Memory repair. The cave does not understand what those words mean. It knows what the mushroom does."*
- **Tier:** Rare
- **Mechanic:** "Memory Boost" — when purchased, permanently upgrades the spore output of one randomly selected launch species by 15%. The bonus cannot be undone. You grow the species you already own.
- **Real basis:** Lion's Mane. Contains hericenones and erinacines that stimulate NGF. Studied for Alzheimer's.

### 100. Piptoporus betulinus / Birch Polypore (Ötzi's Pharmacy)
*"Ötzi carried two pieces of it. It treats intestinal parasites. He had intestinal parasites. He also had an arrow in his back, which it could not help with."*
- **Tier:** Common
- **Mechanic:** "Healer" — cancels one negative status effect on any species per day. The cheapest debuff cure in the game.
- **Real basis:** Birch polypore. Ötzi the Iceman carried it. Contains agaric acid, an antiparasitic.

### 101. Fomitopsis betulina / Betulinic Bracket (Modern Research)
*"Betulinic acid is a potential HIV inhibitor. Potential. The papers are peer-reviewed. The cave is not a clinical trial."*
- **Tier:** Uncommon
- **Mechanic:** "Research Bonus" — generates "Research Points" (a third secondary currency) used in a separate "Cave Lab" interface to permanently upgrade mechanic formulas. Feeds the long-term meta-progression layer.

### 102. Laricifomes officinalis / Agarikon (The Physician's Ghost)
*"Dioscorides prescribed it. Pliny the Elder wrote about it. Specimens found in Pacific Northwest caves are 10,000 years old. The FDA has no opinion about this yet."*
- **Tier:** Epic
- **Mechanic:** "Ancient Prescription" — passively generates one "Physician's Token" per real-world week. Tokens are tradeable. Supply is hard-capped (one per player per week globally). Scarcity drives economy.
- **Real basis:** Agarikon. Largest polypore. Found in old-growth forests. Paul Stamets has researched antiviral properties.

---

## BATCH 8 — "MYCONID RISING"
*Theme: Fictional, mythological, and game-universe fungi. This is where FunGuy transcends mycology and becomes mythology.*
*Launch event: "The Spore Mind Awakens" — a Myconid elder NPC appears in The Deep and offers lore quests.*

---

### 103. Myconid Sovereign / The Elder Spore (D&D)
*"In the Underdark it holds court. In your cave it holds court. The distinction is irrelevant to the Sovereign."*
- **Tier:** Mythic
- **Mechanic:** "Spore Colony" — acts as a hub. All mushrooms placed within 3 slots of the Myconid Sovereign gain +20% output. The best adjacency multiplier in the game. Forces cave layout planning.
- **Lore basis:** D&D Underdark. Myconid Sovereigns are the elders of fungal communities. Perfect fit.

### 104. Shrieker (D&D) / The Listener
*"It screams when light touches it. The cave has light now. The cave regrets nothing."*
- **Tier:** Uncommon
- **Mechanic:** "Alarm" — when any other player enters the cave zone, the Shrieker emits a visual alarm effect and boosts all mushrooms' output by 15% for 5 minutes. Rewards having other players visit.
- **Lore basis:** D&D dungeon mushroom. Classic encounter creature.

### 105. Violet Fungus (D&D) / Rot Touch
*"In the Underdark it paralyzes adventurers and dissolves them into nutrients. In your cave it has redirected this energy toward capitalism."*
- **Tier:** Rare
- **Mechanic:** "Drain" — siphons 5% of output from every mushroom within 2 slots and adds it to its own counter. Territorial. Requires isolated placement to avoid cannibalizing neighbors.

### 106. Sporadic Starburst / The Mario Cap (Nintendo Reference)
*"A red cap, white spots, a kingdom to save. You know this mushroom. You have always known this mushroom. It was never real. It is real now."*
- **Tier:** Rare (cosmetic Epic treatment)
- **Mechanic:** "Power-Up" — once per hour, player clicks it to receive a 60-second +100% output "power-up" mode with a distinct visual effect. The most satisfying click in the game.
- **Lore basis:** Super Mario Bros. Amanita muscaria-inspired. Universal recognition.

### 107. Gloomshroom (Terraria) / Terrarian Spore
*"It grows only in the Corruption biome, where the grass has turned purple and nothing friendly remains. You imported it. The corruption will follow."*
- **Tier:** Rare
- **Mechanic:** "Corruption Spread" — slowly spreads a purple visual effect to adjacent cave terrain. Purely cosmetic but creates a visible "corrupted zone" players either love or manage. Optional aesthetic choice.
- **Lore basis:** Terraria's Gloomshroom grows in the Corruption biome.

### 108. Spore Shroom (Hollow Knight) / Dream Scatter
*"It releases spores that carry dreams. The Hallownest scholars catalogued 47 varieties of fungal dream. Their notes smelled of mushroom."*
- **Tier:** Epic
- **Mechanic:** "Dream Spore" — passively generates "Dream Fragments" over 6 hours. Dream Fragments are the only currency for purchasing cosmetic cave decorations from the aesthetic shop (walls, floor, lighting).
- **Lore basis:** Hollow Knight's fungal kingdom. Highly recognizable among indie game fans.

### 109. Scarecrow Shroom (Original) / The Watcher
*"It has no eyes. It watches everything. This has been verified independently by three separate researchers who have since changed careers."*
- **Tier:** Uncommon
- **Mechanic:** "Surveillance" — once per day, reveals the exact spore count, tier, and last harvest time of any one mushroom owned by another player (with their cave accessible). Competitive intelligence mechanic.

### 110. The Clockwork Cap (Original Mythic) / Temporal Mycelium
*"It grows faster than visible. If you watch it long enough you will believe you can see time move. You cannot. The mushroom can."*
- **Tier:** Mythic
- **Mechanic:** "Time Compression" — once per real-world week, activates a 10-minute period where all offline time accumulation is simulated in real time (as if you'd been offline for 8 hours while actually playing). The time-machine mechanic.

### 111. Mycelial Titan (Original Mythic) / The Network
*"The Wood Wide Web is real — the underground mycelium network connecting all trees in a forest through chemical signaling. What is underground your cave is older than the cave."*
- **Tier:** Mythic
- **Mechanic:** "World Network" — connects to every other player's cave via a server-wide mycelium network animation visible in The Deep. 0.1% of all server-wide spore production flows to Mycelial Titan owners. True passive income from other players' activity.
- **Lore basis:** The Wood Wide Web (Simard et al.). Real phenomenon, mythologized here.

### 112. Tolkien's Pale Fungus (Lore Reference) / Mirkwood Shade
*"In Mirkwood the elves' halls glowed faintly with bioluminescent fungi in the stone. Tolkien did not name them. You have."*
- **Tier:** Rare
- **Mechanic:** "Elven Glow" — purely aesthetic. Places a diffuse cool blue glow around the entire cave zone when owned. Visual enhancement only. Collectible for lore enthusiasts.
- **Lore basis:** Tolkien's descriptions of Thranduil's halls. Bioluminescent cave aesthetic directly from source material.

### 113. Norse World-Tree Fungus (Mythology) / Yggdrasil Root
*"The world-tree is sick. The goats gnaw it, the serpent Nidhogg gnaws its roots, and still it stands. It stands because of what grows at its base."*
- **Tier:** Mythic
- **Mechanic:** "World Root" — at the start of each real-world day, redistributes 5% of total spores from all players in the server to the top 3 most active players. The "Yggdrasil redistribution" — activity-weighted daily income.

### 114. The Nameless Bloom (Original Mythic) / Last Light
*"It has no Latin name. No common name. No classification. It was found once, described in one paragraph in a 1923 journal, and never found again. The cave found it."*
- **Tier:** Mythic
- **Mechanic:** "Unknown Properties" — the mechanic is not shown in the tooltip. It does something different for every player, randomized at purchase. Players on the FunGuy Discord would share what theirs does — community discovery mechanic.

### 115. Aether Cap (Original Mythic) / The Void Bloom
*"Some mushrooms grow toward the light. This one grew toward the absence of light, through the absence of rock, into the space between spaces. The cave is not sure what it found there."*
- **Tier:** Mythic (end-game, post-Prestige 3 unlock only)
- **Mechanic:** "Void Income" — generates "Void Spores" (a fourth, final prestige currency). Void Spores are the only currency for post-Prestige 3 upgrades. The horizon-extension species — proof there is always a next tier.

### 116. The Sporulate Entity (Original, Prestige-Only) / Spore God
*"You have seen what the cave contains. You have seen what grows beneath the cave. Now the cave sees you. It is pleased with what it sees. Grow."*
- **Tier:** Mythic (Prestige-exclusive, unlocked by completing first full Prestige cycle)
- **Mechanic:** "Prestige Multiplier" — adds a permanent +15% multiplier to all species owned, compounding per additional Prestige completion. The core prestige reward species. The reason players Sporulate.

---

## Priority Map — What to Build When

### Year 1, Months 1–6 (Batches 1–3): Foundation
**Highest priority species for early updates:**
- Mycena chlorophos, Panellus stipticus (Batch 1) — core bioluminescent loop, defines the aesthetic
- Omphalotus olearius, Neonothopanus gardneri (Batch 1) — event-tied mechanics establish event value
- Fairy Ring Sprite, Marasmius oreades (Batch 3) — introduces layout/placement puzzle mechanic
- Claviceps purpurea / Ergot (Batch 3) — first server-wide social mechanic, critical for community building
- Clathrus archeri, Destroying Angel (Batch 3) — high drama, high shareable visual moments

**Priority reasoning:** Batches 1 and 3 establish both the visual identity AND the social infrastructure. New players need the glowing aesthetic (Batch 1) and veterans need server-wide reasons to return (Batch 3).

### Year 1, Months 7–10 (Batches 4–5): Economy Layer
**Highest priority:**
- Ophiocordyceps unilateralis (Batch 4) — introduces the most complex mechanic in the game; needs its own event to explain
- Tuber magnatum / White Truffle (Batch 5) — the anchor for the player-driven trading economy; launch this when you have 500+ concurrent players
- Matsutake Sovereign (Batch 5) — introduces decoration interaction system (new system launch with this batch)

**Priority reasoning:** The economy (Batch 5) only has impact when there are enough players to drive market dynamics. Delay White Truffle if player count is below threshold.

### Year 1, Months 11–12 (Batch 6): Spectacle
**Highest priority:**
- Humongous Fungus (Batch 6) — the jaw-drop moment species. Nothing else in the game spans all cave slots. Announce it 4 weeks early.
- Calvatia gigantea / Puffball (Batch 6) — the most satisfying moment-to-moment mechanic. Players will clip and post the eruption.

### Year 2 (Batches 7–8): Depth and Legacy
**Highest priority:**
- Cordyceps sinensis / Himalayan Gold (Batch 7) — weekly reward cadence; teach players weekly engagement before it launches
- Myconid Sovereign (Batch 8) — the layout-puzzle game within the game; will drive Discord discussions about optimal placement
- The Nameless Bloom (Batch 8) — mystery species; announce it 6 weeks early with zero mechanic information. Let the community speculate. The speculation is marketing.
- Aether Cap / Void Bloom (Batch 8) — launch this the same day as Prestige 3 unlock. It is the reason to prestige a third time.

---

## Species Count Summary

| Batch | Name | Species | Tier Breakdown |
|---|---|---|---|
| Launch | — | 36 | 12C / 8U / 7R / 5E / 4M (approximate) |
| Batch 1 | The Glowing Dark | 18 | 5C / 5U / 5R / 2E / 1M |
| Batch 2 | Roots of the World | 15 | 4C / 5U / 5R / 1E / 0M |
| Batch 3 | The Old Lore | 16 | 1C / 4U / 6R / 3E / 2M |
| Batch 4 | Spore War | 14 | 2C / 3U / 5R / 3E / 1M |
| Batch 5 | The Market | 14 | 2C / 4U / 5R / 2E / 1M |
| Batch 6 | Colossal | 13 | 0C / 4U / 6R / 2E / 1M |
| Batch 7 | The Apothecary | 12 | 1C / 3U / 4R / 3E / 1M |
| Batch 8 | Myconid Rising | 14 | 0C / 3U / 3R / 3E / 5M |
| **TOTAL** | | **152** | — |

**Trajectory to 350+:** 152 after Batch 8 (Month 18). Repeat the roadmap pattern with Year 2 themes: Regional Batches (by continent), Seasonal Batches (winter species, tropical monsoon species), and Community-Designed Batches (player votes on the next species added). Reaching 350 at ~Month 36.
