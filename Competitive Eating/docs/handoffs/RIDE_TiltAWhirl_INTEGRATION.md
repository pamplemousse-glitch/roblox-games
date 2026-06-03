# TiltAWhirl RideController Integration Notes

## Constants to update post-merge
- **None.** `SPIN_RIDES.TiltAWhirl.rps = 0.75` is preserved as-is. No
  `pivotY`, `swingOutAmplitude`, `gallopAmplitude`, or other entry needed.

## New code modules needed
- None. RideController.luau requires no edits for this rebuild.

## Named-part contract preserved
RideController treats TiltAWhirl as a generic SPIN_RIDES entry. The contract
is just:

| RideController call          | What it reads                              | Status |
|------------------------------|---------------------------------------------|--------|
| `anchorAll(m)`               | every `BasePart` descendant                | OK — every part anchored at build time |
| `partCentroid(m) / fixPivot` | average of all `BasePart` positions (no Structural tag set) | OK — pancake stack is rotationally symmetric, centroid lands on the spin axis |
| `getSeats(m)`                | direct `Seat` children of the model         | OK — 6 `Seat_1`..`Seat_6` parented directly to the model |
| `addBoardingPrompt(...)`     | `#seats > 0`                                | OK |

No parts were renamed in a way that would break a hardcoded `FindFirstChild`
call elsewhere — RideController only references TiltAWhirl via the SPIN_RIDES
loop, never by named part.

## New named parts (info only)
For future tooling reference, the rebuild parents these directly to the model:

- `Body` — top pancake (PrimaryPart, the spin deck)
- `Pancake_1`..`Pancake_4` — lower pancakes in the stack
- `PancakeRim_1`..`PancakeRim_5` — golden-brown rim rings
- `SyrupPuddle` — amber gloss disc on top of the deck
- `SyrupDrip_1`..`SyrupDrip_8` — sloped drips around the rim
- `SyrupGloss_1`..`SyrupGloss_8` — neon highlight strips on each drip
- `ButterPat_1`..`ButterPat_6` — the 6 yellow butter-pat car bases
- `ButterPatHi_1`..`ButterPatHi_6` — top highlight on each pat
- `ButterMelt_1`..`ButterMelt_6` — small melt drips on the leading edge
- `ButterBack_1`..`ButterBack_6` — backrest behind each Seat
- `Seat_1`..`Seat_6` — the riderable Seats (RideController contract)
- `SugarDust_1`..`SugarDust_5` — decorative powdered-sugar specks

## Gotchas
- The 6 Seats are arranged in a circle at `radius = 22 studs` from the spin
  axis, on top of the `topY = 5 * 3.2 = 16` stud-tall stack. If anything in
  RideController expected seats at the *old* TiltAWhirl Y, double-check
  `addBoardingPrompt`'s anchor offset — it places the prompt at
  `pivPos + (0, 2, 14)` which still lands south of the new model.
- All parts are anchored at build time; `weldAll` welds every descendant to
  `Body` so `PivotTo()` will move everything as a rigid unit when the
  RideController spins the model.
