# ScramblerRide RideController Integration Notes

Rebuild script: `src/Server/RideRebuildScramblerRide.server.luau`
Food shape: **Eggbeater** — stand-mixer hub with 4 whisks ending in 8 eggs, sitting in a giant ceramic mixing bowl. 2× scale.

## Constants to update post-merge

**NONE.** ScramblerRide constants in `RideController.luau` need no change:

- `SCRAMBLER_MAIN_RPS = 0.28` — unchanged. The new model is wider (whisk tip radius ~38 studs vs. previous), so the same angular speed reads as slightly faster linear motion at the tip, which feels right for an eggbeater.
- `SCRAMBLER_SUB_RPS = -0.84` — unchanged. The 3× counter-rotation around each arm's centroid still produces the classic Scrambler whip.

The `buildScrambler` function (line 430) computes all offsets dynamically from `partCentroid(model)` and each arm's `partCentroid` at boot — it adapts to the new geometry on its own. No code change required.

## New code modules needed

None. All build logic lives in the standalone rebuild script.

## Named-part contract preserved

`buildScrambler` reads only the following names from the rebuilt model — all are present:

| Reader path | New name |
| --- | --- |
| `workspace.ScramblerRide` | outer Model (preserved — `ClearAllChildren`, not destroyed) |
| `.Generated` | Folder (called Model by helper — `:FindFirstChild("Generated")` works on either) |
| `.Generated.ScramblerRide` | Model (inner) |
| `.Generated.ScramblerRide.BaseStructure` | Model (the mixer body — chrome cylinders, dial, cap, motor head) |
| `.Generated.ScramblerRide.Mechanics` | Model containing 4 arm Models |
| `.Generated.ScramblerRide.Mechanics.Arm_1..Arm_4` | each Model has 6 whisk-rod segments + 2 crossed hoops + 2 egg cars |
| `Seat` direct children of outer model | `Seat_1..Seat_8` (8 total — 2 per arm, placed at egg positions) |

`getSeats` only inspects `model:GetChildren()` (depth 1), so seats live at the outer model level. `buildScrambler` assigns each seat to its nearest arm via Euclidean distance — verified the 2 seats nearest each arm's egg cluster will bind to that arm.

Arm names sort alphabetically (`Arm_1` < `Arm_2` < `Arm_3` < `Arm_4`), so the arm-group iteration order is deterministic.

## Pivot / scale notes

- Original ride footprint unknown precisely (Studio-authored), but the food brief calls for 2×. New footprint: bowl floor radius **56 studs** (≈112-stud diameter), whisk tip arc radius ~38 studs. Hub is ~16 studs across, ~10 studs tall.
- `m:PivotTo(originalPivot)` is called at the end so the ride re-anchors at its original world position. Anything else around it (boarding platforms, neighbor rides) should be untouched.
- `BoardZone_ScramblerRide` prompt is created by `addBoardingPrompt` in RideController at runtime — no script change needed.

## Backup

The pre-rebuild model is cloned to `ServerStorage.ScramblerRide_PreFood_2026-06-03` for one-shot rollback. (Idempotent on repeat reload: a duplicate clone would land in ServerStorage; clean up manually if needed during dev.)

## Gotchas

- **Cylinder orientation:** `AB.cylinder` Z-rotates internally so its X-axis points along world Y — for the speed dial (which should stick sideways out of the mixer) we use `AB.part` with `shape=Cylinder` directly to keep the dial axis along world X.
- **Welding scope:** Only `BaseStructure` and each `Arm_N` are welded internally. The outer model's bowl rim segments, bowl floor, and seats are NOT welded together — they stay as independent anchored parts so the seats can be CFrame-driven by `RideController` per-frame without dragging the bowl along.
- **Seat positioning:** seats are placed at Y = `BOWL_RIM_H + HUB_HEIGHT * 0.35 - 0.5` (≈ 6.6 above the bowl floor center). At rest this puts the rider's body roughly at egg-center height; once the ride spins, the seats follow their arm's CFrame.
