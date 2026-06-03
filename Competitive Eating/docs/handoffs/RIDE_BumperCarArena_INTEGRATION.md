# BumperCarArena RideController Integration Notes

## Constants to update post-merge
**None.**

`BumperCarArena` does not appear in any `RideController.luau` table
(`SPIN_RIDES`, `PENDULUM_RIDES`, `DROP_TOWERS`, coaster waypoints, flume
`wps`, scrambler arms, parachute groups). `grep -n "BumperCar" RideController.luau`
returns zero matches. The ride is decorative-only in the current build, per
playbook §11.

## New code modules needed
None. The rebuild is a single self-contained `*.server.luau` under
`src/Server/` that runs at server start. No helpers stubbed, no shared
modules touched besides `require(ReplicatedStorage.Common.AssetBuilder)`.

## Named-part contract preserved
There is no named-part contract to preserve — RideController never reads
`workspace.BumperCarArena` children. The rebuild still names parts
sensibly for future iteration:

- `ArenaFloor` (PrimaryPart of the BumperCarArena Model; cocoa-drink disc)
- `FoamRing`
- `CupWall_3..24` (segments 1 and 2 removed for the boarding gap)
- `CupRim_3..24`
- `EntryRamp`, `EntryRampTrim`
- `MarshmallowCar_1..7` (each a sub-Model with `Body`, `ToastedCap`, `BumperSkirt`, `Seat`)

If a future RideController pass wants to drive the cars (e.g. add a slow
random-walk or a contest-mode dodgem game), the per-car `Seat` is already
a real `Seat` instance — flipping `Anchored=false` on Body + Seat and
adding a `BodyVelocity` / `LinearVelocity` is sufficient. No rename
required.

## Aesthetic / scale notes for the orchestrator
- Arena diameter = `clamp(originalFootprint * 2, 60, 240)` measured live
  from the pre-rebuild `m:GetBoundingBox()` so the 2× rule holds even if
  the orchestrator nudged the workspace model between sessions.
- Coords are never hardcoded — the rebuild builds around local origin
  `CFrame.new()` then `PivotTo(originalPivot)` to restore world position
  (per `feedback_studio_drift.md`).
- Backup parented to `ServerStorage.BumperCarArena_PreFood_2026-06-03`
  for rollback.
