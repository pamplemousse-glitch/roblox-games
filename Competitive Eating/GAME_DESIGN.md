# Competitive Eating — Roblox Game Design Document

*Based on deep research into real competitive eating, existing games/media, and Roblox game design best practices. May 2026.*

---

## 1. The Real World Foundation

### The Sport (Major League Eating / IFOCE)
- ~80 contests/year, $400–500K in prizes. Nathan's Famous (Coney Island, July 4th) is the Super Bowl: 35,000 in-person, millions on ESPN, 10 minutes, 76 hot dogs record (Joey Chestnut, 2021).
- Every contest has an individual scorekeeper per eater. Safety EMT on site. Detailed rulebook per sponsor.
- **The game should treat this as a real sport — because it is one.**

### The Stars (and their in-game DNA)

| Real Eater | Nickname | Key Trait | Game NPC |
|---|---|---|---|
| Joey Chestnut | "Jaws" | Methodical, relentless, 16+ Nathan's titles | **The Jaws** — enters trance, ignores all debuffs for 10 sec |
| Takeru Kobayashi | "The Tsunami" | Small, lean, invented the Solomon Method & The Shake | **The Tsunami** — tiny frame, massive output, mid-contest shimmy |
| Miki Sudo | "The Notorious M.I.K.I." | Most dominant women's eater, 9 Nathan's titles | **The M.I.K.I.** — psychological warfare, debuffs #1 opponent |
| Sonya Thomas | "The Black Widow" | 100 lb woman who beats 200 lb men; "I want to kill them" | **The Widow** — counter-intuitive small/huge output |
| Matt Stonie | "The Megatoad" | Upset king, 16M YouTube subs | **The Toad** — performs better when losing (clutch) |
| Tim Janus | "Eater X" | Wore elaborate face paint, 2nd at Nathan's | **Eater X** — crowd-energy-based mechanics |
| Crazy Legs Conti | "The Showman" | Was buried in popcorn and ate his way out | **The Showman** — arrives via ridiculous vehicle |

### The Vocabulary (All become mechanics)

| Term | Reality | Game Mechanic |
|---|---|---|
| **Solomon Method** | Split food in half, eat both simultaneously | Upgradeable technique: bite counts double, slower jaw animation |
| **Kobayashi Shake** | Bounce to settle food, create space | Active skill (Q): shimmy to recover 15% stomach space, 45s cooldown |
| **Dunking** | Dip bready food in water to soften | Dunk station on the map gives +20% speed for compatible foods |
| **Chipmunking** | Pack extra in cheeks at end; must swallow in ~30 sec | Last 10s: stuff cheeks for bonus count — risk of reversal |
| **Reversal of Fortune** | Vomit = instant DQ (ESPN's polite term) | Overfill the meter → cartoon reversal → DQ |
| **Fat Belt Theory** | Lean eaters win, fat ≠ capacity | Stat design: character size doesn't reflect stats, defying expectations |
| **Water Loading** | Train stomach by drinking gallons | Upgrades named after real training: "Water Session I–V" |
| **Gag Reflex Suppression** | Brush tongue twice daily, hypnotherapy | "Mental Training" upgrade branch → "Focus" stat |
| **The Mustard Belt** | Nathan's famous yellow belt trophy | Primary progression trophy — belt colors change with prestige |

### The Most Gameable Real Foods

*Real MLE records, mapped to contest tiers:*
- **Tier 1 (Local):** Hot Dogs, Burgers, Donuts, Chicken Wings, Tacos
- **Tier 2 (Regional):** Ramen, Gyoza, Peeps (255 in 5 min!), Twinkies, Bacon Strips (182 in 5 min)
- **Tier 3 (National):** Brain Tacos (real Chestnut record), Spray Cheese from a can, Butter Logs (Don Lerman's record — 7 sticks in 5 min), Donut Holes (350 in 8 min)
- **Tier 4 (World):** Cow Brains (Kobayashi, 57 in 15 min), Gallon of Mayo (Zhornitskiy), Rocky Mountain Oysters (unlock with comedy warning)

---

## 2. The Game

### Core Identity
**"Nathan's Famous meets Roblox — a genuine sport simulator with cartoon physics, George Shea-level absurdist commentary, and the drama of the greatest rivalry in eating history."**

Tone: SpongeBob + Kirby + WarioWare. Cartoon gross, never realistic gross. Big eater = enthusiastic, joyful, full of life — never a villain.

---

### The Four Stats (All Grounded in Reality)

| Stat | Real Basis | What It Does | Upgrade Names |
|---|---|---|---|
| **Stomach Capacity** | Kobayashi stretched his to 4x via water loading | Maximum total you can eat before reversal risk | Water Session I-V → Stretch Protocol → Bottomless Pit |
| **Jaw Speed** | Chew 6 pieces of gum simultaneously; elite eaters chew 2-3x per bite | Fill rate per bite | Gum Chewing I-V → Iron Jaw → Solomon Unlock → Hyperjaw |
| **Swallow Rate** | Converting packed food to digested food faster prevents overflow | How fast the fill meter clears downward, preventing reversal | Throat Training I-V → Smooth Passage → Liquid Assist |
| **Focus** | Biofeedback, hypnotherapy, video review — the mental game | Reduces random fumbles, enables longer perfect-bite streaks | Mental Training I-V → Hypnotherapy → Biofeedback → The Zone |

Stats start at 1x real-world baseline. Max is 4x (Kobayashi-level). That's the progression ceiling.

---

### Hub World

A compact 3D fairground midway (~150×150 studs). All four tier arenas are visible from a single screen — the Diner is right in front, the Fairground tent is across the midway, the Stadium tunnel entrance is in the distance, and the Coney Island boardwalk is visible on the horizon before you've unlocked it. Higher tiers are aspirational landmarks you can see from day one.

**Hub contents:** Upgrade shop kiosk (always visible from all arenas), leaderboard board, cosmetics locker, George Shea flavor NPC, pet vendor. No loading screen and no menu lobby — everything is one Place. Walk up to an arena entrance and tap/press E to queue.

**Between contests:** Players are in the hub. They can upgrade at the kiosk, check leaderboards, flex cosmetics, or watch an active contest through the arena window. The hub is always alive — other players' prestige auras are visible, which creates social aspiration.

---

### The Contest (Core Loop)

```
QUEUE (up to 15s)
  └─ Walk up to arena, press E / tap prompt to join queue
  └─ Shop button appears — upgrade while you wait (modal overlay, stays in queue)
  └─ NPC backfill fires at T-10s for any empty seats

COUNTDOWN (5s)
  └─ George Shea intro (2-line typewriter text, skippable). Crowd builds.

ACTIVE CONTEST (90 seconds)
  ├─ Each food item = a skill-check minigame (ring, hold-bar, combo, etc.)
  ├─ Q / left button: The Shake (recover 15% stomach space, 45s cooldown)
  ├─ E / right button: Deep Focus (widens skill-check zones 30%, 8s, 60s cooldown)
  ├─ Blue cup at seat: Dunk (0.8s animation, ring pauses, next 3 bites 20% wider zone)
  ├─ Power Food zone: golden plate slides in every 25s — eat it or lose it
  └─ Fill meter: rises → caution → danger → Reversal of Fortune

CHIPMUNK WINDOW (last 10s, if fill is 50–90%)
  └─ "CHIPMUNK?" prompt flashes. Hold action button → unlabeled gauge fills.
  └─ Release in gold zone (60–80%): +15% fill, cheeks puff — safe!
  └─ Release early (<60%): +5% fill — wasted attempt
  └─ Release late (>80%): REVERSAL — cheeks burst, -20% fill, crowd groans

RESULTS (15s)
  └─ Live leaderboard revealed (was updating every 0.5s during contest)
  └─ Individual bite stats shown. Winner animation. Crowd reacts.
  └─ For DQ'd players: "Cheer for a player" button active during results

REWARDS
  └─ Coins by place (60/40/25/15 + 10 participation)
  └─ Challenge progress + record notifications + streak bonus
  └─ Upgrade prompt if coins sufficient for next upgrade
```

**Contest structure:** 3 arenas per server, staggered 30-second offsets (Arena A starts at 0:00, B at 0:30, C at 1:00, then loop). A new player never waits more than 30 seconds for a contest to start. 4 players per table — always (1–3 real + NPC fill). Camera locks to low third-person during contest (8 studs behind, 5 above, 10° down toward food table). Unlocks after result screen.

**Fill Meter Danger Signals (all visual/audio, no text):**

| Zone | Fill % | Visual | Audio | Character |
|---|---|---|---|---|
| Safe | 0–75% | Green | Normal chew sounds | Smiling |
| Caution | 75–90% | Yellow pulse | Strained chewing, labored breath | Sweating |
| Danger | 90–99% | Red flash + screen edge pulse | Heartbeat, urgent music | Eyes wide, wobbling |
| Overflow | 100%+ | Cartoon explosion | "BLORP" | Green spiral, deflate — DQ |

**Post-DQ spectator loop:** Overflow victims immediately become crowd participants. "Cheer for a player" button gives chosen player +Crowd Meter. Small coin reward for watching the round to completion instead of leaving.

---

### Contest Formats

1. **Capacity Contest** (always-on core) — Most units eaten in 90 seconds. The Nathan's format. Available at all tiers, all arenas, at all times.
2. **Speed Contest** — Fixed quantity, fastest time wins. (First to finish 7 hot dogs wins.) Weekly rotation.
3. **Endurance Contest** — Food types change every 20 seconds. Last eater without reversal wins. Unlocks at Tier 2. Weekly rotation.
4. **Spicy Round** — Adds a Heat Meter. A red thermometer fills at 10%/sec. At 100%: current food item fails + -10% fill. Water Chug button (R / blue lower-left button) triggers 0.7s animation — ring *pauses*, heat drops 50%. Rhythm: 4 bites → chug → 4 bites → chug. Weekly rotation.
5. **Precision Round** — Slower pace. Partial units count against fill score. Rewards Swallow Rate + Focus over raw jaw speed. Weekly rotation.
6. **Tag Team** — Two players, one shared fill meter. Player A eats; Player B waits and spectates. Voluntary HANDOFF (H / orange button) at any time. Forced auto-handoff if fill hits 85% and player doesn't pass within 3 seconds. Ping button lets inactive player signal readiness. NPC partner auto-handoffs at 70%. Unlocks at Tier 2. Weekly rotation.

---

### Progression Ladder

| Tier | Location | Unlock Gate | Food Pool (5 foods, rotating) | Prize |
|---|---|---|---|---|
| 1 — Local Diner | Small-town diner | Start of game | Hot Dog, Hamburger, Sloppy Joe, Corn Dog, Pancake Stack | Bronze Napkin |
| 2 — Regional Fairground | State fairground | 10 wins + 500 coins (~25 min) | Pizza Slice, Fried Chicken, Taco Platter, Onion Rings, Lobster Roll | Silver Fork |
| 3 — National Stadium | Big stadium | 30 total wins + 3,000 coins (~1.5 hrs) | Ramen Bowl, Giant Burrito, Deep Dish Pizza, Smoked Ribs, Gyoza Tray | Gold Stomach Belt |
| 4 — World Championship | Coney Island boardwalk | 75 total wins + 15,000 coins (~4–5 hrs) | Nathan's Hot Dog, Dragon Pepper Roll, Steel Gyoza, Double Smashburger, Coney Dog Stack | **The Mustard Belt** |

**Tier gates** are physical archways in the hub with a live progress bar ("8/10 wins | 320/500 coins"). Unlocking a tier triggers a brief camera pan to the new arena + crowd cheer.

**Food rotation:** 5-food pool per tier, pseudo-random order guaranteed no repeat for 3 consecutive contests. Arena entrance sign shows current food AND next food preview.

**Contest format rotation:** Capacity (most food wins — Nathan's format) is always-on at every arena. Two specialty formats rotate weekly (Monday reset):
- Week A: Speed + Spicy
- Week B: Endurance + Precision
- Week C: Tag Team + Speed
- Week D: Spicy + Precision
Specialty formats announced on hub billboard 24h early. Endurance and Tag Team don't unlock until Tier 2.

### Prestige System (5 Belt Tiers)

Prestige resets: all stats, all coins, all tier unlock progress. Player keeps: cosmetics, prestige aura, username color, permanent stat multipliers earned so far.

| Prestige | Name | Requirement | Permanent Bonus | Visual |
|---|---|---|---|---|
| P1 | Bronze Belt | Max all stats Level 10 + 50K coins | +5% all stats | Bronze floating belt + [P1] name prefix |
| P2 | Silver Belt | Max Level 20 + 150K coins | +10% all stats | Silver belt + silver name + particle trail |
| P3 | Gold Belt | Max Level 30 + 500K coins | +15% all stats | Gold belt + gold name + aura ring + gold eating animation |
| P4 | Diamond Belt | Max Level 40 + 2M coins | +20% all stats | Prismatic belt + blue trail + diamond crown + body sheen |
| P5 | Champion Belt | Max Level 50 + 10M coins | +25% all stats | Spinning belt + rainbow name + champion aura (visible 50 studs) + [CHAMPION] banner + unlocks The Bear |

All prestige auras are opt-in toggle in settings. P5 win in any contest triggers a server-wide "CHAMPION WINS" banner for all players.

### The Bear Encounter

**Trigger:** P5-only. A golden booth appears in the hub every Friday at weekly reset. George Shea delivers a cinematic intro. Walking up to the booth enters The Bear challenge.

**Format:** 1-on-1, Precision format (narrower skill-check windows). 3-minute contest (longer than standard 90s). The Bear runs at 120% of the player's personal best session stats — always slightly faster than you've ever been.

**Rewards:**
- First-time win: "Bear Slayer" title badge (visible in hub) + 100,000 coins + exclusive "The Bear" emote
- Weekly wins: 25,000 coins + Bear Trophy leaderboard point (resets Monday; top 3 get exclusive weekly cosmetic)

**Rules:** Retry immediately with no cooldown. Only 1 win counts per week for rewards. The Bear is repeatable forever — a permanent weekly goal for P5 players.

---

### NPC Personalities (The Cast)

Each NPC gets a **George Shea-style absurdist intro** before each contest. Example format (based on real Shea): *"Three years ago she euthanized her doubt, buried her hesitation in a shallow grave, and filled the void with an appetite that science cannot explain. She has been called many things — unstoppable, unprecedented, unbelievable — all of them true. Ladies and gentlemen, THE BLACK WIDOW!"*

Every NPC has:
- **One special move** (unique mechanic that activates mid-contest)
- **One personality hook** (pre-contest trash talk / ritual)
- **One visual signature** (face paint, outfit, arrival method)

| NPC | Special Move | Personality | Visual |
|---|---|---|---|
| **The Jaws** | "Grind" — ignores all debuffs for 10s | Quiet off-stage, terrifying on-stage | American flag gear |
| **The Tsunami** | "The Shake" — recovers 15% stomach space | Bows before each contest; pre-contest haiku | Minimal, lean, intense |
| **The M.I.K.I.** | "Widow's Sting" — debuffs #1 opponent's jaw -20% | Smiles sweetly before destroying you | Custom competition outfits |
| **The Widow** | "Unlimited Reserves" — +30% capacity at 80%+ full | Chose nickname to psychologically intimidate | Small frame, enormous output |
| **The Toad** | "Clutch" — +25% speed when losing | Nervous before, unstoppable during | Gaming/streaming aesthetic |
| **Eater X** | "Crowd Pop" — crowd meter gives stacking speed bonus | Makes eye contact with camera every bite | Elaborate face paint |
| **The Showman** | "Crowd Pop" variant — smoke machine, theatrical | Declares every bite a performance | Dreadlocks, arrives via unusual vehicle |
| **Deep Dish** | "Deep Heat" — 2x speed on spicy foods | Trash-talking Chicago native, somehow likeable | Italian American, loud outfits |
| **The Professor** | "Optimization" — eliminates one opponent technique for 15s | Narrates strategy out loud mid-contest | Lab coat, whiteboard |
| **The Grandma** | "Unlimited Reserves" — defies physics at high fill | Unexpected competitor; crowd goes insane when she's close | Apron, reading glasses |
| **The Rookie** | "Clutch" — performs better when trailing | Self-deprecating intro, unstoppable finish | Plain outfit, shaky hands at start |
| **The Bear** | None — immune to ALL debuffs | Doesn't trash talk. Just eats. | 6'9", massive, no expression |

---

### Input Design (Satisfying on Mobile + PC)

- **Each bite = a skill-check minigame** — not pure button mashing. Each food type has a distinct mechanic (see Minigame Mechanics section below).
- **Q key / left button:** The Shake — shimmy animation, recover 15% stomach space (45s cooldown)
- **E key / right button:** Deep Focus — widens all skill-check zones 30% for 8 seconds (60s cooldown)
- **Blue cup at seat (E / tap cup icon):** Dunk — 0.8s dip animation, ring *pauses* during it, next 3 bites have 20% wider success zone. Only available for bready foods; cup icon grays out otherwise. Tradeoff: 0.8s of eating time lost.
- **Solomon Method (purchased upgrade):** Each food item splits visually in half. Two smaller sequential rings per food instead of one. Ring 1 (0.6s) → 0.1s gap → Ring 2 (0.6s). Total 1.3s vs standard 1.5s. Both perfect = 110% value. One hit = 70%. Both miss = 30% + fill penalty. On mobile: left tap zone = Ring 1, right tap zone = Ring 2.

All mechanics use a single tap/click as the primary input — works identically on mobile and PC. Use `InputBegan`/`TouchBegan` events exclusively — standard click events have a 300ms mobile delay that destroys skill-check feel.

**Mobile non-negotiables:**
- Ring UI minimum 250px diameter
- Tap target = full lower half of screen (not a small button)
- Audio cue fires 400-500ms before each skill check appears (essential for mobile where visual attention is split)
- Minimum 70px touch targets, scaled to 120px on tablets

---

### Minigame Mechanics (Per Food Type)

Each bite triggers a food-specific skill-check minigame. Alignment/success % determines bite effectiveness — a perfect hit gives full fill, a glancing hit gives partial, a miss gives nothing plus a brief fumble cooldown. Stats modify the minigame parameters directly and visibly.

**Stat → Minigame variable mapping (follow Roblox Fisch's model — each stat changes something visually distinct):**
- **Jaw Speed** → needle/element rotation speed (slower = more time to react)
- **Focus** → success zone size (wider = bigger target)
- **Swallow Rate** → inter-bite cooldown (faster next minigame appears)
- **Stomach Capacity** → total bites needed per contest (unchanged per-bite)

**Difficulty targets (Stardew Valley's creator admitted starting too hard is the #1 minigame design mistake):**
- New player success rate: 70–75% per bite
- Veteran (max stats) success rate: 85–90% per bite
- Never below 50% at any upgrade level — that's frustration, not challenge
- The skill expression is consistency and speed across a full contest, not per-bite perfection

---

#### Food 1: Hot Dogs — Ring/Dial Alignment
*Reference: Dead by Daylight skill checks, Flee the Facility (Roblox)*

- Outer ring = static success arc. Inner needle rotates clockwise.
- Click/tap when the needle is inside the arc. Alignment % = bite effectiveness.
- A "Great" zone (narrow sliver at center of arc) gives 120% effectiveness — bonus bites.
- **Audio cue fires 400ms before the ring appears** — players hear it, then see it. Critical for mobile.
- Base needle speed: **240°/sec** (one full rotation in 1.5s). DBD uses 320°/sec; ours is more forgiving to start.
- Base success arc: ~54° (~15% of circle). With max Focus: ~90° (25%). With no Focus: ~28° (8%).
- Needle always starts at 12 o'clock; success arc position is randomized (not too close to start).
- Captures the Solomon Method rhythm — repeated, timed bites at pace.

#### Food 2: Burgers — Sequential Two-Ring
*Reference: Three-click golf swing (Hot Shots Golf, EA Sports PGA Tour — 40-year proven mechanic)*

- Two rings appear in sequence. Click ring 1, then click ring 2.
- Ring 1: full-size, slower needle (easier — "commit to the bite").
- Ring 2: smaller, faster needle (harder — "the crunch").
- 300ms "checkpoint flash" between rings — brief success animation before ring 2 appears.
- If ring 1 is missed: ring 2 never appears, bite fails entirely.
- If ring 2 is missed after good ring 1: partial credit (started the bite, didn't finish cleanly).
- 150ms input lockout after ring 1 resolves before ring 2 activates — prevents tap bleedthrough on mobile.
- Captures the structural top/bottom bun nature of a burger bite.

#### Food 3: Ramen/Noodles — Hold-Bar Oscillation
*Reference: Roblox Fisch (2024, millions of players), Stardew Valley fishing, Jetpack Joyride*

- A horizontal bar with a "noodle bundle" icon that oscillates left/right.
- Hold button to push the catch-bar toward the noodle bundle; release to let it fall back.
- Bar has momentum physics — hold builds upward acceleration, release causes drift. Not instant stop/start.
- Keeping the bundle inside the catch-bar builds a "slurp meter" — fill it completely = one successful bite worth of fill.
- This is a **sustained minigame** (3-5 seconds), not per-bite. One slurp = several bites' worth.
- Bar width scales with Focus stat (wider = easier to keep bundle inside).
- Bundle movement speed scales with Jaw Speed (faster jaw = slower bundle movement — more control).
- Perfect slurp bonus (+20% extra fill) if bundle never leaves the bar during the entire slurp.
- Starting bar width: 35% of bar length (generous). Captures the sustained, sustained physics of slurping noodles.
- **Do not make this start too hard** — Stardew's creator publicly regretted the difficulty floor of their fishing mechanic.

#### Food 4: Donuts — Shrinking Window
*Reference: WarioWare microgame design, mobile hyper-casual pattern*

- A ring with a target arc that closes in from both sides symmetrically.
- Click/tap before the arc shrinks to zero.
- Total window: 1.5–2 seconds from full arc to zero.
- Tap anywhere on screen (no positional requirement — only timing matters).
- Sound effect intensifies as the arc closes (rising pitch, ticking).
- Partial credit if clicked when arc is small but not zero.
- Shrink speed scales with Focus stat (more focus = slower shrink = more time).
- Starting arc size scales with Jaw Speed (bigger jaw = starts larger).
- Captures the compression of a donut — the eating act literally squishes it before swallowing.
- Linear shrink speed only — no sudden snap at the end, which feels unfair.

#### Food 5: Spray Cheese — Fill + Stop (Charge Meter)
*Reference: Super Mario RPG's Geno charge, archery draw mechanics*

- A vertical meter fills while button is held. Release before it hits the overflow line.
- Sweet spot: top 15–20% of the bar below the overflow line.
- Three visual stages as it fills: green (safe) → yellow (approaching) → red (overflow imminent, sputtering sound).
- Releasing in the sweet spot = full bite. Below sweet spot = partial. Above overflow line = spray goes everywhere (mess animation, no bite, brief penalty).
- 400–500ms overflow buffer — minor micro-shakes on mobile don't cause false failures.
- Fill speed scales with Jaw Speed (faster jaw = fills faster = harder to stop in time at high speed).
- Sweet spot width scales with Focus (more focus = wider safe zone).
- Overflow failure animation: character covered in cheese (comedy, not punishment-feeling).
- Directly simulates the real act of spray cheese — hold the nozzle for exactly the right duration.

#### Food 6: Chicken Wings — Rapid 3-Click Combo
*Reference: Jujutsu Shenanigans Black Flash, WarioWare multi-tap microgames*

- Three click zones appear in sequence. Hit all three within a 700ms window.
- Each successful click produces a distinct escalating crunch sound (0.9x → 1.0x → 1.1x pitch).
- Each click lights up a visual "bone segment" indicator so players can track progress.
- Completing all three: satisfying "bone slide out" animation.
- Full tap target = lower half of screen (no positional precision required on mobile).
- Time window for all three clicks: 600–800ms total. Missing one breaks the chain; partial credit for 2/3.
- The 3-click window scales with Jaw Speed (higher speed = slightly longer window = more control per gnaw).
- Captures the real wing technique: scrape-scrape-pull, three distinct motions in rapid succession.

#### Food 7: Butter — Dual Moving Targets
*Reference: Most complex variant — designed as the hardest standard food*

- Both the needle AND the success arc move simultaneously at different speeds.
- Needle: fixed clockwise rotation at moderate speed.
- Arc: oscillates between two positions on a sine wave (predictable but requires pattern reading).
- Needle moves faster than arc — moments of convergence require timing.
- Click when needle is inside the arc during a convergence window.
- Arc oscillation uses a smooth sine wave (learnable pattern), not random (would be unreadable).
- Low Focus = wider arc oscillation amplitude (harder to predict). High Focus = narrower oscillation (more stable).
- Designed for veteran players: the most skill-expressive mechanic in the set.
- Success sound is extra distinct and satisfying — reward for the hardest mechanic.
- Captures the uncontrollable slipperiness of butter — even when you read the pattern, execution is demanding.

#### Food 8: Brain Tacos — Two Sequential Rings (Exotic)
*Reference: Burger mechanic (Mechanic 2), but both rings are hard — Tier 4 food*

- Two sequential rings, both smaller and faster than standard rings.
- Neither ring has an "easy" version — both require precision.
- 400ms checkpoint animation between rings.
- Ring 1 miss = bite fails. Ring 2 miss = partial credit (ring 1 was harder to hit, so partial is fair).
- This is the exotic tier mechanic — players encounter it at Tier 4 (World Championship level).
- By this point, players have high Focus and Jaw Speed stats, which compensate for the double difficulty.

#### Food 9: Gallon of Mayo — Slow + Unpredictable Zone Jump (Comedy Food)
*Reference: Intentional chaos design — the comedy relief food*

- Needle rotates slowly (easy to track). Players relax. Then — the success arc randomly teleports to a new position.
- **200ms audio cue (a "squelch" sound) fires before each zone jump** — fair warning, requires fast reaction.
- After each jump, zone stays in the new position for 600–800ms — hittable if you react to the squelch.
- Designed success rate: ~60–70% per bite even for skilled players — mayo is inherently messy and inefficient.
- Failure animation: character face covered in mayo (the comedic payoff).
- Mayo is never a top-tier competition food — it exists to make players laugh, not to optimize.
- Do not use mayo in ranked PvP modes. Comedy food = friendly/casual contests only.

#### Bonus: Rhythm Variant (One Seasonal/Special Food)
*Reference: Eat Beat: Dead Spike-san (rated 4.7/5 iOS), an actual rhythm game about eating*

- The arena plays a background track with a clear tempo.
- Bite indicators scroll toward the player (Guitar Hero-style, single lane, one button).
- Hit each indicator on the beat for a perfect bite; early/late = partial; miss = nothing.
- Consider for: a special seasonal food (e.g., "Holiday Ham" at a Christmas event) or The Showman's signature food.
- This mechanic is untested in Roblox eating games and would be novel.

---

### Audio/Visual Feedback (Every Bite)

**Per bite:**
- Unique sound per food type (crunch = chips, slurp = ramen, splat = mayo, THWACK = burger)
- Brief scale-up of character head/cheeks
- Food particle burst
- Floating number (+1 Dog! +2! PERFECT!)

**Fill meter danger zone:**
- Red pulsing screen edges
- Belly visually protrudes further
- Sweat particle effects
- Music tempo accelerates

**Chipmunk state:**
- Face comically distorted — 3x normal cheek size
- Wobbly walk animation
- Countdown timer visible on cheeks

**Reversal of Fortune:**
- Character turns green, eyes spiral
- Green puff cloud (no visible vomit — cartoon only)
- "BLORP" sound effect
- Character shrinks/deflates
- Crowd: "OHHHH" audio
- Brief slow-motion moment before it hits

**Win:**
- Belt descends from sky
- Confetti explosion
- Customizable victory dance
- Crowd roars

---

### Power Foods (Kirby Copy Ability Applied)

Rare foods that trigger temporary effects when eaten mid-contest:

| Food | Effect | Duration |
|---|---|---|
| Dragon Pepper | Jaw speed x3, fire breath visual | 5 seconds |
| Lava Ramen | Stomach capacity +50% | 10 seconds |
| Steel Gyoza | Invincible to Reversal | 15 seconds |
| Ice Cream Mountain | Brain Freeze — slows you, cools fill meter | 8 seconds |
| The Golden Hot Dog | +50% Style Bucks bonus after contest | Post-contest |
| The Mystery Bag | Random effect (anything) | Varies |

---

### Spectator System (Unique Feature)

Spectators stand behind a transparent barrier in the arena. Two actions available:

**Throw Food** (15-second cooldown per spectator):
- Target reticle → tap an eater → food item launches in an arc
- 70%: Visual flavor, crowd laugh sound, no mechanical effect
- 15%: Spills their water cup → 0.5s ring pause (distraction)
- 15%: Bonus bite lands on plate → +5% fill for that eater (spectator earns "+5 assist" badge)
- Mostly visual flavor — cannot be used to grief or win a contest for someone

**Wave Signs** (button hold, 3 seconds):
- Adds +1 to chosen eater's Crowd Meter
- Max 10 Crowd Meter points per spectator per contest
- Purely positive — never hurts anyone. Safe for friends watching each other.

**Crowd Meter** (each player's own bar, horizontal at top of screen, gray → gold):

| Threshold | Color | Effect |
|---|---|---|
| 25% | Blue — "Getting Warm" | Crowd cheers ambient. +2% fill speed. |
| 50% | Orange — "On Fire" | Crowd doubles. "CROWD CHANT" pop. NPCs stutter briefly (flavor). |
| 75% | Red — "The Crowd Goes Wild" | Spectator trophy prop lands → +10% fill for next 5 bites. |
| 100% | Gold — "LEGENDARY" | **Signature Move** — special eating animation, +25% instant fill, wider zones for 10s, drains to 0. |

Fills on: perfect skill check (+8%), good hit (+3%), chipmunk success (+15%), Solomon double-perfect (+20%).
Drains on: missed skill check (-10%), heat overflow (-15%), reversal (-25%).

---

### NPC Opponents

**Visualization during contest:**
- Right-rail UI: 4 fill meters stacked vertically (yours is gold-bordered, sorted by current fill %)
- Updates every 0.5 seconds via server replication
- No NPC skill-check rings shown — visual focus stays on the player's own ring
- 3D NPC characters animate eating at their seats: normal at 0–30% fill, speeding up at 70–90%, frantic at 95%+
- When any NPC hits 80% fill, a small "almost done!" icon flashes next to their bar

**Difficulty calibration (selected at contest start, fixed for that contest's duration — no rubber-banding):**

| Profile | Fill Rate | When Used | Player Win Rate |
|---|---|---|---|
| Rookie | 60% of tier max | Under 10 wins | ~60% |
| Veteran | 85% of tier max | 10+ wins, mid upgrades | ~50% |
| Elite | 100% of tier max | Maxed upgrades | ~30% |

The Bear is the only adaptive difficulty in the game (always 120% of player's personal best). Clearly labeled.

**NPC behavior variance:** ±20% randomness in fill rate per contest. Occasional "pause" animations mimic human rhythm. NPCs never have perfectly constant eating speed — bots are detectable; good NPCs aren't.

**Backfill:** NPC fills any empty seat at T-10s of queue window. Named AI Challengers ("Chomping Charlie," "Big Belly Beatrice") with distinct visuals and region tags. Labeled "AI Challenger" openly.

---

### Upgrade Shop

**Primary access:** A physical kiosk counter in the hub, always visible from all arenas. Walk up, press E / tap. 4 large buttons (one per stat), each showing current level, next level effect, cost. Single tap to upgrade if coins are available. Never more than 2 taps to purchase.

**Secondary access:** During the 15-second queue window, a "SHOP" button appears in the upper corner. Opens the same shop as a modal overlay without leaving the queue. Upgrades while waiting = no dead time.

**Stat display in shop:**
- **Stomach Capacity** — "How much you can eat before overflow"
- **Jaw Speed** — "Ring needle rotates slower. More time to react."
- **Swallow Rate** — "Food items complete faster after a perfect hit."
- **Focus** — "Green zone on every ring is wider."

---

### Coin Economy

**Earn rates (per contest):**
- 1st place: 60 coins | 2nd: 40 | 3rd: 25 | 4th/last: 15
- Any finish (participation): +10 coins regardless of place
- First Win of the Day: +100 coins
- Win streak bonus: +10% per consecutive win, up to +50%
- Prestige multipliers: +5% per prestige tier (P5 players earn 25% more coins)

**First upgrade target: under 5 minutes.** A new player losing every contest earns ~25 coins/contest. In 5 minutes (~2.5 contests at 90s each), they have ~62 coins. First upgrade costs 50 coins.

**Upgrade cost curve (per stat, quadratic: 50 × level²):**

| Level | Cost |
|---|---|
| 1 | 50 coins |
| 2 | 200 coins |
| 3 | 450 coins |
| 5 | 1,250 coins |
| 10 | 5,000 coins |
| 50 (max) | 125,000 coins |

**No passive coin generation.** Coins only come from contest performance. This keeps coin value stable and prevents AFK inflation.

---

### Onboarding (First 2 Minutes)

| Time | What Happens |
|---|---|
| 0–10s | Spawn in hub. George Shea NPC directly ahead, "FREE CONTEST" sign + blinking arrow. One line: "HEY! First contest is on me. Step up!" Transparent barrier blocks other paths. |
| 10–25s | Enter Arena 1 (all-NPC, no wait). Shea panel: "Today's food: HOT DOGS. Hit the ring when it's green. GO!" Ring appears immediately. Pulsing "HIT HERE" label on green zone for first 3 bites, then disappears. |
| 25–100s | First contest. NPCs at 50% difficulty. Green zone is 40% wider than normal (invisible assist — player doesn't know it's easier). Player wins or finishes 2nd. |
| 100–110s | Result screen. "YOU WON! 60 coins." Pop-up: "UPGRADE YOUR JAW SPEED? [50 coins] → [YES] [NOT NOW]." YES is highlighted. |
| 110–120s | Tap YES → upgrade fires → Shea says "You're getting stronger!" Barrier dissolves. Player is free. |

Total: under 2 minutes from spawn to first upgrade. No paragraph of tutorial text. No forced reading. Action teaches the mechanic.

---

### George Shea Announcer

**Format:** Text only (no voice acting). Typewriter style at 30 chars/sec. Yellow newspaper-headline panel. Max 2 lines per appearance. 8-second auto-skip. Always skippable immediately by tapping anywhere.

**Delivery points:** Pre-contest player/NPC intro + post-result one-liner + Bear challenge intro.

**Content:** 30+ line rotating pool. New lines addable via ModuleScript update — no game update required. Repeat players rarely see the same line twice in a week.

Example lines:
- *"LADIES AND GENTLEMEN — the stomach of a HIPPOPOTAMUS in the body of a ROBLOX CHARACTER!"*
- *"She trained by consuming eleven pounds of watermelon daily. THE CROWD APPROVES."*
- *"He has broken reality, and all of time pours down around us now at once, simultaneous and endless."*

---

### Audio Per Tier

Consistent across all tiers: chipmunk success = cartoon "BWOMPH", reversal = sad trombone, perfect skill check = bright ding. Muscle memory sounds — never change per tier.

| Tier | Genre | BPM | Ambient | Crowd Clips |
|---|---|---|---|---|
| 1 — Local Diner | Lo-fi diner jazz / honky-tonk | 90–100 | Kitchen sizzle, clinking silverware, small murmur | 15 clips, quiet |
| 2 — Regional Fairground | Americana / banjo-forward indie pop | 110–120 | Carnival barker, ferris wheel, corn dog sizzle | 40 clips |
| 3 — National Stadium | Stadium rock, drums prominent | 128–135 | PA system static, sneaker squeak, crowd buzz | 80 clips, coordinated chant |
| 4 — World Championship | EDM/orchestral hybrid, TV broadcast feel | 140+ BPM during contest | Ocean breeze, fireworks, massive roar, air horns | 150+ clips, full stadium |

Crossfade on arena entry: 1–2 second smooth blend. Each tier's audio is immediately, subconsciously recognizable.

---

### Long-Term Engagement

**Daily:**
- Daily challenge (eat X units of Y food) → escalating reward calendar with streak bonuses
- Friends leaderboard (strongest engagement driver)

**Weekly:**
- Rotating contest format
- Challenge cup — limited-time NPC for exclusive cosmetic

**Seasonal events:**
- Summer Hot Dog Bowl (July 4th — the Nathan's analog)
- Halloween Brain Taco Championship
- Winter Butter Eating Spectacular
- Spring Peeps Madness

**Pets (Roblox meta — cosmetic only):**
- Stomach-themed pet companions that follow your character. Zero stat effect — pure personality and flex.
- Themed eggs: Hot Dog Egg, Burger Egg, Ramen Egg — rarity tiers. All eggs earnable through gameplay (contest wins, daily quests, achievements). No egg is exclusive to Robux purchase.
- Merge system for stronger visual variants (not stronger stats)
- Examples: Stomach Gremlin (wobbles when you eat), Jaw Bug (chews alongside you), Lucky Noodle (does a dance when you win)
- Rare pets unlocked by breaking in-game records — not by spending. The rarest pets are rewards for the hardest in-game achievements.

**Achievement system — "Break 55 Records":**
- Chestnut holds 55+ world records. Players chase in-game records across all food types and formats.
- Each record broken = trophy, title, and coin bonus.

---

### Monetization (Post 15-min Gate, Age-Safe, Strictly Non-P2W)

#### Core Principle: Money Buys Looks. Skill Buys Power.

Every stat upgrade, every technique unlock, every progression tier, The Mustard Belt, and beating The Bear are achievable by every free player. Real money never touches the stat economy — not directly, not through multipliers, not through consumables.

#### Dual Currency System

**Coins** (earn only through gameplay — never purchasable with Robux):
- Earned by: winning contests, daily challenges, breaking records, login streaks
- Spent on: all four stat upgrade trees (Stomach Capacity, Jaw Speed, Swallow Rate, Focus)
- Coin earn rate is identical for free and premium players. No multipliers for sale.

**Style Bucks** (cosmetic currency — earn slowly through gameplay OR buy with Robux):
- Earned by: bonus rewards, seasonal events, achievements, daily quest streaks
- Spent on: all cosmetics — outfits, face paints, belt colors, cheek styles, victory poses, bite sound packs, pet eggs
- Buying Style Bucks with Robux never translates to stat advantage of any kind

#### What Free Players Get
- Full contest access at every tier (Local → Regional → National → World Championship)
- Full stat upgrade shop — every upgrade purchasable with gameplay Coins
- Pets earnable through contest wins and achievements
- Every NPC opponent (including The Tsunami, The Jaws, and The Bear) as a challenge
- The Mustard Belt
- Every in-game record title
- Basic character appearance and standard victory animations

#### Game Passes (permanent Robux — cosmetic and social perks only)

- **VIP Champion** — Cosmetic prestige pack: animated golden belt aura, exclusive VIP contest outfit, VIP name badge, access to VIP lobby waiting area (social space, no stat advantage). Zero effect on Coins or stat progression.
- **Champion's Kit** — Exclusive character skins (Giant Mouth, Glow-Belly), 5 premium victory poses, the "Fan Favourite" title
- **Showman's Pass** — "The Professor" NPC coach follows your character and delivers absurd real-time commentary during contests ("Your jaw speed is statistically consistent with a mid-level alligator"). Purely cosmetic and comedic. No stat coaching effect.

#### Developer Products (consumable Robux — Style Bucks only, never stats)

- **Style Buck Bundle (Small)** — immediate Style Bucks deposit
- **Style Buck Bundle (Large)** — immediate Style Bucks deposit at better rate
- No consumable product ever modifies Jaw Speed, Stomach Capacity, Swallow Rate, Focus, Coins, or any contest outcome.

#### Cosmetics (pure flex, zero stat effect)
- Contest outfits (Hawaiian shirts, American flag gear, lab coat, foam hot dog hat)
- Face paints (Eater X style — elaborate designs)
- Mustard Belt colors (gold → diamond → holographic → animated)
- Custom chipmunk cheek styles (hamster, puffer fish, balloon)
- Victory poses (backflip, flex, dramatic collapse, The Shake)
- Bite sound packs (cartoon, realistic, ASMR, opera singer)

#### Design Rules to Enforce in Code
1. Stat upgrade functions accept only Coins. No Robux path to the stat API.
2. Contest result calculation reads only server-side stats. No client-sent buffs.
3. No leaderboard category that reflects spending (no "VIP-only" rankings).
4. Seasonal cosmetics are available through gameplay challenges, not exclusively through purchase.
5. The rarest pets are achievement-locked (e.g., "Beat The Bear") — not Robux-locked.
6. Never sell auto-tap or any speed boost for Robux — ever. Mine Racer tried this; it destroys competitive integrity.
7. Server-side idle detection required. AFK scripts are the #1 exploit for tapping games.

---

### Art Direction

> **Kirby's cute body language + SpongeBob's cartoon gross + WarioWare's speed + Nathan's real drama**

- Characters: rounded, expressive, Roblox-native proportions with exaggerated stomachs/cheeks/jaws
- Food: large, cartoonishly rendered, exaggerated scale (hot dog as tall as character's torso)
- Arena: real competitive eating venue aesthetic — long tables, crowd in stands, big screen scoreboard, summer fair lighting
- UI: large, readable, arcade-energy — fill meters that feel physical, not clinical
- Color palette: warm, saturated, food-commercial. Yellows, reds, oranges dominate.
- Content rating target: Mild/Moderate (maximum reach for 9–15 demographic). No gore, no realistic vomit. Cartoon gross only.

---

### What Makes This Different from Existing Roblox Games

1. **Real sport foundation** — every mechanic traces to a real competitive eating technique
2. **George Shea announcer NPC** — unique absurdist comedic voice no other Roblox game has
3. **Reversal of Fortune mechanic** — fill-meter-of-doom with cartoon consequence; unique tension not in Eating Simulator
4. **Spectator as active participant** — turns viewers into players
5. **Named NPC rivals with personalities** — not stat-scaled dummies; characters with stories and trash talk
6. **The Bear as mythological ceiling** — gives the game an impossible final boss
7. **Uncontested niche** — no well-executed competitive eating game exists at scale on Roblox. Blob Eating Simulator (23M visits, now dead) used direct PvP eating (wrong model). The space is open.

---

## 3. Absurdist Content That Works for All Ages

### Comedy Sources (What Makes It Funny)
1. The announcer's over-the-top absurdist poetry for every player and NPC
2. The gap between a tiny character and their enormous eating capacity
3. The moment before Reversal of Fortune — desperate wobble, green tinge, crowd horror
4. The sheer quantity of food on screen at peak chaos
5. NPC pre-contest rituals and trash talk
6. Unexpected outcomes (Grandma wins, The Bear loses to a new player, Rookie clutches in overtime)

### Cartoon Gross vs. Realistic Gross
**Do:** Wobbly swollen belly, chipmunk cheeks at 3x normal size, comical sweat drops, burp that sends a napkin flying, bite so big character briefly doubles in size, green face + spiral eyes, the dramatic "BLORP"

**Don't:** Realistic stomach expansion, sound effects suggesting actual vomiting, blood, references to real health consequences, realistic food decay

---

## 4. Key Numbers (From Real Records — Use as Design Targets)

| Record | Holder | In-Game Application |
|---|---|---|
| 76 hot dogs in 10 minutes | Joey Chestnut | "The number to beat" — max stat player approaches this |
| 4x stomach capacity | Kobayashi (trained) | Stat ceiling — starts at 1x, max upgrade = 4x |
| 255 Peeps in 5 minutes | Matt Stonie | Tier 2 record to break |
| 182 bacon strips in 5 minutes | Matt Stonie | Tier 2 speed contest target |
| 57 cow brains in 15 minutes | Kobayashi | Tier 4 exotic food record |
| 350 donut holes in 8 minutes | James Webb | Donut contest world record |
| 35,000 crowd at Nathan's | Real attendance | Spectator count affects in-game crowd bonus |
| 55+ world records | Joey Chestnut | Achievement target: "Break 55 Records" |

---

*Research sources: Major League Eating official records, Nathan's Famous contest history, ESPN/NPR/NBC reporting on Chestnut/Kobayashi, competitive eating training documentation, Roblox developer retention research, Naavik Roblox market analysis, Overcooked/Pizza Tower/WarioWare/Kirby design analysis, Food Wars and Toriko wikis, MLE competition rankings.*

---

## 5. Competitive Landscape & Technical Lessons (Roblox Research)

### Market Position
- **No direct competitor at scale.** Closest: Blob Eating Simulator (23M visits, now 0 active players — died from wrong PvP model + no NPC backfill), Competitive Eating Simulator (negligible visits, PvE boss format). The parallel-PvP eating contest format is unexecuted.
- **Closest structural analog:** Mine Racer — timed session, click input, parallel competition, upgrade-gated speed, 4M+ visits. Its critical mistake: sold auto-tap as Robux (killed competitive integrity). Avoid this entirely.

### PvP Design Principles (from research)
- **Pure parallel racing — no sabotage.** Research across obby races, Mine Racer, and Bee Swarm Simulator confirms: mixing parallel competition with player-sabotage mechanics creates "unfair loss" feelings that kill games. Players can't tell if they lost to skill or to a power-up. Keep PvP as identical simultaneous challenges — same food, same timer, most units wins.
- **Prestige-bracket matchmaking is mandatory.** Pet Simulator 99 was destroyed by stat whales dominating new players. Human PvP sessions must match by prestige tier. Never pit Prestige 0 against Prestige 5.
- **Live leaderboard updates every 0.5 seconds** during a contest. This is the entire competitive layer — seeing an opponent close the gap is what makes parallel racing tense. Bee Swarm Simulator's 4.4 billion visits proves players don't need to fight each other to feel competitive.

### NPC Opponents
- **Ship named AI Challengers at launch, labeled openly.** Blob Eating Simulator's death came from empty servers. NPC names ("Chomping Charlie," "Big Belly Beatrice") with distinct visuals and region tags make the empty-lobby feel like a real tournament.
- **±20% behavioral variance per contest.** NPCs that eat at exactly-constant speed are immediately recognizable as bots, deflating competitive tension. Add variance + occasional "pause" behavior mimicking human rhythm.
- **Soft rubber-band for leading players only.** If a player is winning comfortably, NPCs push slightly harder within reason. Never make NPCs unbeatable when a player is winning — that punishes good play.

### Tap/Click Mechanic Design
- **Rhythm over raw speed.** A satisfying chew rhythm (with a natural CPS ceiling) is better than a pure speed contest. This also solves the fatigue problem that led Mine Racer to sell auto-tap.
- **Every tap needs: audio, visual, number popup.** 60fps responsiveness is non-negotiable. Input lag kills the feel entirely.
- **Mobile tap target: anywhere on screen**, minimum 90px touch target. Fixed-position tap requires pixel-perfect aim on mobile — unacceptable for Roblox's audience.
- **Meter must visually react to speed** — not just fill linearly. At high tap rate, the meter should feel like it's straining forward.

### Fill Meter Overflow — Three-Phase Design
The "fail by doing too much" mechanic is novel on Roblox. No game has done it at scale. Design the zones precisely:

| Zone | Fill % | Visual | Audio | Character |
|---|---|---|---|---|
| Safe | 0–75% | Normal green | Normal chew sounds | Smiling |
| Caution | 75–90% | Yellow pulse | Strained chewing, labored breath | Sweating |
| Danger | 90–99% | Red flash + screen edge pulse | Heartbeat, urgent music | Eyes wide, wobbling |
| Overflow | 100%+ | Cartoon explosion | "BLORP" | Green spiral, deflate |

- The danger zone (90–99%) is the primary skill expression window. Veterans who can eat at max speed in this zone without tipping will win contests.
- DQ animation must complete in **under 8 seconds**. Longer = players leave instead of staying to spectate.

### Post-DQ Spectator Loop
DQ'd players (overflow victims) become crowd participants immediately:
- "Cheer for a player" button → triggers brief visual crowd boost on chosen player (+crowd meter, minor animation)
- Small coin reward for watching the round to completion (not leaving)
- Converts the "frustrating failure" state into a participation state — reduces quit rate

### Leaderboard Categories (Multiple Winners)
From Mining Simulator's 92.8% rating at 830M visits — multiple leaderboard categories let different player types feel successful:
- **This Contest** — live, per-session, most food eaten
- **Weekly Champion** — most contests won this week
- **All-Time Record** — biggest single-session performance ever
- **Prestige Rank** — most rebirths
- **Win Streak** — longest unbroken streak
- **Friends** — always show friends leaderboard prominently; friend comparison is the strongest retention driver

### Anti-Cheat (Non-Negotiable)
Tapping games are the #1 target for auto-clickers on Roblox. Must ship at launch:
- Server-side click validation with debounce mutex — never trust client click rate
- Behavioral pattern analysis: real humans have ±30–50ms timing variance; perfect-interval clicks = bot signature
- Soft CPS cap server-side regardless of client fire rate
- Ping-aware tolerance window to avoid false positives on high-latency players
- AFK idle detection — warning before kick, server-side only

### What Never To Do (Confirmed by Research)
- Never sell auto-tap or speed boost for Robux (Mine Racer mistake — destroys competitive integrity)
- Never add player-sabotage power-ups (confirmed by parallel race game research)
- Never match players across prestige tiers in ranked PvP (Pet Sim 99 mistake)
- Never let servers go empty without NPC backfill (Blob Eating Simulator cause of death)
- Never make DQ animation longer than 8 seconds
- Never use purely passive eating mechanics (Junk Food Simulator's 61% rating confirms: equip gear → watch stat go up → players leave)
