# DropTower → Sundae Drop RideController Integration Notes

Branch: `feature/ride-droptower`
Script: `src/Server/RideRebuildDropTower.server.luau` (263 lines / ≤280 budget)

## Constants to update post-merge

**None required.** The DropTower mechanic constants in `RideController.luau`
(lines 39-42) are correct as-is for the rebuilt sundae:

- `DROP_Y_MIN = 7` — gondola rest height: still works (cherry-body bottom Y≈1.5 clears the Y=0 concrete pad)
- `DROP_Y_MAX = 50` — gondola top: still works (cone shell top is at Y=68, scoop center Y=78 → no clipping)
- `DROP_CX, DROP_CZ = 155, -175` — tower center: unchanged
- `DROP_RISE / DROP_FALL / DROP_BRAKE / DROP_HOLD / DROP_LOAD / DROP_BRAKE_Y` — all unchanged

## Build details

- **Cone shell** (waffle-pattern tan ice-cream cone): 12 vertical layers × 12 tangential slats = 144 slats, alternating WAFFLE_TAN (205,150,85) and WAFFLE_DARK (150,100,55) per layer for the wafer cross-grid look. Outer radius lerps 30→13 from Y=1 to Y=68. Plus ~16 vertical dark ribs and 16 base-ring blocks.
- **Scoop crown**: two SmoothPlastic white spheres (main 32-dia at Y=78, side bump 22.4-dia at Y=84) for a two-scoop silhouette.
- **Sprinkles**: 24 tiny tilted cylinders dotted around upper hemisphere of the main scoop in 5 colors (pink, blue, yellow, cherry-red, stem-green).
- **Cherry on top**: 6-dia red sphere at Y=98 + 5-stud green stem above it.
- **Concrete pad** (PrimaryPart): 72-dia disc at Y=0.

## Cherry CARRIAGE re-skin (rider's seat carriage)

The runtime gondola is a 13×1.5×13 red disc created by `buildDropTower` and
moved each frame in the Heartbeat loop via `gondola.CFrame = gondCF`. We
**cannot edit that code**, but we can hang welded UNanchored decoration parts
off the disc. WeldConstraint between an anchored Part0 and unanchored Part1
keeps Part1 in sync with Part0's CFrame updates — verified pattern in Roblox.

Decoration added (children of `workspace.DropTower`, all `Massless = true`,
`CanCollide = false`):

- `CherryBody` — 11-dia red sphere, 5.5 studs below gondola center
- `CherryGloss` — 3-dia lighter red sphere on the upper-left of the body
- `CherryStem` — 7-long green cylinder rising 4 studs above gondola
- `CherryLeaf` — small green leaf block beside the stem

## Named-part contract preserved

All `RideController.buildDropTower` references confirmed intact:

| Name (RideController reads) | Preserved by rebuild? |
|---|---|
| `workspace.DropTower` (Model) | YES — Model instance retained, only contents rebuilt |
| `DropGondola` (Part) | YES — detached to ServerStorage during clear, restored after |
| `DropSeat_1`..`DropSeat_6` (Seats) | YES — detached and restored |
| 8 anonymous railing Parts (Size 0.3×2×0.3) | YES — detached and restored |
| `workspace.DropBoardZone` + child ProximityPrompt | YES — RideController builds this in workspace (NOT in DropTower model), so my `ClearAllChildren` doesn't touch it |

## New code modules needed

None. Pure primitives via `AssetBuilder` (block, sphere, cylinder, model).

## Gotchas / risks for orchestrator

1. **Run order**: my script's `task.wait(1)` relies on `Main.server.luau` calling `RideController.init` first (which calls `buildDropTower` synchronously). If `Main` ever moves to a deferred startup pattern, the runtime parts won't exist when my detach loop runs — the script will simply skip the cherry re-skin (guarded by `if gondola then`) but the named-part contract preservation still works because nothing is destroyed.
2. **Backup model**: a clone is parked at `ServerStorage.DropTower_PreFood_2026-06-03` for revert purposes. Safe to delete after acceptance.
3. **Cherry stem clipping**: at gondola Y=50 (top of travel), the cherry stem reaches Y≈57.5 — inside the cone interior (cone top Y=68) but the cone is a hollow shell with overlapping tangential slats, so the stem is hidden from outside view. No visual issue expected, no collision (CanCollide=false on the stem, plus the cone has clearance > 6 studs to the gondola axis everywhere).
4. **Part count**: ~210 parts in the new model (144 slats + 16 ribs + 16 base ring + 24 sprinkles + 2 scoops + cherry top set + pad + 1 gondola + 6 seats + 8 railings + 4 cherry-adorn parts). Stays well under any practical budget.

## RideController constants flagged for update

**NONE.** Everything works with current values.
