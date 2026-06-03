# LogFlume RideController Integration Notes

Branch: `feature/ride-logflume`
Subagent: a57340ddb0a359a81 (worktree)
Theme: **Hot Dog Flume** — mustard water trench + ketchup-bottle lift-hill dispenser.

## Constants to update post-merge
**NONE.**

The boat is built programmatically inside `RideController.buildLogFlume`
(lines 345-426). Its `wps` table is hardcoded with absolute world coordinates
(`X=235`, `Z=-445→-295`, `Y=23.5→0.5`). Our rebuild script only authors visual
scenery — it never moves the boat path, never resizes the boat, never alters
the FlumeBoardZone position. The boat continues to enter at `wps[1]` and exit
at `wps[#wps]`, and the boarding prompt at `wps[1] + Vector3(0, 2, 9)`
continues to land in a sensible spot (just behind the lift-hill dispenser).

No RideController constants need updating.

## New code modules needed
None. The rebuild script is self-contained and uses only `AssetBuilder`
helpers (`block`, `cylinder`, `sphere`, `weldAll`) plus stdlib Roblox APIs.

## Named-part contract preserved

`RideController.buildLogFlume` reads NOTHING from `workspace.LogFlume` other
than the bare existence check on line 346:

```luau
if not workspace:FindFirstChild("LogFlume") then return nil end
```

So the entire contract is: **the Model named `LogFlume` must exist under
`workspace`**. Our rebuild satisfies that — we `:ClearAllChildren()` rather
than `:Destroy()`, preserving the Model instance itself.

`workspace.FlumeBoat`, `workspace.FlumeBoat.BoatHull`, `.BoatBow`, `.BoatRim`,
`FlumeBoatSeat`, and `workspace.FlumeBoardZone` (with its `ProximityPrompt`)
are all built by RideController at runtime — outside our jurisdiction. The
rebuild script does NOT touch them.

## What the rebuild adds to `workspace.LogFlume`

Roughly **62 parts** total, in three families:

| Name pattern | Count | Role |
|---|---|---|
| `ChannelFloor_01..14` | 14 | 12-stud-wide mustard trench segments along WPS |
| `Bank_L_NN`, `Bank_R_NN` | 28 | Darker mustard ridges flanking each segment |
| `KetchupBottleBody/Shoulder/Cap/Nozzle`, `MustardDrip` | 5 | Lift-hill dispenser at `wps[1]` |
| `SplashPool`, `PoolRim_L`, `PoolRim_R`, `PoolBackWall` | 4 | Visual basin at `wps[#wps]` |
| `BunPylon_L/R_03/07/11` | 6 | Tan bun-shaped supports on the steep top half |

All parts are `Anchored = true`. All non-floor parts have `CanCollide = false`
so disembarking riders never get pinched. The floor parts (`ChannelFloor_*`)
are `CanCollide = true` so anyone falling out of the boat lands on mustard
rather than the void below.

## Visual scale

- Original channel: ~6 studs wide.
- New channel: **12 studs wide** (2× as requested) with 4-stud-wide banks on
  each side — total visible footprint ~20 studs across, vs the original ~6.
- Lift-hill dispenser tops out at `Y ≈ 26` (just above `wps[1]` at `Y=23.5`),
  the tallest scenery element.

## Gotchas

1. **The boat hull center rides at the WPS Y.** The water surface is
   intentionally placed `1.3` studs below the WPS Y so the boat looks like it
   sits in the trough rather than levitating above a slab.
2. **`workspace.LogFlume` must NOT be destroyed.** Always `:ClearAllChildren()`
   so `RideController:FindFirstChild("LogFlume")` keeps resolving on future
   reruns of the build cycle.
3. **No `LogFlume_PreFood_2026-06-03`-merge conflict risk** — that backup
   lives in `ServerStorage`, not in any tracked source file.
4. The MustardDrip sphere at the nozzle tip uses `Material.Neon` so it pops
   visually at distance; the rest of the channel is `SmoothPlastic` to avoid
   blowing out the fairground's overall lighting.
