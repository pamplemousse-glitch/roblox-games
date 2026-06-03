# MiniTrain RideController Integration Notes

## Constants to update post-merge
- **None.** MiniTrain has no entry in RideController's SPIN_RIDES, waypoint, or
  drop-tower tables (verified via `grep -i minitrain` over RideController.luau →
  zero hits). Static prop for v1.0.

## New code modules needed
- **None.** Ride remains static. The original session plan (RIDE_PLANS_v1.md
  §Session 4) called for a rideable consist with `TRAIN_SPEED` /
  `TRAIN_CAR_SPACING` constants and a Heartbeat loop, but the
  RIDE_REBUILD_PLAYBOOK §3 explicitly defers this to "keep static for v1.0
  (avoid scope creep)." Subagent kept that scope.

## Named-part contract preserved
- RideController reads **zero named parts** from `workspace.MiniTrain`. Nothing
  to preserve.
- For polish: 2 BunCars each contain `Seat_1` / `Seat_2` instances so players
  can sit on the static train if they like. These are not contract-required.

## What changed in `workspace.MiniTrain`
- Backup: `ServerStorage.MiniTrain_PreFood_2026-06-03` (full clone of old model).
- Rebuilt `Model` retained at `workspace.MiniTrain` (ClearAllChildren preserves
  the instance, satisfying any future `:FindFirstChild("MiniTrain")` callers).
- New children:
  - `TrackCenter` (invisible PrimaryPart at local origin so `PivotTo` lands
    track-center at the original world pivot).
  - `Track/` folder — 40 wooden ties + 96 iron rail segments (48 × 2 sides) on
    an ellipse with X-radius 55 / Z-radius 75 (≈110 × 150 stud footprint, 2× the
    previous build).
  - `Engine` Model — grilled hot dog (sausage cylinder + 2 sphere ends, 5
    mustard zigzag stripes, 4 grill marks, ketchup cowcatcher, 8 iron wheels,
    mustard smokestack cylinder + rim + steam puff).
  - `BunCar_1`, `BunCar_2` — puffy bun bodies (block + 2 sphere ends, lighter
    crust crown, 4 grill stripes, 2 Seats each, 8 iron wheels).
- `AB.weldAll` run on top-level and on each sub-Model so the train is rigid.
- `PivotTo(originalPivot)` restores world placement at (-240, 0, -355).

## Gotchas / follow-ups
- Engine and cars are placed on the south straight of the oval as a static
  visual. If v1.1 promotes this to a moving ride, the consist already lives in
  local space (oval centered at 0,0,0) so a Heartbeat loop just needs to update
  each unit's CFrame along the same `ovalPos`/`ovalTangent` helpers.
- No `RideController.luau` edit required for this merge.
