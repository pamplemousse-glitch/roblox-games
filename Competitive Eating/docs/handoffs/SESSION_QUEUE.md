# Session Queue — Frank's Fairground Overhaul

Created 2026-05-31 at the end of the Carousel REBUILD session. Each entry below is a **separate Claude session** to preserve context quality. Start each with: *"Do session N from SESSION_QUEUE.md"*.

Per `CLAUDE.md`: each session reads the latest handoff first, state-audits via MCP (no trusting auto-memory positions), and ends with a `docs/handoffs/YYYYMMDD-HHMM-<topic>.md`.

---

## Session 1 — ✅ DONE (2026-05-31)
**Subject:** `Workspace.Carousel` REBUILD (Victorian palette) + scale 1.4×
- Status: complete. Handoff: `docs/handoffs/20260531-0208-carousel-rebuild.md`
- Backup of original parts: `ServerStorage.CarouselBackup_20260531`

---

## Session 2 — PirateShipRide REBUILD
**Subject:** `Workspace.PirateShipRide` — pendulum ship
**Reference target:** classic pirate galleon. Search: *"wooden pirate ship ride carnival amusement reference"*.
**Scope:**
- State-audit current ship (memory says: 6 bench seats, mast/boom/sail, Jolly Roger, neon trim, swing via PirateShipSwing tween).
- Reference-driven REBUILD: weathered wood hull (`WOOD_PLANK` + `WOOD_DARK`), proper galleon silhouette (taller stern, lower bow), rigging detail, gold trim, a real figurehead at bow.
- Scale up ~1.4×. RideController constants (`amplitude`, `frequency`, `pivotY=26`, `axis="Z"`) may need rescaling — re-derive `pivotY` from new pivot height.
- Preserve seat count + Seat:Sit boarding (`addBoardingPrompt`).
**Watch out:** centroid drift if you don't tag structural parts. The pendulum pivot uses `pivotY` override — re-measure after scale-up.

---

## Session 3 — ScreamerCoaster REBUILD
**Subject:** `Workspace.ScreamerCoaster` (track) + `Workspace.ScreamerCart`
**Reference target:** wooden roller coaster (Coney Cyclone). Search: *"wooden roller coaster Coney Island Cyclone reference photo"*.
**Scope:**
- State-audit: 343-part track at X0=80 to X1=325, Z=-432/Z=-472. Waypoints: ArcN(16) + RailA(50) + ArcF(16) + RailB(50 reversed) = 132 points.
- REBUILD: thicker wooden trusses, support columns down to ground, lift-hill, banked turns.
- Scale: longer track + taller lift hill. Cart scales 1.3× (don't make it dwarf the player).
- **RideController coupling**: `setupScreamerCart()` re-runs at init and welds everything to PrimaryPart=`Body`. Don't rename `Body`.
- Waypoints are read by name (`ArcN0_2`, `RailA0_2` … `ArcN15_2`); preserve naming when you rebuild the track.
**Watch out:** highest-complexity session — single subject, no scope creep.

---

## Session 4 — MiniTrain REBUILD
**Subject:** `Workspace.MiniTrain` — track + engine + cars
**Reference target:** Coney Island miniature railway / Disney's Casey Jr. Search: *"miniature steam train carnival amusement reference"*.
**Scope:**
- State-audit: 55×75 oval track at X=-240, Z=-355. Steam engine + passenger car + station.
- REBUILD: proper boiler shape, smokestack, cowcatcher, multiple passenger cars (currently only one), wood ties + iron rails for track.
- Scale up 1.4× — track length grows ~70→105 stud, engine grows proportionally.
- **No RideController coupling exists yet** for MiniTrain (per memory it's a static prop). If we want a rideable train, that's a Session 4b — separate scope.

---

## Session 5 — SwingCarousel REBUILD + scale
**Subject:** `Workspace.SwingCarousel`
**Reference target:** classic chair-swing / Wave Swinger. Search: *"chain swing ride amusement reference"*.
**Scope:**
- State-audit (memory: 16 chair seats, 128 neon parts + 16 festoon lights, 0.30 rps, 20s ramp).
- REBUILD top hub with conical canopy matching Carousel's red/cream palette, taller center mast.
- Add real chair-swing-out v2 (deferred from Phase 7 per memory) — chairs swing outward at speed via geometry, not just centripetal CFrame.
- Scale 1.4×.

---

## Session 6 — Spin/Pendulum scale-up pass
**Subject:** rest of the rides at 1.4× (no rebuild, just scale + palette pass)
- `Workspace.TeacupRide`
- `Workspace.TiltAWhirl`
- `Workspace.ScramblerRide` (and its `Generated.ScramblerRide.Mechanics.*` sub-models — scale ALL recursively or `RideController.buildScrambler` re-measures arm centroids at init)
- `Workspace.ParachuteJump`
- `Workspace.DropTower`
- `Workspace.LogFlume` (waypoints in code at `LogFlume.lua` `wps` table — **must update Lua constants too**)
- `Workspace.BumperCarArena`
**Skip:** `Workspace.BigWheel` (user says perfect, leave alone).
**Watch out:** scaling LogFlume's geometry doesn't scale its Lua waypoint table — must hand-edit `RideController.luau` `wps` constants in sync.

---

## Session 7 — Mini-game stalls overhaul (one big batch)
**Subject:** all 5 stalls — bigger + better props per `Competitive Eating/CLAUDE.md` "Mini-Game Stall Visual Pattern"
- RingToss, HighStriker, DuckPond, BalloonDart, SkeeBall
- Pattern is consistent (pre-built workspace models, camera-locked, Creator Store props). Batch-able.
- Per art memory: prefer Creator Store over Meshy.ai for stall props.
- Per stall: scale stall structure 1.3×, swap runtime-spawned props for Creator Store assets parented into the model under contract names (`Bottle_1..30`, `Duck_1..6`, etc.).
- Add the missing `CameraTarget` / `CameraOrigin` named parts so UI scripts can stop computing offsets.

---

## Cross-cutting notes for tomorrow

1. **Palette discipline**: `src/Common/Palettes.luau` is the source of truth. Don't write ad-hoc `Color3.fromRGB()` in new code — `require` the palette.
2. **`Structural` tag**: RideController's `partCentroid` prefers tagged parts. When you add decorative parts to a ride, tag only the load-bearing structural ones so the spin pivot stays put.
3. **EditTag every new part**: `part:SetAttribute("EditTag", "<session-id>-<batch>")` per `CLAUDE.md` State Discipline — keeps additions reversible by tag scan.
4. **Verification is non-negotiable**: per session, play-mode + screenshot + reference-image side-by-side + enumerated 5-diff list. "Looks great" not allowed.
5. **Don't trust this doc's claims about current state** — state-audit via MCP at each session start.
