# Ride REBUILD Plans — Pre-Planned via Parallel Sub-Agents

Generated 2026-05-31 by four parallel sub-agents during carousel session. Each plan is execution-ready: teardown / rebuild phases / code edits / rollback / verification all specified. Estimated execution times are sub-agent estimates and should be treated as ±30%.

**Suggested execution order (low risk → high):** PirateShip → ScreamerCoaster → SwingCarousel → MiniTrain

---

## Session 2 — PirateShipRide REBUILD

**Reference:** https://en.wikipedia.org/wiki/Pirate_ship_(ride) — canonical Huss/Zamperla galleon.

**Aesthetic:** Weathered painted-wood galleon. Burgundy hull + deep_wood ribs + ivory deck + antique_gold trim. A-frame supports (NOT single pole). Burgundy pennant replaces Jolly Roger (palette).

**Critical:** Hull/keel/mast/A-frame tagged `Structural` — decorative ornaments **untagged** so `partCentroid()` ignores them. Solves the existing "centroid drift" code comment cleanly.

**Teardown:** ~35-50 parts → `ServerStorage.PirateShipBackup_v1`. Removes old hull, mast, neon strips, off-white sail, Jolly Roger, 6 old seats, broken support frame.

**Rebuild (~70-90 parts, 7 phases):** hull (14) + deck/railings (14) + mast/rigging (6) + sail/pennant (3) + 6 seats (6) + ornaments (12) + A-frame supports (6).

**Code edit:** `RideController.luau` line 31 — recompute `pivotY` after rebuild (was 26, likely 28-30); verify axis stays "Z".

**Estimated time:** ~25-35 min execute_luau (smallest of the 4)

---

## Session 3 — ScreamerCoaster REBUILD

**Reference:** https://en.wikipedia.org/wiki/Coney_Island_Cyclone

**Aesthetic:** Weathered painted-wood Cyclone-style coaster. Burgundy lift hill + ivory truss columns + antique_gold rivet plates + deep_wood track ties.

**HARD CONSTRAINTS (do not break):**
- Track parts MUST keep names `ArcN0_2`..`ArcN15_2`, `RailA0_2`..`RailA49_2`, `ArcF0_2`..`ArcF15_2`, `RailB0_2`..`RailB49_2` — RideController reads by name
- `ScreamerCart.Body` stays as PrimaryPart
- `ReplicatedStorage.Remotes.CoasterFade` stays
- Waypoint XYZ positions UNCHANGED (1-stud move warps the path)

**Teardown (~80-150 parts):** all non-waypoint decoration, station, cart cosmetic shells. KEEP all 132 waypoint parts and cart Body.

**Rebuild (~280-340 parts, 7 phases):** track repaint+ties (~50) + side rails (~60) + truss columns (~80) + lift hill emphasis (~25) + station house (~30) + cart re-skin (~12-15) + marquee (~10).

**Code edit:** Optional only — possibly tune `COASTER_SPEED = 28` → 24-26 if scaling. No structural code changes.

**Estimated time:** ~35-50 min (132-part track repaint is fast; truss lattice is the heavy part)

---

## Session 4 — MiniTrain REBUILD

**Reference:** https://en.wikipedia.org/wiki/Casey_Jr._Circus_Train

**Aesthetic:** Vintage Coney-Island steam railway. Burgundy boiler + antique_gold brass bands + deep_wood smokestack/cowcatcher + ivory cab roof.

**Decision: rideable** (currently static — adds RideController coupling).

**Teardown (~80-150 parts):** all current MiniTrain children → `MiniTrain_Backup_<session>`.

**Rebuild (~180-230 parts, 7 phases):** oval track 1.4× (~60) + steam engine (~25) + 2 passenger cars (~80) + coupler chains (~6) + station house (~20) + boarding (~3) + RideController train coupling code.

**Code edit (new module ~+110 lines in RideController.luau):**
- New constants: `TRAIN_SPEED = 10`, `TRAIN_CAR_SPACING = 9`
- New type `TrainState` + helpers `buildTrainWaypoints` + `setupTrainConsist`
- New init + Heartbeat loop: engine, car1, car2 each independently `PivotTo`'d at offset distances along same waypoint path

**Estimated time:** ~50-70 min (most complex of the 4 — new code module + 3-unit consist)

---

## Session 5 — SwingCarousel REBUILD

**Reference:** https://en.wikipedia.org/wiki/Swing_ride — Zierer-style Wave Swinger.

**Aesthetic:** Sister ride to the Carousel. Burgundy/ivory striped conical canopy + antique_gold spire + 16 chain-suspended deep_wood chairs that fly outward as the ride spins up.

**Teardown (~150-160 parts):** old central column, canopy, spire, 16 old chairs, 128 neon parts (drop to ~16-20 globe lanterns).

**Rebuild (~140 parts, 6 phases):** center mast/pole (3) + conical canopy (32) + canopy rim ring (16) + 16 chairs (64) + 16 chain ribbons (16) + festoon globes (16).

**Code edit:** Extend `SpinState` with `chairs: { ChairSwing }?` and `swingOutAmplitude: number?`. New `ChairSwing` type. Init scans for ChairGroup_1..16. Heartbeat applies tangential offset proportional to `currentRps/rps * amp` so chairs progressively swing outward during the 20s ramp. Critical: rotate `radialDir` by current spin angle each frame.

**Add to `SPIN_RIDES`:** `swingOutAmplitude = 4.5`

**Estimated time:** ~45-60 min (medium complexity, code edit similar pattern to gallop)

---

## Combined estimated total: ~2h 35min – 3h 35min

Best done in a single fresh session per ride (per the SESSION_QUEUE.md philosophy of context preservation), OR all in one session if you accept higher context risk in exchange for fewer hand-offs.
