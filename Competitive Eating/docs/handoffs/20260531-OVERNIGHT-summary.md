# Overnight Session Summary — 2026-05-31

Five rides worked on in one session. Status per ride below.

## ✅ Completed and committed

### 1. Carousel (v1 → v9) — commit `dbdb1b5`
- Full structural + palette overhaul from bright candy carnival to muted Belle-Époque (burgundy/ivory/antique gold/deep wood)
- 9 iterations refining: cone roof closure, 1.4× + 1.5× scale ups, ornate finial, palette correction, horse position + facing direction + Y variation, cornice declutter, two-tier roof proposal (rejected), seam ribs, mount position fix, prompt occupancy gating
- `RideController.luau`: per-horse gallop animation (HorseGallop type + Heartbeat overlay), per-seat Mount ProximityPrompts (replacing buried BoardZone), occupancy-aware prompt visibility
- Full v1→v9 detail in `20260531-0208-carousel-rebuild.md`

### 2. PirateShipRide — commit `5c49842`
- 44 ship parts + 7 PirateShipSupport parts in **separate sibling model** (A-frame doesn't swing with the hull — fixes the original "support frame inflates centroid" bug)
- Belle-Époque palette: burgundy hull + deep_wood ribs + ivory deck + antique_gold gunwale/figurehead, burgundy pennant replaces Jolly Roger
- Hull/keel/bow/stern/mast/A-frame tagged `Structural` so `partCentroid()` ignores decorative
- 6 PirateSeats preserved, repositioned to new deck Y=9.3 facing bow-forward
- `RideController.luau`: `pivotY` updated 26 → 28 to match new A-frame axle height

### 3. SwingCarousel — commit `eb50d87`
- 133 new parts: antique-gold center mast + 16-panel burgundy/ivory conical canopy + 16-segment gold rim ring + 16 ChairGroup_i Models (platform + back + 2 rails + RiderSeat + chain) + 16 warm-glow festoon globes
- `RideController.luau`: new `ChairSwing` type, `SpinState` extended with `swingOutAmplitude` + `chairs`, `SPIN_RIDES["SwingCarousel"]` gets `swingOutAmplitude = 4.5`
- Init scans `ChairGroup_1..16`, collects parts/chains/seat per group
- Heartbeat (post-PivotTo, pre-gallop): computes radial direction from chair's **current** world position (so it follows the spin), applies translation = `currentRps/rps × amp × radialDir`. Chairs + seats move full delta; chains move half (visual tilt approximation)

## ⚠️ Built in Studio but NOT in git

### 4. ScreamerCoaster
- **In Studio**: 132 waypoints preserved + repainted deep_wood, 215 non-waypoint parts backed up to `ServerStorage.ScreamerCoasterBackup_v1`, 681 new parts (cross-ties + burgundy side rails + ivory truss columns + cross-braces + antique-gold rivet plates + station house + marquee + cart re-skin + warm-glow headlight)
- **No RideController.luau code change** — preserved waypoint names + ScreamerCart.Body PrimaryPart per plan constraints
- **Quality flag**: truss lattice came out ~3× denser than planned (every waypoint segment got rails + every ~12 stud got trusses). Reads as "supported framework" but messy. **Polish recommended**: thin to single-rail-per-segment + group trusses into 4-column bents every 25 stud.

### 5. MiniTrain
- **In Studio**: ~205 new parts. New Engine model (burgundy boiler + brass bands + deep_wood smokestack + cowcatcher + cab + 4 driving wheels + 2 pilot wheels + bell + warm-glow headlight). 2 open-air passenger cars (deep_wood floor + antique_gold posts + ivory roof + burgundy bench Seats + wheels + side rails). 48-segment oval track (deep_wood ties + antique_gold rails). Station house (deep_wood walls + burgundy gabled roof + ivory platform) with "FRANK'S EXPRESS" SurfaceGui sign + TrainBoardZone.
- **TrainMovement script** (workspace.MiniTrain.TrainMovement) updated to handle boarding: TrainBoardZone ProximityPrompt → `collectPassengerSeats()` → Sit first empty seat. **This script is NOT Rojo-tracked** — lives only in the .rbxl file.
- **No RideController.luau code change** — TrainMovement already had the orbit Heartbeat from the original build, just augmented with boarding.

## 📦 To save the Studio-only work

The ScreamerCoaster + MiniTrain rebuilds live ONLY in the Studio data model. They'll persist after a Studio save (Ctrl+S in Studio → writes to the `.rbxl` file at `/Users/antoinewiley/Documents/Competitive Eating.rbxl`). Tomorrow, save the file in Studio to lock those changes in.

## 🚀 Pushed commits

```
eb50d87 SwingCarousel REBUILD: chair-swing-out physics + Belle-Époque palette
5c49842 PirateShipRide REBUILD: A-frame support + Belle-Époque palette + pivotY recalc
dbdb1b5 Carousel REBUILD v1→v9: full structural + palette overhaul + horse gallop + ridable seats
0c47093 Initial commit: Roblox games monorepo
```

All on `main`, pushed to `origin/main`.

## 🪲 Known issues

1. **ScreamerCoaster overbuilt truss density** — polish pass recommended (~10 min)
2. **Mount position/prompt UX for Carousel** — script edits made (v9), but visual confirmation requires a play-mode walk-through that I can't programmatically capture
3. **MiniTrain not committed to git** — Studio-only. Save the .rbxl to persist.
4. **No play-mode verification** done on PirateShip swing (pivotY=28) or SwingCarousel chair-swing-out — both should work per the code patterns but visual confirmation is yours to do

## ✅ Backup folders in ServerStorage

- `CarouselBackup_20260531` (v1 originals)
- `CarouselBackup_20260531_v2` (v2 originals)
- `CarouselBackup_20260531_v7` (v7 originals)
- `PirateShipBackup_v1` (117 original ship parts)
- `SwingCarouselBackup_v1` (87 original parts)
- `ScreamerCoasterBackup_v1` (215 original non-waypoint parts)
- `MiniTrainBackup_v1` (6 original train children)

Rollback via tag-scan + reparent. All new parts tagged `rebuild-<ride>-<version>-added`.

## 🛌 Tomorrow's recommended order

1. **Open Studio + Save** (Ctrl+S) to persist the .rbxl changes
2. **Playtest each ride** — verify carousel mount UX, pirate swing, swing chairs flying outward, train boarding
3. **Polish ScreamerCoaster trusses** (optional ~10 min cleanup)
4. **Continue per SESSION_QUEUE.md** — Session 6 (scale-up pass on TeacupRide/TiltAWhirl/Scrambler/ParachuteJump/DropTower/LogFlume/BumperCars), Session 7 (mini-game stalls overhaul)

Sleep well.
