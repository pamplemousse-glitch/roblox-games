# Frank's Fairground — Mega Plan

Single source of truth for what ships when, where we currently are, and what comes after v1.0.

Last updated: 2026-06-01

---

## Where we are right now (one-line)

**v1.0 is technically functional and visually playable.** Contest loop works end-to-end (queue → countdown → eat with visible food piles & NPC rigs → results with DQ shown → coins). Foreign-content cleanup, audit fixes, and visual polish are committed (8aac0f8). The blocking items left are Antoine-action launch chores: gamepass IDs, dev product IDs, friend playtest, thumbnail capture, click Public.

---

## Status board

### Done (functional + shipped on main)
- [x] Core contest loop: queue → countdown → active → results → idle
- [x] Skill-check ring with GREAT/HIT/MISS feedback + Foodgasm burst
- [x] Stat upgrade shop (4 stats × 50 levels) — coins only, no Robux
- [x] 8 NPCs with personality (catchphrase, tell, win/lose lines, familiar/rival memory)
- [x] DataStore persistence with BindToClose flush
- [x] Belle-Époque carnival visual rebuild (carousel, pirate ship, swing, coaster, train)
- [x] Map IS Food overlay (bun ground, mustard ocean, cotton candy clouds, broccoli, lollipops)
- [x] 4 hero ride re-themes (Donut Carousel, S.S. Frank, Pizza Wheel, Spaghetti Slammer)
- [x] 5 hero building re-themes (Watermelon, Gingerbread, Wedding Cake, Burger, Haunted)
- [x] Currency unification (Coins + Style Bucks, dropped Carnival Tickets)
- [x] Monetization scaffold (gamepass checks, ProcessReceipt) — IDs pending
- [x] 6 v2 features merged: Photo Mode, Glory Reel, Friend Vault, NPC Memory, Cookbook, Tournament Arc
- [x] Foreign-content audit + cleanup (rogue React framework deleted)
- [x] Critical audit fixes (ContestPhaseChanged args, prompt replication race, OpenShop listeners, BindToClose, schema sync)
- [x] **Visible food piles + NPC rigs at chairs + bite-bob animation** (the big polish pass — 6d94906)
- [x] Pity Pit consolation (last place gets +15 coins)
- [x] Anti-cheat (rolling bite-rate cap, 80ms minimum interval)
- [x] Mobile UX (1.45× ring scale on touch, haptic motor pulse)
- [x] Sound effects (centralized SFX manager)
- [x] Genre-per-map decision locked in master plan
- [x] Per-food specialized mechanics catalog drafted

### Currently broken or deferred to v1.1
- [ ] **Mini-games at carnival booths** — 5 UI submodules (RingTossUI, HighStrikerUI, DuckPondUI, BalloonDartUI, SkeeBallUI) were untracked WIP and lost in tonight's cleanup. Need rewrite. ~6-10 hrs.
- [ ] **Red dot at top center** — not from our code, not standard CoreGui. Likely Studio Play-mode-only indicator. Won't appear in published game.
- [ ] **Tournament arc UI** — server-side progress works; client shows only a stage-completion toast. Full journal UI is v1.1.
- [ ] **Friend Vault visibility level gating** — currently shows from minute 1; should hide until level 10 or first contest done.

### Blocking v1.0 launch (Antoine action)
- [ ] Save the .rbxl in Studio (Cmd+S) to persist tonight's visual rebuilds + cleanup
- [ ] Create 3 gamepasses on creator.roblox.com (VIP 299R$, Champion 599R$, Showman 199R$)
- [ ] Create 4 dev products (Style Bucks: 99/299/999/2499 R$)
- [ ] Paste 7 IDs into `src/Server/Services/MonetizationService.luau` (search `TODO`)
- [ ] Run 3-friend playtest, capture any errors
- [ ] Capture hero thumbnail (1280×720) in Studio + upload to Game Settings
- [ ] Write store listing copy (title + tagline + description)
- [ ] Enable Studio Access to APIs (Game Settings → Security) so DataStore actually persists
- [ ] Click Public on creator dashboard

**Total Antoine-action time: ~45-60 minutes of clicking.**

---

## The grinding loop architecture

### Five concentric loops

| Loop | Cadence | Reward | Time cost |
|---|---|---|---|
| Contest | 60-90s | Coins + bites + cookbook + XP | Real-time |
| Stat grind | 5-20 min | Stat level up | Coins |
| Daily | 24h | Login streak + quest + vault | 10 min |
| Weekly | 7d | Format rotation + leaderboard | Top-10 effort |
| Monthly | 30d | Boss raid + seasonal event | Show up |

### Daily 10-minute return loop
```
1. Login          → escalating streak bonus
2. Daily quest    → "Eat 5 different foods today" → reward
3. Friend Vault   → check + grab deposits (decays 1%/day uncollected)
4. Contest        → 1-3 runs for coins
5. Upgrade        → spend coins on one stat level
6. Cookbook       → eat one new food → +1% bonus per completed tier
```

### Weekly format rotation
| Week | Mode | Hook |
|---|---|---|
| 1 | Speed Eat | 30s contests, bites only |
| 2 | Iron Stomach | No swallow recovery, capacity dictates everything |
| 3 | Spicy Sunday | All foods +50% heat, spice tolerance matters |
| 4 | Combo Frenzy | Chain bonus across contests, decays if you stop |

### Monthly anchor — Soufflé Princess raid
- Server-wide boss, week 1 of each month
- Requires 100+ players globally to defeat
- 60 min per attempt, 3 attempts per player
- Reward: permanent server-wide title + cosmetic for anyone who landed 1+ bite

### Retention hooks
1. **Streak shield** — daily login = win streak doesn't break
2. **Vault decay** — Friend Vault loses 1%/day uncollected → check-in pressure
3. **Cookbook FOMO** — weekly-rotation foods only appear that week
4. **Tournament invisible progression** — progress just by playing
5. **Cosmetic scarcity** — past-week leaderboard cosmetics never return

---

## Eating attribute system (stats)

### Current (v1.0 — 4 stats)
| Stat | Effect per level | Cap |
|---|---|---|
| Stomach Capacity | +1% fill headroom | 50 |
| Jaw Speed | -0.8% needle speed | 50 |
| Swallow Rate | +1.5% drain rate | 50 |
| Focus | +0.9% wider arc | 50 |

### v1.1+ — 10 additional stats reserved in schema
| Stat | Effect | Pairs with |
|---|---|---|
| Spice Tolerance | Reduce heat-DQ chance | Chili Dog, World's Hottest Wings |
| Dexterity | Tighter swipe/drag windows | Ramen chopsticks, Bloomin' Onion |
| Bite Strength | Hard foods break faster | Pretzel, Cheese Curds |
| Endurance | Late-contest stats don't degrade | Long contests, tournament |
| Composure | Reduce "choke" event chance | Finals, raids |
| Mouth Volume | Bigger bites = more fill per tap | Synergy with Capacity |
| Crowd Charisma | Bonus coins from crowd hype | Style-mode contests |
| Hydration | Drink challenges, spice recovery | Drink District, Boba |
| Specialty Mastery | +X% per food eaten 100+ times | Cookbook synergy |
| Sugar Resistance | Sweet foods drain meter slower | Donut, Funnel Cake |

**Design rule:** at any progression point, only 5-7 stats are useful for the genres unlocked. Forces meaningful build choices (Italian-focus vs Japanese-focus).

---

## Districts (genre per map)

| District | Genre | Unlock | Build cost | Ship target |
|---|---|---|---|---|
| Frank's Fairground | American Carnival | Starting | 0 (exists) | v1.0 |
| Pizza Plaza | Italian-American | 50 wins | 16-24 hrs | Week 4 |
| Burger Boulevard | Burger Variants | 150 wins | 16-24 hrs | Week 6 |
| Donut Dynasty | Sweets / Pastries | 250 wins | 24-32 hrs | Week 8 |
| Tokyo Town | Japanese Street | 400 wins | 24-32 hrs | Month 3 |
| BBQ Holler | American BBQ | 600 wins | 16-24 hrs | Month 4 |
| Mercado del Sol | Mexican Street | 750 wins | 16-24 hrs | Month 5 |
| Curry Lane | South Asian | 900 wins | 16-24 hrs | Month 5 |
| Patisserie Quarter | French | 1100 wins | 12-16 hrs | Month 6 |
| Dessert Town | Frozen / Cake | 1300 wins | 12-16 hrs | Month 6 |
| Drink District | Liquid | 1500 wins | 8-12 hrs | Month 7 |
| Underground Speakeasy | Bar snacks | Mystery door | 12-16 hrs | Month 8 |
| Frank's Future | Cyberpunk synthetic | 3000 wins | 16-24 hrs | Month 9 |

Each district has 4 tiers × 5 foods = ~20 dishes within its genre.

---

## Per-food specialized mechanics

### Rollout cadence
- **v1.0**: All foods use base ring. Per-food mechanics scaffolded.
- **v1.2**: 3 specialized mechanics ship (Pretzel rapid-multi-tap, Chili spice gauge, Footlong needle escalation).
- **v1.3+**: New mechanic every other content drop. Each becomes a TikTok clip moment.

### Catalog (sample)
| Food | Mechanic |
|---|---|
| Hot Dog | Base ring (canonical) |
| Pretzel Bites | Rapid multi-target tap (3 dots in 0.4s) |
| Chili Dog | Heat tolerance gauge alongside ring |
| Funnel Cake | Sugar haze obscures ring |
| Footlong | Needle speeds up per bite |
| Bloomin' Onion | Drag-to-peel layers, replaces ring |
| World's Hottest Wings | Cooldown gauge between bites |
| Ramen | Chopstick swipe direction |
| Sushi Roll | Memory rhythm replay |
| Donut | Glaze-dip rhythm |
| Boba | Catch bouncing pearls |
| Synthetic Burger | Glitching color-zone ring |

Full list in `docs/MASTER_PLAN.md`.

---

## Roadmap

### Week 0 (NOW) — Pre-launch
- Antoine action checklist (45-60 min)
- Smoke test contest end-to-end with friends
- Capture thumbnail, write store listing
- Toggle Public

### Week 1 post-launch — Stability + first response
- Watch for crashes / DataStore errors via dashboard
- Patch anything broken
- Wire monetization IDs if not done at launch
- Discord / TikTok seeding (3-5 clips of Foodgasm bursts + chipmunk window)

### Week 2 — First content drop
- Rebuild lost carnival booth mini-games (Ring Toss, Skee-Ball)
- Add Tournament arc full journal UI
- Friend Vault level-gate (only show after level 10)

### Week 3-4 — Pizza Plaza district
- New map, 5 Italian-American foods
- 1 specialized mechanic (Pizza cheese-pull threshold)
- New 4-NPC roster (Vinny, Tony, Carmela, Sal)
- Cross-district contests possible from week 4

### Month 2 — Stat expansion
- Add Spice Tolerance, Dexterity, Bite Strength stats (10 → 7 active)
- Cap on prior stats unchanged
- Spicy Sunday weekly format launches

### Month 3 — Tokyo Town district + first specialized mechanic launches
- 5 Japanese street foods
- Ramen chopstick-swipe mechanic ships
- 4 new Japanese-themed NPCs

### Month 4 — First monthly raid
- Soufflé Princess server-wide boss
- Endurance + Composure stats unlock for raid scoring
- BBQ Holler district releases

### Month 5+ — Cadence
- 1 new district every 4-6 weeks
- 1 new specialized mechanic every 6-8 weeks
- 1 weekly format rotation always active
- 1 monthly boss + 1 seasonal event each month

---

## Monetization (cosmetic-only, never stat-boosting)

### Gamepasses (one-time)
- **VIP** (299 R$) — +10% coin earnings, exclusive outfit, daily 200-coin bonus
- **Champion's Kit** (599 R$) — VIP + gold trim cosmetic + Champion title
- **Showman's Pass** (199 R$) — animated entry, particle trail at the table

### Dev Products (Style Bucks)
- Small (99 R$ → 100 SB)
- Medium (299 R$ → 350 SB)
- Large (999 R$ → 1500 SB)
- Mega (2499 R$ → 5000 SB)

Style Bucks spend on:
- Animated outfits
- Reaction emotes ("Mama, look!")
- Custom Foodgasm text variants
- Cosmetic-only stat-shaped accessories (giant mouth = visual only)

### 15-minute monetization gate
No purchase UI surface before 15 minutes of play. Per Roblox policy + retention research.

---

## The 5 non-negotiables (never violate)

1. Cosmetic-only Robux. **Never** stat-boosting Robux items.
2. Server-authoritative for all currency + stat changes
3. 15-minute monetization gate
4. Foodgasm burst stays exactly as-built (it's the TikTok hook)
5. NPCs always have catchphrase + tell + win/lose lines

---

## What I'd watch on the creator dashboard

- D1 retention (target: 25%+)
- D7 retention (target: 8%+)
- Average session length (target: 12+ min)
- Robux per DAU (target: 0.5+ within first month)
- Drop-off point in first session (look for first-contest abandonment)

---

## Where to look in code

| What | Where |
|---|---|
| Contest state machine | `src/Server/Services/ContestService.luau` |
| Visible food piles + NPCs | `src/Server/Services/ContestStaging.luau` |
| Stats math | `src/Common/Utils.luau` |
| All constants (foods, NPCs, prices) | `src/Common/Constants.luau` |
| Player data persistence | `src/Server/Services/DataManager.luau` |
| Monetization (paste IDs here) | `src/Server/Services/MonetizationService.luau` |
| Client controller wiring | `src/Client/Main.client.luau` |
| Hud + ring + results | `src/Client/Controllers/HudController.luau` |
| Per-controller controllers | `src/Client/Controllers/*` |
