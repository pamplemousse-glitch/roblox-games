# Parallel Asset Generation — Session Prompts

Each prompt below is one full district. Copy/paste into a fresh Claude Code terminal window. Run all 5 in parallel.

## Launch protocol

```bash
# In a NEW terminal window for EACH session:
cd ~/Roblox && claude --dangerously-skip-permissions
```

Then paste the corresponding prompt below into the session.

---

## SHARED CONTEXT (auto-loaded by each session via /roblox-game)

- Project: `/Users/antoinewiley/Roblox/Competitive Eating/`
- Read first: `docs/MEGA_PLAN.md` for genre / dish list / master vision
- Reference scaffolding: `src/Assets/Districts/PizzaPlaza/` (worked example — copy patterns)
- Template module: `src/Assets/Districts/_template/_TEMPLATE.luau`
- Helper library: `src/Common/AssetBuilder.luau`
- Manifest format: `src/Common/AssetManifest.luau`

**STRICT RULES every session must follow**
1. NEVER call `mcp__Roblox_Studio__*` tools. Pure source code only.
2. Work on your assigned branch only. Push when done.
3. Each asset module follows the contract: `(parent: Instance, originCF: CFrame) -> Model`
4. Use `AB = require(game.ReplicatedStorage.Common.AssetBuilder)` for all primitives.
5. Keep modules ≤ 150 lines. Split into multiple if larger.
6. Append every asset module to `src/Common/AssetManifest.luau`
7. District X-band: see assigned coordinates per session.
8. Commit frequently. Push to your branch when done.

---

## SESSION 1 — Tokyo Town

```
Branch: feature/district-tokyo-town
Folder: src/Assets/Districts/TokyoTown/
District X-band: 4000

Genre: Japanese Street
Build all of:

FOODS (5, each as a Foods/<Name>.luau module — visual food display):
  Ramen Bowl, Gyoza Tray, Takoyaki, Sushi Roll, Mochi
  Each is a primitive-based representation: bowl/tray/balls/cylinder of rice with topping color.

BUILDINGS (5, each as Buildings/<Name>.luau):
  RamenShop (red noren curtain entry, wood + paper screens, neon sign in katakana style — use English text)
  SushiBar (white + black countertop, glass-front display case)
  IzakayaPub (warm wood, red lanterns hanging, sliding shoji doors)
  ShintoArchEntry (vermilion torii gate, two pillars + crossbar)
  StreetCartTakoyaki (small mobile cart with grill plate)

NPCS (4, each as Npcs/<Name>.luau — simple block rig with name billboard):
  Kenji, Yumi, Riku, Akemi

Coordinates: position each food at (4000+10i, 6, 0), buildings at (4000+50i, 0, 100),
NPCs at (4000+20i, 6, 30). Append each to AssetManifest.luau.

When done: commit with message "feature/district-tokyo-town: 14 assets" + push.
```

---

## SESSION 2 — Donut Dynasty

```
Branch: feature/district-donut-dynasty
Folder: src/Assets/Districts/DonutDynasty/
District X-band: 6000

Genre: Sweets / Pastries
Build all of:

FOODS:
  Donut (pink-glazed torus = cylinder with hole), Eclair (chocolate-topped log),
  Churro (sugared cylinder with ridges), Beignet (powdered cube), CinnamonRoll (spiral disk)

BUILDINGS:
  DonutShop (pastel pink storefront, neon "DONUTS" sign, glass case visible inside)
  GlazeFountain (multi-tier white fountain with pink "glaze" overflow)
  CoffeeKiosk (small wooden hut with espresso machine silhouette)
  BakeryArchEntry (gilded baroque arch in cream + gold)
  SugarSiloTower (tall white silo with "SUGAR" label)

NPCS: Marie, Bernard, Lulu, Stéphane

Coordinates: position each food at (6000+10i, 6, 0), buildings at (6000+50i, 0, 100),
NPCs at (6000+20i, 6, 30). Append each to AssetManifest.luau.

Palette: pastel pink (#FFC8D6), cream (#FFF0DC), chocolate brown (#5C3924), gold (#D4A852).

When done: commit with message "feature/district-donut-dynasty: 14 assets" + push.
```

---

## SESSION 3 — Burger Boulevard

```
Branch: feature/district-burger-boulevard
Folder: src/Assets/Districts/BurgerBoulevard/
District X-band: 8000

Genre: Burger Variants
Build all of:

FOODS:
  Smashburger (flat patty stack), DoubleStack (two patties + double bun),
  SliderCombo (3 small burgers on a tray), FriedChickenSandwich (chicken patty + slaw),
  Milkshake (tall glass + cherry on top)

BUILDINGS:
  DriveThruDiner (50s diner with red booths, chrome trim, neon "EAT" sign)
  BurgerJoint (small fast-food building, golden + red color scheme)
  ShakeStand (mid-century stand with milkshake icon)
  BurgerTowerLandmark (giant burger statue 20 studs tall)
  RetroGasStation (vintage gas pump aesthetic — repurposed as condiment fill station)

NPCS: Smash Riley, Patty Bonez, Slider Steve, Cookie

Coordinates: position each food at (8000+10i, 6, 0), buildings at (8000+50i, 0, 100),
NPCs at (8000+20i, 6, 30). Append each to AssetManifest.luau.

Palette: chrome silver (#B0B0B0), 50s teal (#7FCAC2), neon red (#FF3030), creamy white (#FFF5E8).

When done: commit with message "feature/district-burger-boulevard: 14 assets" + push.
```

---

## SESSION 4 — BBQ Holler

```
Branch: feature/district-bbq-holler
Folder: src/Assets/Districts/BbqHoller/
District X-band: 10000

Genre: American BBQ
Build all of:

FOODS:
  Brisket (rectangular smoked slab with bark crust), PulledPork (mound of stringy meat on bun),
  Ribs (rack of 4-5 connected ribs), HotLink (sausage link with grill marks),
  MacAndCheese (yellow cylinder of pasta in a bowl)

BUILDINGS:
  SmokehouseShack (wood cabin with brick smokestack, smoke rising)
  PicnicPavilion (open-sided wood structure with picnic tables)
  ChuckwagonStand (covered wagon trailer-cart with BBQ rig)
  BarnLandmark (red barn with white trim)
  FirepitCircle (stones + glowing logs)

NPCS: Big Earl, Mama Hattie, Tex Diggs, Skinny Joe

Coordinates: position each food at (10000+10i, 6, 0), buildings at (10000+50i, 0, 100),
NPCs at (10000+20i, 6, 30). Append each to AssetManifest.luau.

Palette: smoked wood brown (#6B4423), barn red (#A02828), embers orange (#FF8030), straw yellow (#E8C870).

When done: commit with message "feature/district-bbq-holler: 14 assets" + push.
```

---

## SESSION 5 — Mercado del Sol

```
Branch: feature/district-mercado-del-sol
Folder: src/Assets/Districts/MercadoDelSol/
District X-band: 12000

Genre: Mexican Street
Build all of:

FOODS:
  Taco (folded shell with meat + green + red interior),
  Burrito (rolled cylinder of multi-color fillings),
  Quesadilla (flat folded round with cheese stringing out),
  Tamale (corn-husk-wrapped log with red sauce dot),
  Elote (corn on cob with mayo + cheese dust + chili powder)

BUILDINGS:
  TaqueriaStall (open-front stall with grill, hand-painted sign)
  MercadoCanopy (multi-color papel picado banners overhead, tile floor)
  SalsaCart (pushcart with 3 dispensers — green, red, brown)
  CathedralArchEntry (cream-stucco arch with painted flowers)
  PiñataTower (chain of piñatas hanging from a tall pole)

NPCS: Don Pepe, Lucia, Memo, Doña Rosa

Coordinates: position each food at (12000+10i, 6, 0), buildings at (12000+50i, 0, 100),
NPCs at (12000+20i, 6, 30). Append each to AssetManifest.luau.

Palette: warm terracotta (#C45F2C), fiesta yellow (#FFB834), papel green (#5DA855), agave teal (#2B8C9C).

When done: commit with message "feature/district-mercado-del-sol: 14 assets" + push.
```

---

## What YOU do as coordinator

1. Open 5 new terminal tabs/windows
2. In each: `cd ~/Roblox && claude --dangerously-skip-permissions`
3. Paste the session prompt into the corresponding terminal
4. Wait 4-8 hours (sessions work in parallel)
5. When all 5 push their branches, ping me: I merge all 5 into main sequentially
6. Open Studio, reconnect Rojo. AssetSpawner instantiates everything on next Play.

## Notes for the coordinator (you)

- Watch each session's CPU/disk: parallel claude sessions can hit OS limits on a M-series Mac. 5 is usually fine, more is risky.
- If any session errors out and stops, just paste the same prompt back in to resume.
- Each session has full read access to MEGA_PLAN.md so it can self-orient on genre + dishes.
