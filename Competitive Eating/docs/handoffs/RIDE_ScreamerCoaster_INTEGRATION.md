# ScreamerCoaster RideController Integration Notes

## Constants to update post-merge
**None.** The 132 waypoint parts (`ArcN0_2`..`ArcN15_2`, `RailA0_2`..`RailA49_2`,
`ArcF0_2`..`ArcF15_2`, `RailB0_2`..`RailB49_2`) are preserved in-place with
unchanged XYZ positions, so `buildWaypoints()` produces the identical path and
`COASTER_SPEED = 28` still produces the intended on-rails velocity.

`SPIN_RIDES` has no entry for ScreamerCoaster (it isn't a spin ride), so nothing
to update there either.

## New code modules needed
**None.** `RideRebuildScreamerCoaster.server.luau` requires only
`ReplicatedStorage.Common.AssetBuilder` which already exists.

## Named-part contract preserved
- 16x `ArcN<i>_2` (i=0..15) — kept, untouched
- 50x `RailA<i>_2` (i=0..49) — kept, untouched
- 16x `ArcF<i>_2` (i=0..15) — kept, untouched
- 50x `RailB<i>_2` (i=0..49) — kept, untouched
- `ScreamerCart.Body` — kept as PrimaryPart (re-skinned to a meatball sphere,
  but the part instance and name are the same so `setupScreamerCart()`'s
  `FindFirstChild("Body")` still resolves and the welder still uses it)
- `ReplicatedStorage.Remotes.CoasterFade` — untouched (script never references it)
- `Seat` is added at runtime by `setupScreamerCart()` so we do NOT include one
  in the cart cosmetic — RideController owns that.

## Renamed parts
**Zero.** Verified by `buildKeepSet()` which whitelists every name
RideController reads. The rebuild script `Destroy`s only non-waypoint children.

## Gotchas
- The script does not call `weldAll(sc)` on the ScreamerCoaster model itself.
  All waypoint parts are independently Anchored (and were before), so welding
  would be a no-op for movement but could complicate any future re-pivot.
  Decoration is parented under `sc.FoodDecoration` (Folder) to keep the
  top-level child list of the model uncluttered for RideController's
  `FindFirstChild` lookups.
- The cart's `Body` part is reshaped to `Enum.PartType.Ball` and grown ~1.4×
  for visual presence. If `Body.Size` was originally `(2,2,2)` the meatball
  becomes `(~5.6, ~5.6, ~5.6)` — the Seat placement at `body.CFrame * (0,2.5,0)`
  in `setupScreamerCart()` still sits the rider on top of the meatball.
- Sprinkles + sauce cap + basil sprig are WeldConstraint-anchored to `Body`,
  so when `setupScreamerCart()` runs its weld loop they get a second redundant
  weld — harmless.
- Backup naming uses date stamp `_PreFood_2026-06-03`. Re-running the script
  would `_PreFood_2026-06-03` collide; safe in practice because rebuild
  scripts run once per server boot.
