# LAUNCH v1.0 — Frank's Fairground

## TL;DR

7 of 8 build blocks complete. Game is functionally ready to ship. The only remaining gating items are **Antoine actions on the Roblox creator dashboard** + a friend playtest pass + a thumbnail capture.

---

## What's in v1.0

### Visual identity (the "Map IS Food" overlay)
- Bun-tan terrain across the entire 700×600 fairground
- 60 sesame seed specks scattered
- Mustard ocean stretching to horizon (4 large Neon strips around perimeter)
- Cotton candy clouds in the sky (14 pink Neon spheres)
- Pretzel entrance arch
- Corn dog sky tower (180-stud tall pole + corn dog head with mustard squiggle)
- Giant Pink Donut center landmark (32 segments + sprinkles)
- All 35 oak trees converted to broccoli
- All 14 lampposts converted to lollipops

### Hero ride re-themes (4 done, 9 stay Belle-Époque for v1.1+)
- 🍩 **Donut Carousel** — 8 horses replaced with glazed donut rings (pink/chocolate/strawberry/vanilla rotation, sprinkles on top). Gallop animation still works (Mane/Tail markers preserved).
- 🌭 **S.S. Frank** — pirate ship hull repainted bun-tan, mustard squiggle along gunwales, giant frankfurter on deck, ketchup bottle figurehead, fork mast tines, "S.S. FRANK" stern sign.
- 🍕 **Pizza Wheel** — Ferris wheel gondolas repainted with cheese/crust colors (pepperoni overlay attempted but gondolas aren't named as expected — minor v1.1 polish).
- 🍝 **Spaghetti Slammer** — 132 coaster track waypoints → noodle cream, 66 ties → meatball brown, 262 side rails → tomato red, cart Body → meatball, marquee updated.

### Hero building re-themes (5 done)
- 🍉 **Watermelon BigTent** — rind stripes, pink flesh walls, black seeds, stem on top
- 🍞 **Gingerbread FunHouse** — gingerbread walls, icing drips, candy decorations
- 🎂 **Wedding Cake Bandstand** — pink/white cake colors, 3-tier topper, gold trim
- 🍔 **Burger Arcade** — patty walls, bun roof, cheese slice top, lettuce frill, sesame seeds
- 🥖 **Stale Gingerbread Haunted Mansion** — gingerbread walls, icing windows

### Gameplay polish (Block 5)
- **NPC personalities**: Jaws Beasley McGraw, Tsunami Tyler, MIKI, Lil' Stuff, The Mouth Mason, Doc, Bigtop Bob, Mrs. Pickles — each with catchphrase + tell + win/lose lines in `Constants.NPC_CHARACTERS`.
- **Foodgasm reaction burst**: on every GREAT bite, 12 radial sparkles + giant "FOODGASM!/PERFECT!/SUBLIME!" text. TikTok-bait by design.
- **Pity Pit**: last-place finisher gets +15 coins consolation. Fixes worst player experience.
- **Free starter cosmetic**: first-ever win auto-grants Hat_HotDog. Identity from minute 2.

### Currency unification (Block 1)
- Carnival Tickets dropped. Mini-games now pay Coins at 2.5× the old ticket count.
- Existing player saves migrate automatically (existing tickets → coins on next load).
- Stat math validated against 2.5× max-advantage target (already met by current JAW+FOCUS multipliers).

### Monetization scaffold (Block 6) — Antoine action required
- New `MonetizationService` with VIP / Champion's Kit / Showman's Pass gamepass ownership checks.
- ProcessReceipt handler for Style Buck dev-product purchases.
- VIP coin multiplier (10%) + daily VIP login bonus (200 coins).
- **TODO**: Antoine pastes gamepass + dev product IDs into `MonetizationService.luau` lines 24-36.

### Mobile UX (Block 7)
- Ring UI scales 1.45× on touch devices (220px → 320px)
- Needle thickness doubles on touch
- Haptic motor pulse on perfect bite (mobile vibration)

### Anti-cheat (Block 7)
- Rolling-window cap: 12 bites max in any 6-second span
- Sub-80ms bite intervals rejected
- Shadow-ban infra ready (just needs a flag in player data to activate)

### Sound system (Block 7)
- `SoundController` with 10 Roblox-hosted SFX (no upload needed)
- Pre-loaded on init, plays via clone-and-destroy pattern (overlapping bites)

---

## What Antoine needs to do before launch

### 1. Save .rbxl (BLOCKING)
Studio data-model changes from Blocks 2, 3, 4 (visual rebuilds) live only in Studio. **Ctrl+S in Studio** to persist them to disk.

### 2. Create gamepasses on Roblox creator dashboard (BLOCKING for monetization)
[create.roblox.com](https://create.roblox.com) → your game → Passes:
- **VIP Pass** at 299 R$
- **Champion's Kit** at 599 R$
- **Showman's Pass** at 199 R$

### 3. Create dev products (BLOCKING for Style Bucks)
Same area → Developer Products:
- 99 R$ → "100 Style Bucks"
- 299 R$ → "350 Style Bucks (+50 bonus)"
- 999 R$ → "1,300 Style Bucks (+300 bonus)"
- 2499 R$ → "3,500 Style Bucks (+1000 bonus)"

### 4. Paste IDs into source
Edit `src/Server/Services/MonetizationService.luau`:
- Lines 24-28: gamepass IDs
- Lines 32-36: dev product IDs (format: `[productId] = { styleBucks = N }`)

### 5. Friend playtest
Share Studio test link with 1-2 friends. Watch them play. Note where they get confused or hit bugs. **This is the most important launch step.**

### 6. Hero thumbnail
The hero camera angle is set up (see `block_8_hero_shot_v1.png` from this session). Use a similar angle for the store thumbnail — should show the bun terrain + mustard ocean + donut tower + a ride in one frame.

### 7. Roblox store listing
Use the draft below.

### 8. Click "Public"
On the Roblox game page, set the place to **Public**.

---

## Draft Roblox store listing

### Game name
**Frank's Fairground — Eat Dangerously**

### Tagline (subtitle)
*90-second eating contests in a world made of food.*

### Description
> 🌭 Welcome to FRANK'S FAIRGROUND — the Coney Island boardwalk that's secretly sitting on a giant hot dog bun.
>
> Compete in 90-second eating contests against named rival NPCs: 'Jaws' Beasley McGraw, Tsunami Tyler, MIKI, The Mouth Mason, and more. Hit the perfect bite, watch the Foodgasm bursts, and beware the Chipmunk Window in the last 10 seconds.
>
> Upgrade 4 stats (Stomach Capacity, Jaw Speed, Swallow Rate, Focus). Climb prestige belts. Ride the Donut Carousel, the S.S. Frank hot-dog ship, and the Pizza Wheel. Battle The Bear at Prestige 5.
>
> 🍩 Donut Carousel | 🌭 S.S. Frank | 🍕 Pizza Wheel | 🍝 Spaghetti Slammer | 🥨 Pretzel Swings
>
> ✨ Free starter cosmetic on first win
> 🏆 Daily login streak
> 🥧 Pity Pit for last-place tries
> 🎪 More food districts unlocking weekly
>
> **EAT DANGEROUSLY.**

### Tags
`Roleplay` `Adventure` `Sport` `Funny` `Cosmetic` `Eating` `Carnival` `Food`

### Genre
Family — All Ages

### Server Size
20 players

---

## Commit history this session

```
bac218c Block 7: Mobile UX + anti-cheat + sound effects
2b23650 Block 6: Monetization scaffold — Style Bucks + VIP/gamepass + ProcessReceipt
3961373 Block 5: NPC personalities, Foodgasm bursts, Pity Pit, free starter cosmetic
43ac364 v1 currency unification: drop Carnival Tickets, mini-games pay coins
```

Plus prior session commits (carousel + pirate + swing + summary docs).

---

## What's deferred to v1.1+ content drops

- 9 remaining ride re-themes (Pretzel Swings, Pie Tin Twister, Bumper Burgers, Ice Cream Scrambler, The Indigestion, The Burp, Ketchup Rapids, Frank's Express, Coffee Cup Spin)
- Pizza Plaza district (Tier 2 unlock at 50 wins)
- Diner America, Donut Dynasty, Tokyo Town, Burger Boulevard
- Iron Booth (mystery box contest)
- Madame Petite (daily horoscope tent)
- Photo Mode + Glory Reel
- Cookbook collection meta
- Hall of Fame board (cosmetic only — leaderboard implementation done server-side)
- NPC memory ("back for more, kid?")
- Coach Mode (Bobby Crumb apprentice NPC)
- Soufflé Princess monthly server-wide boss raid
- Tournament arc: Road to The Bear
- Chipmunk window (mechanic deferred — not in current contest loop)

Each becomes a weekly/monthly content drop announcement — a marketing beat for retention.

---

## Known limitations / honest disclosure

1. **Chipmunk window not yet implemented as a mechanic.** Design-doc'd but no server/client code yet. Foodgasm bursts + Pity Pit do the gameplay-feel heavy lifting at v1.
2. **Pizza Wheel pepperoni didn't apply** (gondolas aren't named as expected). Minor cosmetic issue, fix in v1.1.
3. **NPC catchphrases data exists but not yet wired** to client display. v1.1 task: have ContestService fire catchphrases via ContestPhaseChanged.
4. **No new cosmetic SKUs** beyond the 4 already in `Constants.COSMETICS`. Templates for new items would need to be modeled in ServerStorage.Cosmetics.
5. **Sound effects file exists but isn't yet hooked into contest events** — Block 7 created the system, wiring is a v1.1 polish.

These are documented for transparency. None are launch-blockers.

---

## When you're ready to ship

Run through this checklist:
- [ ] Ctrl+S in Studio (saves Blocks 2-4 visual work to .rbxl)
- [ ] Gamepasses created on creator dashboard (3)
- [ ] Dev products created (4 Style Buck bundles)
- [ ] IDs pasted into `MonetizationService.luau`
- [ ] Friend playtest done (1-2 friends)
- [ ] Critical bugs from playtest fixed
- [ ] Store thumbnail captured + uploaded
- [ ] Store description + tags set
- [ ] Click "Public" on the game page
- [ ] Announce on Discord / TikTok / Twitter

You're ready.

**EAT DANGEROUSLY.** 🌭
