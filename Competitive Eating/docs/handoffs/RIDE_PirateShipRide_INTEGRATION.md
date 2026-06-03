# PirateShipRide RideController Integration Notes

Banana Boat rebuild of `workspace.PirateShipRide`. Built by
`src/Server/RideRebuildPirateShipRide.server.luau` (idempotent, runs once at
server start, backs old model up to ServerStorage as
`PirateShipRide_PreFood_2026-06-03`).

## Constants to update post-merge

In `src/Server/Services/RideController.luau`, in the `PENDULUM_RIDES` table
at line 31:

```luau
{ name = "PirateShipRide", amplitude = 0.55, frequency = 0.7, pivotY = 28, axis = "Z" },
```

Update to:

```luau
{ name = "PirateShipRide", amplitude = 0.55, frequency = 0.7, pivotY = 56, axis = "Z" },
```

### Why pivotY = 56 (measured)

- The new banana hull spans local Y = -4..+10 (HULL_HEIGHT 6 plus a 4-stud
  sag bow). Deck sits at local Y = 6.
- Two `SwingArm_L/R` parts run vertically from `DECK_Y = 6` up to `AXLE_Y = 56`.
- The `Axle` part itself sits at local Y = 56. The two A-frame towers (Fore +
  Aft) meet their crossbeams at the same Y = 56 height.
- `Body` (the invisible PrimaryPart spine) sits at the deck (Y = 4) — the
  pendulum animator wants the **axle** Y, not the body Y, so the explicit
  `pivotY = 56` override is required.
- This is exactly **2×** the previous value (28 → 56), matching the 2×
  footprint rule in the playbook.

### Why axis stays "Z"

The banana hull is laid out along the local X axis (length = 50 studs).
Pendulum rotation needs to be around the perpendicular horizontal axis (Z),
which makes the bow + stern arc up and down. That's unchanged from the old
PirateShip orientation.

### Amplitude / frequency

No change. amplitude = 0.55 rad, frequency = 0.7 Hz still feel right for a
hull this size. If post-merge playtest looks too fast/slow, knock frequency
to 0.55 — but ship one number at a time.

## New code modules needed

- **None.** The rebuild script lives at
  `src/Server/RideRebuildPirateShipRide.server.luau` and is fully
  self-contained (uses only `AssetBuilder` primitives + workspace + ServerStorage).
- No new helpers in `RideController.luau` are needed; the existing pendulum
  loop (line 888 region) handles the new model unchanged because:
  - `PrimaryPart = Body` exists.
  - `partCentroid` finds Structural-tagged parts (hull segments, body spar,
    swing arms, axle, A-frame legs + crossbeams) and ignores decorative
    parts (ripe spots, palm fronds, peel strips, coconuts, gold trim, seat
    backs) — so the centroid hugs the ship's true long axis.
  - With the `pivotY = 56` override, only X/Z come from the centroid; Y is
    pinned to the axle.

## Named-part contract preserved

`RideController.luau`'s pendulum init (line 643-660) reads from
`workspace.PirateShipRide`:

- `m.PrimaryPart` — set to `Body` (verified: line 138 of rebuild script).
- `getSeats(model)` walks immediate children for `ClassName == "Seat"`.
  6 Seats named `Seat_1`..`Seat_6` are direct children of the ship Model
  (verified: lines 166-186 of rebuild script).
- `partCentroid` prefers Structural-tagged parts. Tagged parts:
  - `HullSeg_1` .. `HullSeg_9` (9 banana segments)
  - `Body` (invisible spine)
  - `SwingArm_L`, `SwingArm_R`
  - `Axle`
  - `AFrame_Fore_L`, `AFrame_Fore_R`, `AFrame_Aft_L`, `AFrame_Aft_R`
  - `AFrame_Fore_Base`, `AFrame_Aft_Base`
  Total: 17 Structural-tagged parts, evenly distributed around the ride's
  true geometric center along X/Z so the centroid override only needs Y.

### Renamed / removed parts

None. The contract is name-for-name compatible.

## Verification checklist for orchestrator

After merging this branch + applying the pivotY = 56 update:

1. Server start: console should log
   `[RideRebuildPirateShipRide] Rebuilt as Banana Boat — N parts, PrimaryPart=Body, pivotY target ≈ 56`.
2. Old model should be in `ServerStorage.PirateShipRide_PreFood_2026-06-03`.
3. Pendulum visibly swings around the **axle line at Y = 56** (not around the
   deck and not around the ground). Bow + stern arc symmetrically.
4. 6 boarding seats still pickable via the `BoardZone_PirateShipRide`
   ProximityPrompt.
5. `BillboardGui` / lights from `FranksStringLights` still anchor near
   ride origin (no change — only model contents were rebuilt).

## Gotchas

- The script runs at server start once and bails idempotently if the
  Model is missing. Re-running on an already-rebuilt model will produce a
  second backup `PirateShipRide_PreFood_2026-06-03_N` (Roblox auto-suffixes
  name collisions in ServerStorage) and re-clear the ride — that's fine,
  but if you replay-edit and want to keep your live state, comment out the
  script first.
- `task.wait(1)` at the top is so peer rebuild scripts can land before
  `:ClearAllChildren()` fires. If a parallel rebuild script ever modifies
  PirateShipRide's children (none currently do), it must run before this
  script's wait expires.
