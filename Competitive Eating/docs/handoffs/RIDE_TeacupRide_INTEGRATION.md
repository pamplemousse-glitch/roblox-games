# TeacupRide RideController Integration Notes

## Constants to update post-merge

**None.** `SPIN_RIDES.TeacupRide.rps = 0.55` is preserved as-is per playbook.

The rebuilt model spins around its `partCentroid` exactly like the original — only the cup geometry has changed (now 8 donuts on a glaze platter at 2× scale). Platter + first dough segment of each donut are tagged `Structural` so the centroid lands at the model's geometric center (the platter axis), not skewed by sprinkles or the central whipped-cream dollop.

## New code modules needed

**None.** No helpers were stubbed. The script uses only existing `AssetBuilder` primitives (`block`, `cylinder`, `sphere`, `weldAll`, `model` indirectly).

## Named-part contract preserved

RideController only reads two things for TeacupRide:

1. **Model name `TeacupRide`** — preserved (script uses `ClearAllChildren`, not `Destroy`, on the existing model instance).
2. **`Seat` children** — `getSeats(model)` scans `model:GetChildren()` for `ClassName == "Seat"`. The rebuild creates exactly **8 anchored Seats** as direct children of the model, one in the center hole of each donut, named `Seat` (same naming as the original cup-ride pattern).

No parts were renamed in a way that breaks the contract. All other named parts (Donut1_Dough_*, Donut1_Frosting_*, sprinkles, platter, dollop) are pure decoration that RideController does not read.

## Gotchas / orchestrator-visible

- **Boarding prompt timing**: `RideController.init` runs synchronously from `Main.server.luau`, while this rebuild waits 1s per playbook. That means when `addBoardingPrompt` ran it referenced the OLD seats which no longer exist. The model spin still works (RideController only stores `model = m` + `baseCF` and calls `m:PivotTo`), but the BoardZone prompt will try to sit players in destroyed seats. **Recommended post-merge fix** (orchestrator may apply once, alongside other ride rebuilds with the same pattern): have `RideController.init` defer its per-ride init by `task.wait(1.5)` OR re-run `getSeats` + `addBoardingPrompt` after the rebuild scripts settle. This is a cross-ride concern, not specific to TeacupRide — flagging here so it's not lost.
- **Anchored seats**: The 8 Seats are anchored. The SeatWeld will still carry the rider when the model is `PivotTo`'d each Heartbeat, so spin behaviour is identical to the original anchored-cup approach.
- **Footprint**: New platter is 190 studs across (radius 95). If the original cup ride was tighter, neighbouring rides may be closer than expected — orchestrator should eyeball post-merge for overlap with adjacent fairground rides.
