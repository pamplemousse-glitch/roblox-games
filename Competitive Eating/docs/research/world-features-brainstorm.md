# Food World Expansion Brainstorm — Frank's Fairground

*A creative menu (not a plan) for expanding the Frank's Fairground world beyond the current Coney Island boardwalk concept. Aimed at the moment you've shipped Tier 1 and want to know what could come next. Browse, cherry-pick, mash up. Curated picks are at the bottom.*

> **Direction it assumes:** [Frank's Fairground](./design-concept-menu.md#concept-1--franks-fairground-coney-island-belle-époque) is the anchor (Belle-Époque carnival, named NPC eaters, rides re-themed as food). Everything in this doc plugs into that world or proposes the next district outward.
>
> **What this doc is NOT:** a build queue, a sprint plan, or an architecture decision. It's a creative buffet. The [gameplay deep-dive](./gameplay-design-deep-dive.md) is still the source of truth for what to actually ship next.

---

## Table of Contents

1. [Buildings to add to Frank's Fairground](#part-1--buildings-to-add-to-franks-fairground)
2. [District expansion beyond the boardwalk](#part-2--district-expansion-beyond-the-boardwalk)
3. [New mini-game types](#part-3--new-mini-game-types)
4. [NPC archetypes, vendors, rivals](#part-4--npc-archetypes-vendors-and-rivals)
5. [Events, seasonal content, recurring storylines](#part-5--events-and-seasonal-content)
6. [Mechanics stolen from food media](#part-6--mechanics-stolen-from-food-media)
7. [Cosmetic categories](#part-7--cosmetic-categories)
8. [Social and community features](#part-8--social-and-community-features)
9. [Crazy / risky ideas](#part-9--crazy--risky-ideas)
10. [Antoine's top 20 picks (curated)](#part-10--antoines-top-20-picks-curated)

---

# Part 1 — Buildings to add to Frank's Fairground

Cost legend: **XS** = couple hours of greybox + 1 service hook. **S** = half-day build. **M** = ~1-2 day build, light scripting. **L** = multi-day build, real systems, networked state.

> Inspiration sources pulled throughout: [Nathan's Famous contest history](https://en.wikipedia.org/wiki/Nathan's_Hot_Dog_Eating_Contest), [Charlie & the Chocolate Factory's room-as-character design](https://parametric-architecture.com/architectural-look-inside-willy-wonkas-world/), [Spirited Away's food market](https://www.tofugu.com/japan/spirited-away-food/), [Mineko's Night Market](https://store.steampowered.com/app/762940/Minekos_Night_Market/), and [Spiritfarer's comfort-food kitchen](https://spiritfarer.fandom.com/wiki/Cooking).

## 1A. Contest venues (alternate arena types)

| # | Name | What it is | Mechanical hook | Audience | Cost | Source |
|---|---|---|---|---|---|---|
| 1 | **The Iron Booth** | A 6-seat oval booth where the contest food is randomized at countdown. Mystery-box reveal animation. | Borrows [Iron Chef's mystery-ingredient](https://www.executivechefevents.com/iron-chef-mystery-boxes) drama; player who guessed the food on the way in (single-button "what's tonight?" prediction kiosk outside) gets +10% Crowd Meter start. | Replayability hunters | M | Iron Chef |
| 2 | **Tag Team Tent** | Striped circus tent for 2v2 contests with shared fill meter. | Existing Tag Team format gets a dedicated visual home; queue UI lets you matchmake by friend invite. | Friend groups | M | Tag Team format already speced |
| 3 | **The Pity Pit** | Sunken arena for last-placed players to enter a consolation contest with the day's other 4th-place finishers. | The "8th place rule" of state fairs — last place gets a small prize so nobody leaves embarrassed. | Lapsed/retention | S | State fair tradition |
| 4 | **The Cage Match** | Wire-fence arena, two players only, identical fill meters, no NPC fill. | Pure 1v1 ranked PvP for prestige players. Smaller crowd, single overhead light, gladiatorial. | High-prestige | M | WWE / MMA framing |
| 5 | **The Endurance Arena** | Long table that visibly stretches across the boardwalk — 8 seats, 4-minute contests. | Endurance format gets gravity from sheer table length. The longer you sit, the more painful it looks. | Hardcore | M | Marathon eating |
| 6 | **The Speed Strip** | Drag-strip-shaped narrow arena. Whoever finishes 7 dogs first wins. | Pure Speed format, with a literal finish line that sweeps in as players finish. | Sprint/casual | S | Drag racing |
| 7 | **The Roast Hall** | Booth where George Shea roasts the player who lost worst, broadcast to all spectators. | Comedic dunk tank. Spectators react with emotes. Lost player gets a tiny coin prize for taking it. | Comedy/community | M | Comedy roasts |
| 8 | **The Stairwell Showdown** | 4-story scaffold with a contest seat on each floor. | Tier-mixed contests: each player is at their tier's seat. Visible bracket. Crowd watches all 4 at once. | Mid-game | L | Cuphead boss-tower |
| 9 | **The Trial of the Bear** | A golden private booth, already in design. | Existing P5-gated weekly Bear fight. | P5 endgame | already speced | already speced |
| 10 | **The Underground Speakeasy** | A hidden cellar arena — entrance through a phone booth or via password to bouncer NPC. | Discoverable secret arena; once-per-week format with weird food (mystery taco, etc.) | Discovery | M | [Disco Elysium's dialog](https://www.oreateai.com/blog/beyond-the-dice-roll-understanding-disco-elysiums-unique-skill-checks/39f4f589c2a7441b60b488c0b1896bd0)-style entry checks |

## 1B. Training facilities (where players grind stats)

| # | Name | What it is | Mechanical hook | Audience | Cost | Source |
|---|---|---|---|---|---|---|
| 11 | **The Water Lock-Up Gym** | A tiled chamber with a giant water cooler. Hold a button to chug. | Stomach training mini-game. 10s tap-and-hold rhythm earns coins, mirrors [Kobayashi's water loading](https://econlife.com/2023/07/competitive-eating-3/). | All | S | Real MLE training |
| 12 | **The Jaw Garage** | A grease-monkey-style garage with a giant gum-chew machine. | Jaw Speed mini-game; click on the beat for 30s. | All | S | MLE gum training |
| 13 | **The Focus Dojo** | Zen rock garden tucked behind the fairground. NPC monk teaches breathing. | Focus mini-game: hold a target inside a moving zone for 20s. Mirrors [Disco Elysium](https://www.oreateai.com/blog/beyond-the-dice-roll-understanding-disco-elysiums-unique-skill-checks/39f4f589c2a7441b60b488c0b1896bd0)-style inner-voice flavor text from "Stomach," "Jaw," "Throat," "Mind" as you train. | Comedic/all | M | Disco Elysium / MLE hypnotherapy |
| 14 | **The Throat Spa** | A pastel-pink wellness lounge with a swallow-rhythm machine. | Swallow Rate mini-game. Aesthetic flex on TikTok. | Adopt Me demo | S | Mukbang ASMR culture |
| 15 | **The Heat Room** | A red sauna with a Scoville-tracking thermometer. | Buy a single spice tolerance bonus per day; survive a 15-second hold for a daily Spicy contest +5% buff. | All | S | Hot Ones culture |
| 16 | **The Cold Plunge** | A reverse spa. Ice tub for chipmunk recovery training. | Stomach Capacity stretch session (daily quest). | All | XS | Ice-bath bro culture |
| 17 | **The Mirror Gym** | A wall of mirrors where you watch yourself eat in slow-mo replay. | Cosmetic flex space + replay viewer (re-watch your last contest). | Highlight reel | M | Sports film rooms |
| 18 | **The Lecture Hall** | A small auditorium where a Professor NPC delivers ridiculous eating-science lectures. | Daily "lesson" gives +5% Crowd Meter start for 3 contests. | Lore/comedy | S | The Professor NPC |

## 1C. Cosmetic shops (themed boutiques)

| # | Name | What it sells | Mechanical hook | Audience | Cost | Source |
|---|---|---|---|---|---|---|
| 19 | **Whiskers' Haberdashery** | Top hats, monocles, mustaches | Belle-Époque cosmetic flex | DTI demo | S | Belle-Époque |
| 20 | **The Mustard Boutique** | Belt color skins and prestige auras | Endgame flex | P3+ | S | Mustard Belt |
| 21 | **Face Paint Atelier** | Custom face paint in [Eater X's](https://en.wikipedia.org/wiki/Nathan's_Hot_Dog_Eating_Contest) elaborate style | Tier 3 unlock | Teen flex | S | Eater X |
| 22 | **The Costume Closet** | Full-body food costumes (hot dog suit, taco suit) | Avatar economy play | Kid casual | M | Cuphead-style anthropo food |
| 23 | **The Sound Studio** | Bite-sound packs (ASMR, opera, cartoon, robot) | Audio cosmetic | ASMR/mukbang fans | S | Mukbang aesthetic |
| 24 | **The Trail Shop** | Particle trails (sprinkles, ketchup drip, neon) | Cosmetic | All | S | Trail meta |
| 25 | **The Emote Booth** | Reaction emotes (foodgasm, faint, kiss-the-fingers) | Cosmetic | All | M | [Food Wars foodgasm trope](https://tvtropes.org/pmwiki/pmwiki.php/Manga/FoodWars) |
| 26 | **The Tattoo Parlor** | Belly tattoos visible during chipmunk window | Cosmetic flex | Teen | S | Tattoo meta |

## 1D. NPC homes and hangouts

| # | Name | What it is | Mechanical hook | Audience | Cost | Source |
|---|---|---|---|---|---|---|
| 27 | **The Jaws' Trailer** | American-flag-painted Airstream parked behind Arena 4 | Daily visit for trash talk dialog, no rewards | Lore | XS | Joey Chestnut character |
| 28 | **The Tsunami's Tea House** | Wooden tea house with a pre-contest haiku board | Read today's haiku for +5 Focus on next contest | Lore/quest | S | Kobayashi character |
| 29 | **The Widow's Parlor** | Victorian sitting room with skull motifs | Riddle quest weekly | Lore | M | The Black Widow |
| 30 | **The Showman's Carnival Wagon** | Caravan painted in circus pinstripes | Showman gives daily "performance" tip | Lore | S | Crazy Legs Conti |
| 31 | **The Professor's Lab** | Small white-walled study with whiteboards full of "eating physics" | Whiteboards rotate weekly with new pseudo-equations | Lore/comedy | S | The Professor NPC |
| 32 | **Grandma's Cottage** | A literal cottage with a smoking chimney off the boardwalk | Grandma gives you a sandwich for a +10% next-contest Stomach buff | Cozy | S | The Grandma NPC |

## 1E. Lore / discovery buildings

| # | Name | What it is | Mechanical hook | Audience | Cost | Source |
|---|---|---|---|---|---|---|
| 33 | **The Hall of Fame** | Marble-floor museum with statues of legendary NPCs | Read plaques for in-world history. Plaques unlock as you beat each NPC. | Completionists | M | [Nathan's Hall of Fame](https://en.wikipedia.org/wiki/Nathan's_Hot_Dog_Eating_Contest) |
| 34 | **The Mustard Belt Vault** | Glass-cased display of every belt color earned | Personal trophy room. Visitors can see your collection. | Flex | M | Mustard Belt traditions |
| 35 | **The Ghost of the Glutton King** | A "haunted" booth in the corner where a translucent NPC tells stories of pre-1970s eaters | Lore vignettes that unlock new George Shea announcer lines | Adult ironic | M | Coney Island history |
| 36 | **The Statue Garden** | An outdoor garden of bronze statues of every NPC | A daily "rub the statue for luck" interaction | Casual | S | State fair traditions |
| 37 | **The Sourdough Scroll Library** | A tiny library of in-world "lore books" — fictional cookbooks, eater memoirs | Book collectible meta — collect 25 to unlock a hidden contest | Discovery | M | Hidden lore collectibles |
| 38 | **The Big Wheel Time Capsule** | A capsule under the Big Wheel — opens once per real-world year | Annually rotating cosmetic drop | Anniversary | S | Time capsule trope |
| 39 | **The Madame Petite Tent** | Fortune teller. Cards = daily horoscope. | "Today's lucky food: hot dog. Eating hot dogs gives +5% Crowd start." | Cozy/daily | S | Belle-Époque fortune teller |

## 1F. Functional buildings (vault, post office, casino)

| # | Name | What it is | Mechanical hook | Audience | Cost | Source |
|---|---|---|---|---|---|---|
| 40 | **The Vault** | A bank-style building where players can store coins safely with friends | Shared friend-vault for cooperative goal-saving | Friend groups | L | Bee Swarm club concept |
| 41 | **The Post Office** | NPC-run mail building | "Mail to NPC" interactions (Section 8 social feature) | Social/RP | M | Mineko's Night Market |
| 42 | **The Gambling Hall** | Vintage casino tent — coin-flip "double or nothing" on contest winnings | Risk/reward mini-economy. Capped per day to prevent abuse. | Teen/risk | M | Vegas / state fair |
| 43 | **The Pawn Shop** | Sell duplicate cosmetics for Style Bucks | Cosmetic economy lubricant | All | M | RPG vendor convention |
| 44 | **The Bus Depot** | Where new NPCs "arrive" weekly | Visible weekly content drop — players see new NPC exit a stagecoach | Retention | S | Pet Sim weekly drops |
| 45 | **The Health Tent** | EMT-themed tent that revives DQ'd players faster | -50% post-DQ cooldown if you visit the tent. Real Nathan's has an [EMT on site](https://majorleagueeating.com/july4th/). | Quality-of-life | XS | Real MLE |

## 1G. Themed restaurants (each with a unique gimmick)

These are NOT contest arenas. They're hangout spaces with single mini-game gimmicks. Stand-alone fun.

| # | Name | What it is | Gimmick | Audience | Cost | Source |
|---|---|---|---|---|---|---|
| 46 | **The Slurp Lounge** | Ramen counter | Pay 5 coins, play a slurp rhythm mini, win a cosmetic ticket | Cozy | M | Tampopo |
| 47 | **The Ice Cream Parlor** | Pastel sundae bar | Build-a-sundae mini, photo mode lets you photograph it | DTI demo | M | Cooking Mama |
| 48 | **The Sushi Conveyor** | Conveyor belt sushi bar | Tap-to-grab timing mini for cosmetic tickets | All | M | Conveyor belt sushi |
| 49 | **The Diner Counter** | Chrome-and-vinyl 50s diner | Jukebox lets you play a song; coffee +5% next-contest Focus | Cozy | M | Route 66 / [Retro Diner](https://retro-diner.fandom.com/wiki/Retro_Diner) |
| 50 | **The Tea Ceremony Pavilion** | Quiet wood pavilion | Precision-pour mini for Focus stat training | Cozy | M | Spirited Away |
| 51 | **The Hot Pepper Bar** | Spice rack with Scoville scale wall | Hot-pepper roulette mini — risk for big Style Buck reward | Risk/comedy | M | Hot Ones |
| 52 | **The Speakeasy Soup Club** | Velvet-curtained underground | Soup-of-the-day rotates daily, gives micro-buff | Discovery | M | The Bear ambience |
| 53 | **The Bakery** | Croissant-shaped building | Buy a daily lottery-pastry — 1-in-100 chance of a rare cosmetic | Daily | S | Bakery culture |
| 54 | **The Mukbang Studio** | Brightly-lit ring-light booth | Sit, eat for the camera, get viewer-tip coins from NPC viewers | Niche/funny | M | [Mukbang culture](https://en.wikipedia.org/wiki/Mukbang) |
| 55 | **The Soft-Serve Stand** | Pastel kiosk | One-tap ice cream, cools your fill meter by 5% next contest | Casual | S | Carnival classic |
| 56 | **The Funnel Cake Window** | Window-only stand | Powdered-sugar-trail cosmetic of the day | Daily flex | S | [State fair classic](https://everafterinthewoods.com/deepfried-delights-to-enjoy-at-state-fairs-across-the-u-s/) |
| 57 | **The Deep-Fried Anything Stand** | Big vat with rotating menu (fried butter, fried bubble gum, fried Oreo, fried Coke) | Weekly mystery fried item gives a one-day mystery buff | Discovery | M | [Deep-fried fair tradition](https://wicproject.com/food/14-state-fair-fried-foods-that-go-way-too-far/) |

## 1H. Mini-game stalls (beyond the existing 5)

| # | Name | Mechanic | Tier prize | Cost |
|---|---|---|---|---|
| 58 | **Watermelon Seed Spit** | Aim and hold to charge, release | Plush watermelon pet | S |
| 59 | **The Strongman Eater** | Hold-and-release timing, but for a giant hot-dog squat | Strongman cosmetic | S |
| 60 | **The Coin Push** | Classic arcade coin pusher | Coin/ticket payout | M |
| 61 | **Ladle Catch** | Catch ladles of soup as they fly off a stove | Apron cosmetic | S |
| 62 | **Pie Toss** | Throw pies at a clown NPC | Pie pet | S |
| 63 | **Whack-a-Frank** | Whack-a-mole with hot dogs | Mole pet | S |
| 64 | **Catch the Fortune Cookie** | Net falling cookies | Daily fortune dialog | S |
| 65 | **The Yarn Pull** | Pull a string to reveal a prize. Always wins. | Daily participation | XS |

## 1I. Memorial / seasonal structures

| # | Name | What it is | Cost |
|---|---|---|---|
| 66 | **The Memorial Statue** | A bronze statue of the highest-record-holder of the week — auto-replaces weekly | M |
| 67 | **The Founder's Booth** | A roped-off booth that's "always reserved for Frank himself" — never sit-able. Lore. | XS |
| 68 | **The Tree of Belts** | A literal tree where every prestige belt earned by anyone in the server hangs as a leaf | L |
| 69 | **The Wall of Flavor** | A graffiti wall players can leave one-line messages on (filtered) | M |
| 70 | **The Eternal Flame Grill** | A grill that's "been lit since 1903." Players can throw a coin in for luck. | XS |

## 1J. Player-housing options

Aim: light, social, no-grind housing. Not Bloxburg-deep.

| # | Name | What it is | Cost |
|---|---|---|---|
| 71 | **Boardwalk Booth** | Small named-plaque booth you rent for 100 coins/week. Holds 1 trophy display. | M |
| 72 | **The Backstage Cabin** | A 4-wall single-room cabin behind the arenas. Place 5 trophies. | L |
| 73 | **The Beach Hut** | A tiny hut on the sand. Pets idle outside. | L |
| 74 | **The Penthouse Skybox** | Inside the Sky Tower. P3+ unlock. | L |

## 1K. Easter-egg / hidden buildings

| # | Name | What it is | Cost |
|---|---|---|---|
| 75 | **The Sewer Buffet** | Hidden entrance behind the funnel cake stand. Sentient rat NPC runs an underground feast. (Ratatouille reference.) | M |
| 76 | **The Carnival Mirror Maze** | A maze of funhouse mirrors. Solve it once for an exclusive trail. | M |
| 77 | **The Toaster Cult Shrine** | Tiny shrine in a corner: a toaster on a pedestal. Worship for the laugh. | XS |
| 78 | **The Phone Booth Portal** | A red phone booth that, once per week, teleports you to a one-room mystery contest. | M |
| 79 | **The Ghost Train Caboose** | An abandoned train car. Inside: an NPC who only speaks to players above P3. | M |
| 80 | **The Cardboard Box Cookoff** | A literal cardboard box. Crawl in for a 30-second timed quest with a guaranteed coin reward. | XS |

---

# Part 2 — District expansion (beyond Hot Dog Boardwalk)

> The base concept doc [already names a few of these](./design-concept-menu.md). I'm restating them briefly, then expanding with new districts that fit the Frank's Fairground belle-époque-meets-eating-mecca framing. Districts are designed to be modular — ship one per quarter as a content drop.

Cost legend per district: **M** = ~3-4 week content drop, **L** = ~6-8 week content drop.

## District 1 — Pizza Plaza (existing concept, expanded)

- **Theme:** Sun-faded Italian piazza off the boardwalk; cobblestones, terra-cotta roofs, fountain shaped like a giant tomato can. A flatscreen TV plays soccer in every shop. Inspired by [Pizza Tower's pizza-monsters aesthetic](https://store.steampowered.com/app/2231450/Pizza_Tower/) but dialed back to "warm Sunday market" rather than gross-out.
- **Unlock:** 25 Tier-2 wins.
- **Buildings:** Nonna's Brick Oven (Tier 2 contest), Slice Lounge (hangout), The Calzone Cathedral (lore + statue garden), Pesto Bar (cosmetic shop), The Anchovy Underground (speakeasy).
- **NPCs:** **Nonna Margherita** (gives quests, scolds you in Italian), **Tony Pepperoni** (rival eater, slicks his hair back), **Father Calzone** (priestly NPC who blesses every contest), **The Soufflé Princess** (cameo).
- **Signature food:** Whole Pizzas (Tier 2 contest food).
- **Cost:** L

## District 2 — Donut Dynasty (existing concept, expanded)

- **Theme:** Imperial Chinese palace silhouette but every column is a giant donut. Lantern strings made of donut holes. Strong [Charlie & the Chocolate Factory candy-room](https://parametric-architecture.com/architectural-look-inside-willy-wonkas-world/) influence on architecture (oversized, vaguely edible, intentionally absurd).
- **Unlock:** 50 wins.
- **Buildings:** Donut Throne Room (Tier 3 contest), The Glaze Geyser (Spicy variant — molten sugar instead of pepper), The Hole (a literal hole in the ground that drops you into a single-bite quest).
- **NPCs:** **Emperor Krispy** (sits on a literal donut throne), **The Holey Sage** (cryptic), **Sprinkles the Court Jester** (carnival mini-game vendor).
- **Signature food:** Donut Holes (350-in-8-minutes Webb record — already in design doc).
- **Cost:** M

## District 3 — Burger Boulevard

- **Theme:** Brooklyn-meets-Vegas — neon, brick, dive bars, a giant flickering "BIG BUN" sign that's visible from the boardwalk skyline. Diner America meets late-night burger joint.
- **Unlock:** Tier 3 access.
- **Buildings:** The Patty Palace (Tier 3 arena), The Smashbar (cosmetics), The Bun Bakery (cosmetic emote shop), The Ketchup Fountain (selfie spot).
- **NPCs:** **Big Earl** (trucker eater), **Veronica Diamond** (sequined Vegas champion), **The Smashmaster** (chef NPC).
- **Signature food:** Double Smashburger.
- **Cost:** M

## District 4 — Tokyo Town

- **Theme:** Two-block Shinjuku-alley sliver dropped at the edge of the fairground. Neon kanji-style signage (fictional script), narrow stalls stacked 3 high, a koi pond. Skews [Neon Ramen Alley](./design-concept-menu.md#concept-8--neon-ramen-alley-cyberpunk-food-district) but daytime + warmer.
- **Unlock:** Tier 3 access.
- **Buildings:** Ramen Throne (Tier 3 contest), Gyoza Steam Stall, The Sushi Conveyor (mini-game), Karaoke Booth (rhythm cosmetic shop), The Bonsai Bench (Focus training).
- **NPCs:** **Master Tonkotsu** (ramen sensei), **Sushi Bot 9** (deadpan robot chef), **Karaoke Kenji** (rhythm vendor), **The Tsunami's apprentice** Hayato.
- **Signature food:** Ramen Bowl (sustained slurp mini-game).
- **Cost:** L

## District 5 — BBQ Holler (Texas country)

- **Theme:** Wood-plank smokehouse aesthetic. Cattle skulls on the wall (cartoonish). Country-western jukebox. Brisket smoke rising from every chimney. Permanent golden-hour lighting.
- **Unlock:** 100 wins.
- **Buildings:** The Pit (smoked ribs Tier 3 contest), The Mechanical Bull (mini-game), The Cattle Drive Drive-In (hangout), The Hat Shop (cowboy cosmetics).
- **NPCs:** **Sheriff Brisket** (sheriff badge, drawls), **Granny Slow-Cook** (waits 12 hours per dish, lore NPC), **Hank the Pit Master** (vendor).
- **Signature food:** Smoked Ribs, Brisket.
- **Cost:** M

## District 6 — Farmers Market (Vegan / Verde)

- **Theme:** Open-air market with wood stalls, flower garlands, lots of green. Solar-panel string lights. The chill, healthy, low-stakes district. Inspired by [Mineko's Night Market](https://store.steampowered.com/app/762940/Minekos_Night_Market/) cozy stall culture.
- **Unlock:** Open from start (sub-tier hangout).
- **Buildings:** The Veggie Stand (Tier 1 alt contest — eats less per bite but cools fill meter), Smoothie Bar, Salad Spinner (mini-game), The Compost Heap (recycling cosmetics).
- **NPCs:** **Mama Carrot**, **Tofu Tony** (zen rapper), **The Beekeeper** (lore — connects to Bee Swarm Easter egg).
- **Signature food:** Mega Salad.
- **Cost:** M

## District 7 — Diner America (50s nostalgia)

- **Theme:** Chrome-and-neon strip — checkerboard floors, red vinyl, jukeboxes. A road-trip hangout zone. Pulls from [Concept 3 in the menu](./design-concept-menu.md#concept-3--route-66-glutton-run-diner-america).
- **Unlock:** Tier 2 access.
- **Buildings:** Dottie's Diner (Tier 2 alt arena), The Drive-In (movie cosmetic shop showing fictional eater films), Jukebox Row (sound packs).
- **NPCs:** **Dottie** (waitress), **The King** (Elvis impersonator), **Big Earl** (also visits BBQ).
- **Signature food:** Pancake Stack.
- **Cost:** M

## District 8 — Patisserie Quarter (French)

- **Theme:** Wrought iron balconies, café umbrellas, baguette displays. The cosmetic flex / DTI-demo district. Lavender and pink palette.
- **Unlock:** Tier 3 access.
- **Buildings:** The Macaron Tower (contest), Croissant Café (cosmetics), The Soufflé Pavilion (hosts a precision-format weekly), The Wine Cellar (hangout, P2+).
- **NPCs:** **Pierre Au-Beurre** (Tier 4 boss-level chef-rival), **The Soufflé Princess** (faints often), **The Maître d'** (cosmetics).
- **Signature food:** Macaron Tower (precision food).
- **Cost:** M

## District 9 — Mercado del Sol (Mexican market)

- **Theme:** Papel picado banners, mariachi music in the air, terra-cotta walls, sunset palette. Festive, music-forward.
- **Unlock:** Tier 3 access.
- **Buildings:** The Taco Truck (Tier 3 alt arena), The Salsa Wall (heat-tolerance training), The Piñata Stage (mini-game — whack for cosmetics), Dia de los Muertos Plaza (Halloween event venue).
- **NPCs:** **Abuelita Carmen** (recipe vendor), **El Salsa Demonio** (Tier 4 rival), **Mariachi NPCs** (ambient).
- **Signature food:** Taco Platter, Brain Taco (the exotic Tier 4 food, already in design doc).
- **Cost:** M

## District 10 — Curry Lane (Indian / South Asian)

- **Theme:** Spice-market stalls, hanging marigolds, henna-art textures, gold-trimmed everything. Hot-color palette (saffron, marigold, deep red).
- **Unlock:** Tier 3 access.
- **Buildings:** The Curry Pit (Tier 3 alt Spicy contest), The Chai Cart (cosmetic), Dosa Dome (large hangout), Spice Bazaar (Heat training).
- **NPCs:** **Chef Bhuna** (jovial, gives spice quests), **The Chai Wallah** (vendor), **Mrs. Singh** (Grandma equivalent, terrifying spice tolerance).
- **Signature food:** Vindaloo Bowl, Dosa Tower.
- **Cost:** M

## District 11 — Drink District (Cocktails, Smoothies, Boba)

- **Theme:** A short alley between two arenas. Three distinct stalls — boba bar, smoothie hut, mocktail lounge (no alcohol — kid-safe).
- **Unlock:** Open from start.
- **Buildings:** The Boba Bar, The Smoothie Hut, The Mocktail Lounge.
- **NPCs:** **Boba Brenda** (vendor), **The Smoothie Surfer** (lore: hangs ten with a smoothie), **The Mocktail Mystic** (fortune cosmetic).
- **Mechanical role:** Drinks are mini-buffs purchasable per contest. One drink active at a time. Inspired by [Genshin Impact's one-buff-active food system](https://genshin-impact.fandom.com/wiki/Food).
- **Cost:** S (small footprint)

## District 12 — Frank's Future (Cyberpunk slice)

- **Theme:** A neon alley wedged between Tier 4 arena and the ocean. Holographic kanji-style signage, magnetic-rail rides. The Tier 4 "endgame nightlife" district. Pulls heavily from [Concept 8](./design-concept-menu.md#concept-8--neon-ramen-alley-cyberpunk-food-district) but as a wing of the fairground rather than the whole map.
- **Unlock:** P2+ only — endgame social space.
- **Buildings:** The Chrome Belt Vault, The Hologrill (Tier 4 alt arena), Neon Tattoo Parlor (#26), The Drone Delivery Pad (cosmetic shop).
- **NPCs:** **Chef-9** (chrome chef), **Glitch** (smuggler), **Mama Synth** (vocoded grandma).
- **Cost:** L

## District 13 — Dessert Town (Cake Heights)

- **Theme:** Pastel pink/blue/yellow, frosting-topped buildings, sprinkles for sidewalks. The "Candyland" slice of the [City of Bread](./design-concept-menu.md#concept-4--the-city-of-bread-the-map-is-food) concept dropped in as one district.
- **Unlock:** Tier 2 access.
- **Buildings:** The Cake Castle (Tier 2 alt arena — precision frosting), Ice Cream Mountain (mini-game venue), The Cupcake Carousel (re-themed carousel), The Macaron Maze (Easter-egg path).
- **NPCs:** **Princess Frosting**, **Sundae Sammy**, **The Marshmallow Mayor**.
- **Cost:** M

## District 14 — Underground Speakeasy (Whole secret district)

- **Theme:** Velvet curtains, jazz, low light. Speakeasy with multiple rooms. The discovery / endgame social slice.
- **Unlock:** Find the password from a randomized NPC each week.
- **Buildings:** The Velvet Booth (Tier 4 cinematic arena), The Cigar Lounge (chat lounge), The Roulette Room (gambling).
- **NPCs:** **The Bouncer** (asks the riddle), **Madame Marmalade** (cosmetics), **Knuckles Bagel** (gangster eater rival).
- **Cost:** L

---

# Part 3 — New mini-game types (beyond the existing 7)

Cost legend: **XS** = a couple hours, no new art. **S** = half-day. **M** = 1-2 days. **L** = whole-week mini-system.

| # | Name | Pitch | Input | Reward | Cost | Source |
|---|---|---|---|---|---|---|
| 1 | **Burger Assembly** | Build a 5-layer burger in 20s, ingredients fall from above | Drag/tap layered items | Cosmetic tickets | M | [Overcooked](https://en.wikipedia.org/wiki/Overcooked!) |
| 2 | **Sushi Conveyor** | Tap the right plate as it passes; rare plates worth more | Single-tap timing | Cosmetic tickets | S | Conveyor sushi |
| 3 | **Mukbang Stream** | "Eat for the camera." 30s of bites — viewers tip you based on streak | Tap rhythm | Style Bucks | M | [Mukbang culture](https://en.wikipedia.org/wiki/Mukbang) |
| 4 | **Speed Peeling** | Peel a banana / orange via swipe gesture, faster = more | Swipe | Tickets | S | Cooking Mama chop |
| 5 | **No-Hands Pie Eating** | Cartoon classic. Hands tied behind back. Tap to face-dive bites. | Single tap | Tickets | XS | State fair classic |
| 6 | **Watermelon Seed Spit** | Charge-and-release distance contest | Hold + release | Tickets + plush | S | County fair |
| 7 | **Ramen Slurp Speed** | Existing food mechanic, recontextualized as standalone stall | Hold-bar | Tickets | XS | Existing |
| 8 | **Hot Pepper Roulette** | 4 peppers, 1 hot. Eat all 4. Survive the burn? Big prize. | Single tap + heat bar | Style Bucks | M | Hot Ones |
| 9 | **Chopstick Relay** | Drag a single noodle from bowl A to bowl B without dropping | Drag | Tickets | S | Tampopo |
| 10 | **Pizza Tossing** | Rhythm tap as the pizza dough spins overhead | Rhythm tap | Tickets | M | Tony's pizzeria |
| 11 | **Cake Decorating** | Draw frosting on a cake — accuracy scored vs target pattern | Drag-to-draw | Cosmetic skin | M | Cooking Mama |
| 12 | **Tea Ceremony Precision** | Pour without spilling. Hold to pour, release at the line. | Hold + release | Focus daily buff | S | Spirited Away |
| 13 | **Fortune Cookie Smash** | Smash 10 cookies, collect the fortunes | Tap | Daily quest fuel | XS | Fortune cookies |
| 14 | **Catch the Pancake** | Frying-pan flip. Hold to charge, release on a meter, catch the pancake | Hold + release | Tickets | S | Cooking Mama flip |
| 15 | **The Wing-Bone Pull** | Three-tap rhythm to clean a wing bone (already in design doc as bite-level mechanic — also exists as a stall) | Triple tap | Tickets | S | Existing |
| 16 | **The Mystery Box Reveal** | Iron Chef mystery box — pay 50 coins, see what's inside, eat it for a buff | Single click | Random buff | S | [Iron Chef](https://www.executivechefevents.com/iron-chef-mystery-boxes) |
| 17 | **Disco Slurp** | A slurp rhythm mini-game with disco lights and a BPM | Rhythm tap | Style Bucks | M | Mukbang + rhythm |
| 18 | **The Bread Bowl Surf** | Stand on a giant bread bowl as it floats down the chocolate river | Tilt balance | Tickets | M | City of Bread |
| 19 | **The Foodgasm Reaction Booth** | After winning a contest, tap rapidly to "react" — bigger reaction, bigger crowd pop | Tap mash | Crowd Meter banked for next contest | M | [Food Wars foodgasms](https://tvtropes.org/pmwiki/pmwiki.php/Manga/FoodWars) |
| 20 | **Counter Crumb Hunt** | A first-person shrink-down mini where you collect crumbs as a tiny | Movement + tap | Cosmetic | L | [Counter Kingdom concept](./design-concept-menu.md#concept-5--counter-kingdom-tiny-world) |
| 21 | **The Salt Bae** | Sprinkle salt on a steak in slow-mo. Precision flick. | Flick/drag | Daily emote | S | Salt Bae meme |
| 22 | **Microwave Roulette** | 30s timer, hit "stop" before pop-popcorn explodes. Pure tension. | Single tap | Tickets | XS | Microwave anxiety |
| 23 | **The Bone Stack** | Stack chicken wing bones tall without toppling | Tap to drop | Tickets | M | Buffalo Wing Fest tradition |
| 24 | **The Soup Sip Marathon** | Sustained sip — sustain heat bar inside a window for 30s while reading a vintage menu (idle) | Hold | Style Bucks | S | Tampopo soup ritual |
| 25 | **The Chip Crunch Listener** | Crunch a chip on the beat. Audio-only rhythm cue. | Headphones-optional rhythm | Tickets + accessibility flex | M | ASMR / mukbang |

---

# Part 4 — NPC archetypes, vendors, and rivals

> The current cast is 12 named eaters. This pushes it to ~35 named NPCs across all districts and tiers, plus boss-tier additions. Keeping the [George Shea absurdist intro format](https://en.wikipedia.org/wiki/Nathan's_Hot_Dog_Eating_Contest) for every named NPC.

## 4A. Tier 1 contest opponents (Hot Dog Boardwalk — already in design doc)

| NPC | Already in doc? | One-line |
|---|---|---|
| Chomping Charlie | Yes | Generic backfill |
| Big Belly Beatrice | Yes | Generic backfill |
| The Rookie | Yes | Clutch underdog |

**New additions:**

| NPC | One-line | Special move |
|---|---|---|
| **Skinny Pete** | Lean as a rake; eats like a black hole | "Vacuum" — +50% Solomon speed for 5s |
| **Big Cheeks Charlene** | Hamster-themed character, perma-chipmunked | Starts contest with +20% chipmunk capacity |
| **The Kid** | Roblox-coded 12-year-old in a backwards cap; underestimated | Crowd Meter starts at 25% for free |

## 4B. Tier 2 contest opponents (Pizza Plaza, Dessert Town, Diner America)

| NPC | District | One-line | Special move |
|---|---|---|---|
| **Tony Pepperoni** | Pizza Plaza | Slicked hair, gold chain | "Slice Switch" — every 5 bites, his food rotates to a different pizza variant |
| **Sundae Sammy** | Dessert Town | Brain-freeze immune | Ignores Ice Cream Mountain debuff |
| **Princess Frosting** | Dessert Town | Wears a tiara, surprisingly competitive | Auto-decorates her cake mid-contest for crowd bonus |
| **The King** | Diner America | Elvis impersonator | Sings between bites for crowd pop |
| **Dottie's Husband** | Diner America | Burly trucker | Slow but unstoppable — never fumbles |

## 4C. Tier 3 contest opponents

| NPC | District | One-line | Special move |
|---|---|---|---|
| **Master Tonkotsu** | Tokyo Town | Bald sensei, eyes closed always | "Zen Slurp" — Focus-equivalent bonus passive |
| **Sheriff Brisket** | BBQ Holler | Big hat, bigger appetite | "Slow Smoke" — +0% speed, +20% capacity |
| **El Salsa Demonio** | Mercado | Lucha mask | Immune to Spicy heat |
| **Chef Bhuna** | Curry Lane | Cheerful, always laughing | Heat doesn't drain his Crowd Meter |
| **Pierre Au-Beurre** | Patisserie Quarter | Petite, devastating | Precision-format master — 90° success arc on butter |
| **Knuckles Bagel** | Speakeasy | Gangster | Bribes the crowd — flat +10% Crowd Meter every 20s |
| **Mama Synth** | Frank's Future | Vocoded grandma | Auto-dunks every bread item |

## 4D. Tier 4 contest opponents

| NPC | Already in doc? | One-line | Special move |
|---|---|---|---|
| The Jaws, The Tsunami, The M.I.K.I., The Widow, The Toad, Eater X, The Showman, Deep Dish, The Professor, The Grandma, The Bear | Yes | (see design doc) | (see design doc) |
| **Veronica Diamond** | New | Vegas buffet queen, sequined | "Showgirl" — Crowd Meter fills 2x speed |
| **Father Calzone** | New | Eating priest, prays before each bite | "Benediction" — once per contest, blesses you with +20% fill |
| **The Shadow Chef** | New (boss-tier) | A masked figure in chef whites; never speaks | Mimics the player's exact stat profile, +5% |
| **The Glutton King** | New (boss-tier) | A 7-foot mythological eater in a crown | Doesn't eat — absorbs food via gravity. Visually unsettling, plays it for the laugh |
| **The Soufflé Princess** | New (boss-tier, fragile) | Royal pastry, collapses if you say anything mean | Pre-contest dialog tree determines her difficulty |

## 4E. Trainer NPCs (one per stat)

| NPC | Trains | Personality |
|---|---|---|
| **Coach Granite** | Stomach Capacity | Ex-Navy, gravelly voice, screams "STRETCH IT" |
| **Master Manjirou** | Jaw Speed | Ancient, soft-spoken, gum on the wall |
| **Throat-Pipe Pete** | Swallow Rate | Plumber, calls himself a "pipe specialist" |
| **The Monk** | Focus | Wears robes, talks in koans |

## 4F. Vendor NPCs (each shop has personality)

| NPC | Shop |
|---|---|
| **Whiskers Garibaldi** | Haberdashery |
| **Madame Marmalade** | Mustard Boutique |
| **Boba Brenda** | Boba Bar |
| **The Salt Lord** | Spice Bazaar |
| **Lil' Lou** | Carnival Mini-game Prize Booth |
| **Antoine the Sommelier** | Mocktail Lounge (named for the user; ironic flex) |
| **DJ Crumb** | Sound Studio |
| **Hairdresser Helga** | Tattoo Parlor |

## 4G. Lore NPCs

| NPC | Role |
|---|---|
| **Madame Petite** | Fortune teller; daily horoscope. Already mentioned in concept doc. |
| **The Carnival Historian** | Stands at Hall of Fame, reads plaques aloud. |
| **The Ghost of the Glutton King** | Haunted booth. Tells stories of pre-1972 eating. |
| **The Boardwalk Drunk** | Comedic NPC who rambles in-universe lore that's secretly canon. |
| **Old Marble** | Just a marble on a pedestal. Sometimes speaks. Cameo from [Counter Kingdom](./design-concept-menu.md#concept-5--counter-kingdom-tiny-world). |

## 4H. Quest-giver NPCs

| NPC | Quest type |
|---|---|
| **Sad Larry** | "I lost a contest. Win one for me." Once-per-day. |
| **The Hungry Kid** | "Feed me a hot dog." Drops a hot dog cosmetic prop, deliver to him. |
| **The Traveling Salesman** | Sells weekly unique cosmetic for inflated coins. |
| **The Lost Tourist** | Asks you to escort them across the boardwalk. Pays in Style Bucks. |
| **The Beekeeper** | Bee Swarm easter-egg crossover NPC. Gives daily honey buff. |

## 4I. Boss tier (beyond The Bear)

| Boss | When | Mechanic |
|---|---|---|
| **The Bear** | Friday weekly, P5 | Existing |
| **The Shadow Chef** | Halloween event | Mirrors your stats with +5%. Atmospheric horror lighting. |
| **The Glutton King** | Monthly | Sits in the Hall of Fame, walks out once per month to challenge top 3 prestige leaderboard |
| **The Soufflé Princess** | Birthday-event boss | Difficulty determined by your dialog choices — be polite, she's gentle. Mean to her, she humiliates you. |
| **The FLDSMDFR** | Once a year (food-rain event) | A literal food-weather machine — not an NPC, an arena that rains food at you |
| **Anton Ego's Critic Panel** | Quarterly Precision-Format ritual | 3 critic NPCs score your bites Michelin-style. Inspired by [Anton Ego's flashback scene](https://faroutmagazine.co.uk/flashback-scene-ratatouille/) |
| **The Iron Chef** | Bi-monthly | Mystery-box format. You don't know the food until the bell rings. |

## 4J. Comedic recurring NPCs

| NPC | Joke |
|---|---|
| **Sad Larry** | Always losing, always asking for help |
| **The Boardwalk Drunk** | Speaks lore by accident |
| **The Sentient Hot Dog** | A wholesome anthropo-food NPC who's "the only one of his kind here" — exists for the Cuphead/Snackopolis-flavored cameo |
| **The Roomba** | A literal Roomba that patrols the boardwalk at night. Stay away. Cameo from [Counter Kingdom](./design-concept-menu.md#concept-5--counter-kingdom-tiny-world). |
| **The Mime** | Performs every contest in pantomime |
| **The Newspaper Boy** | Shouts updated server records as headlines |

---

# Part 5 — Events and seasonal content

> The design doc lists 4 seasonal events. This pushes it to 25 covering monthly themed contests, real-world holiday tie-ins, mini-bosses, crossover events, anniversaries, and tournament arcs.

## 5A. Monthly themed contests (always-on rotation)

| Month | Event | Hook |
|---|---|---|
| Jan | **The Polar Plunge Pancake Bowl** | Frozen-themed arena, pancakes give +1% capacity per bite |
| Feb | **The Heartburn Cup** | Love-themed, Spicy format, 2-player Tag Team bonus |
| Mar | **Peeps Madness** | Pure-sugar Tier 2 Speed contest (Matt Stonie's 255-in-5 record) |
| Apr | **The Easter Egg Hunt** | Hidden cosmetics in eggs scattered across the boardwalk |
| May | **Cinco de Mayo Taco Tuesday** | Mercado del Sol event, brain-taco encounters |
| Jun | **Pride Parade** | Rainbow cosmetics, Pride-march entrance |
| Jul | **The Summer Hot Dog Bowl** | Already in doc — Nathan's analog, July 4 |
| Aug | **The Watermelon Wars** | Seed-spit mini-game tournament |
| Sep | **The Harvest Crown** | Farmers Market district event |
| Oct | **The Brain Taco Championship** | Already in doc — Halloween event |
| Nov | **The Turkey Trot** | Thanksgiving — eat a whole turkey |
| Dec | **The Frostbite Frosting Festival** | Cake decorating, hot cocoa buffs |

## 5B. Real-world holiday tie-ins (one-day or one-weekend)

| Event | Hook |
|---|---|
| National Hot Dog Day (July 19) | All contest food is hot dogs server-wide for 24h |
| April 1 | Mayo Day — comedy food unlocked in all arenas |
| St. Patrick's Day | Green palette overlay; clover cosmetics |
| Halloween | Ghost overlay on every NPC; Brain Taco Championship runs all week |
| Christmas | Gingerbread re-skin of all signage |
| New Year's Eve | Midnight countdown contest |

## 5C. Limited-time mini-bosses

| Boss | Frequency | Hook |
|---|---|---|
| **The Shadow Chef** | Each Halloween week | Stat-mirror |
| **The Iron Chef** | Bi-monthly | Mystery box |
| **The Glutton King** | Monthly | Walks out of the Hall of Fame |
| **The Soufflé Princess** | Bi-monthly | Dialog-determined difficulty |
| **The Anton Ego Critic Panel** | Quarterly | Michelin-grade Precision |

## 5D. Crossover events (with fictional brands)

| Event | Hook |
|---|---|
| **The NoodleCorp Showdown** | Fictional cyberpunk sponsor takes over Frank's Future for a weekend; exclusive cyber cosmetics |
| **Big Hank's Beans Invitational** | Cowboy-themed; BBQ Holler hosts |
| **Roar Energy Tournament** | Tier-4 speed-format week with electric-glow cosmetics |
| **Mama Margherita's Bake-Off** | Pizza Plaza; voted-on by NPC judges using a [Food Wars-style foodgasm meter](https://tvtropes.org/pmwiki/pmwiki.php/Manga/FoodWars) |

## 5E. Anniversary celebrations

| Event | Hook |
|---|---|
| **Game Launch Anniversary** | Every July 4 — a 24h Mustard Belt parade. All players get a free anniversary belt skin. |
| **Frank's 100th Birthday** | One-time launch event — a single-day cinematic where the founder's ghost appears |
| **Personal Anniversary** | Each player's join-anniversary triggers a confetti cutscene + free cosmetic |

## 5F. Tournament arcs (multi-week storylines)

| Arc | Hook |
|---|---|
| **The Road to The Bear** | 4-week tournament: beat 4 increasingly-tough rivals, finale is The Bear |
| **The Hall of Fame Gauntlet** | 5 weekly contests, each against a Hall-of-Fame statue come to life. Players earn lore plaques. |
| **The Tournament of Tiers** | Cross-tier bracket: lower-tier underdogs occasionally upset higher-tier favorites for big coin |
| **The Mystery of the Glutton King** | Detective-style arc — collect clues by winning specific contest formats; finale reveals lore |

## 5G. Mystery / rotating events

| Event | Hook |
|---|---|
| **The Cardboard Box Cookoff** | A random building in the boardwalk turns into a hidden contest for 10 minutes once a week |
| **The Surprise Visitor** | A randomly-selected named NPC visits a random server once per day |
| **The Bear Sighting** | A 1-in-1000 chance The Bear appears in a Tier 3 contest unannounced. Server-wide alert. |
| **The Food Rain** | Once per month, food literally falls from the sky for 60s (FLDSMDFR-inspired). Tap to catch for coins. |

---

# Part 6 — Mechanics stolen from food media

> Picks from my research — 22 specific ideas with explicit "how it adapts" notes. The strongest fits are at the top. Weaker stretches at the bottom labeled as such.

## STRONG fits

### 1. The Foodgasm Reaction Burst — [Food Wars](https://tvtropes.org/pmwiki/pmwiki.php/Manga/FoodWars)
After a Perfect skill check, briefly cut to a stylized "reaction shot" — the player's character in a surreal background (floating in space, surrounded by hot dogs, briefly nude under a swirl of stars), then snap back. Lasts 0.4s. Crowd Meter +5%. **Why it works:** This is the single most iconic Food Wars mechanic. It rewards skill, it's funny, and it generates massive screenshot/TikTok bait. **Risk:** Tonal calibration — keep it cartoon-absurd, not horny.

### 2. The Iron Chef Mystery Box — [Iron Chef](https://www.executivechefevents.com/iron-chef-mystery-boxes)
Once per day, a contest entry pad shows a covered platter instead of a food name. You don't know what you're eating until the countdown ends. The reveal animation is the lid lifting. **Why it works:** It's the single most replayable mechanic in food TV. Players will queue for the mystery contest just to see what's inside. **Adaptation:** Limit to once per day per player to keep mystery valuable.

### 3. Yes, Chef Command Chain — [The Bear](https://www.cbr.com/yes-chef-what-the-bear-gets-right-about-the-restaurant-industry/)
A special contest format where each Perfect bite triggers a tiny "YES CHEF" voice line and grants +1% to a shared "Service" meter. Hit 100% Service before the time runs out for a 5x final bite. **Why it works:** Translates The Bear's call-and-response intensity into a meter-management mini. Pairs naturally with Tag Team. **Adaptation:** Use only in a special Spicy variant called "The Service."

### 4. The Anton Ego Memory Bite — [Ratatouille](https://faroutmagazine.co.uk/flashback-scene-ratatouille/)
Once per contest, a random Perfect bite triggers a brief "memory" cutscene — the player's character as a tiny version of themselves at a kid's birthday party. 0.6s. Grants +30% Crowd Meter. **Why it works:** Pure emotional gut-punch from a comedy game, which is exactly the [Anton Ego scene's](https://faroutmagazine.co.uk/flashback-scene-ratatouille/) trick. **Risk:** Don't overuse — once-per-contest randomness keeps it precious.

### 5. The Solomon Method (already in doc) — [Kobayashi](https://econlife.com/2023/07/competitive-eating-3/)
Already speced. Worth noting it stays the strongest mechanic-to-source-material fit in the game.

### 6. The Mukbang Studio Stream — [Mukbang culture](https://en.wikipedia.org/wiki/Mukbang)
A standalone hangout building. Sit in the ring-lit booth, eat for the camera, NPC viewers tip you with style bucks based on your streak. **Why it works:** A non-contest social activity that doesn't break the carnival theme — mukbang is just "eating with friends watching." **Adaptation:** Friends can opt-in to watch your stream via a "tune in" button in the social menu.

### 7. The Anti-Spaghetti Etiquette Booth — [Tampopo](https://en.wikipedia.org/wiki/Tampopo)
A purely cosmetic Etiquette Class building where an NPC teaches you how to "eat the European way." If you complete the lesson, you unlock a "Silent Eater" cosmetic emote (no chewing sound for the next contest). The joke is that quiet eating is useless in a competitive eating game. **Why it works:** Tampopo's etiquette-class scene is the most cited food-cinema joke ever; the homage will land for adult ironic players.

### 8. The Eat-with-the-Bin-Crew — [Tampopo midnight ramen heist](https://en.wikipedia.org/wiki/Tampopo)
A late-game co-op quest: 4 players sneak into rival shops at night to "learn techniques." A stealth-flavored mini that ends with all 4 players sharing a stat boost. **Why it works:** Anchors a friend-group co-op moment in the world's most beloved food film.

### 9. The FLDSMDFR Food Rain — [Cloudy with a Chance of Meatballs](https://en.wikipedia.org/wiki/Cloudy_with_a_Chance_of_Meatballs_(film))
Monthly server-wide event: food literally falls from the sky for 60 seconds. Tap to catch — each item is a coin. The biggest items (10-foot hot dogs) cause "weather damage" — a fake building collapse, instantly repaired. **Why it works:** Pure TikTok bait. The thumbnail writes itself.

### 10. The Queen of Sauce TV — [Stardew Valley](https://stardewvalleywiki.com/Cooking)
A vintage TV in the fairground plays a Sunday-only cooking show. Watching unlocks the day's "Recipe" (a food skin for a contest food). Stardew's mechanic, brought across whole. **Why it works:** Forces a single weekly login that rewards minimal effort. Stardew proved its retention power.

### 11. The Mineko Night Market Stalls — [Mineko's Night Market](https://store.steampowered.com/app/762940/Minekos_Night_Market/)
Once per real-week, the boardwalk transforms into a night-lit version with extra stalls run by NPCs. Lanterns light up. Special cosmetics drop. **Why it works:** Built-in weekly rhythm with strong cozy aesthetic.

### 12. The Cooking Mama Mini-Game Pipeline — [Cooking Mama](https://en.wikipedia.org/wiki/Cooking_Mama)
For a future expansion: contests at the highest tier become multi-stage. Each food is preceded by a single 5-second prep mini-game (chop, mix, fry). Bonus to bite effectiveness based on prep success. **Why it works:** Adds skill depth without changing the eating loop. **Risk:** Increases complexity — only for Tier 4+ rituals.

### 13. The Spiritfarer Comfort Meal — [Spiritfarer](https://spiritfarer.fandom.com/wiki/Cooking)
Each named NPC has a "comfort food" — find it as a drop, deliver it, unlock a unique dialog tree and a friendship cosmetic. Like Stardew gifts but with eaters. **Why it works:** Wholesome connection mechanic in a competitive game — exactly the balance the [design doc](../GAME_DESIGN.md) is aiming for.

### 14. The Battle Chef Brigade Combo Multiplier — [Battle Chef Brigade](https://store.steampowered.com/app/452570/Battle_Chef_Brigade_Deluxe/)
Stack consecutive Perfect bites for a visible "combo" meter at top of screen. At 10 combo: +20% bite value. At 25: +50%. Resets on a single miss. **Why it works:** Adds skill expression without changing input. Combo culture is a proven retention loop. **Adaptation:** Make this an unlockable Focus upgrade so new players aren't overwhelmed.

### 15. The Cuphead Boss-Tier Anthropo Food — [Cuphead's Sugarland Shimmy](https://cuphead.fandom.com/wiki/Sugarland_Shimmy)
For the special "Eat the Boss" event — the final boss is a Cuphead-style anthropo food character (Baroness Von Bun Bun-equivalent) and the eating contest IS the boss fight. **Why it works:** Adds genre-mash variety at endgame. Tonal balance with the otherwise-grounded carnival risks reading "off," so contain it inside a quarterly event.

### 16. The Disco Elysium Inner-Voice Skill Check — [Disco Elysium](https://www.oreateai.com/blog/beyond-the-dice-roll-understanding-disco-elysiums-unique-skill-checks/39f4f589c2a7441b60b488c0b1896bd0)
During the Chipmunk Window, your "Stomach," "Jaw," "Throat," and "Mind" each pop up as separate inner-voice text bubbles arguing what to do. Higher stat = louder voice = more useful advice. **Why it works:** Adds personality to a tense moment and gives the four stats a literal voice in the world. **Adaptation:** Pure flavor text; doesn't change mechanic.

## DECENT fits (worth considering)

### 17. The Overcooked Co-op Chaos — [Overcooked](https://en.wikipedia.org/wiki/Overcooked!)
A 4-player Tag Team mode where the kitchen shifts mid-contest (table tilts, plates slide, etc.). **Why it's a stretch:** Adds chaos at the cost of clarity. Overcooked works because it's a stand-alone co-op game; layering it on a 1v1 eating contest may feel busy. Use sparingly as a special weekly format.

### 18. The Spirited Away Bathhouse Spirit Market — [Spirited Away](https://www.tofugu.com/japan/spirited-away-food/)
A special weekly market in Tokyo Town where mythical NPCs (river spirits, etc.) come to feast and trade rare cosmetics. **Why it's a stretch:** Bathhouse spirituality reads heavy against carnival levity. Works only if presented as a dream-sequence event.

### 19. The Genshin Impact 4-Buff Stack — [Genshin Impact](https://genshin-impact.fandom.com/wiki/Food)
Pre-contest, you can stack one Offensive, one Defensive, one Stamina, one Elemental food buff. **Why it's a stretch:** Adds depth, but also adds 4 currencies and pre-contest fuss. Skip unless you're chasing the hardcore audience.

### 20. The Don't Starve Hunger Meter — [Don't Starve](https://www.thegamer.com/spiritfarer-complete-recipe-guide/)
A persistent "between contests" hunger meter that affects stats. **Why it's a stretch:** Punishes lapsed players. Skip.

### 21. The Pizza Tower Speed-Style Score — [Pizza Tower](https://en.wikipedia.org/wiki/Pizza_Tower)
A speed-style grade at the end of each contest (D → S+ → P-rank). **Why it works as decent:** Quick-to-implement bragging-rights layer. **Why it's not strong:** The game already has place 1-4, coin rewards, leaderboards — yet another grade may feel redundant.

### 22. The Wonka Random Room — [Charlie & Chocolate Factory](https://parametric-architecture.com/architectural-look-inside-willy-wonkas-world/)
A "Wonka Door" in the fairground that, when entered, drops you into a random one-room mystery contest with absurd food (chocolate river slurp, taffy chew, etc.). **Why it works:** Strong discovery hook. **Why it's a stretch:** Production cost — you need to build a real "room of the week" cadence to keep it fresh.

---

# Part 7 — Cosmetic categories (massive expansion)

> The design doc has 6 cosmetic categories (outfits, face paints, belts, cheek styles, victory poses, bite sound packs). This expands to 22 with examples each.

| # | Category | Examples |
|---|---|---|
| 1 | Outfits (existing) | Hawaiian shirt, American flag gear, lab coat, foam hot dog hat |
| 2 | Face Paints (existing) | Eater X face paint, Lucha mask, Day of the Dead skull |
| 3 | Belt Colors (existing) | Bronze, silver, gold, diamond, holographic, animated |
| 4 | Cheek Styles (existing) | Hamster, puffer fish, balloon, double-chipmunk |
| 5 | Victory Poses (existing) | Backflip, flex, dramatic collapse, The Shake |
| 6 | Bite Sound Packs (existing) | Cartoon, realistic, ASMR, opera singer, robot, anime, dubstep |
| 7 | **Full-Body Food Costumes** | Hot dog suit, taco costume, donut suit, sushi roll suit, broccoli suit, walking pizza |
| 8 | **Reaction Emotes** | Foodgasm reaction, faint, kiss the fingers (Italian), Salt Bae, prayer, mukbang nod |
| 9 | **Contest Entrances** | Rainbow runway walk, suplex into seat, parachute drop, arrival by ridiculous vehicle, slide in on tray, smoke machine entrance |
| 10 | **Trophy Cabinets** | Wood, glass, neon, marble, holographic — display in your housing |
| 11 | **Trail Effects** | Sprinkle trail, ketchup drip, neon, fire, snow, sushi rice, bubble trail |
| 12 | **Pet Companions** | Walking sandwich, taco dog, sentient bean, croissant fairy, fortune-cookie companion, ramen noodle snake |
| 13 | **Music Tracks** | Tier 1 surf rock, Tier 4 EDM, Tier 4 orchestral, lo-fi diner, mariachi, EDM remix of George Shea quotes |
| 14 | **Contest Food Skins** | Your hot dogs look like tacos, your wings look like macarons. Pure visual. |
| 15 | **Belly Tattoos** | Visible during chipmunk window. Mustache tattoo, "MOM" heart, sponsor logo |
| 16 | **Chipmunk Cheek Patterns** | Camo, flag, leopard, holographic — visible only when stuffed |
| 17 | **Eyes / Iris Colors** | Animated mustard-yellow eyes, sparkly, hot-pepper red |
| 18 | **Drool / Sweat Skins** | Glitter sweat, neon drool, golden tears |
| 19 | **Aura Particles** | Sparkle aura, fire aura, ice mist, mustard cloud |
| 20 | **Nameplate Frames** | Wood-plank, marble, mustard-belt-shaped, ASCII food art |
| 21 | **Prestige Crowns** | Worn floating above head. Bronze, silver, gold, diamond, champion. |
| 22 | **Stall Skins** | If you own a Boardwalk Booth (housing), reskin its canopy: striped, neon, royal, Halloween |

---

# Part 8 — Social and community features

> Beyond what's already planned in the design doc.

## Photo / sharing

- **Photo Mode** — Pause the game, move a freecam, snap a screenshot, share to a server-wide gallery board.
- **Highlight Replay** — Every contest auto-saves a 5-second clip of your best bite for the day. Share to friends.
- **The Boardwalk Gallery** — A wall in the hub displays the top 5 community photo-mode shots of the week.

## Collection / discovery

- **The Recipe Cookbook** — Collect "recipes" (food skins) over time. Reaching milestones (10, 25, 50, 100) unlocks cosmetic rewards. Stardew Valley model.
- **Lore Document Collection** — Hidden in-world: 25 lore documents (carnival posters, eater memoirs, menus) hidden across the map. Full collection unlocks a unique title.
- **Pet Egg Index** — Track every egg you've hatched. Encourages re-rolls for collection completeness, not power.

## Daily / cozy

- **Daily Horoscope** — Madame Petite's tent. "Today's lucky food: donut. Eating donuts gives +5% Crowd Meter."
- **The Mailbox** — NPCs pen-pal players. Each day, a different named NPC mails you a flavor letter. Replies cost 5 coins and increase friendship.
- **The Comment Wall** — Server-wide message board where players leave one-line comments (filtered).

## Social roles

- **The Mayor of Each District** — Weekly NPC + community vote elects a player to be "Mayor" of a district. Mayor's name appears on signage, gets a unique nameplate frame. Purely cosmetic role.
- **The Boardwalk Critic** — A daily-rotating player role where one user gets to "review" the day's top contest. Their text becomes server flavor.

## Cooperative non-contest activities

- **The Feeding the Homeless Booth** — A do-gooder side activity. Donate food cosmetics to a soup-kitchen NPC. Gives a Karma stat, which unlocks empathy-themed cosmetics.
- **The Lost Tourist Escort** — Random NPC asks a passing player to walk them across the boardwalk. Pays in Style Bucks.
- **The Community Sandcastle** — A massive sandcastle on the beach that any player can drop a sand bucket on. Resets weekly. Top 10 contributors get a "Sandcastle Hero" badge.

## Friend-specific

- **Friend Vault** — Shared friend group can pool coins for a shared goal (a high-tier cosmetic unlocked only at 100k pooled).
- **Friend Spectator Mode** — Watch a friend's contest from inside their UI perspective. Cheer for them with stickers/emojis.
- **The Buddy Booth** — A 2-seat booth where two friends sit together and play a non-contest mini (split-screen rhythm) for shared cosmetics.

## Server-wide

- **Server Champion Banner** — When any player on the server wins their first Tier 4, banner overlays for 10 seconds for everyone.
- **The Lottery Stall** — Once-per-server-per-day, a player gets a random prize via the lottery stall.
- **Server Records Board** — Always visible. Updates live. Players name themselves into the world by setting records.

---

# Part 9 — Crazy / risky ideas

> 15 swing-for-the-fences ideas. Listed with honest "should we try this?" notes.

| # | Idea | Why it could rule | Why it could fail | Verdict |
|---|---|---|---|---|
| 1 | **"Eat the Boss" Final Boss** | The final P5 boss is a 10-foot anthropo-food character (Sugarland-Shimmy style). The contest IS the boss fight — you literally bite chunks out of them. Mood-shift cinematic. | Tonal risk. May read horrifying. | **Try it as a quarterly event boss, not the regular Bear.** Lean Cuphead-cartoony, not visceral. |
| 2 | **Vendor-for-a-Day** | A randomly-chosen player gets to run one of the stalls for an hour. They set the price. They keep 50% of the coins spent there. | Exploits / griefing concerns. Coin economy abuse. | **Skip in v1.** Test in private servers later. |
| 3 | **Crime Mode** | A weekly format where 4 players sneak into a contest and try to steal each other's food without getting caught. | Sabotage = parallel-PvP design death (already noted in deep-dive). | **Skip.** Violates established design principle. |
| 4 | **Wedding Venue** | Players can host weddings on the boardwalk. Friends throw rice (rice cosmetic). | Adopt Me does this and prints money. Why not us? | **Try it as a Tier 3 unlock for friend groups.** |
| 5 | **Food Baby Pregnancy** | After hitting 95% fill without DQ, your character has a "food baby" cosmetic that lasts 10 real minutes. | Lol risk. | **Try it.** Pure dumb fun. |
| 6 | **Rival Eating Gangs / Turf Wars** | Players join one of 4 gangs (Boardwalk Boys, Pizza Mafia, Donut Dynasty, Counter Crew). Each district has a leaderboard for each gang. Weekly turf changes. | Genuinely cool. Adds team identity. | **Strong YES.** Try in v2. |
| 7 | **The Sentient Hot Dog Side-Story** | One specific anthropo hot dog NPC lives in the boardwalk. Has a multi-week storyline. Crosses concepts. | Tonal whiplash if not handled well. | **Try as a hidden lore arc.** Optional. |
| 8 | **The "Become the Bear" Endgame** | After beating The Bear 100 times, you BECOME a Bear-style boss for other players. Your name appears in their The Bear panel. | Exploitable. Could break matchmaking. | **Skip.** Use as title only ("The Successor"). |
| 9 | **Auctionable Cosmetics** | Player-to-player auctions for rare cosmetics. | Trading + economy abuse + scams. | **Skip.** Roblox economy can't handle without RMT problems. |
| 10 | **Server-Wide Co-Op Boss Raid** | All players on a server simultaneously eat against one giant boss meter. Defeat the Soufflé Princess together. | Social-event culture is huge. | **Strong YES.** Try as a monthly event. |
| 11 | **The Sponsor Brand Takeover** | Real-world brand IP licensed in (e.g. a Nathan's-licensed week). | Trademark risk. Player skepticism of ads. | **Skip permanently.** Stay fictional. |
| 12 | **The Curse of the Glutton King** | If you lose 5 contests in a row, the Glutton King "curses" you — your character gets cartoon ghost-eyes for the next hour. Comedy debuff. | Punishes losing. | **Try it as cosmetic-only with a buff "blessing" instead — winning streak unlocks the Glutton King's blessing aura.** |
| 13 | **Tampopo Midnight Heist Quest** | 4-player co-op stealth quest. Sneak into rival shops at night to "steal" technique. | Stealth on Roblox is hard. | **Strong YES.** Try as a small one-room quest. |
| 14 | **The Bear's Origin Story** | Multi-week unlock chain that reveals The Bear's backstory through fragmented in-world documents. | Adds depth. Big build cost. | **Strong YES at P5.** Endgame meta. |
| 15 | **NPC Marriage** | Build friendship with an NPC long enough and they propose a "best friend" ceremony with you. Permanent pet bonus. | Adopt Me-coded social hook. | **Try it.** Wholesome. |

---

# Part 10 — Antoine's top 20 picks (curated)

> If you only add 20 things from this entire document, these are the ones I'd start with. Reasoned per pick. Ordered by impact-per-build-cost.

| # | Pick | Why | From Part |
|---|---|---|---|
| 1 | **The Iron Booth (Mystery-Box Contest)** | Single highest replayability ROI in the doc. One-time build, infinite curiosity payoff. | 1A #1 |
| 2 | **Madame Petite's Daily Horoscope** | A 5-minute daily login hook with cozy flavor and a real +5% buff. Stardew's TV-show retention trick. | 1E #39 + 8 |
| 3 | **The Foodgasm Reaction Burst** | The cheapest TikTok-bait mechanic in the game. Cosmetic flex, screenshot-bait. | 6 #1 |
| 4 | **The Pity Pit (Last-Place Consolation Arena)** | Directly fixes the worst feeling in the game (last place). State fair tradition reframed. | 1A #3 |
| 5 | **Photo Mode** | Roblox content economy is built on screenshots. This is non-negotiable for marketing. | 8 |
| 6 | **The Recipe Cookbook (Collection Meta)** | Long-tail retention for completionists. Cheap to implement on top of existing food data. | 8 |
| 7 | **The Mukbang Studio** | A non-contest social building that rewards lurkers and streamers alike. Adds a new player role. | 1G #54 + 6 #6 |
| 8 | **The Hall of Fame (Lore Building)** | Cheap to build, makes the world feel persistent, gives all NPCs in-world history. | 1E #33 |
| 9 | **Tournament Arc: Road to The Bear** | Gives P3-P4 players a multi-week goal that funnels them toward P5. | 5F |
| 10 | **The Server-Wide Co-Op Boss Raid (Soufflé Princess)** | Adopt Me / Bee Swarm proved monthly community boss events drive concurrent peaks. | 9 #10 |
| 11 | **Anton Ego Memory Bite** | Cheap to implement (a single cutscene), massive emotional payoff. The kind of moment players post about. | 6 #4 |
| 12 | **The FLDSMDFR Food Rain (Monthly Server-Wide)** | TikTok-bait spectacle. Justifies a single big particle system once a month. | 6 #9 |
| 13 | **Full-Body Food Costumes** | The fastest Style-Buck-monetizable cosmetic category. Avatar economy slam dunk. | 7 #7 |
| 14 | **The Vendor NPCs with Real Personality (esp. Lil' Lou Prize Booth)** | Personality-driven vendors are why Adopt Me, Pet Sim 99, and Brookhaven all retain. | 4F |
| 15 | **Friend Vault (Shared Coin Pool)** | The strongest friend-retention loop in any sim game. Bee Swarm clubs proved it. | 8 |
| 16 | **The Tampopo Midnight Heist Co-op Quest** | A single rare quest with high replay value that bonds friend groups. Cheap content per friction. | 9 #13 |
| 17 | **District: Diner America (Tier 2 expansion)** | Lowest-build-cost district expansion that fits the existing aesthetic. Validate the district-content model before bigger drops. | 2 #7 |
| 18 | **The Deep-Fried Anything Stand (Weekly Mystery Food)** | A single weekly rotating piece of content. Trivial to build, massive curiosity hook. | 1G #57 |
| 19 | **The Wedding Venue (Friend-Group Event)** | Adopt Me prints money on weddings. The Roblox audience will use it. | 9 #4 |
| 20 | **Rival Eating Gangs / Turf Wars (v2)** | Best long-term retention idea in the document, but plan for v2 to validate first the core PvE-with-drop-in-PvP loop. | 9 #6 |

## My top 3 if I could only add 3

1. **The Iron Booth (Mystery-Box Contest)** — replayability per dollar of build cost is unbeatable.
2. **The Foodgasm Reaction Burst** — cheapest TikTok bait, cheapest joke, fits the absurdist George Shea register exactly.
3. **The Pity Pit (Last-Place Consolation Arena)** — fixes the single worst player experience (DQ + last place) with a tradition-rooted reframe.

---

## Sources

- [Nathan's Hot Dog Eating Contest — Wikipedia](https://en.wikipedia.org/wiki/Nathan's_Hot_Dog_Eating_Contest)
- [Major League Eating July 4th Resources](https://majorleagueeating.com/july4th/)
- [Joey Chestnut vs Kobayashi rivalry — ESPN](https://www.espn.com/espn/story/_/id/40474004/takeru-kobayashi-hot-dog-eating-competition-joey-chestnut)
- [Competitive Eating and the Solomon Method — Econlife](https://econlife.com/2023/07/competitive-eating-3/)
- [Food Wars / Shokugeki no Soma — TV Tropes](https://tvtropes.org/pmwiki/pmwiki.php/Manga/FoodWars)
- [Overcooked design analysis — Hypercritic](https://hypercritic.org/collection/overcooked-review-overcooked-2-coop-game)
- [Battle Chef Brigade — Steam](https://store.steampowered.com/app/452570/Battle_Chef_Brigade_Deluxe/)
- [Battle Chef Brigade combat-cooking analysis — Game Developer](https://www.gamedeveloper.com/design/smashing-genres-together-for-tasty-results-in-i-battle-chef-brigade-i-)
- [Spirited Away food — Tofugu](https://www.tofugu.com/japan/spirited-away-food/)
- [Pizza Tower — Wikipedia](https://en.wikipedia.org/wiki/Pizza_Tower)
- [Cuphead: Sugarland Shimmy / Baroness Von Bon Bon — Cuphead Wiki](https://cuphead.fandom.com/wiki/Sugarland_Shimmy)
- [Iron Chef Mystery Boxes — Executive Chef Events](https://www.executivechefevents.com/iron-chef-mystery-boxes)
- [Hell's Kitchen Secret Ingredient Challenge — Hell's Kitchen Wiki](https://hellskitchen.fandom.com/wiki/Episode_2308_-_Get_A_Clue!)
- [Wonka's Factory architectural analysis — Parametric Architecture](https://parametric-architecture.com/architectural-look-inside-willy-wonkas-world/)
- [The Bear "Yes, Chef" culture — CBR](https://www.cbr.com/yes-chef-what-the-bear-gets-right-about-the-restaurant-industry/)
- [The Bear and kitchen drama — Movieweb](https://movieweb.com/the-bear-how-the-fx-show-turns-cooking-into-fiery-drama/)
- [Mukbang — Wikipedia](https://en.wikipedia.org/wiki/Mukbang)
- [Cooking Mama — Wikipedia](https://en.wikipedia.org/wiki/Cooking_Mama)
- [Stardew Valley Cooking — Stardew Wiki](https://stardewvalleywiki.com/Cooking)
- [Genshin Impact Food — Genshin Wiki](https://genshin-impact.fandom.com/wiki/Food)
- [Restaurant Tycoon 3 features — Roblox DevForum](https://devforum.roblox.com/t/50-new-features-in-restaurant-tycoon-3%E2%AD%90/3636102)
- [Cloudy with a Chance of Meatballs — Wikipedia](https://en.wikipedia.org/wiki/Cloudy_with_a_Chance_of_Meatballs_(film))
- [Anton Ego's flashback scene analysis — Far Out Magazine](https://faroutmagazine.co.uk/flashback-scene-ratatouille/)
- [Tampopo (1985) — Wikipedia](https://en.wikipedia.org/wiki/Tampopo)
- [Disco Elysium skill checks — Oreate AI](https://www.oreateai.com/blog/beyond-the-dice-roll-understanding-disco-elysiums-unique-skill-checks/39f4f589c2a7441b60b488c0b1896bd0)
- [Spiritfarer Cooking — Spiritfarer Wiki](https://spiritfarer.fandom.com/wiki/Cooking)
- [State fair fried-food traditions — Wic Project](https://wicproject.com/food/14-state-fair-fried-foods-that-go-way-too-far/)
- [Deep-fried fair delights — Ever After in the Woods](https://everafterinthewoods.com/deepfried-delights-to-enjoy-at-state-fairs-across-the-u-s/)
- [Mineko's Night Market — Steam](https://store.steampowered.com/app/762940/Minekos_Night_Market/)
- [Retro Diner (Roblox) — Retro Diner Wiki](https://retro-diner.fandom.com/wiki/Retro_Diner)
- [Frank's Fairground concept (internal)](./design-concept-menu.md#concept-1--franks-fairground-coney-island-belle-époque)
- [Gameplay Design Deep-Dive (internal)](./gameplay-design-deep-dive.md)
