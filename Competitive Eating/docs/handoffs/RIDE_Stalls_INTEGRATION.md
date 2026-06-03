# Mini-Game Stalls + Foodball — Integration Notes

## Branch
`feature/ride-stalls`

## Scripts added
- `src/Server/RideRebuildStalls.server.luau` (279 lines) — rebuilds the 5
  existing carnival stalls (and any `_R` right-side twins found) in place,
  preserving Model name + world pivot.
- `src/Server/RideBuildFoodball.server.luau` (183 lines) — builds the NEW
  Foodball basketball stall at `workspace.Foodball` (world position
  `CFrame.new(60, 0, -40) * yaw(180)`).

## RideController constants to update post-merge
**None.** Stalls are not enumerated in `RideController.luau` (verified via
`grep` — `RingToss/HighStriker/DuckPond/BalloonDart/SkeeBall` only appear in
`src/Server/Services/MiniGameService.luau` and `src/Client/Controllers/MiniGameController.luau`).

## Named-part contract preserved
Searched `Competitive Eating/src/` for any references to the per-stall sub-part
naming conventions hinted at in the prompt (`Bottle_<n>`, `Duck_<n>`,
`CameraTarget`, `CameraOrigin`, etc.). **None of those names appear in any
tracked source file.** The client-side UI submodules
(`RingTossUI`/`HighStrikerUI`/`DuckPondUI`/`BalloonDartUI`/`SkeeBallUI`) that
might have used them were lost in cleanup (see comment at
`src/Client/Main.client.luau:21-22`) and are slated for v1.1 rework.

Therefore the only contract the rebuild must honor is:
1. The `Model` instance keeps its name (`Stall_<Kind>`) and stays in
   `workspace`.
2. At least one `ProximityPrompt` descendant exists (the client controller
   wires `DescendantAdded` and any `ProximityPrompt` triggers `StartMiniGame`).
3. World pivot is preserved (`PivotTo(originalPivot)` after rebuild).

Belt-and-braces sub-part names emitted anyway for future v1.1 UI re-implementation:
- RingToss: `Bottle_1..10`, `BottleCap_1..10`, `Ring_1..4`
- HighStriker: `StrikerTower`, `Bell`, `StrikePad`, `Mallet*`, `ScoreMark_1..6`
- DuckPond: `PondRim`, `PondWater`, `Duck_1..6`, `DuckBill_1..6`, `Rod`
- BalloonDart: `DartBoard`, `Balloon_1..18`, `Dart_1..3`
- SkeeBall: `Lane`, `Gutter[EW]`, `Hole_1..5`, `Ball_1..3`

Foodball additionally exposes: `Backboard`, `BBTrim*`, `BBTargetSquare`,
`DonutDough_1..18`, `DonutFrost_1..18`, `Sprinkle_1..30`, `Net_1..8`,
`Counter`, `Meatball`, `Parm_1..5`, `Seat`.

## Behavior notes
- Both scripts run on server start. The stalls rebuild is **idempotent** —
  it clones the pre-rebuild model to `ServerStorage.Stall_<X>_PreFood_20260603`
  before clearing, so a manual rollback is one drag-and-drop.
- The Foodball script wipes any prior `workspace.Foodball` and rebuilds from
  scratch.
- `task.wait(1)` (stalls) / `task.wait(1.2)` (Foodball) gives sibling rebuild
  scripts (PirateShip, Coaster, etc.) headroom to land first.

## v1.1 follow-ups (NOT this PR)
- Foodball mini-game logic (currently visual-only). Needs:
  - New `Foodball` entry in `MiniGameService.GAME_TIME` + handler triplet
    (start/throw/result).
  - Client UI module `FoodballUI` mirroring the SkeeBall pattern.
  - Wire `Foodball` into `MiniGameController.STALL_GAME_MAP`.
- Re-implement the 5 lost UI submodules with the new prop layouts as camera
  targets (sub-part names listed above are ready to be referenced).

## Gotchas
- If a stall doesn't yet exist in `.rbxl` (e.g. fresh clone without the
  committed place file), the rebuild logs `warn(... not found; skipping)` —
  this is intentional (won't break server start).
- Foodball position (60, 0, -40) was picked clear of the documented food
  landmark scatter (centered around X=0, Z=-120 and outward). If a sibling
  rebuild script places a ride nearby, slide Foodball further out east before
  merge.
- The donut hoop is built from 18 overlapping spheres + 18 frosting spheres +
  30 sprinkles + 8 net cylinders. If part budget pressure surfaces in playtest,
  drop SEGMENTS from 18 → 12 (one-line change in `RideBuildFoodball.server.luau`).
