# Parallel Asset Generation V2 — Expanded scope, mixed tooling

V2 of the parallel session pattern. Each district now targets **70-100 placements** (was ~14) with selective Cube 3D mesh allowance.

---

## Shared rules (every session must follow)

### Setup (mandatory per session — uses git worktree)

```bash
cd ~/Roblox
git fetch origin
git worktree add ../<short>-wt -b feature/district-v2-<full-name> origin/main
cd ../<short>-wt
claude --dangerously-skip-permissions
```

Replace `<short>` with `pizza`, `tokyo`, `donut`, `burger`, `bbq`, `mercado`. **Never `cd` back to the shared repo while the session is running** — that's how branches got contaminated last time.

### Tool selection guide (TL;DR for each session)

| Tool | When to use | When NOT to use |
|---|---|---|
| **`AssetBuilder` primitives** (`src/Common/AssetBuilder.luau`) | Walls, floors, fences, simple shapes, anything that can be a colored block/cylinder/sphere/wedge | Anything that needs curvature, soft edges, organic shapes |
| **`mcp__Roblox_Studio__generate_mesh`** (Cube 3D) | 1-2 hero buildings per district + 5 food items per district. 5/min rate limit. | Bulk content. Wastes the rate limit. |
| **`mcp__Roblox_Studio__generate_procedural_model`** | Batch variants (e.g. 12 different lanterns, 8 trash cans with different colors) | One-off pieces |
| **`mcp__Roblox_Studio__insert_from_creator_store`** | Plants, trees, generic decor that already exists in Roblox Toolbox | Custom-themed pieces (those should be primitives or Cube 3D) |
| **`mcp__Roblox_Studio__generate_material`** | Custom surface textures (brick, asphalt, wood grain) for primitives | Tiny props |
| **External: Meshy.ai REST API** | Hero landmarks (Statue of Liberty-tier showpieces, character mascots) | Building bulk. Costs credits. |

### Output structure per district

```
src/Assets/Districts/<DistrictName>/
  Buildings/           # 5-8 heroes (Cube 3D where it counts) + 8-12 backdrop primitives
  Foods/               # 5 food displays (primitives — already done)
  Props/               # 20-40 ambient (Cube 3D + primitives mix)
  Decor/               # 30+ small decorative (mostly primitives via vstack/circleArrange)
  Npcs/                # 4-8 named NPCs (primitive rigs) + 8-12 background pedestrian rigs
  Landmarks/           # 1-3 iconic features (Cube 3D or Meshy.ai)
```

Every asset = a Luau module exporting `(parent: Instance, originCF: CFrame) -> Model`. Same contract as v1.

### Quality bar

- Each asset module: up to **400 lines** (was 150)
- 5-10 distinct visual elements per non-trivial building (door frame + windows + roof detail + sign + etc.) — not just a colored box
- Hero buildings use 1+ Cube 3D mesh + surrounding primitive detail
- Add ambient lighting on neon/glowy elements via `AssetBuilder.glow`
- Use `AssetBuilder.weldAll` so models can be moved as units

### Append every asset to `src/Common/AssetManifest.luau`

Use the position formulas in the per-district sections below.

### Polish review step (mandatory at end)

After writing all assets, re-read your own modules and add 5+ details to each weak-looking asset. Specifically check:
- Does the building have door/window cutouts (not just a solid box)?
- Are there sign/text elements?
- Is there at least one Neon part for nighttime visibility?
- Does the front face have visual interest?

### Commit cadence

Commit after each category folder is complete (Buildings, then Foods, then Props, etc.). Push branch when done.

---

## SESSION 1 — Pizza Plaza (`feature/district-v2-pizza`)

```
/roblox-game

You are V2-rebuilding the Pizza Plaza district at /Users/antoinewiley/Roblox/Competitive Eating/.

WORKTREE: ~/Roblox/pizza-wt (already created via session setup)
BRANCH: feature/district-v2-pizza
DISTRICT BASE X: 700 (Frank's at 0, Pizza Plaza next east)

GENRE: Italian-American street.

CATALOG (build all of these as modules under src/Assets/Districts/PizzaPlaza/<category>/):

BUILDINGS (10-13):
  Hero (use mcp generate_mesh for 1-2):
    1. TonysPizzeria — red striped awning, neon "PIZZA", brick walls, glass front
    2. MammaCarmelasTrattoria — outdoor seating, vine-covered, soft amber windows
    3. VinnysSliceShop — corner counter window, takeout-style
    4. RomeosGelatoStand — pastel display case with colored bins, striped umbrella
    5. SalsCalzoneCart — small wheeled cart with neon "CALZONE"
  Backdrop primitives:
    6. TenementWalkup — 3-story brick apartment, fire escape attached
    7. BrickAlleyWall — long alley wall with mural
    8. LaundryLineBuildings — buildings with laundry strung between
    9. BocceCourt — gravel rectangle with white-painted lines
    10. RistoranteSignWall — backside wall with painted "Ristorante" sign

PROPS (20-30):
  Checkered table umbrella set (×4), espresso cart, mini Vespa, wine barrel stack,
  fruit market crates (×3), trash can, lamppost (×6), street sign, food crates,
  busker accordion stand, sandwich-board chalk menu, pigeon perches

DECOR (30+):
  Italian flag bunting strands, "Open" neon signs, drying pasta racks (cosmetic),
  lemon garland strings, café chair rows, vine planters, "Ciao!" mural

LANDMARKS (2-3):
  Hero (Cube 3D recommended):
    1. TreviFountain — Baroque-style fountain with statues, 3-tier
    2. BaroqueArchEntry — large carved arch at district boundary
    3. GiantPizzaOven — landmark-scale brick oven w/ flames

NPCS (8-12):
  Named v1 (block rigs):
    Vinny, Tony, Carmela, Sal
  Pedestrians (block rigs, ambient):
    OldManBenchReader, KidWithGelato, NonnaShoppingBag, AccordionBusker,
    FashionCouple, StreetSweeper, DeliveryBoyOnBike

PLACEMENT (append to src/Common/AssetManifest.luau):
  Buildings at (700+50i, 0, 100) for i=1..10
  Foods   at (700+10i, 6, 0)  for i=1..5
  Props   at (700+15i, 0, 60+10j) — grid them, i = 1..20, j = 0..4
  Decor   at (700+10i, 12, 80+5j) — grid
  Landmarks at (700+100i, 0, 130) for i=1..3
  NPCs    at (700+20i, 6, 30) for i=1..12

TOOL GUIDANCE:
  - Hero buildings (TonysPizzeria, MammaCarmelas, TreviFountain): use mcp generate_mesh with descriptive Italian-American prompts; budget your 5/min rate limit wisely
  - Everything else: AssetBuilder primitives
  - Plants/trees: try `mcp insert_from_creator_store` with searches like "potted plant", "olive tree", "italian flag"

PALETTE: brick red (150, 60, 50), pasta cream (240, 220, 180), basil green (80, 140, 60), wine red (110, 30, 40), espresso brown (60, 35, 20)

When done: commit with "feature/district-v2-pizza: full district, NN assets" + push.
```

---

## SESSION 2 — Tokyo Town (`feature/district-v2-tokyo`)

```
/roblox-game

You are V2-rebuilding Tokyo Town district at /Users/antoinewiley/Roblox/Competitive Eating/.

WORKTREE: ~/Roblox/tokyo-wt
BRANCH: feature/district-v2-tokyo
DISTRICT BASE X: 1400

GENRE: Japanese street.

CATALOG:

BUILDINGS:
  Hero (Cube 3D for 1-2):
    1. DaikonRamen — red noren curtain entry, wood beams, paper screens, glowing "RAMEN"
    2. SushiDaiko — long counter with glass display, sleek minimal exterior
    3. IzakayaLantern — string of red paper lanterns along front, sake bottles in window
    4. SakeBar — narrow speakeasy-style with bamboo accents
    5. TakoyakiCart — pushcart with grill plate and tako tools
  Backdrops:
    6. CapsuleHotel — tower with pod windows
    7. VendingMachineWall — row of colorful vending machines
    8. NarrowAlleyShops — close-packed multi-color shops
    9. SalarymanApartments — boxy apartment block
    10. LanternNoodleRow — string of food stands with red lanterns

PROPS:
  Red paper lanterns (string ×3), vending machines (single ×8), sake barrels,
  pachinko machine, bicycle rack, manhole covers, broom + dustpan, kindergarten
  pull-cart, daruma dolls, omikuji rack, koi pond stones

DECOR:
  Katakana neon "ラーメン"-style, cherry blossom strings, washi-paper banners,
  Japanese flag bunting, white-tile alley markings

LANDMARKS:
  Hero (Cube 3D):
    1. GiantManekiNeko — 30-stud-tall lucky cat statue
    2. MiniPagodaTower — 3-tier pagoda
    3. ShintoTorii (already exists in v1 — make it 2x bigger)

NPCS:
  Named: Kenji, Yumi, Riku, Akemi
  Pedestrians: SalarymanSuited, SchoolgirlBento, SushiChef, RamenSlurper,
  BowingShopkeeper, CapsuleHotelGuest, BicycleSchoolgirl, PachinkoPlayer

PLACEMENT: same formulas as Pizza Plaza but base X = 1400. Append to AssetManifest.

TOOL GUIDANCE:
  - DaikonRamen + GiantManekiNeko: use mcp generate_mesh
  - Cherry blossom trees: try `mcp insert_from_creator_store` "sakura tree" "cherry blossom"
  - Foods (RamenBowl, etc.): already done in v1, KEEP and don't rebuild

PALETTE: vermilion red (200, 50, 40), warm wood (150, 100, 60), paper white (245, 240, 230), bamboo green (140, 180, 100), lantern yellow (255, 180, 70)

When done: commit "feature/district-v2-tokyo: full district, NN assets" + push.
```

---

## SESSION 3 — Donut Dynasty (`feature/district-v2-donut`)

```
/roblox-game

V2-rebuild Donut Dynasty at /Users/antoinewiley/Roblox/Competitive Eating/.

WORKTREE: ~/Roblox/donut-wt
BRANCH: feature/district-v2-donut
DISTRICT BASE X: 2100

GENRE: Sweets / Pastries — bright, pastel, fairy-tale.

CATALOG:

BUILDINGS:
  Hero (Cube 3D for 1-2):
    1. LeGlacePastry — French patisserie facade with gold trim, display window
    2. SweetheartDonuts — pink storefront with rotating neon donut sign
    3. BeignetBayou — New Orleans-style with iron lacework balcony
    4. CinnamonSpiralRollCo — twisted-tower roof
    5. CocoaAndCake — chocolate-themed dark brown shop
  Backdrops:
    6. PinkTownhouses — row of pastel pink homes
    7. CandyCaneLampRow — striped lampposts
    8. SugarCrustedApartments — frosted exterior
    9. GingerbreadStorefronts — themed shops

PROPS:
  Candy-coated benches (×4), lollipop signposts (×6), marshmallow ottomans,
  sugar cube planters (×8), gum-drop pebbles, hot chocolate stand, ice cream
  pushcart, donut display rack, cake-stand tables

DECOR:
  Pink balloon bunches, ribbon streamers, gumdrop fences, cotton candy bushes,
  rainbow sprinkle paths

LANDMARKS:
  1. GlazeFountain (v1 already, KEEP)
  2. GiantDonutTower — 80-stud tall donut sculpture
  3. CandyCaneArchway — striped welcome arch
  4. SugarSpireCastle — small castle structure

NPCS:
  Named: Marie, Bernard, Lulu, Stephane
  Pedestrians: PastryChef, FairyGodmother, DonutDeliveryKid, KidCottonCandy,
  WeddingPhotoCouple, BalletDancerKid, BakerWithApron

PLACEMENT: same formulas, base X = 2100.

TOOL GUIDANCE:
  - SweetheartDonuts + GiantDonutTower: mcp generate_mesh
  - Plant decor: insert_from_creator_store "candy" "lollipop"
  - Foods: v1 already done, KEEP

PALETTE: pastel pink (255, 200, 214), cream (255, 240, 220), chocolate brown (92, 57, 36), gold (212, 168, 82), mint green (180, 230, 200)

When done: commit "feature/district-v2-donut: full district, NN assets" + push.
```

---

## SESSION 4 — Burger Boulevard (`feature/district-v2-burger`)

```
/roblox-game

V2-rebuild Burger Boulevard at /Users/antoinewiley/Roblox/Competitive Eating/.

WORKTREE: ~/Roblox/burger-wt
BRANCH: feature/district-v2-burger
DISTRICT BASE X: 2800

GENRE: 50s Americana / burger drive-in.

CATALOG:

BUILDINGS:
  Hero (Cube 3D 1-2):
    1. SmashvilleDriveIn — 50s diner with red booths visible, chrome strip
    2. BigBeefDiner — classic dining car aluminum exterior
    3. SliderStop — small mid-century stand
    4. ChickenwichExpress — fast-food order window
    5. CoolShakeMixer — milkshake-themed building
  Backdrops:
    6. DriveInMovieWall — large screen with vintage film
    7. VintageGasStation — pumps with sign canopy
    8. NeonMotel — pink neon "VACANCY"
    9. AutoGarage — open-bay garage
    10. SuburbanHouses — picket-fence single-story

PROPS:
  Vintage Cadillac models (×3), jukebox (×2), drive-in speakers, roller-skater
  display rack, condiment caddy, fryer vats, milkshake mixers, bar stools

DECOR:
  Chrome trim everywhere, red+white checkered banners, neon arrow signs,
  vinyl records hung, americana flag bunting

LANDMARKS:
  1. GiantBurgerTower (v1 has, KEEP/upgrade)
  2. 50sNeonArch — entry archway
  3. DriveInMarquee — vintage marquee with show titles
  4. MilkshakeWaterTower — water tower painted as milkshake glass

NPCS:
  Named: SmashRiley, PattyBonez, SliderSteve, Cookie
  Pedestrians: RollerSkatingWaitress, GreaserWithComb, JukeboxDancer, BeatnikWithShake,
  VarsityLetterman, ClassicCarOwner

PLACEMENT: same formulas, base X = 2800.

TOOL GUIDANCE:
  - SmashvilleDriveIn + GiantBurgerTower: mcp generate_mesh
  - Cadillac models: try insert_from_creator_store "vintage car" first
  - Foods: v1 done, KEEP

PALETTE: chrome silver (176, 176, 176), 50s teal (127, 202, 194), neon red (255, 48, 48), cream (255, 245, 232), sky blue (135, 206, 235)

When done: commit "feature/district-v2-burger: full district, NN assets" + push.
```

---

## SESSION 5 — BBQ Holler (`feature/district-v2-bbq`)

```
/roblox-game

V2-rebuild BBQ Holler at /Users/antoinewiley/Roblox/Competitive Eating/.

WORKTREE: ~/Roblox/bbq-wt
BRANCH: feature/district-v2-bbq
DISTRICT BASE X: 3500

GENRE: American BBQ / rural smokehouse.

CATALOG:

BUILDINGS:
  Hero (Cube 3D 1-2):
    1. SmokehouseSmokyJoes — large smoker shack with brick chimney + smoke
    2. RibShack — wooden shack with corrugated tin roof
    3. PulledPorkPit — dug-out pit with open fire
    4. BrisketBarn — converted red barn with sliding door
    5. PitBossBBQTruck — vintage food truck
  Backdrops:
    6. WeatheredFarmhouse — old wooden farmhouse
    7. RustedShed — metal shed
    8. HayBarn — large hay barn
    9. LogCabin — rough timber cabin
    10. WaterTower — wooden water tower

PROPS:
  Smoker barrels with smoke particles (×4), BBQ grills (×3), picnic tables (×4),
  wooden crates, beer kegs, charcoal piles, axe + stump, rocking chairs, lanterns

DECOR:
  String lights, American flag bunting, sun-bleached pennants, wagon wheels,
  ranch fence, hay bale stacks, dried corn husks

LANDMARKS:
  1. BarnLandmark (v1 has, KEEP)
  2. GiantPigStatue — fiberglass-style pig sculpture
  3. SmokerChimneyTower — tall industrial smoker
  4. HayBalePyramid — towering hay bale stack

NPCS:
  Named: BigEarl, MamaHattie, TexDiggs, SkinnyJoe
  Pedestrians: PitMasterApron, CowboyWithHat, FarmgirlIcedTea, BBQJudge,
  KidEatingRibs, FarmerWithPitchfork, GuitarPlayerPorch

PLACEMENT: same formulas, base X = 3500.

TOOL GUIDANCE:
  - SmokehouseSmokyJoes + GiantPigStatue: mcp generate_mesh
  - Foliage / hay: insert_from_creator_store "hay bale" "fence"
  - Add ParticleEmitter to smoker barrels for smoke effect
  - Foods: v1 done, KEEP

PALETTE: smoked wood brown (107, 68, 35), barn red (160, 40, 40), embers orange (255, 128, 48), straw yellow (232, 200, 112), rust brown (140, 80, 50)

When done: commit "feature/district-v2-bbq: full district, NN assets" + push.
```

---

## SESSION 6 — Mercado del Sol (`feature/district-v2-mercado`)

```
/roblox-game

V2-rebuild Mercado del Sol at /Users/antoinewiley/Roblox/Competitive Eating/.

WORKTREE: ~/Roblox/mercado-wt
BRANCH: feature/district-v2-mercado
DISTRICT BASE X: 4200

GENRE: Mexican street market.

CATALOG:

BUILDINGS:
  Hero (Cube 3D 1-2):
    1. TaqueriaElSol — open-front with hand-painted menu board
    2. BurritoCasa — colorful adobe storefront
    3. QuesadillaStand — corner stall with cheese-pull display
    4. TamaleTia — small kiosk with steamer pot
    5. EloteTruck — yellow truck with corn cob mascot
  Backdrops:
    6. TerracottaHacienda — clay-tile roofed building
    7. CantinaStainedGlass — bar with colored window panes
    8. PinkGreenStuccoShops — vivid pastel facades
    9. FountainCourtyard — central courtyard with fountain
    10. BellTower — Spanish-style bell tower

PROPS:
  Papel picado banners (×6), sombrero rack, donkey cart, mariachi gear pile,
  ceramic pots (×8), salsa cart, succulent planters, calaveras (sugar skulls),
  woven baskets, dance ribbons

DECOR:
  Marigold flower arches (Día de Muertos style), painted tile walls,
  candle altar (with cosmetic candles), woven hammocks, papel picado strings

LANDMARKS:
  1. PinataTower (v1 has, KEEP / upgrade)
  2. CathedralArchEntry (v1, KEEP)
  3. MariachiBandstand — gazebo-style bandstand
  4. GiantCactusSculpture — saguaro cactus 40 studs tall

NPCS:
  Named: DonPepe, Lucia, Memo, DonaRosa
  Pedestrians: MariachiMusician, AbuelaTortillaCart, KidWithElote, MaskedLuchador,
  DancingCouple, ChurroVendor, KidsKickingBall

PLACEMENT: same formulas, base X = 4200.

TOOL GUIDANCE:
  - TaqueriaElSol + GiantCactusSculpture: mcp generate_mesh
  - Marigold flowers: insert_from_creator_store "marigold" "flower bush"
  - Foods: v1 done, KEEP

PALETTE: terracotta (196, 95, 44), fiesta yellow (255, 184, 52), papel green (93, 168, 85), agave teal (43, 140, 156), bougainvillea pink (220, 80, 140)

When done: commit "feature/district-v2-mercado: full district, NN assets" + push.
```

---

## What YOU do as coordinator

1. **Open 6 terminal tabs** — one per district
2. In each, run the **setup commands** at the top of this file (with the correct `<short>-wt` name)
3. Paste the matching session prompt
4. Let them run 10-12 hours
5. **When all 6 push their branches**, tell me — I merge sequentially into main

## Coordinator merge protocol (when sessions are done)

```bash
cd ~/Roblox
git checkout main && git pull
for d in pizza tokyo donut burger bbq mercado; do
  git merge --no-ff origin/feature/district-v2-$d -m "Merge district v2 $d"
done
git push origin main
# Clean up worktrees:
for d in pizza tokyo donut burger bbq mercado; do
  git worktree remove ../$d-wt
done
# Delete branches:
git branch -D $(for d in pizza tokyo donut burger bbq mercado; do echo feature/district-v2-$d; done) 2>/dev/null
git push origin --delete $(for d in pizza tokyo donut burger bbq mercado; do echo feature/district-v2-$d; done) 2>/dev/null
```

The AssetManifest conflicts (every district modifies it) will need union-resolution per branch.
