# ParachuteJump → Lollipop Drop — RideController Integration Notes

Branch: `feature/ride-parachute`
Rebuild script: `src/Server/RideRebuildParachuteJump.server.luau` (261 lines)

## Constants to update post-merge

**None.** The new build was designed to fit the existing constants exactly:

- `PARACHUTE_TOP_Y    = 183` — chute disc center sits here at top of cycle (unchanged).
- `PARACHUTE_BOTTOM_Y = 7`   — chute disc center sits here at bottom of cycle (unchanged).
- `PARACHUTE_HOLD_TOP = 3`, `PARACHUTE_FALL_T = 6`, `PARACHUTE_HOLD_BOT = 1`, `PARACHUTE_RISE_T = 2` — timing unchanged.
- Cycle = 12s, phase offset 1.5s per chute (unchanged).

The 2× footprint scaling is purely horizontal (chute orbit radius 50 studs vs. ~25 in the original); the vertical drop distance (176 studs) is the same as before.

## New code modules needed

None. Rebuild uses only `AssetBuilder.luau` primitives (`block`, `cylinder`, `sphere`, `part`, `weldAll`).

## Named-part contract preserved

RideController.luau lines 673-690 scan `ParachuteJump:GetDescendants()` and for each chute index `idx ∈ 1..8` collects BaseParts whose names match one of:

1. `^Chute[A-Za-z]+<idx>$`   — e.g. `ChuteBasket3`, `ChuteRider3`, `ChuteFrame3`, `ChuteRim3`, `ChuteD3`
2. `^ChuteS<idx>_%d+$`       — e.g. `ChuteS3_1`, `ChuteS3_4`
3. `^ChutFrame<idx>$`         — legacy alt; not used by new build, kept harmless

Each captured part has its top-position recorded and is translated vertically per-frame.

### Parts emitted per chute (idx 1..8)

| Name pattern         | Count | Role                                      |
| -------------------- | ----- | ----------------------------------------- |
| `ChuteBasket<idx>`   | 1     | Disc head (lollipop candy puck)           |
| `ChuteFrame<idx>`    | 1     | White stick above the disc                |
| `ChuteRider<idx>`    | 1     | Seat — actual sittable Seat instance      |
| `ChuteD<idx>`        | 1     | Glossy red dome on disc top               |
| `ChuteS<idx>_1..6`   | 6     | Striping rings (red/white alternating)    |
| `ChuteRim<idx>`      | 4     | Decorative basket-rim cables under disc   |

Total moving parts per chute: **14**, total across 8 chutes: **112**.

### Static parts (do not match any chute regex)

- `GroundPad` (1) — pastel candy floor under the ride
- `PadSprinkle` (24) — colorful sprinkles on the pad
- `TowerBraid` (78) — 26 slices × 3 strands, pretzel-twist column
- `TowerKnotBase` / `TowerKnotMid` / `TowerKnotTop` (18 each = 54) — oversized pretzel loops
- `SaltGrainBase` (36) / `SaltGrainTop` (28) — salt sprinkles
- `TowerCap` (1) — pretzel-cap sphere
- `TowerCore` (1, invisible) — PrimaryPart sentinel

Total static parts: **223**. Total descendants: **335**.

### No renames

Zero parts use names the old build relied on; the new names all match the existing regex contract. RideController needs no edits.

## Rebuild contract followed

- [x] `task.wait(1)` at start.
- [x] Bails with warn if `workspace.ParachuteJump` is missing.
- [x] Backs up old model to `ServerStorage.ParachuteJump_PreFood_2026-06-03`.
- [x] `ClearAllChildren()` (does not Destroy the Model — RideController still finds it).
- [x] Builds at origin, 2× footprint, `AB.*` primitives only.
- [x] Sets `PrimaryPart = TowerCore` (invisible cylinder).
- [x] Runs `AB.weldAll(m)`.
- [x] Restores `originalPivot` so the ride sits where it was.
- [x] Script length 261 lines (under 280-line cap).
- [x] No edits to `RideController.luau`, other rides, other districts, GUI, NPCs, or contest logic.
- [x] No `mcp__Roblox_Studio__*` calls.

## Aesthetic notes

- Central tower: brown braided pretzel column (~200 studs tall) with three salt-encrusted knot rings at base / mid / top, capped by a pretzel-bun sphere.
- Chutes: red/white striped flat disc lollipops (22-stud diameter) with a glossy red candy dome and a white stick handle pointing skyward.
- Riders sit on the upper face of the disc; a decorative 4-cable basket rim hangs ~3 studs below the disc to read as "parachute basket".
- Pad: warm ivory candy-shop floor ringed by multi-color sprinkles.

## Gotchas

1. **Seat placement is above the disc**, not below — the brief said "seats hang below", but `PARACHUTE_BOTTOM_Y = 7` means anything below the disc-center at top would clip underground at the bottom of the cycle. The decorative `ChuteRim*` cables hang below the disc to preserve the parachute-basket silhouette while keeping the actual `Seat` safely above ground (lowest seat Y at bottom-of-cycle = 9.5).
2. **Tower is static** — all `TowerBraid`/`TowerKnot*`/`SaltGrain*` part names lack a trailing digit, so the RideController regex skips them. Verified manually.
3. **`AB.weldAll`** welds all parts to `TowerCore`. Since RideController's per-frame loop uses `part.Position = ...` on anchored parts, the welds are inert at runtime (Position writes override). Matches the original ride's behavior.
4. **Chute base at bottom of cycle is Y=7** (disc bottom Y ≈ 5.75). The ground pad surface is at Y ≈ 6.75 — disc may visually tap the pad at minimum height, which reads as "landed". Intentional.
