# DropTower → Classic Drop Tower RideController Integration Notes

Branch: `feature/ride-classic-droptower`
Script: `src/Server/RideRebuildDropTower.server.luau` (≤ 280 lines)
Replaces the prior food-shape "Sundae Drop" rebuild with a Belle-Époque
ivory + antique_gold structural lattice drop tower per playbook §9.

## Constants to update post-merge

**FLAGGED — orchestrator action required**

The structural tower top is now **Y = 40** (was ~110 in the food-shape build,
~50 stock). Current `DROP_Y_MAX = 50` in `RideController.luau` line 48 would
push the gondola disc above the tower cap — it would visually punch through
the antique_gold crown plate.

| Constant | Current | Recommended | Reason |
|---|---|---|---|
| `DROP_Y_MAX` | 50 | **33** | Gondola top (Y_MAX + 0.75 = 33.75) + railing top (Y_MAX + 2.5 = 35.5) sit below tower cap at Y=40. ~4-stud headroom inside the crown plate. |
| `DROP_BRAKE_Y` | 15 | 11 | Optional — proportional brake zone for shorter travel (50→33 range). Leaving at 15 still works (it's just less brake distance from Y_MAX). |

Unchanged (must remain):
- `DROP_CX, DROP_CZ = 155, -175` — tower center XZ (rebuild centers on these)
- `DROP_Y_MIN = 7` — gondola rest height (rebuild pad surface at Y=0, gondola disc at Y=7 clears 6+ studs above ground)
- `DROP_RISE / DROP_FALL / DROP_HOLD / DROP_LOAD` — all motion timings unchanged

## Build details

- **Pad** (`Pad`, `PadTrim`×16): 44-dia slate stone disc with burgundy fabric trim ring.
- **Masts** (`Mast1..4`, `MastBase1..4`, `MastCap1..4`): 4 ivory marble corner pillars tapering R=11→8, with antique_gold metal base + cap caps. Square lattice arrangement (45° offset).
- **Lattice braces** (`Brace<row>_<c>`): 6 horizontal rows × 4 segments each, alternating antique_gold (metal) and ivory (marble).
- **Diagonal X-bracing** (`Diag<c>A/B`): 8 wrought_iron diagonals, crisscross per face.
- **Banners** (`Banner1..4`): 4 burgundy fabric banners hung at mid-height between masts.
- **Crown** (`CrownPlate`, `CrownDome`, `Finial`, `FinialOrb`): antique_gold metal crown disc at Y=40, dome above, finial spire, crimson_glow neon orb at the tip (Y=11 above tower top).
- **Boarding fence** (`FencePost`, `FenceCap`): 12-post wrought_iron perimeter with cream marble ball caps, gapped on the south face for the `DropBoardZone` prompt.
- **Gondola re-skin** (in-place recolor of runtime parts):
  - `DropGondola` → burgundy SmoothPlastic
  - `DropSeat_1..6` → ivory Marble
  - 8 railing posts → antique_gold Metal
- **Gondola welded adorn** (decorative, unanchored + WeldConstraint to gondola):
  - `GondRim1..12` — ivory rim band around carriage edge
  - `GondHub` — antique_gold center hub cylinder
  - `GondSkirt` — burgundy underskirt disc just below gondola (clears pad at Y_MIN=7)

## Named-part contract preserved

| Name (RideController reads) | Preserved? |
|---|---|
| `workspace.DropTower` (Model) | YES — Model instance retained, ClearAllChildren used |
| `DropGondola` (Part) | YES — detached to ServerStorage during clear, restored after |
| `DropSeat_1`..`DropSeat_6` (Seats) | YES — detached and restored |
| 8 anonymous railing Parts (Size 0.3×2×0.3) | YES — detached and restored |
| `workspace.DropBoardZone` + child ProximityPrompt | YES — built in workspace (not DropTower model), untouched |
| `m.PrimaryPart` | Identity-rotation `PivotAnchor` (0.1³ transparent) at (DROP_CX, 0, DROP_CZ) |

## New code modules needed

None. Pure primitives via `src/Common/AssetBuilder.luau`.

## Gotchas / risks for orchestrator

1. **DROP_Y_MAX MUST be reduced post-merge.** If left at 50, the gondola will pop above the tower cap at top-of-travel — visually broken. Recommend 33.
2. **Run order**: script's `task.wait(1)` lets `RideController.init` build the runtime gondola first. If startup ever defers RideController, the detach loop finds no gondola — the script gracefully skips the re-skin (`if gondola then` guard).
3. **Gondola in-place recolor**: We mutate `DropGondola.Color` / `Material` directly. RideController does NOT re-set these per-frame (only CFrame), so the recolor sticks.
4. **Backup**: `ServerStorage.DropTower_PreBelleEpoque_2026-06-03` retains the prior food-shape Sundae build for revert.
5. **Part count**: ~110 descendants in the new model (4 masts ×3 caps = 12, 24 braces, 8 diagonals, 4 banners, 16 pad trim, ~22 fence parts, crown set, gondola adorn ~14, runtime 15 = ~115).
6. **Boarding gap**: fence omits posts in southern arc (sin(a) < -0.7) so `DropBoardZone` at (DROP_CX, 5, DROP_CZ - 13) remains visually accessible.

## RideController constants flagged for update

- **`DROP_Y_MAX`: 50 → 33** (REQUIRED — visual clipping otherwise)
- `DROP_BRAKE_Y`: 15 → 11 (optional, proportional to new range)
