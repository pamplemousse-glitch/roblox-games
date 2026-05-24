# FunGuy — The Deep: Mob Design Document

## Naming Philosophy

The best names compress *what the creature does to you* into one word. Use real mycology/cave biology Latin roots mixed with Old English/Norse sounds. Never describe appearance — name the relationship.

Five rules:
1. **One compressed idea, not a description.** "Vellichor" beats "glow_spore_enemy."
2. **Invented words that sound like they existed already.** Use roots: `caeci-` (blind), `rhizo-` (root), `myco-` (fungus), `troglo-` (cave), `stygno-` (underworld water), `hypha-` (thread). Mix with Old English/Norse suffixes: `-gast` (ghost), `-orm` (worm/serpent), `-welt` (mark left behind), `-vant` (wanderer).
3. **Name the creature's relationship to the environment, not its appearance.**
4. **Borrow mythic weight through sound, not literal reference.**
5. **Tiers sound different.** Common: short, chunky (`Knurr`, `Velk`). Rare: compound, slightly wrong (`Vellichor`, `Caecivant`). Elite: proper-noun weight (`Tholwatch Prime`). Boss: titles, not names (`The Underfold`).

---

## Hostile Mobs

### Tier 1 — Common

**GRUBWELT**
Swarm mob. A plump, blind larva that wallows through cave floor sediment, trailing phosphorescent slime it cannot see itself produce. Appears in clusters of 6–10.
- Combat: Individually weak, overwhelm through numbers
- Drop: Raw Spore Cluster
- Inspiration: Arachnocampa luminosa larvae; cave diplurans. "Grub" + "welt" (Old English: a mark left on skin)

**KNURR**
Tank/Roller. A squat, pale-shelled isopod roughly the size of a boot. Curls into a calcite-white ball when threatened and rolls down inclines into players.
- Combat: High defense, knockback on roll, low damage
- Drop: Chitin Shard
- Inspiration: Cave isopods (Caecidotea spp.); "knurl" (a hard knob or ridge) compressed

**VELK**
Ambush. A translucent, eel-shaped creature that undulates through flooded cave trenches, its spine faintly glowing yellow-green, steering by vibration rather than sight.
- Combat: Hides in water pockets, lunges when player passes
- Drop: Luminescent Marrow
- Inspiration: Olm (Proteus anguinus); cave fish. "Selkie" + "velvet" + hard stop of "elk"

**SPINDRIFT**
Trapper. A daddy-long-legs the size of a hand that moves in erratic, floating bounds through cavern air, trailing glow-thread that snags and slows players.
- Combat: Deploys slow-thread zones, floats away from melee
- Drop: Gossamer Thread
- Inspiration: Cave harvestmen (opiliones); Arachnocampa silk hunting. "Spindle" + "drift"

**MURGOT**
Swarm Tank. A colony organism — compressed cave crickets fused into a single lurching body by a fungal mat, clicking constantly in the dark.
- Combat: Moderate HP; splits into 3–4 smaller crickets at 50% HP
- Drop: Chittered Spore
- Inspiration: Ophiocordyceps zombie-ant mechanism applied to crickets. "Maggot" + "murk"

### Tier 2 — Uncommon

**THOLWATCH**
Stunner. A pseudoscorpion the size of a dog, completely eyeless, that presses flat against rock ceilings and drops onto prey — its chelicerae coated in paralytic sporemilk.
- Combat: Drops from ceiling; applies Spore-Paralysis debuff (slows collection speed 8 sec)
- Drop: Paralytic Spore Sac (crafting: slow traps)
- Inspiration: Cave pseudoscorpions (Tartarocreagris texana). "Tholus" (Latin: dome/vault) + "watch" inverted

**CAECIVANT**
Chaser. A blind, albino centipede three meters long that navigates by vibration of spore fall — and interprets a player's harvesting as a territorial challenge.
- Combat: Triggered by harvest noise; relentless pursuit, high speed
- Drop: Segment Shell
- Inspiration: Cave centipedes; "caeci-" (Latin: blind) + "-vant" (gallivant — blind wanderer that charges)

**RIMEGAST**
Bruiser. A towering pale crayfish, almost translucent, that haunts the deepest flooded channels — its claws large enough to crack a stalactite. Ancient enough to be nearly geological.
- Combat: High HP, area-denial claw slams, spawns Knurr on death
- Drop: Rime Claw
- Inspiration: Cave crayfish (Cambarus aculabrum). "Rime" (Old Norse: frost/ancient) + "gast" (Old English: ghost)

**VELLICHOR**
Area Denial. A cluster of bioluminescent spores with rudimentary locomotion and territorial instinct — drifts slowly, violently disperses near heat or harvesting.
- Combat: Drifts toward player, explodes in spore cloud when damaged or near active harvest
- Drop: Foxfire Spore
- Inspiration: Mycena chlorophos; slime mold locomotion. Repurposed from "vellichor" (Dictionary of Obscure Sorrows) — the sound evokes something beautiful that bites

**VITTRASK**
Guardian. A leathery, cowled creature squatting motionless at cave junctions, indistinguishable from a stalactite, that hisses and charges when a player approaches its fungal patch.
- Combat: Zone-locked — does not pursue beyond its patch; drops aggro if player leaves its territory
- Drop: Claim-Stone
- Inspiration: Swedish Vittra (territorial underground spirits). "Vittra" + "trask" (Swedish: marsh/swamp)

### Tier 3 — Rare

**SHIKROOT**
Parasite Hunter. A corrupted troglobite driven by a parasitic mycelium cord threading through its skull. Specifically seeks out and devours bioluminescent growths — including player mushrooms.
- Combat: Targets placed mushrooms if left unattended; moderate damage, high persistence
- Drop: Cordyceps Strand (cursed upgrade: double output, take damage)
- Inspiration: Ophiocordyceps + Shikome (Japanese underworld pursuers sent by Izanami). "Shiko-" + "-root"

**LUMENARCH**
Lure Hunter. A vast crab-like creature whose carapace is overgrown with bioluminescent fungal colonies. Hunts by extinguishing ambient cave light, then using its own light as a lure.
- Combat: Suppresses ambient glow in radius; lures players toward false-light; claws do high damage
- Drop: Lumen Carapace (Tier 5 upgrade material)
- Inspiration: Cave crab morphology + Crabsquid (Subnautica) EMP mechanic. "Lumen" (Latin: light; ruler of light)

---

## Passive / Neutral Mobs

**PALLORM**
A fat, slow-moving worm that grazes on cave moss and old spores, depositing nutrient-rich castings that accelerate mushroom growth nearby.
- Mechanic: Follow → rich spore veins. Alive = +15% growth aura to nearby mushrooms. Killed → Worm Casting (growth booster item)
- Inspiration: Cave oligochaetes; "pallor" + "orm" (Old Norse: worm/serpent)

**GLOOMOLCH**
A translucent, jellyfish-like organism floating near the ceiling on convection currents, absorbing ambient bioluminescence and releasing light-spore bursts like a living lantern.
- Mechanic: Tap/harvest → Lumospore burst (temporary glow, reveals hidden wall veins). Startled → erratic dispersal, brief screen blind
- Inspiration: Arachnocampa luminosa ceiling glow; "molch" (German: newt/salamander — the olm reference)

**COBLYN**
A small, hunched figure barely visible in the rock that taps rhythmically on cave walls with stone knuckles, seeming to communicate. Following its tapping leads to richer spore veins.
- Mechanic: Follow → bonus spore deposits. Attacked → summons 3x Knurr and flees. Drop: Knocker's Coin (luck upgrade)
- Inspiration: Coblyn — the actual Welsh mining spirit; direct counterpart to the Cornish Tommyknocker

**FERNGAST**
A pale, wide-eyed amphibian perching on wet rock shelves, eating small invertebrates that cluster around bioluminescent mushrooms. Its skin faintly mirrors nearby light.
- Mechanic: Reduces Grubwelt spawns in its territory. Feed Chitin Shards → produces Luminescent Marrow passively. Skittish — flees if player moves too fast
- Inspiration: Olm (Proteus anguinus — lives 100 years, navigates by electromagnetic field). "Fern" (German: distant) + "gast" (ghost)

**MYCOSTRIDER**
A long-legged harvestman walking calmly through the deepest passages, covered in a living coat of tiny fungi. It neither attacks nor flees — simply walks its route endlessly.
- Mechanic: Follow → reveals hidden tunnel entrances. Touch → random buff from fungi colonies on its body. Killing curses zone: -20% growth for 5 min
- Inspiration: Cave harvestmen + phoresis (organisms hitching rides) + mycorrhizal symbiosis. "Myco-" + "strider"

**ALUXI**
A mischievous, knee-high silhouette visible only in peripheral vision. Steals dropped spores but can be bribed with an offering to reveal hidden passages.
- Mechanic: Steals 5–15 spores if player idles too long. Bribe with Foxfire Spore → secret cache revealed. Attacked → permanently hostile for the session
- Inspiration: Alux (Mayan cave spirits — knee-high, invisible, steal things, respond to offerings, associated with cenotes/caves)

---

## Elite / Named Mobs

**CAECIVANT THE UNMEASURED**
The oldest of its kind — a cave centipede so long its full body has never been seen. It has consumed smaller tunnel systems and expanded into the walls themselves.
- Gimmick: Segments must be killed in order; attacking out of order causes regeneration; final phase fuses into a ring around the arena
- Drop: The Unmeasured Coil (passive income from all active caves)

**THOLWATCH PRIME — "The Ceiling's Patience"**
It has hung from the same stalactite so long that calcite formations have grown around its legs, integrating rock and creature. It does not drop — it descends.
- Gimmick: P1 — stalactite camouflage; identify it among real formations using spore-pulse detection. P2 — descends slowly, massive AOE paralysis. P3 — fuses to ground, fires paralytic volleys
- Drop: Ancient Chelice

**VELK THE STILL CURRENT**
A Velk that has grown to fill an entire flooded trench. Its body is the tunnel now. Its glow has faded to near-infrared. It moves only when it has decided to move.
- Gimmick: Environmental fight — the "floor" is its body. Read ripple patterns to predict surfacing. Pulls players under
- Drop: Still-Current Scale (enables flood cave upgrade — passive rare drops from water sector)

**THE HOLLOWKNURR**
A Knurr whose shell has been entirely colonized by ghost fungus — it no longer rolls but levitates slightly, pulsing white, releasing paralytic spores on impact.
- Gimmick: Floats, predictable. Contact poison corrupts player's cave (-50% spore output 30 sec). Must be hit during its dark phase when the fungus dims
- Drop: Ghost Chitin (highest-tier armor crafting)

**ANASTOMANCER** (fragment)
Not a creature — or not entirely. A floating tangle of hyphal cords that has achieved distributed cognition. Each strand is individually alive. Together they are ancient and hostile to individual existence.
- Gimmick: 4 cord-entities must be killed simultaneously; attacking any surviving entity regenerates the others
- Drop: Anastomotic Fragment (links two cave sectors for shared 5% spore income)

---

## Bosses

### THE UNDERFOLD
*"Where the cave folds back on itself, something was folded in with it."*

An enormous layered organism resembling geological strata — banded like sedimentary rock but breathing. Each band is a different age of cave ecosystem compressed into one body. It does not move so much as *shift,* like tectonic plates.

**Phase 1 — Geological Patience:** Barely acknowledges players; sends autonomous Knurr and Tholwatch from cavities in its body. Players attack luminous node-organs while managing spawned mobs.

**Phase 2 — Tidal Fold:** Physically contracts the arena — walls move inward. Smaller space, same mob count, spore pickups crushed against walls. Forces urgency.

**Phase 3 — Inversion:** Floor and ceiling swap. The Underfold unfolds itself, revealing a vast bioluminescent interior landscape. True weak point: the Pallorm at its core, which it has been feeding on for centuries. Kill the Pallorm; kill the boss.

- **Drops:** Fold-Stone (The Deep sector expansion) + Pallorm's Last Casting (+10% passive growth, permanent, entire cave)
- **Name anatomy:** Geological folding (real cave formation process) + "under" + "fold" = what lies beneath the fold of the world

---

### RIMEGAST THE FIRST TENANT
*"The cave was not empty when the first mushroom grew. Something had already been here, in the cold, for a very long time."*

An ancient cave crayfish of extraordinary size — its translucent body reveals fossil records inside its carapace, the bones of things it ate ten thousand years ago. Its claws are calcified into speleothem formations. Cave pearls encrust its back.

**Phase 1 — The Ancient Peace:** Rimegast moves slowly in the flooded lower arena. Players fight from elevated ledges. Sweeping calcite-claw arcs, summons Velk to the surface water.

**Phase 2 — Territorial Fury:** Floods the lower chamber entirely. Players must reach higher ground. Its bioluminescent organs ignite, drawing Grubwelt swarms. Players must harvest Grubwelt mid-fight (drops temporary healing spores) while dodging Rimegast's lunges.

**Phase 3 — The Knock:** Rimegast begins destroying structural columns — stalactites fall as arena hazards. It makes rhythmic *knocking* with its claws — the Knocker's warning. The knocking is real: the ceiling is collapsing. 60-second final timer.

- **Drops:** First Pearl (cosmetic cave trophy) + Stygian Marrow (water-sector upgrade material)
- **Name anatomy:** Cave crayfish + Knocker folklore + cave pearl carapace + geological time made animate. "The First Tenant" implies you are the invader.

---

### THE ANASTOMANCER
*"It began as two hyphae touching. Then a network. Then a name. Now it is asking what you are."*

The elite Anastomancer fragment was a piece of this. The full manifestation is room-sized — a cathedral of woven hyphal cords, bioluminescent in dozens of colors, beautiful and wrong. It is trying to absorb the player's cave into itself.

**Phase 1 — Communion:** Not yet hostile. Attempts to "link" with the player's cave — each passing second siphons spore income. Players must destroy 6 link-nodes to force Phase 2. Each destroyed node causes backlash damage.

**Phase 2 — Absorption:** Active attack phase. Hyphal tendrils can "infect" placed mushrooms, converting them temporarily into hostile Shikroot. Players fight the boss while managing their own corrupted garden.

**Phase 3 — The Anastomosis:** One glowing hyphal knot at the center — the origin point, smaller than a fist. All outer attacks are reflected by the network. Players must throw collected spores at the knot to create attack windows. Destroying it causes the entire network to desiccate rapidly — bioluminescence extinguishes from the outside in.

- **Drops:** Anastomancer's Core (permanent: links all cave sectors, 5% shared income between all sectors) + Chromatic Hypha (cosmetic: deep-hue mushroom variants)
- **Name anatomy:** Real mycological anastomosis (hyphal fusion into network intelligence) + "-mancer" (one who controls) — network-weaving as magic, grounded in real biology

---

## Future Naming Seeds

Word-fragment combinations for naming future mobs:

| Prefix | Meaning | Example combos |
|--------|---------|----------------|
| `Rhizo-` | Root network | Rhizovant, Rhizomourn |
| `Stygno-` | Underworld water | Stygnolch, Stygnoarm |
| `Chlamydo-` | Thick-walled spore | Chlamydour, Clamydusk |
| `Caecid-` | Blind | Caecidor, Caecidwelt |
| `Hypha-` | Fungal thread | Hyphavant, Hyphalarve |
| `Mond-` | Moon (cave moonmilk) | Mondmilker, Mondwelt |
| `Knall-` | Knock/bang (German) | Knallgast, Knallside |
| `Vittr-` | Swedish underground spirit | Vittruk, Vittroch |
| `Alux-` | Mayan cave spirit | Aluxine, Aluxwatch |

---

## Implementation Notes

Current code (`src/Server/MobManager.luau`) supports:
- `cave_beetle`, `blind_fish`, `shadow_spore` — these are placeholder IDs
- Replace with proper mob IDs from this document in the combat expansion phase
- Config.luau `MOB_TYPES` array needs full entries: id, hp, damage, drops, aggro radius
- MobSpawn_ markers in workspace.TheDeep determine spawn positions
- Passive mobs need a separate PassiveMobManager module (non-combat, interaction-based)
- Elites should use the same MobManager but with `isElite = true` flag and scaled HP/drops
- Bosses need a dedicated BossManager module with phase state machine
