# Frank's Fairground — Belle-Époque Ride Rebuild Playbook

Replaces the deprecated `RIDE_REBUILD_PLAYBOOK.md` (food-shape direction). Per user decision: Frank's stays a **conventional carnival**, rides use the Belle-Époque palette matching the existing Carousel. Districts (Pizza, Donut, Tokyo, etc.) carry the extreme food-themed escalation.

**Scope:** 11 rides. Carousel and BigWheel are exempt (user satisfied). Stalls already classic-themed.

---

## Strict rules (every subagent)

1. **NO `mcp__Roblox_Studio__*` calls.** Studio MCP is singleton; orchestrator owns it.
2. **NO edits to `src/Server/Services/RideController.luau`.** Document any constants needing change in `docs/handoffs/RIDE_<NAME>_INTEGRATION.md`; orchestrator applies post-merge.
3. **NO edits to other rides, other districts, stalls, food landmarks, or GUI.**
4. **OVERWRITE** the existing `src/Server/RideRebuild<RideName>.server.luau` files (do not create new filenames). The old food-shape build becomes irrelevant once your Belle-Époque version replaces it.
5. **PivotAnchor pattern is MANDATORY.** Never use the result of `AB.cylinder` as `m.PrimaryPart` — it bakes a 90° Z rotation that breaks `PivotTo`. Create an invisible 0.1×0.1×0.1 identity-rotation anchor part at the model origin, use that as PrimaryPart. (See `memory/feedback_pivot_anchor_pattern.md` for the full reasoning.)
6. **Pure primitives via `src/Common/AssetBuilder.luau`.** No Meshy.
7. **Read first:**
   - `Competitive Eating/src/Server/Services/RideController.luau` — for your ride's named-part contract
   - `Competitive Eating/src/Common/AssetBuilder.luau` — helpers
   - `Competitive Eating/src/Common/Palettes.luau` — Belle-Époque colors (use these exclusively)
   - `Competitive Eating/src/Server/TokyoGround.server.luau` — idempotent rebuild template
   - `Competitive Eating/docs/handoffs/RIDE_PLANS_v1.md` — for your ride's classic aesthetic + named-part contract

---

## Belle-Époque palette (mandatory)

| Name | RGB | Use |
|---|---|---|
| `burgundy` | (130, 30, 50) | Primary structural color (hull, walls, frame) |
| `ivory` | (245, 235, 205) | Highlight panels, stripes, sails |
| `antique_gold` | (200, 160, 80) | Trim, rivets, decorative bands |
| `deep_wood` | (110, 75, 45) | Wood decking, ties, beams |
| `wood_plank` | (160, 110, 70) | Lighter wood accents |
| `wrought_iron` | (40, 35, 40) | Iron rails, supports, chains |
| `cream` | (230, 215, 180) | Soft contrast accents |
| `crimson_glow` | (220, 60, 70) | Neon/glow accents (rare, hero touches) |

If `src/Common/Palettes.luau` already defines these (or equivalents), USE THOSE NAMES. Don't redefine inline.

---

## Universal contract per rebuild script

Same pattern as before:

1. `task.wait(1)` so peer scripts settle.
2. Bail with `warn` if `workspace.<RideName>` is missing.
3. Clone existing model to `ServerStorage.<RideName>_PreBelleEpoque_2026-06-03`.
4. `m:ClearAllChildren(); m.PrimaryPart = nil`.
5. **Create identity-rotation PivotAnchor first**:
   ```luau
   local pivotAnchor = AB.part({
       size         = Vector3.new(0.1, 0.1, 0.1),
       color        = Color3.new(1, 1, 1),
       cf           = CFrame.new(0, 0, 0),
       canCollide   = false,
       transparency = 1,
       name         = "PivotAnchor",
   }, m)
   m.PrimaryPart = pivotAnchor
   ```
6. Build the ride geometry around `O = CFrame.new(0, 0, 0)` at 2× original scale.
7. Preserve every part name RideController reads (Seat_1..N, named waypoints, etc.).
8. `AB.weldAll(m)` then `m:PivotTo(originalPivot)`.

Script ≤ 280 lines.

---

## Per-ride briefs

### 1. PirateShipRide → **Classic Pirate Galleon** (feature/ride-classic-pirateship)
- **Mechanic:** Pendulum swing.
- **Named parts:** `Seat_1..Seat_6`, hull `Body` as a named structural part (NOT PrimaryPart now — PivotAnchor is).
- **Aesthetic:** Weathered painted-wood galleon. Burgundy hull, deep_wood ribs, ivory deck, antique_gold trim. A-frame supports (not single pole). Burgundy pennant flag. Real figurehead at bow. Tagged `Structural` on hull/keel/mast/A-frame.
- **Scale:** ~50-stud-long hull (2× the original ~25). Axle at world Y=28 (originalPivot.Y); update RideController.PENDULUM_RIDES.PirateShipRide.pivotY if measurement says otherwise.
- **Integration note:** confirm `pivotY` measured value.

### 2. ScreamerCoaster → **Wooden Cyclone-style Coaster** (feature/ride-classic-coaster)
- **HARD constraint:** preserve every named waypoint part: `ArcN0_2`..`ArcN15_2`, `RailA0_2`..`RailA49_2`, `ArcF0_2`..`ArcF15_2`, `RailB0_2`..`RailB49_2`. XYZ unchanged.
- **ScreamerCart.Body** stays as the cart's primary, but in the CART (sub-model), not the track.
- **Aesthetic:** Coney Island Cyclone reference. Weathered ivory truss columns, deep_wood track ties, antique_gold rivet plates, burgundy lift-hill paint. Cart re-skin as a classic wooden coaster car: burgundy body + ivory trim + antique_gold rivets.
- **Scale:** Decoration 2× thicker around waypoints. Cart 1.3× original.
- **Integration note:** none expected.

### 3. MiniTrain → **Coney Island Miniature Railway** (feature/ride-classic-minitrain)
- **Mechanic:** Static for v1.0 (no live RideController coupling).
- **Aesthetic:** Vintage 1900s-style steam train. Burgundy boiler, antique_gold brass bands, deep_wood smokestack/cowcatcher, ivory cab roof. 2 passenger cars with bench seats. Oval track at ~110×150 stud at center (-240, 0, -355).
- **Scale:** 2× original footprint.
- **Integration note:** none.

### 4. SwingCarousel → **Wave Swinger** (feature/ride-classic-swing)
- **Mechanic:** Centripetal spin with chair swing-out + rope-physics Y lift (RideController already wired via cyclePause/Accel/Peak/Decel + swingOutAmplitude + swingDropAmplitude).
- **Named parts:** 16 `ChairGroup_1..ChairGroup_16` folders each with `Chain_*`, `RiderSeat` (Seat). PivotAnchor as PrimaryPart.
- **Aesthetic:** Sister ride to the Carousel. Burgundy + ivory striped conical canopy + antique_gold spire + 16 chain-suspended deep_wood chairs. NO straws, NO paper umbrella aesthetic — proper Belle-Époque Wave Swinger.
- **Scale:** Mast 26 stud, rim radius 18, chair radius 16 (these already proven by the playtest — don't increase).
- **Integration note:** none if you reuse the existing constants.

### 5. TeacupRide → **Classic Spinning Teacups** (feature/ride-classic-teacup)
- **Mechanic:** Spin (rps=0.55).
- **Named parts:** `Seat_1..Seat_N` at cup centers, platform PrimaryPart=PivotAnchor.
- **Aesthetic:** 8 fluted porcelain teacups (burgundy + ivory + antique_gold trim) on a decorative platter (burgundy with ivory rim, gold filigree). Each cup has a backrest and floral detail. Center teapot decoration.
- **Scale:** ~60-stud platter diameter (2× of 30-stud original).
- **Integration note:** none.

### 6. TiltAWhirl → **Classic Tilt-A-Whirl** (feature/ride-classic-tiltawhirl)
- **Mechanic:** Spin (rps=0.75) on an undulating wave platform.
- **Aesthetic:** Single circular platform (not stacked pancakes) with a gentle undulation. 6 burgundy + ivory tilt cars facing inward, each with a backrest and gold trim. Surrounding striped fence (burgundy/ivory).
- **Scale:** ~56-stud platform diameter.
- **Integration note:** none.

### 7. ScramblerRide → **Classic Scrambler** (feature/ride-classic-scrambler)
- **Mechanic:** Dual-rotation epicyclic.
- **HARD constraint:** preserve `workspace.ScramblerRide.Generated.ScramblerRide.Mechanics` inner Model hierarchy. `buildScrambler` in RideController reads it.
- **Aesthetic:** Burgundy + antique_gold center hub. 4 ivory arms with crimson-glow accent stripes. Cars: burgundy + ivory two-seater shells with deep_wood backrests. Surrounding ring fence.
- **Scale:** 2× original footprint.
- **Integration note:** confirm Mechanics inner structure naming preserved.

### 8. ParachuteJump → **Classic Parachute Drop** (feature/ride-classic-parachute)
- **Mechanic:** 8 chutes phase-offset rise/fall.
- **Named parts:** `Chute<style><idx>` per existing regex (read RideController).
- **Aesthetic:** Tall central deep_wood + antique_gold lattice tower (NOT a pretzel). 8 ivory parachute canopies with burgundy stripes, each with a rider seat hanging below.
- **Scale:** Tower 2× original height (preserve TOP_Y / BOTTOM_Y constants for the controller).
- **Integration note:** none.

### 9. DropTower → **Classic Drop Tower** (feature/ride-classic-droptower)
- **Mechanic:** Vertical drop (`buildDropTower` in RideController).
- **Aesthetic:** Tall ivory + antique_gold structural tower (NOT an ice cream cone) with burgundy accents. Drop carriage: burgundy + ivory open gondola with rider seats arranged in a ring.
- **Scale:** Tower 40 stud tall (was 61 — keep total height down so it doesn't dominate the skyline). Preserve DROP_CX/CZ/Y_MIN/Y_MAX constants.
- **Integration note:** if you shrink TOP_Y, document the new value for RideController.

### 10. LogFlume → **Classic Water Flume** (feature/ride-classic-logflume)
- **HARD constraint:** `wps` waypoint table in RideController.luau lines 349-360 is hardcoded — channel decoration is visual only.
- **Aesthetic:** Water trench tinted blue/teal (clear water, NOT mustard). Log boats: deep_wood hollowed logs with rider seats. Lift hill: stained wood ramp with antique_gold rivets.
- **Scale:** Visible channel 2× wider.
- **Integration note:** none.

### 11. BumperCarArena → **Classic Bumper Cars** (feature/ride-classic-bumpercars)
- **Mechanic:** Decorative (no live physics).
- **Aesthetic:** Smooth-floored arena (deep_wood planks). Surrounding ivory + burgundy + antique_gold trim wall (NOT cocoa cup). 6-8 bumper cars: burgundy + ivory two-tone shells with rubber bumpers and a single Seat each. Overhead light bulbs (string of crimson_glow + ivory bulbs).
- **Scale:** 2× original footprint.
- **Integration note:** none.

---

## Integration doc template

```markdown
# <RideName> RideController Integration Notes

## Constants to update post-merge
- (e.g.) `PENDULUM_RIDES.PirateShipRide.pivotY`: measured at <value> stud
- (e.g.) `DROP_Y_MAX`: was 61, now 40 — see DropTower constants

## Named-part contract preserved
- Confirm each name RideController reads (`Seat_1..N`, `Body`, `ChuteBasket<idx>`, etc.) is present in the new model

## Gotchas
- (anything the orchestrator should know)
```

---

## Output protocol

```bash
git log --oneline origin/main..HEAD     # 1 or 2 commits (rebuild + integration doc)
git push -u origin HEAD:feature/ride-classic-<short>
```

Report ≤ 150 words:
- Branch pushed
- Commit SHAs
- Part count of new model
- RideController constants flagged
- Any gotchas

---

## Orchestrator post-merge protocol

1. Merge each branch sequentially into main.
2. After every 4 merges, user playtest checkpoint.
3. After all 11 merged, single post-merge commit applies RideController constant updates (if any).
4. Optional: revert FoodballBasketball if user wants pure carnival classic on the stall too.
