# SwingCarousel (Cocktail Umbrella Swing) — RideController Integration Notes

Branch: `feature/ride-swing`
Rebuild script: `src/Server/RideRebuildSwingCarousel.server.luau`
Backup model: `ServerStorage.SwingCarousel_PreFood_2026-06-03`

## Constants to update post-merge
- `SPIN_RIDES.SwingCarousel.rps` — **no change** (keep 0.30 per playbook rule "KEEP existing SPIN_RIDES rps untouched").
- `SPIN_RIDES.SwingCarousel.rampSecs` — no change (20).
- `SPIN_RIDES.SwingCarousel.swingOutAmplitude` — no change (4.5 still reads correctly against the new chair radius).
- No `pivotY` override is needed. Centroid is anchored by `Structural`-tagged
  parts (the mast, stem bands, and 16 canopy panels), so the new chairs and
  hanging straws cannot drag the spin centre off-axis.

## New code modules needed
- None. The rebuild uses only existing `AB.*` primitives from
  `src/Common/AssetBuilder.luau` (block, cylinder, sphere, model, weldAll).

## Named-part contract preserved
- `workspace.SwingCarousel` — Model preserved (`ClearAllChildren` only; instance
  identity intact so `SPIN_RIDES` lookup still hits it).
- `workspace.SwingCarousel.PrimaryPart` = **`CenterMast`** (cylinder) — same
  name as the previous build for handoff continuity.
- `ChairGroup_1` … `ChairGroup_16` — 16 child Models, each containing:
  - `RiderSeat` — Class `Seat`, found via `ch:IsA("Seat")`.
  - `Chain_<i>` — `BasePart` whose `Name:match("^Chain")` is true, so it's
    routed into `ChairSwing.chains` by the swing-out scanner.
  - `StrawVert_<i>`, `StrawBend_<i>`, `StrawHoriz_<i>`, `SeatPad_<i>` — feed
    `ChairSwing.parts`.

## Desired chair swing-out v2 (NOT applied; orchestrator handles post-merge)

The current `RideController.SpinState` already supports v1 swing-out
(`swingOutAmplitude` + `chairs[]`). The v2 polish this rebuild *would* like —
but does NOT implement (per "do not modify RideController.luau") — is:

1. **Chair tilt**: when chairs swing outward by `dx`, also rotate them by
   `atan2(dx, hang_length)` so the bendy-straw seat tilts to face the
   centripetal vector instead of staying axis-aligned. Suggested patch to the
   heartbeat block that updates `ChairSwing`:

   ```luau
   for _, c in spinState.chairs do
       local radial      = (spinState.currentRps / spinState.rps) * spinState.swingOutAmplitude
       local tiltRad     = math.atan2(radial, 14)  -- 14 = chain hang length
       -- existing translation logic …
       for _, p in c.parts do
           p.CFrame = p.CFrame
               * CFrame.new(radial - c.prevOffset, 0, 0)
               * CFrame.Angles(0, 0, tiltRad - c.prevTilt or 0)
       end
       c.prevOffset = radial
       c.prevTilt   = tiltRad
   end
   ```

2. **`SpinState` type extension** for `c.prevTilt: number?`. Add to
   `type ChairSwing = { …, prevTilt: number? }` and initialise to 0.

3. **Chain stretch**: when chairs swing out, lengthen `chains` parts by the
   same `atan2` factor so the chain visually stays taut.

Orchestrator: apply (1)–(3) in the single post-merge constants-update commit
that consolidates every ride's RideController patches.

## Build summary

- 16 ChairGroup Models × 6 parts each (Chain + 3 straw segments + SeatPad + Seat)
  = 96 chair-bound parts.
- Center mast: 1 cylinder + 3 stem gold bands + 1 apex bead = 5 parts.
- Canopy: 16 panels + 16 underside rim segments + 16 gold-rim segments
  = 48 canopy parts.
- Total ≈ 149 BaseParts (vs 87 in the prior Belle-Époque rebuild, ≈ 2× footprint).

## Gotchas

- The new chairs sit at radius 22 (was ~9), and the rim is at radius 24
  (was ~11). The previous `swingOutAmplitude = 4.5` still keeps chair swing-out
  visually inside the canopy silhouette — no rim collision.
- `Seat` instances are children of `ChairGroup_<i>` (not direct children of
  `workspace.SwingCarousel`), so `getSeats(m)` in RideController returns `{}`
  and the spawned `BoardZone_SwingCarousel` Part never gets a usable prompt.
  The rebuild attaches per-seat `ProximityPrompt`s directly on each `RiderSeat`
  so boarding still works. No RideController change needed.
- `Structural` tag is applied to the mast, stem bands, and canopy panels so
  `partCentroid` ignores the off-axis chair geometry.
