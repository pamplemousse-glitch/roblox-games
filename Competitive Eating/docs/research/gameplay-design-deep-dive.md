# Gameplay Design Deep-Dive — Frank's Fairground / Competitive Eating

*An opinionated research brief for Antoine. Written May 2026. Goal: help you commit to a design direction before you sink another 50 hours of build time into the wrong one.*

> **Bottom line up top (TL;DR).** Your current design is over-scoped. The good news: the core eating contest, the four-stat system, and the carnival hub are individually strong. The bad news: you've stacked them on top of two other full games (a carnival mini-game suite + a ride simulator) you don't have the player count to support. The right move is to cut hard, lean into a **PvE-first hybrid loop with parallel-PvP when populated**, keep the dual currency for now but rename it, and ship the eating contest as a polished 10-minute experience long before any ride scripts.
>
> **Recommended direction in one sentence:** A PvE-anchored skill-and-stat eating contest with seamless live-player drop-in (Bee Swarm Simulator's retention model), shipping the Tier 1 loop alone and treating rides + half the mini-games as Phase 2 wallpaper, not launch features.

---

## Table of Contents

1. [What's already built (context)](#1-whats-already-built-context)
2. [Q1 — Core loop: PvE vs PvP vs Story vs Mixed](#2-q1--core-loop)
3. [Q2 — Skill vs grind balance](#3-q2--skill-vs-grind-balance)
4. [Q3 — Progression structure](#4-q3--progression-structure)
5. [Q4 — Monetization in Roblox 2026](#5-q4--monetization-in-roblox-2026)
6. [Q5 — Retention hooks (daily/weekly/seasonal)](#6-q5--retention-hooks)
7. [Q6 — Onboarding (first 5 minutes)](#7-q6--onboarding)
8. [Q7 — Social mechanics](#8-q7--social-mechanics)
9. [Q8 — Content velocity & update cadence](#9-q8--content-velocity-and-cadence)
10. [Q9 — Comparable successes and failures](#10-q9--comparable-successes-and-failures)
11. [My recommended design for this specific game](#11-my-recommended-design-for-this-specific-game)
12. [Top 5 decisions to make this week](#12-top-5-decisions-to-make-this-week)

---

## 1. What's already built (context)

This section is the honest audit. The recommendations later in the doc assume these exist or are nearly done. If something here is aspirational rather than implemented, downgrade the trust accordingly.

**Built or in flight (per `PLAN.md`, `GAME_DESIGN.md`, `src/` tree):**

- **Tier 1 Arena greybox** in Studio — floor, stage, backdrop wall, contest table with 4 seats, queue zone, crowd barrier, spawn location. Not yet wired to ContestService.
- **Core eating contest skeleton**: `ContestController` (client), `ContestService` (server, implied), queue → countdown → active → results loop documented and partially coded.
- **Hot Dog ring skill check**: documented in detail, ~240°/sec needle, ~54° success arc, "Great" zone for 120% bites. (Per design doc; verify in `src/Client/Controllers/ContestController.luau` against actual implementation.)
- **Four stats**: Stomach Capacity, Jaw Speed, Swallow Rate, Focus. Quadratic upgrade curve (50 × level²). Wired in `Constants.luau` per file list.
- **Dual currency**: Coins (gameplay only) + Carnival Tickets (mini-games → cosmetic prizes). Style Bucks mentioned in design doc but appears to be a third currency layer for cosmetics — needs reconciliation.
- **Carnival mini-games (in-progress)**: Ring Toss, Duck Pond, Balloon Dart, High Striker, Skee-Ball UI controllers exist as separate files. So 5 of the planned 16 mini-games are scaffolded.
- **Onboarding controller**, **Shop controller**, **HUD controller**, **NPC vendor service**, **Cosmetics service**, **Ride controller** — all present as files. Maturity level unknown without reading the source.
- **MiniGameService** + **MiniGameController** — generic dispatcher present.
- **Frank's Fairground map** (~700×600 studs) — landmark structures + 6 rides planned, partial greybox done in the Friday May 30 sprint.
- **15-minute monetization gate** — enforced as a CLAUDE.md rule.
- **Prestige system, spectator system, NPC personalities, George Shea announcer** — documented but not yet built.

**What's notably NOT built yet (treat as "if we ship it"):**

- Tier 2–4 arenas (greybox not started)
- 5 of 7 documented food minigames (only Hot Dog ring + Burger sequential are partially scoped)
- Most ride scripting (Carousel is closest, per handoff log)
- DataStore-backed prestige, daily streaks, weekly tournaments, seasonal events
- Real monetization (game passes, dev products) — currently behind the gate
- Spectator system, chipmunk window, power foods, The Bear encounter

That's the current state. Everything below operates from this foundation.

---

## 2. Q1 — Core loop

### What's working on Roblox in 2026 for contest-style games

The 2026 top charts make the answer unambiguous: **hybrid loops dominate**. Forsaken (survival horror + RPG progression), Anime Vanguards (tower defense + RPG + gacha), Blade Ball (skill-based PvP + cosmetic grind), Steal a Brainrot (tycoon + low-stakes PvP), Grow a Garden (cozy idle + light social), Deepwoken (roguelike + soulslike). The most successful Roblox RPGs in 2026 [hybridize genres in ways that keep the space evolving](https://rowatcher.com/news/best-roblox-rpgs-in-2026-ranking-the-top-10-by-gameplay-and-player-retention).

Pure-PvP games on Roblox in 2026 have a *concurrent player problem*: they need a constant population to be playable. Blade Ball survives because it has the population. Most new games don't, and die in the matchmaking queue. Pure-PvE games (Pet Sim 99, Anime Vanguards, Bee Swarm) thrive because they're playable solo and add social layers on top.

### Tradeoff matrix

| Loop type | Population required | Content velocity needed | Skill floor | MAU/DAU profile | Forgiveness at low CCU |
|---|---|---|---|---|---|
| **Pure PvP (sync)** | Very high — matchmaking must fill in <30s or game feels dead | Medium (maps, modes) | High (drives churn for new players) | Spiky DAU, low session length | **Lowest. Empty lobby = dead game.** |
| **Pure PvE / idle** | Zero — solo playable | Very high (new content monthly minimum, ideally weekly) | Low | Steady DAU, high session length | **Highest. The game is the same with 1 or 100 players.** |
| **Story / linear** | Zero | One-shot — no ongoing content treadmill | Variable | Very high MAU bump on launch, then collapses | High at launch, none after |
| **Mixed PvE + drop-in PvP** | Medium — works with 0, better with 4+ | High | Medium | Balanced | **High — degrades gracefully.** |
| **Async / leaderboard** | Zero live, but needs scale for top board to feel real | Medium | Low–medium | Long-tail DAU | High |

Loops MOST forgiving at low CCU: **PvE with drop-in async PvP and named NPC fillers**. This is the Bee Swarm model and the Anime Vanguards model. Both can be played solo forever. Both feel multiplayer when others are present. Neither dies when the server is empty.

### Comparison to specific Roblox successes

| Game | Loop class | Why it works |
|---|---|---|
| [Bee Swarm Simulator](https://romonitorstats.com/experience/1537690962/) | PvE idle + collection + light async social | "Marathon, not a sprint" — quests drive progression, gifted bees are the long-term hook, no PvP combat. 50+ bee types, crafting, seasonal events. Solo-playable from spawn to endgame. |
| [Adopt Me](https://naavik.co/deep-dives/roblox-blox-fruits-brookhaven-adopt-me/) | Trading economy + roleplay + collection | The player-to-player economy IS the product. Pets are status. Trading is the loop. Pure social. |
| [Blade Ball](https://games.gg/roblox/guides/roblox-blade-ball-codes-april-2026/) | Pure PvP skill | Survives only on population. The skill ceiling and constant tournaments keep it alive. Cosmetic grind is secondary. |
| [Pet Simulator 99](https://ccucheck.com/games/8737899170) | PvE collection + trade + idle + gacha | The progression IS the game. Highly monetized via Forever Pack and limited-time pets. Whales fund the LiveOps. |
| [Brookhaven](https://www.themetakey.com/news/brookhaven-robloxs-biggest-game) | Roleplay sandbox | Players stay for other players. Almost no built-in loop — the loop is "be on Roblox with friends in a place that looks like a town." |
| [Doors](https://studiokrew.com/blog/top-games-on-roblox-and-analysis-2026/) | Co-op horror runs | Repeatable 20–40 min sessions. PvE with optional co-op. Low CCU OK. |
| [Dress to Impress](https://romonitorstats.com/experience/15101393044/monetization/) | Async PvP (themed rounds) + cosmetic collection | 8 players, 3-minute themed rounds, peer-voted. Cosmetics ARE the gameplay. Social by design. |

### Eating-game precedents

The space is **mostly unexecuted at scale**, which is good news for you:

- **[Competitive Eating Simulator](https://www.roblox.com/games/16083413950/Competitive-Eating-Simulator)** — PvE boss eating format. Low visit count. Doesn't have the contest format you're building.
- **[Eating Simulator](https://www.roblox.com/games/6953291455/Eating-Simulator)** and variants — the "eat → grow bigger → sell → upgrade" idle simulator pattern. Many copies, none retained at scale.
- **Blob Eating Simulator** (per your own GAME_DESIGN.md notes) — 23M visits historically, now 0 CCU. Died because it used direct PvP without NPC backfill, so empty lobbies killed the game.
- **Steak Slammer** — could not verify in 2026 searches; either renamed, dead, or never large.

There is no Joey-Chestnut-style competition simulator at scale on Roblox. The niche is open. The genre-mate that succeeded ([Hot Pot Restaurant at 88% rating, 7.1M players](https://bloxmake.com/blog/cooking-up-fun-the-best-roblox-food-games-for-foodies)) is a cooking sim, not an eating contest. Different loop entirely.

### Verdict for Q1

**Mixed loop: PvE-anchored with parallel-PvP when populated.** Specifically: contests always run with 4 seats. NPCs fill empty seats at T-10s. The player never feels alone. When real players are present, they show up in the leaderboard sidebar with their actual names. Same contest mechanic; the live competitor is just a swap-in.

This is exactly what GAME_DESIGN.md already proposes. Stay the course on the loop structure. The mistake would be making the contest *require* humans (Blob Eating Simulator's fatal error).

**Sources for Q1:**
- [Best Roblox RPGs in 2026 — RoWatcher](https://rowatcher.com/news/best-roblox-rpgs-in-2026-ranking-the-top-10-by-gameplay-and-player-retention)
- [Top Roblox Games 2026 — StudioKrew](https://studiokrew.com/blog/top-games-on-roblox-and-analysis-2026/)
- [Roblox Success Stories: Blox Fruits, Brookhaven RP & Adopt Me — Naavik](https://naavik.co/deep-dives/roblox-blox-fruits-brookhaven-adopt-me/)
- [Cozy Chaos: Grow a Garden + Steal a Brainrot — Gameflip](https://gameflip.com/en/blog/cozy-chaos-why-grow-a-garden-and-steal-a-brainrot-are-the-perfect-low-stress-games-right-now)
- [Steal a Brainrot: 60 Billion Visits — LootBar](https://www.lootbar.com/blog/en/steal-a-brainrot-roblox-top-charts.html)

---

## 3. Q2 — Skill vs grind balance

### The two failure modes

**Pure skill (twitch / timing / button mash):** the ceiling is whatever the best human can do at the input. Phantom Forces and Blade Ball have this. The risk: the skill expression caps quickly for casual players. Without a progression curve, a player who's "okay" after 30 minutes has nowhere to grow. They leave.

**Pure grind (stats grow, gameplay dispenses time):** every Eating Simulator clone is this. The risk is twofold: (1) the game is fundamentally passive — see Junk Food Simulator's 61% rating per your own GAME_DESIGN.md — and (2) the economy is exploitable for pay-to-win, which Roblox's audience punishes harder in 2026 than 2022.

The synthesis is the only thing that works long-term, and the working pattern in 2026 is clear: **make the player feel that they got better, and that their character also got better, in roughly equal measure**.

### What ratios actually work

Look at the most retentive Roblox games of the last 18 months. Each has a skill layer AND a stat layer, and a clean variable to point at for "this stat changes that input":

- [Fisch](https://fischipedia.org/wiki/Fishing) has a skill check minigame (shake prompts + bar control). Bait and rod stats modify the minigame's parameters directly — wider bar, slower fish, better luck. **Stats compress the difficulty of the skill check; they do not replace it.**
- Blox Fruits scales raw damage with grind but the actual moment-to-moment combat is dash/dodge/combo execution. A higher-level player isn't a passive winner — they hit harder, but a skilled lower-level can still win duels.
- Bee Swarm Simulator has almost no twitch skill, but the "skill" is build optimization and routing. The grind expresses through strategic choice.
- Pet Simulator 99 leans heavy grind; its skill is just smart spending. It survives on monetization, not gameplay, and is widely critiqued as predatory.

The healthy zone: **stats account for roughly 30–40% of contest outcome at max level. Skill accounts for the remaining 60–70%.** A maxed-stat player with mediocre skill should still lose to a low-stat player with great skill, except in the very early game where stats are catching up.

### How this interacts with your current 4-stat system

Your GAME_DESIGN.md already gets this right (stat → minigame variable mapping section, around line 273). Quoted:
- **Jaw Speed** → needle rotation speed
- **Focus** → success zone size
- **Swallow Rate** → inter-bite cooldown
- **Stomach Capacity** → total bites per contest

This is exactly the Fisch pattern. Each stat changes a visible parameter of the skill check. A new player sees their Focus go up and *sees the green zone get wider*. That's healthy hybrid design.

**The leaky pattern in your current scope, however:** the cumulative effect of maxing all four stats is too dramatic. Per the doc, max Focus changes the success arc from ~28° to ~90° — a 3.2× wider target. Max Jaw Speed slows the needle. Combined, a max-stat player has 6–10× the target window of a starting player. That's *pay-to-skill-floor* — the moment you can't catch up without stats, the floor of "good enough to win" rises and the skill ceiling becomes irrelevant.

**Fix:** cap the combined stat advantage at ~2.5–3× total. Make stats *compress* the difficulty (Fisch's word), not erase it. The success arc should never get wider than ~60° even at max Focus + max Jaw Speed combined. Otherwise the game becomes Junk Food Simulator.

### Has the Roblox meta shifted toward skill or grind?

Both are alive. But the games that have *won* in the last 12 months ([Grow a Garden, Steal a Brainrot, Fisch, Fish It, RIVALS](https://gameflip.com/en/blog/cozy-chaos-why-grow-a-garden-and-steal-a-brainrot-are-the-perfect-low-stress-games-right-now)) all do one of two things:
1. Lean into idle / cozy + light social (Grow a Garden, Adopt Me's modern form)
2. Lean into short, snackable skill loops (Fisch, RIVALS, Blade Ball)

The pure-grind simulator with no skill expression (Junk Food Simulator, the 2020-era Mining Simulator clones) is losing relevance. The mobile-first, short-session, skill-light games are gaining.

For *your* genre — eating contest — the contest IS the skill expression. The grind funds the contest with bigger arc widths and slower needles. Your existing balance is on the right track; just don't let the stat ceiling completely erase the skill curve.

### Verdict for Q2

**60–70% skill / 30–40% stat at maximum upgrade level.** The stat curve should make a winning contest *feel* possible, not *be* automatic. Cap combined-stat effect on any minigame variable at ~2.5× starting difficulty. Make sure a fresh Prestige 0 player with great timing can beat a Prestige 2 player who's coasting.

**Sources for Q2:**
- [Roblox Fisch Beginners Guide — Games.gg](https://games.gg/roblox/guides/roblox-fisch-beginners-guide/)
- [Mastering Fisch — Oreate AI](https://www.oreateai.com/blog/mastering-fisch-your-guide-to-success-in-roblox-fishing/8e90b59a07ebd3c40ffb75178a41346a)
- [Best Roblox Skill-Based Games](https://roblox-skill-based-games.pages.dev/posts/roblox-skill-based-games/)
- [Cozy Chaos: Grow a Garden — Gameflip](https://gameflip.com/en/blog/cozy-chaos-why-grow-a-garden-and-steal-a-brainrot-are-the-perfect-low-stress-games-right-now)

---

## 4. Q3 — Progression structure

### Flat vs deep stat trees

You have a flat tree: 4 stats, each 1–50, no branching, no specializations. That is the right call for this game. Reasons:

1. The eating contest doesn't need build diversity. There's no "tank vs DPS" tradeoff to support. Everyone wants to eat more food faster — the stats serve one optimization function.
2. Deep trees add UI complexity and decision paralysis. For a 9–15-year-old Roblox audience, the optimal tree is *the one you can master in 10 seconds*.
3. A flat tree maps cleanly to your kiosk UI (4 large buttons). A deep tree would force a separate respec system, branching paths, and inevitable balance arguments.

The closest successful Roblox analog with a 4-stat flat tree is Mining Simulator's original era. The closest *bad* example is anything that tried to ship a 20-node skill tree without playtesting. Don't go deeper.

### Prestige systems — do they work for a contest game?

[Prestige works well in simulators where the rebirth feels earned and the bonuses compound](https://devforum.roblox.com/t/prestige-vs-rebirth/594019). World // Zero, Mining Simulator, Pet Sim, and Bee Swarm all have functional prestige systems. The key prestige design rules:

1. **Prestige must add a permanent, visible flex.** Color, particle, aura. Your design (Bronze → Silver → Gold → Diamond → Champion belts) is good.
2. **Prestige must NOT lock out the new-player experience.** Other players' max-prestige auras visible in hub create aspiration; encountering a Prestige 5 player in a ranked contest destroys morale. Match-make by prestige tier or by stat band.
3. **Each prestige tier should take ~5× longer than the last.** Your gates (Level 10 → 20 → 30 → 40 → 50 stat + escalating coin) approximate this. Good.
4. **First prestige must be reachable in week 1.** Otherwise hardcore players have nothing to chase before they bounce.

For a *contest* game specifically, prestige has an extra benefit: it's how you create skill-band matchmaking. P0 contests fill with P0 players. P5 contests are the Champions League. Without prestige, every server is a free-for-all and new players bounce off whales.

The Bear encounter is also a good prestige design — a weekly mythical boss for P5 only. Borrowed pattern from FFXIV ultimate raids; works because it's the One Thing The Max Players Are Chasing.

### Meta-progression vs run-progression

Currently you have meta-progression (stats persist) only. There's no run-progression (in-contest power-ups). The Power Foods system in your design doc gestures at run-progression but isn't built.

I would recommend **NOT** building run-progression at launch. Reasons:
- Each contest is 90 seconds. A power-up system inside 90s adds UI complexity without much player payoff.
- Run-progression systems become a balance nightmare in PvP contexts (which yours partially is).
- Roblox players read "power-up in 90s contest" as "RNG win," which is the exact "unfair loss" trap your own GAME_DESIGN.md warns against (line 752).

Keep Power Foods as Phase 2 polish if at all. Launch on stats + skill only.

### Currency: dual vs single

This is where I'll push back on your current design.

Per your design doc you have **three** currencies floating around:
1. **Coins** — gameplay-earned, gates stat upgrades.
2. **Carnival Tickets** — earned only from mini-games, redeem for cosmetics at the Prize Booth.
3. **Style Bucks** — Robux-purchasable or earned slowly, spent on cosmetics.

Two of these (Tickets + Style Bucks) overlap functionally: both buy cosmetics. The justification in the doc is that Tickets are a "secondary engagement driver" — they motivate playing mini-games. That justification is weak. The mini-games should justify themselves with fun, not with a parallel cosmetic economy that fragments player attention.

**The 2026 meta on currency design** is moving toward [clearer disclosure and simpler systems](https://gametyrant.com/news/the-loot-box-loophole-is-closing-why-2026-is-the-year-your-in-game-currency-finally-becomes-real-money). Both regulators and players are punishing complexity. Pet Sim 99's [aggressive Forever Pack + multi-currency economy](https://screenwiseapp.com/guides/parent-s-guide-to-roblox-pet-simulator-99) is widely criticized as predatory. Adopt Me uses just Bucks. Brookhaven uses just Bucks. Dress to Impress uses just Cash (+ VIP).

**My recommendation:**
- **Keep Coins** — gameplay-earned, gate stat upgrades. (Don't rename — Coins is universal.)
- **Drop Carnival Tickets entirely.** Mini-games pay out Coins at a lower rate than contests. Players will still play them; the cosmetic store accepts Coins. Cosmetics are priced high enough that they're aspirational, not impulse buys.
- **Keep Style Bucks ONLY as the Robux currency.** Same name fine, but it's *only* for premium cosmetics that have no Coin equivalent. Free players never see "Style Bucks" in a normal play loop unless they want to buy.

This gives you a clean single-currency play loop (Coins) and a clean premium currency for monetization (Style Bucks). Two currencies max, one for play, one for pay. Cleaner UX, easier to balance, fits the 2026 clarity trend.

If Antoine pushes back on this with "but Tickets drive mini-game engagement" — the counter is that you should be building one fun mini-game suite, not 16 mediocre ones. Engagement comes from the *fun*, not the currency tax. Build Skee-Ball really well, ship it as the one mini-game, and pay Coins.

### Verdict for Q3

- **Keep the flat 4-stat tree.** Don't add branching.
- **Keep prestige as designed (5 belt tiers).** Make sure prestige-band matchmaking is in for ranked.
- **Drop run-progression / Power Foods** at launch. Add later if needed.
- **Collapse to 2 currencies (Coins + Style Bucks).** Kill Carnival Tickets.

**Sources for Q3:**
- [Roblox Player Retention Strategies — BLOXG](https://bloxg.com/guides/roblox-player-retention)
- [Prestige vs Rebirth — DevForum](https://devforum.roblox.com/t/prestige-vs-rebirth/594019)
- [Currencies (Pet Simulator 99) — Fandom](https://pet-simulator.fandom.com/wiki/Currencies_(Pet_Simulator_99))
- [What's the point of having two in-game currencies? — DevForum](https://devforum.roblox.com/t/whats-the-point-of-having-two-in-game-currencies/3676805)
- [The Loot Box Loophole is Closing — GameTyrant](https://gametyrant.com/news/the-loot-box-loophole-is-closing-why-2026-is-the-year-your-in-game-currency-finally-becomes-real-money)

---

## 5. Q4 — Monetization in Roblox 2026

### The hard numbers

- [Roblox takes 30% of every gamepass and developer product sale](https://playgama.com/blog/game-faqs/what-percentage-does-roblox-take-from-gamepasses/). Developers keep 70%. This is platform-wide and applies to game passes, dev products, and UGC sales.
- [Roblox platform ARPU was $10.58 in Q1 2026](https://www.businessofapps.com/data/roblox-statistics/), up 2.6% YoY. This is the *all platform* number, not per-game.
- [Simulator and tycoon games have 2-3% conversion rates](https://www.gameanalytics.com/reports/2025-roblox-report) — the highest of any genre. Skill-based games are typically 0.5–1.5%.
- [Average spend per paying user varies dramatically by game](https://profitable.app/tools/roblox-revenue-calculator) — typical range is 100–500 Robux average per conversion.
- [Roblox monthly unique payers grew 52% YoY to 31 million in Q1 2026](https://www.businessofapps.com/data/roblox-statistics/) — more people are spending Robux than ever.

For your specific game (eating contest + carnival), realistic expectations:

| Metric | Conservative | Optimistic |
|---|---|---|
| Conversion rate | 1.0% | 2.5% |
| Average spend per payer | 150 Robux | 300 Robux |
| Per-visit revenue | ~1.5 Robux | ~7.5 Robux |
| At 100K visits/week | ~150K Robux/wk | ~750K Robux/wk |
| Dev share after Roblox 30% cut | ~105K Robux | ~525K Robux |
| USD equivalent (DevEx ~$0.0035/R) | ~$367/wk | ~$1,837/wk |

That's not a salary at 100K visits/wk. You'd need 1M+ visits/wk to see a few thousand dollars a week. Set expectations accordingly: this game is a *learning project that might earn coffee money first, lunch money in 6 months if it hits, and a salary only if it explodes*.

### Game Passes vs Developer Products vs Premium Payouts

| Type | Best for | Failure mode |
|---|---|---|
| **Game Pass** (permanent) | One-time purchase = ongoing perk. VIP zone access, cosmetic aura, +20% coin (but read warning below). | Pricing it too high. The 100–499 Robux range converts best. |
| **Developer Product** (consumable) | Repeat purchases. Cosmetic currency bundles, "boost" packs, gacha pulls. | Selling stat power. Mine Racer killed itself with paid auto-tap. |
| **Premium Payouts** (passive) | All games qualify. Pays based on Premium-subscriber time-spent in your experience. No friction. | Effectively zero until you have 50K+ Premium hours/month. |

[Roblox's higher rev-share plan for premium games](https://www.gamedeveloper.com/business/roblox-rolls-out-higher-rev-share-plan-for-devs-making-premium-games) (50–70% at $9.99–$49.99 tier) is a real option, but locks your game behind a paywall — bad for a free competitive eating game trying to grow audience. Skip.

### VIP gamepass — what % of revenue?

Public data is thin, but cross-referencing devforum threads, [Naavik's UGC report](https://naavik.co/deep-dives/the-state-of-ugc-games-2025-deep-dive/), and what's visible on top simulator games: **VIP-style gamepasses typically drive 30–50% of total revenue** in successful Roblox games. They're the workhorse. The pattern is:
- One main VIP at 199–499 Robux ("the obvious one to buy")
- 2–4 supplementary passes at 99–199 Robux (themed: pets, faster something, cosmetic pack)
- Dev products for repeat revenue (cosmetic currency, boost packs)

The risk is that "+20% coins" or "+20% all stats" VIP is functionally pay-to-win in a contest game. Pet Sim 99 gets away with it because it's a simulator; you can't because your game has a competitive layer.

**Your design doc gets this right (lines 654–663):** VIP Champion is cosmetic + social perks only (aura, outfit, VIP lobby). No stat advantage. This is the harder path but the correct one for a contest game. The risk is leaving money on the table compared to a "pay for +20% coins" VIP.

**Compromise that doesn't break competitive integrity:** Offer VIP perks that affect *what you do between contests, not in them*:
- Daily login bonus +50%
- Mini-game payouts +25%
- Extra cosmetic slot
- VIP-only emotes and aura
- Early access to next week's seasonal cosmetic
- Custom username color
- VIP lobby chat channel

These drive purchase without touching contest outcomes. This is the [Brookhaven monetization model — "expression and status, not power"](https://www.themetakey.com/news/brookhaven-robloxs-biggest-game) — and Brookhaven prints money.

### Is cosmetic-only competitive in 2026?

[Dress to Impress shows the answer is yes — but with a wrinkle](https://romonitorstats.com/experience/15101393044/monetization/). DTI is allegedly cosmetic-only and is one of the highest-monetizing Roblox games of 2025, but its VIP unlocks *exclusive cosmetic slots that visibly help you win*. Players complain about pay-to-win.

The lesson: pure cosmetic-only is competitive, but you have to be careful that "exclusive cosmetics" don't become "items required to look the part to win."

For your game, since contest results are based on bites eaten (not how you look), cosmetic-only is actually safe. Don't make VIP cosmetics required to look like a "real" eater. Don't make the Mustard Belt visible status carry mechanical weight.

### Battle pass / season pass patterns

The Roblox season pass meta in 2026:
- 30–60 day cycle
- Free track + premium track (premium track unlocks via Robux purchase, usually 599–999)
- Daily/weekly challenges feed XP
- ~50 tiers with cosmetics
- Limited-time so it creates FOMO

This is the highest-converting LiveOps pattern on Roblox after gamepasses. [Source: Naavik UGC report](https://naavik.co/deep-dives/the-state-of-ugc-games-2025-deep-dive/).

For your game: a "Summer Boardwalk Pass" with cosmetic outfits, emotes, victory poses, and the seasonal hot dog skin would be a natural fit. Build for v2.0, after launch.

### Verdict for Q4

**The mix I'd ship at launch:**
- **Main VIP gamepass** — 299 Robux. Animated golden belt aura, daily bonus +50%, mini-game payouts +25%, VIP lobby, custom username color. *No contest stat effect.*
- **Champion's Kit** — 599 Robux. Exclusive 3 character skins, 5 victory poses, "Champion" title. Cosmetic only.
- **Showman's Pass** — 199 Robux. A real-time announcer NPC that follows you (the absurdist commentary one). Comedic flavor. No contest effect.
- **Style Buck bundles** — 99, 299, 999, 2499 Robux. Standard ladder.
- **No paid speed boosts, no paid stat consumables, ever.**
- **Battle pass: defer to v2.0.**

Expected revenue mix at maturity: VIP ~40%, Champion's Kit ~20%, Showman ~10%, Style Buck bundles ~30%.

**Sources for Q4:**
- [Roblox Revenue and Usage Statistics — Business of Apps](https://www.businessofapps.com/data/roblox-statistics/)
- [What percentage does Roblox take from gamepasses — Playgama](https://playgama.com/blog/game-faqs/what-percentage-does-roblox-take-from-gamepasses/)
- [How to Price Game Passes on Roblox — creation.dev](https://www.creation.dev/learn/how-to-price-game-passes-roblox)
- [The 2025 Roblox Benchmark Report — GameAnalytics](https://www.gameanalytics.com/reports/2025-roblox-report)
- [Brookhaven monetization breakdown — TheMetaKey](https://www.themetakey.com/news/brookhaven-robloxs-biggest-game)
- [Roblox rolls out higher-rev share — GameDeveloper](https://www.gamedeveloper.com/business/roblox-rolls-out-higher-rev-share-plan-for-devs-making-premium-games)

---

## 6. Q5 — Retention hooks

### Daily login design

[Daily reward systems with streak bonuses are the simplest and most effective retention tool on Roblox](https://devforum.roblox.com/t/do-daily-rewards-actually-keep-players-retention/3556728). The patterns that work:

- Each consecutive day gets better than the last
- Milestone rewards at day 7, 14, 30 (anchor moments)
- Streak resets if you miss a day — *but* a one-time "streak shield" item softens this
- Day 30+ wraps to a higher reward tier, never to zero

You already have "First Win of the Day: +100 coins" — that's a daily *first-action* bonus, which is good. Add the calendar.

**Recommended escalation curve:**

| Day | Reward |
|---|---|
| 1 | 50 Coins |
| 2 | 75 Coins |
| 3 | 100 Coins |
| 4 | 150 Coins |
| 5 | 200 Coins |
| 6 | 300 Coins |
| 7 | 500 Coins + cosmetic (rotating weekly) |
| 14 | 1000 Coins + rare cosmetic |
| 30 | 5000 Coins + exclusive seasonal cosmetic |
| 30+ wraps | Back to day 1 but each milestone +10% better |

### Weekly leaderboards & tournaments

**Critical:** [weekly leaderboards drive higher retention than all-time leaderboards because they're winnable](https://devforum.roblox.com/t/weekly-leaderboard/2152962). An all-time global leaderboard locks new players out — they can never catch the OG whales. Weekly resets give everyone a fighting chance every Monday.

Categories you want, in priority order:
1. **Friends Weekly** — strongest retention driver. Players check this to flex on friends.
2. **Weekly Top 100 Champions** — most contests won this week.
3. **Weekly Top 100 Bites** — most food eaten this week.
4. **All-Time Records** — record-holder hall of fame (broken-record events).
5. **Per-arena leaderboards** — Tier 1 / 2 / 3 / 4 winners separately.

Rewards for top weekly placement: cosmetic + Style Bucks. *Not* stat boosts. Otherwise weekly winners snowball.

### Seasonal events

Real food holidays are a goldmine for this game:
- **July 4 — Summer Hot Dog Bowl** (your Nathan's analog, must be the centerpiece)
- **National Hot Dog Day** (July 17) — secondary mini-event
- **Halloween — Brain Taco Championship** (already in design doc)
- **Thanksgiving — Turkey Leg Throwdown**
- **December — Holiday Ham Special**
- **Easter — Peeps Madness** (Matt Stonie's 255-in-5-min record)
- **Mardi Gras — King Cake Crunch**

[Seasonal events with exclusive cosmetics drive the highest return rates](https://devforum.roblox.com/t/do-daily-rewards-actually-keep-players-retention/3556728) because of FOMO. Each event needs a 7–14 day window, exclusive cosmetic, and unique mechanic (e.g. Brain Tacos = Tier 4 mechanic during Halloween only).

Build event content using a single ModuleScript driver so events are data-defined, not code-defined. Each event = a config table with food, mechanic flag, cosmetic IDs, dates. This is what lets you iterate weekly without a code update.

### Streak mechanics

Three streaks you should track:
1. **Login streak** (handled above)
2. **Win streak** — already in your design (+10% per win up to +50%). Good.
3. **Daily challenge streak** — complete the daily challenge X days in a row, milestone rewards.

Avoid more than 3 streaks visible to the player. UI complexity kills.

### Energy / stamina systems — yes or no in 2026?

**No. Not for this game.**

Energy systems work in (a) mobile gacha games where they push paid refills, and (b) idle simulators where they pace progression. Roblox in 2026 is moving *away* from forced pauses. Grow a Garden uses time-gating (plants grow while away) but doesn't lock active play. Pet Sim 99 has no energy. Bee Swarm has no energy. Adopt Me has no energy.

Your game has a contest timer (90 seconds) which is itself a natural pacing mechanism. Adding a stamina cap would make the game feel like work. Don't.

The closest acceptable design: a "VIP gives unlimited queues, free players get 30 contests per day" — but this is monetization for monetization's sake and would torpedo retention. Skip.

### Verdict for Q5

- **Daily login streak with calendar.** Build this in week 1 of LiveOps.
- **Weekly leaderboards** with Monday reset. Friends category first, then global, then per-arena.
- **Seasonal event scaffolding** as a data-driven ModuleScript before launch. Even if launch ships with only one event configured.
- **Three streaks max:** login, win, daily challenge.
- **No energy / stamina cap.**

**Sources for Q5:**
- [Roblox Player Retention Strategies — BLOXG](https://bloxg.com/guides/roblox-player-retention)
- [Do daily rewards actually keep players retention? — DevForum](https://devforum.roblox.com/t/do-daily-rewards-actually-keep-players-retention/3556728)
- [How to make a daily reward system with streaks — DevForum](https://devforum.roblox.com/t/how-to-make-a-daily-reward-system-with-streaks/2652356)
- [Weekly Leaderboard — DevForum](https://devforum.roblox.com/t/weekly-leaderboard/2152962)

---

## 7. Q6 — Onboarding

### The 60-second window

[The first 10 seconds are make-or-break](https://www.spaceport.xyz/blog/how-to-hook-players-in-the-first-2-minutes-game-retention-tips-for-roblox-devs). The next 50 seconds prove the loop. Get to "fun" before you get to "shop."

Roblox's own onboarding docs are blunt about this: [the more a player has to learn in their first session, the more likely they quit](https://create.roblox.com/docs/production/game-design/onboarding). [Contextual tutorials beat explicit walkthroughs](https://create.roblox.com/docs/production/game-design/onboarding-techniques). The goal is to make the player *do* the right thing while thinking it was their idea.

### Should the first contest be rigged?

**Yes. Always. Without exception.** This is one of the only places where I would push hard.

The pattern, from competitive analysis of Forsaken, Anime Vanguards, Bee Swarm, and Steal a Brainrot: **the first 1–3 contests/runs/sessions are tuned for a clean win or near-win.** Players who win their first contest are 3–5x more likely to play a second one.

Your current design (line 559–563): "NPCs at 50% difficulty. Green zone is 40% wider than normal (invisible assist — player doesn't know it's easier). Player wins or finishes 2nd."

That's correct. Hold that line. Add:
- **First contest: 95% chance of winning** (NPCs at 40% capacity, green zone 60% wider). Should feel like a stomp.
- **Second contest: 75% chance** (NPCs at 60% capacity, zone 30% wider).
- **Third contest: 50% chance** (full difficulty).
- After contest 5, all assists removed and difficulty is normal.

This is the same pattern Steal a Brainrot uses to hook 60 billion visits worth of players. They feel competent immediately.

### Tutorial design: explicit walkthrough vs discovery vs both

**Hybrid, weighted to discovery, with contextual hints.** Specifically:

1. **No paragraphs of text.** Roblox's audience won't read them.
2. **Visual hints, not verbal.** Arrows, pulsing green zones, glowing buttons. [Roblox docs explicitly recommend this approach because it crosses language barriers and respects the player's intelligence](https://create.roblox.com/docs/production/game-design/onboarding-techniques).
3. **One-line George Shea announcer text per major beat.** ("First contest is on me. Step up." then later "Upgrade your jaw speed?") Skippable, never blocking.
4. **First skill check has the green zone labeled "HIT HERE"** with a pulsing arrow for the first 3 bites, then the label disappears. By bite 4 the player has muscle memory.

Your design doc (line 555–564) gets this right almost verbatim. Hold the line.

### The hook moment

10 seconds in, the player should be:
- Looking at George Shea standing directly in front of them
- Seeing one giant "FREE CONTEST" sign with a blinking arrow
- Hearing the carnival music
- Seeing other players (or NPCs) walking around the boardwalk in the distance

60 seconds in, the player should have:
- Completed their first bite
- Heard the satisfying ring-hit sound
- Seen the "+1 DOG" floating number
- Watched their fill meter climb

5 minutes in, the player should have:
- Won (or nearly won) their first contest
- Bought their first stat upgrade
- Seen the next-tier arena from a distance
- Made their next goal: 10 wins to unlock Tier 2

10 minutes in, the player should have:
- Played 4–5 contests
- Bought 2–3 upgrades
- Felt distinctly stronger
- Tried at least one mini-game

If they're still around at 10 minutes, they're a Day 7 candidate.

### The 15-minute monetization gate

Your CLAUDE.md rule "No monetization UI before 15 min of play" is good and conservative. The [Roblox onboarding doc and Spaceport's hook guide both recommend at minimum 5–10 minutes before any paid UI shows up](https://www.spaceport.xyz/blog/how-to-hook-players-in-the-first-2-minutes-game-retention-tips-for-roblox-devs). 15 is on the safe end.

**But**: when the first monetization UI shows up at 15:00, it must be *contextual*. Not "BUY VIP NOW." The right pattern:
- Player wins their 5th contest. Result screen has a small "VIEW COSMETICS" tab.
- They click it, see the cosmetic shop, see a fun outfit, *then* see the price.
- VIP shows up only after the player has interacted with the cosmetic shop at least twice.

This is the [Brookhaven path: cosmetics drive social aspiration, then the buy decision](https://www.themetakey.com/news/brookhaven-robloxs-biggest-game). Never push the buy. Let the buy push the player.

### Verdict for Q6

- **Rig contests 1, 2, 3** as scaling difficulty from 95% → 75% → 50% win probability.
- **Visual contextual hints only.** No text walls. One George Shea line per beat.
- **First skill check labeled, fades by bite 4.**
- **Monetization gate at 15 min, cosmetic-led discovery first, VIP introduced only after 2+ cosmetic browses.**
- **Hook moment: free contest sign + announcer NPC at spawn, blocking other paths via transparent barrier.**

**Sources for Q6:**
- [Onboarding Techniques — Roblox Creator Docs](https://create.roblox.com/docs/production/game-design/onboarding-techniques)
- [Onboarding — Roblox Creator Docs](https://create.roblox.com/docs/production/game-design/onboarding)
- [How to Hook Players in the First 2 Minutes — Spaceport](https://www.spaceport.xyz/blog/how-to-hook-players-in-the-first-2-minutes-game-retention-tips-for-roblox-devs)
- [Improving Onboarding through Funnel Events — Roblox Staff](https://devforum.roblox.com/t/improving-onboarding-through-funnel-events/3064458)

---

## 8. Q7 — Social mechanics

### Friends and parties

[Roblox's official Party feature](https://www.gamespot.com/articles/roblox-party-features-explained/1100-6534398/) lets up to 6 players join the same experience together, cross-device. This is the single biggest social hook on the platform — players who play with friends [retain 3–5× better than solo players](https://bloxg.com/guides/roblox-player-retention).

**For your game, the high-value social features are:**
1. **"Play with friends" queue** — if a friend is in the server, join their next contest as a guaranteed seat (push them or an NPC out of seat 4).
2. **Friends weekly leaderboard** — most contests won this week, friends-only.
3. **Spectate friend** — find a friend's server, watch them play in the arena window.

What you don't need to build:
1. Custom party matchmaking (Roblox does this)
2. Voice chat (privacy/age compliance nightmare)
3. Direct messaging (Roblox does this)

### Guilds / teams

**Skip for v1.** Guilds are a high-effort feature with limited payoff in a contest game. The Tag Team contest format (already in your design) is enough team play. Guild systems make sense in long-term simulators (Bee Swarm has them sort of) but not in a 90-second contest game.

If guilds ever become necessary it's because you've added a guild-leaderboard format, which is itself a 3-month build. Defer.

### Trading

**Skip entirely. Forever.** Or at minimum, until you have 50K DAU.

Reasons to skip trading:
- [Trading is the #1 vector for scams on Roblox](https://www.techtimes.com/articles/312739/20251117/roblox-trading-guide-2025-how-trade-items-safely-avoid-scams-online.htm)
- It creates a parallel economy you have to police
- It opens duplication exploits (game-killer category bugs)
- The supply curve is hard to manage — items lose value, players quit
- For cosmetic-only items, trading is "just for show" and rarely retains players the way Adopt Me's high-stakes pet trading does

Adopt Me made trading work because the *trade* IS the game. For you, the *contest* is the game. Trading is a distraction at best.

### Spectator system

Your design doc puts spectator on the "deferred" list. Let's evaluate the cost/benefit of building it.

**Arguments for spectator (per your design doc, lines 460–487):**
- Converts DQ'd players into engaged crowd participants — reduces quit rate
- Crowd Meter mechanic gives spectators agency
- "Throw food" + "Wave signs" are fun mini-actions
- Unique selling point ("turns viewers into players")

**Arguments against:**
- Adds 2-3 weeks of additional client + server scripting
- Forces you to design Crowd Meter mechanics, which then affect contest outcomes (potential balance bugs)
- Untested mechanic on Roblox — high risk, high reward
- Most successful Roblox games don't have spectator mode beyond a basic "watch a friend" view

**My recommendation:** Ship spectator in the *minimal* form for v1:
- DQ'd players become free cameras above the arena.
- They get a "+1 Cheer" button per round (15s cooldown) that adds nothing mechanical but shows a cheer animation in 3D.
- Cheering pays the spectator 5 coins per round (sticks around).

Skip Crowd Meter mechanics, skip "throw food," skip the elaborate sign system. Add them in v1.5 if the simple version creates the engagement loop you want. The complex version is a Phase 2 build, not a launch feature.

### Verdict for Q7

- **Build "join friend's contest" using Roblox's party system.**
- **Build friends-weekly leaderboard.** This alone is huge.
- **Build minimal spectator: free camera + cheer button for DQ'd players.**
- **Skip guilds.**
- **Skip trading.** Forever, or until 50K DAU.
- **Skip the full Crowd Meter / throw food spectator system at launch.** Defer to v1.5.

**Sources for Q7:**
- [Roblox Party Features Explained — GameSpot](https://www.gamespot.com/articles/roblox-party-features-explained/1100-6534398/)
- [Roblox Player Retention Strategies — BLOXG](https://bloxg.com/guides/roblox-player-retention)
- [Roblox Trading Guide 2025 — TechTimes](https://www.techtimes.com/articles/312739/20251117/roblox-trading-guide-2025-how-trade-items-safely-avoid-scams-online.htm)
- [Designing a Trading System for Your Roblox — creation.dev](https://www.creation.dev/blog/roblox-trading-system-design)
- [How to Make a Spectate! — DevForum](https://devforum.roblox.com/t/how-to-make-a-spectate/606352)

---

## 9. Q8 — Content velocity and cadence

### What the 2026 meta requires

[Update cadence is the strongest predictor of retention](https://studiokrew.com/blog/top-games-on-roblox-and-analysis-2026/). The games that hold their player counts ship meaningful content monthly at minimum. The games that die (Shindo Life, Project Slayers, Anime Adventures in early 2026) stopped updating.

Specific cadences working in 2026:
- **Weekly micro-events** — a rotated contest format, a new daily challenge set, a 7-day cosmetic. Bee Swarm Simulator does this.
- **Bi-weekly content drops** — a new food / arena / NPC. Sustainable for a small team.
- **Monthly major drop** — a new tier, a new format, a new event arc.
- **Quarterly seasonal arc** — a major themed event, exclusive cosmetics, lore/story beat.

The brutal truth: **[LiveOps isn't optional in 2026](https://bloxg.com/problems/roblox-game-losing-players-weekly)**. If you publish your game and walk away for two weeks, the players walk away too.

### What this means for you as a solo dev

You can't ship weekly. You can probably ship:
- **Weekly rotation of in-engine config** (which contest format is featured, what the daily challenges are, which cosmetic is featured) — this should require *zero* code changes after you build the rotation system once.
- **Monthly real content drop** — a new food, a new NPC, a balance pass.
- **Quarterly seasonal arc** — 7–14 day themed event with exclusive cosmetic.

The way to make this work without burning out is **data-driven LiveOps**. Build the systems so 80% of "new content" is just a new row in a ModuleScript table — new food = new entry in a food table that already maps to existing minigame types.

The corollary: **don't add new minigame types as content drops**. Add new foods that reuse existing minigame types. A "Holiday Ham" food can ship in 10 minutes as a Donut variant with new art. A "Frozen Custard" food can ship as a Spray Cheese variant.

If every food required a new minigame, your cadence is gated by your slowest engineering task. If foods are data + art, your cadence is gated by how fast you can configure them.

### Event-driven vs evergreen

You want both:
- **Evergreen core**: the contest, the stat upgrades, the 4 tiers, the prestige system. Always there. Doesn't need updates.
- **Event-driven layer**: seasonal events, weekly featured format, monthly new NPC. This is where new players see "this game is alive."

The Naavik report on UGC games notes that successful 2025–2026 Roblox games "tap into evergreen play patterns" but layer events on top.

### The "live game" expectation

**Yes, you're signing up for permanent operations.** This is the part most beginners don't understand until they hit it. A Roblox game in 2026 is not a project; it's a service.

Realistically, that means:
- 4–8 hours/week of LiveOps (configuring weekly content, watching analytics, responding to forum posts)
- 8–16 hours/week of feature/content work (assuming you're not also working a day job)
- Anti-cheat patches as they're needed (cheating tools update faster than your game)

If you can't sustain ~16 hours/week post-launch, ship a smaller game and treat it as evergreen with quarterly updates only. Better to ship a small, complete game than a half-built game that bleeds out.

### Verdict for Q8

- **Build data-driven content system before launch.** ModuleScript tables for foods, NPCs, daily challenges, events. New content = new row.
- **Plan for: weekly rotation, monthly content drop, quarterly seasonal arc.**
- **Don't ship new minigame types after launch. Only new foods/skins on existing types.**
- **Accept that this is a long-term commitment.** Or scope it as a quarterly-only-update game.

**Sources for Q8:**
- [Content updates — Roblox Creator Docs](https://create.roblox.com/docs/production/game-design/content-updates)
- [Top Roblox Games 2026 — StudioKrew](https://studiokrew.com/blog/top-games-on-roblox-and-analysis-2026/)
- [Roblox Game Losing Players Every Week — BLOXG](https://bloxg.com/problems/roblox-game-losing-players-weekly)
- [The State of UGC Games (2025) — Naavik](https://naavik.co/deep-dives/the-state-of-ugc-games-2025-deep-dive/)

---

## 10. Q9 — Comparable successes and failures

### Successes to study

#### Bee Swarm Simulator
- **Loop:** PvE collection + light social + seasonal events
- **What works:** [50+ bee types, gifted bees as long-term hook, marathon-not-sprint pacing](https://romonitorstats.com/experience/1537690962/), heavy reliance on quests for progression structure
- **What to steal:** the "quests drive progression" design — give players a checklist of next-things-to-do that always includes both easy and aspirational items.

#### Anime Vanguards
- **Loop:** Tower defense + gacha + roster collection
- **What works:** [polished UI, regular content updates with weekly events, hybrid genre](https://shapes.inc/fandom/anime-vanguards)
- **What to steal:** the **roster-of-named-characters** is your NPC personalities. Treat your 12 NPCs (Jaws, Tsunami, MIKI, Widow, etc.) like Anime Vanguards treats its units — each has a signature move, a flavor blurb, a specific visual.

#### Steal a Brainrot
- **Loop:** Tycoon income + low-stakes PvP + meme-driven cosmetics
- **What works:** [60+ billion visits because the loop is fast and self-contained — 10 minute sessions, mobile-first](https://www.lootbar.com/blog/en/steal-a-brainrot-roblox-top-charts.html)
- **What to steal:** the **short session length**. A contest is 90 seconds. A play session can be 10 minutes (5–6 contests). Don't design for long sessions.

#### Fisch
- **Loop:** PvE fishing skill check + collection + progression
- **What works:** [skill check minigame with depth, bait/rod stats compress difficulty without erasing it, regular new fish releases](https://fischipedia.org/wiki/Fishing)
- **What to steal:** the **stat-as-modifier** pattern (your design already does this). Also: the "perfect catch" bonus for keeping the bar inside the entire duration — your "Great Zone" mirrors this.

#### Dress to Impress
- **Loop:** Async-PvP themed rounds + cosmetic collection
- **What works:** themed rounds create infinite content from finite assets. 8 players, 3-minute rounds, peer voting.
- **What to steal:** the **themed contest format** — Tag Team, Speed, Endurance, Spicy etc. are already in your design. Make sure the rotation pattern is data-driven so you can add "All-Mayo Sunday" as a one-line config change.

#### Brookhaven
- **Loop:** Roleplay sandbox + cosmetic monetization
- **What works:** [monetizes via cosmetic gamepasses (vehicles, houses) without paying to win](https://www.themetakey.com/news/brookhaven-robloxs-biggest-game)
- **What to steal:** the **cosmetic-as-status** monetization approach. Your Mustard Belt is your equivalent of a Brookhaven house.

### Failures to study

#### Blob Eating Simulator (your own GAME_DESIGN.md notes it died at 0 CCU after 23M visits)
- **Why it died:** Direct PvP eating contest + no NPC backfill. When the population dropped, lobbies stayed empty, new players bounced.
- **Lesson:** PvE-first with NPC backfill is non-negotiable. Your design already does this. Don't reverse the call.

#### Mine Racer (your GAME_DESIGN.md mentions, 4M+ visits but lost integrity)
- **Why it failed:** Sold auto-tap as a Robux gamepass. Destroyed competitive integrity. Casual players quit because winning required spending.
- **Lesson:** Never sell speed boosts or input automation. Your design rule against this is correct.

#### Shindo Life (per [studiokrew](https://studiokrew.com/blog/top-games-on-roblox-and-analysis-2026/))
- **Why it cratered:** Update cadence stopped. CCU collapsed from peak to 1,200–2,200.
- **Lesson:** LiveOps cadence is the game.

#### Junk Food Simulator (your GAME_DESIGN.md notes 61% rating)
- **Why it underperformed:** Passive gameplay — equip gear, watch stat go up. No skill expression.
- **Lesson:** Your skill check minigames are exactly the antidote.

### Food-themed games on Roblox specifically

I searched extensively and the food-themed Roblox space is dominated by *cooking* games, not eating games. [Hot Pot Restaurant (88% rating, 7.1M players)](https://bloxmake.com/blog/cooking-up-fun-the-best-roblox-food-games-for-foodies) and [Bangkok Dinner (94% rating, 17.9M players)](https://bloxmake.com/blog/cooking-up-fun-the-best-roblox-food-games-for-foodies) are the leaders.

This is encouraging: the cooking/food-prep theme has shown audience appetite, but the eating-contest niche is essentially uncontested. You have a clear differentiation: this isn't "cook food, serve customers" — this is "be the contestant, win the belt." That positioning is genuinely fresh.

**Sources for Q9:**
- [Bee Swarm Simulator — RoMonitor](https://romonitorstats.com/experience/1537690962/)
- [Anime Vanguards Wiki](https://animevanguards.fandom.com/wiki/Anime_Vanguards_Wiki)
- [Steal a Brainrot: 60B Visits — LootBar](https://www.lootbar.com/blog/en/steal-a-brainrot-roblox-top-charts.html)
- [Fisch Wiki Progression Guide](https://fischipedia.org/wiki/Progression_Guide)
- [Dress to Impress Monetization — RoMonitor](https://romonitorstats.com/experience/15101393044/monetization/)
- [Brookhaven Game Design Secrets — Manilla Games](https://www.manillagames.com/brookhaven-roblox-guide-game-design-secrets/)
- [Top Roblox Games 2026 — StudioKrew](https://studiokrew.com/blog/top-games-on-roblox-and-analysis-2026/)

---

## 11. My recommended design for this specific game

This is the opinionated section. I'm picking, not listing.

### Core loop: **PvE-anchored hybrid with seamless live-player drop-in**

The contest mechanic itself is unchanged. What I'm picking is the *framing*:

- **Default state**: the contest runs against 3 NPCs (the named cast). Player vs Jaws, Tsunami, MIKI is the *normal* experience. Players don't feel they're "playing alone" — they're playing against the legends.
- **When real players are present**: they replace NPCs in seats by join order. Same contest, same UI, same leaderboard sidebar. The player can't tell from outside whether seat 2 is human or AI without checking the "AI Challenger" label.
- **Population doesn't gate access.** Player can always queue. NPCs always fill. The game is fully playable solo on Day 1 of a 0-CCU server and on Year 1 of a sold-out server.

This is Bee Swarm's retention model applied to a contest format. It also kills the Blob Eating Simulator failure mode permanently.

### Skill / grind ratio: **65/35 in favor of skill at max stat**

- Stats provide up to ~2.5× difficulty compression (success arc wider, needle slower, etc.).
- Max-stat player vs maxed-skill new player: roughly 60/40 split in matches when played correctly. (Currently, per your spec, this would be closer to 90/10 in favor of max-stat. Tune down.)
- The Great Zone (perfect-hit bonus) stays narrow at all stat levels — *that's* the always-skill-expression layer.

This means the game has a real skill ceiling. A Prestige 0 player who's really good can climb the weekly leaderboards. A Prestige 5 player who's lazy will get beaten. That's the design we want.

### Currency structure: **Drop to two — Coins + Style Bucks**

- Coins = gameplay-earned, gates stats. Universal currency, single source of truth.
- Style Bucks = Robux-purchased OR slowly earned via achievements. Cosmetics only.
- **Kill Carnival Tickets.** Mini-games pay Coins. Simpler UX. Cleaner balance. More monetization flexibility.

If you want mini-games to feel rewarding without breaking the contest economy, give them lower Coin payouts than contests (5–15 vs 40–60). Mini-games stay "filler," contests stay "main."

### Monetization mix: **Cosmetic-only, but smarter**

| Item | Price (Robux) | Expected % of revenue |
|---|---|---|
| **Main VIP** (cosmetic + daily/mini-game bonuses, no contest effect) | 299 | 40% |
| **Champion's Kit** (cosmetic bundle) | 599 | 20% |
| **Showman's Pass** (announcer-NPC follower, comedic) | 199 | 10% |
| **Style Buck bundles** (small/medium/large/jumbo) | 99 / 299 / 999 / 2499 | 30% |
| Battle pass | DEFER to v2.0 | 0% at launch |

Target conversion: 1.5% at maturity. Target ARPPU: 250 Robux. At 100K visits/wk you'd see ~150K Robux/wk → ~$370/wk USD after Roblox's 30% cut and DevEx rate. Modest. At 1M visits/wk that's ~$3,700/wk, which starts to be a salary.

### Onboarding first 5 minutes: **The exact prescription**

1. **0:00–0:10** — Spawn in hub. George Shea NPC dead ahead. One blinking "FREE CONTEST" sign with arrow. Transparent barriers block all other paths. Single line: *"HEY! First contest is on me. Step up!"*
2. **0:10–0:25** — Step into queue zone → countdown skips to 3 → Arena 1 fills with named NPCs (rookie-tier). Shea panel: *"Today's food: HOT DOGS. Hit the ring when it's green."*
3. **0:25–1:55** — First contest. Difficulty 40% of max, green zone 60% wider. First 3 bites have a pulsing "HIT HERE" label on the green zone, label fades by bite 4. Player wins (95% probability).
4. **1:55–2:15** — Result screen. *"YOU WON! 60 coins."* Upgrade prompt: *"UPGRADE YOUR JAW SPEED? [50 coins] → YES / NOT NOW"*. YES is highlighted.
5. **2:15–2:30** — Upgrade fires → Shea says *"You're getting stronger!"* → barrier dissolves → player is free.
6. **2:30–5:00** — Player walks the fairground. Sees other arenas with progress bars (X/10 wins to unlock). Sees a mini-game stall light up — that's their next discoverable. Sees the cosmetic kiosk from a distance (no buy prompt yet).
7. **5:00–10:00** — Player queues another contest. Difficulty 60%. They win or come close. Earn coins. Maybe upgrade. Maybe try Skee-Ball. Decide they're playing tomorrow too.
8. **15:00** — First cosmetic shop popup appears. VIP isn't shown yet — only cosmetics.
9. **20:00** — VIP gamepass surfaces *only if* player has browsed cosmetics twice.

This is the contextual, scaffolded approach Roblox's own docs recommend. Every step earns the next.

### Update cadence target: **Weekly rotation + monthly drop**

- **Weekly**: rotated specialty contest format (Speed / Endurance / Spicy / Precision / Tag Team), rotated daily challenges, rotated featured cosmetic in the shop. All driven by ModuleScript config. Zero code changes per week.
- **Monthly**: one new content drop. Could be: a new food (using existing minigame type), a new NPC personality, a new arena event, or a new cosmetic set.
- **Quarterly**: one seasonal event arc. 7–14 days of themed content. Exclusive cosmetics. Bonus event currency / leaderboard.

### Social: **What to build, what to skip**

| Build | Skip |
|---|---|
| Friends weekly leaderboard | Guilds |
| "Join friend's contest" via Roblox party | Trading |
| Minimal spectator (free cam + cheer) | Custom messaging |
| Hub presence visibility (see who's in your server) | Voice chat |
| Player profile card on hover | Friend gifting |

### What to CUT from current scope

This is the hard part. Antoine, you've designed beautifully. But you've designed three games stacked on top of each other. The cut list:

**Cut entirely:**
- **All ride scripting beyond Carousel.** Wonder Wheel, Pirate Ship, Tilt-A-Whirl, Chair-O-Planes, Bumper Cars. They're cool, but they're three months of physics-constraint engineering and they don't move the eating-contest needle. Leave them as decorative statues for v1. Revisit if the game lands.
- **Carnival Tickets currency.** As discussed in Q3 / above.
- **Power Foods system.** Too much balance complexity in a 90s contest. Add post-launch if needed.
- **The full spectator system** (throw food, wave signs, Crowd Meter affecting outcomes). Replace with minimal version.
- **Mini-games beyond 3.** You're scoping 16. Ship 3. Pick the most fun three (my vote: Skee-Ball, Ring Toss, High Striker — three different input feels, none too complex).

**Cut for v1, build later:**
- The Bear encounter (Prestige 5 weekly boss). Build after Prestige 1 is hit by real players.
- Tier 4 arena (World Championship). Ship with 3 tiers; add Tier 4 in the v1.2 patch.
- 5 of your 7 food minigame types. Ship with Hot Dog Ring + Burger Sequential + one more (Donut Shrinking is simplest). Five total foods can reuse these three mechanics — Burger and Sloppy Joe both use sequential, etc.
- Battle pass.
- Endurance and Tag Team contest formats. Ship Capacity + one rotating (Speed). Add Endurance and Tag Team in patches.

**Keep:**
- Four-stat system as designed (with the difficulty-cap fix from Q2)
- Prestige system (build to P3 at launch; P4/P5 in patches)
- George Shea announcer (it's character — keep it cheap, text-only, ModuleScript-driven)
- NPC personalities (build 6 at launch, add the rest in patches)
- Daily challenge + login streak
- Friends weekly leaderboard
- Cosmetic shop, VIP, dev product bundles

### What the launch game looks like

**Frank's Fairground v1.0** — a focused 4-arena Coney Island boardwalk where players queue into eating contests against named NPC opponents (with seamless live-player drop-in), upgrade four stats, climb through three tiers (Diner → Regional → National), and chase weekly leaderboards. Three carnival mini-games and three rides serve as wallpaper that pays small coin bonuses. Cosmetic-only monetization through one main VIP pass, two specialty passes, and Style Buck bundles. Daily login streak, weekly format rotation, and one prestige tier built. Ships at maybe 35% of the design doc by surface area — but every shipped feature is *polished*, not stubbed.

If the launch lands, you've earned the right to build Tier 4, The Bear, the full spectator system, and the ride simulator. If it doesn't, you've shipped a clean game you can be proud of in 3 months instead of 12.

---

## 12. Top 5 decisions to make this week

Antoine — pick yes or no on each of these by end of week. The longer they sit open, the more build time you waste building both sides of the fork.

### Decision 1: Cut Tier 4 and The Bear from launch scope. Yes / no.
*Implication if yes:* You ship in 1/3 the time. You save Tier 4 as a v1.1 patch carrot for players who hit Tier 3. You don't build The Bear until Prestige 5 exists in the wild.
*Implication if no:* You're committing to a ~9-month build before public launch. Justify why.

### Decision 2: Drop Carnival Tickets currency. Yes / no.
*Implication if yes:* You collapse to Coins + Style Bucks. Mini-games pay Coins (lower rate than contests). UX cleaner, monetization simpler, balance easier.
*Implication if no:* Document precisely what Tickets do that Coins can't, and why the cost of a parallel economy is worth that uniqueness.

### Decision 3: Reduce maxed-stat advantage from ~6× to ~2.5×. Yes / no.
*Implication if yes:* The game stays skill-expressive at all levels. A fresh Prestige 0 player has a real chance against a Prestige 2. Weekly leaderboards stay competitive.
*Implication if no:* Whales steamroll new players. Retention craters. Same failure mode as Pet Sim 99's whale-domination problem.

### Decision 4: Ship rides as decorative statues, not as scripted attractions. Yes / no.
*Implication if yes:* Save 6–10 weeks of physics-constraint debugging. Rides exist visually, look impressive in screenshots, don't gate launch.
*Implication if no:* Ride scripting becomes your launch critical path. The eating contest waits. The whole game waits. Don't.

### Decision 5: Commit to a public launch date 8 weeks from today. Yes / no.
*Implication if yes:* Everything from this doc gets cut or scoped to fit. You ship something instead of polishing forever. Friends-only soft launch in week 6, public in week 8.
*Implication if no:* Pick a different date and put it on your calendar. The most common solo-dev failure mode on Roblox is "ship later, polish forever, never publish." Don't.

---

*Document built from sources cited inline. Reflects the Roblox landscape as of May 2026. Tooled for one human reader: Antoine, building Frank's Fairground.*
