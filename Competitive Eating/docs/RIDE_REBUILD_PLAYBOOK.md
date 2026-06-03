# Frank's Fairground Ride Rebuild Playbook

11 rides + 1 stalls batch, each shaped as a food, scaled 2× current footprint. Carousel and BigWheel are exempt (user satisfied). Per the user's call: "rides ARE food."

This playbook is the shared spec every subagent reads. Each ride's specifics are in its own section below.

---

## Strict rules (every subagent)

1. **NO `mcp__Roblox_Studio__*` calls.** Studio MCP is singleton; the orchestrator owns it.
2. **NO edits to `src/Server/Services/RideController.luau`.** If your ride's rebuild needs constant updates (pivotY for pendulums, COASTER_SPEED, SPIN_RIDES rps, etc.), DOCUMENT them in `docs/handoffs/RIDE_<NAME>_INTEGRATION.md` and the orchestrator applies them in a single post-merge commit. Otherwise 11 subagents fight over the same lines.
3. **NO edits to other rides, other districts, the GUI, NPCs, or contest logic.** Only your ride.
4. **Pure primitives via `src/Common/AssetBuilder.luau`.** No Meshy. Stay Roblox-blocky.
5. **Read before coding:**
   - `Competitive Eating/src/Server/Services/RideController.luau` (1091 lines — `grep` for your ride name to find the named-part contract)
   - `Competitive Eating/src/Common/AssetBuilder.luau` — confirm helpers: `block`, `sphere`, `cylinder`, `neon`, `glow`, `weldAll`, `offset`, `pivot`, `model`, `part`
   - `Competitive Eating/src/Common/Palettes.luau` — canonical colors
   - `Competitive Eating/src/Server/TokyoGround.server.luau` — idempotent-rebuild pattern (Clone old → ServerStorage → ClearAllChildren → rebuild)
   - `Competitive Eating/docs/handoffs/RIDE_PLANS_v1.md` — for your ride: aesthetic intent + named-part contract + previously-identified RideController coupling concerns.

---

## Universal contract per rebuild script

Your script lives at `src/Server/RideRebuild<RideName>.server.luau`. It must:

1. **Wait briefly for workspace to settle** (`task.wait(1)`) so any other rebuild scripts can land too.
2. **Bail if the ride model doesn't exist**: `local m = workspace:FindFirstChild("<RideName>"); if not m then return end`. Don't error — log a warn.
3. **Back up the existing model** to ServerStorage:
   ```luau
   local clone = m:Clone(); clone.Name = "<RideName>_PreFood_2026-06-03"; clone.Parent = game.ServerStorage
   ```
4. **Clear children** (not Destroy — preserve the Model instance so RideController can still `:FindFirstChild` it):
   ```luau
   m:ClearAllChildren()
   m.PrimaryPart = nil
   ```
5. **Build the food-shaped replacement at 2× the original footprint** inside `m` using `AB.*` primitives.
6. **Preserve every part name RideController reads**. The contract per ride is below.
7. **Set PrimaryPart** to the canonical part (e.g. `m.PrimaryPart = m.Body` for pendulum rides).
8. **Run `AB.weldAll(m)`**.
9. **`m:PivotTo(originalPivot)`** so the ride sits where it was.

Each script ≤ 280 lines.

---

## Per-ride briefs

### 1. PirateShipRide → **Banana Boat** (feature/ride-pirateship)
- **Mechanic:** Pendulum swing (RideController SPIN_RIDES PirateShipRide entry: amplitude=0.55, freq=0.7, pivotY=28, axis=Z).
- **Named parts to preserve:** 6 `Seat` instances (currently `Seat_1`..`Seat_6`). `Body` as PrimaryPart for the hull.
- **Food shape:** 50-stud-long yellow banana hull (slight curve via segmented blocks), brown ripe-spots (8-12 small dark patches), peeled stern with a giant green palm-leaf sail, gold trim. A-frame structural supports stay (tag `Structural` attribute for partCentroid).
- **Integration note:** pivotY at 2× scale becomes ~56. Subagent documents the new value; orchestrator updates SPIN_RIDES.

### 2. ScreamerCoaster → **Spaghetti Coaster** (feature/ride-coaster)
- **HARD constraint:** preserve every named waypoint part: `ArcN0_2`..`ArcN15_2`, `RailA0_2`..`RailA49_2`, `ArcF0_2`..`ArcF15_2`, `RailB0_2`..`RailB49_2`. Their XYZ positions are read by `buildWaypoints`. **Do not rename or move them.**
- **ScreamerCart.Body** stays as PrimaryPart of the cart Model. `ReplicatedStorage.Remotes.CoasterFade` is untouched.
- **Food shape:** the waypoints are invisible. Around them, build a 2×-thicker visible track: yellow-pasta-strand side rails along each waypoint pair, parmesan-block ties between, lift hill is a tomato-sauce ramp. Cart re-skin is a meatball (round brown body) with parmesan sprinkle accents.
- **No RideController constant updates needed** (waypoints unchanged).

### 3. MiniTrain → **Hot Dog Train** (feature/ride-minitrain)
- **Currently static.** Keep static for v1.0 (avoid scope creep). Just rebuild geometry.
- **Named parts:** none required by RideController (not in any of its tables).
- **Food shape:** Engine is a grilled hot dog (long red-brown sausage, mustard zigzag) with a mustard smokestack (yellow cylinder). 2 passenger cars are buns (puffy white-tan rounded blocks) with grill marks. Oval track stays at X=-240 Z=-355, scaled 2× (~110×150 stud). Track rails = wooden ties + iron rails as currently authored, scaled up.
- **Integration note:** none.

### 4. SwingCarousel → **Cocktail Umbrella Swing** (feature/ride-swing)
- **Mechanic:** Centripetal spin (currently 0.30 rps, 20s ramp).
- **Named parts:** 16 `ChairGroup_1`..`ChairGroup_16` folders, each with a Seat. Center mast PrimaryPart name TBD; check existing.
- **Food shape:** Tall center mast as a giant cocktail-umbrella stem. Conical canopy painted as a striped paper umbrella (red/cream alternating wedges). 16 chairs are straws bent at 90° (yellow/pink/blue stripes) hanging from chain ribbons.
- **Integration note:** if subagent implements the chair swing-out v2 logic, defer the SpinState/ChairSwing extension to integration doc; orchestrator applies post-merge.

### 5. TeacupRide → **Donut Cups** (feature/ride-teacup)
- **Mechanic:** Spin (SPIN_RIDES TeacupRide rps=0.55).
- **Named parts:** check existing — likely a central platform + 6-10 cup Models with Seat children.
- **Food shape:** 8 giant donuts (50-stud diameter at 2×) sitting on a glaze platter. Each donut has a sprinkle-frosted top and a sittable hole in the middle (Seat at center). Platform = pastel pink display tray.

### 6. TiltAWhirl → **Pancake Stack** (feature/ride-tiltawhirl)
- **Mechanic:** Spin (SPIN_RIDES TiltAWhirl rps=0.75).
- **Named parts:** check existing.
- **Food shape:** Stack of 4-5 pancakes as the rotating platform (large tan cylinders with golden-brown rims). Each car is a pat of butter (yellow rounded block). Syrup river decoration around the platform edge (amber sloped channels).

### 7. ScramblerRide → **Eggbeater** (feature/ride-scrambler)
- **Mechanic:** Dual-rotation epicyclic (see buildScrambler in RideController at line 430).
- **HARD constraint:** preserve `workspace.ScramblerRide.Generated.ScramblerRide.Mechanics` inner structure including arm groups.
- **Food shape:** Center hub is a stand mixer base (chrome). Arms are whisks (thin curved white rods). Cars at the end of each whisk are eggs in shells (cream ovoid). Arena floor is a mixing bowl interior (smooth ceramic).

### 8. ParachuteJump → **Lollipop Drop** (feature/ride-parachute)
- **Mechanic:** 8 chutes phase-offset rise/fall.
- **Named parts:** Likely `ChuteGroup_1`..`ChuteGroup_8` plus a central tower.
- **Food shape:** Central tower as a giant pretzel-twist column (brown braided pretzel). 8 "parachutes" are giant disc lollipops (red/white striped flat discs on white sticks) with seats hanging below.

### 9. DropTower → **Sundae Drop** (feature/ride-droptower)
- **Mechanic:** Vertical drop (buildDropTower at line 171).
- **Named parts:** check existing — likely a tower part + drop seat group.
- **Food shape:** Tall tower as an inverted ice cream cone (tan wafer-pattern cone, white scoop crowning). Drop carriage is a giant cherry (red sphere with stem) holding the rider seats below it.

### 10. LogFlume → **Hot Dog Flume** (feature/ride-logflume)
- **HARD constraint:** the `wps` waypoint table is hardcoded in RideController.luau lines 349-360 — DO NOT rely on workspace positions to drive the boat. The water channel is just visual.
- **Named parts:** workspace.LogFlume's children can all be rebuilt freely.
- **Food shape:** Water trench tinted mustard-yellow with darker mustard banks. Log boats are hot dog buns (elongated puffy white-tan blocks) with seats inside. Lift hill stays at the wps[1]→wps[2] position; restyle as a ketchup-bottle dispenser shape.

### 11. BumperCarArena → **Marshmallow Bumpers** (feature/ride-bumpercars)
- **Mechanic:** Decorative — no live bumper physics in current build (placeholder).
- **Named parts:** none required.
- **Food shape:** Arena floor is a cocoa-drink surface (rich brown circular floor). Walls are cocoa-cup ceramic (white cylindrical perimeter wall). Bumper cars are giant marshmallows (white squashed spheres) with single rider seat on top. 6-8 cars scattered.

### 12. Mini-game stalls + new basketball (feature/ride-stalls)
- **Existing 5 stalls:** RingToss, HighStriker, DuckPond, BalloonDart, SkeeBall. Rebuild each at **1.5× scale**, keep carnival-classic theme + Belle-Époque palette (burgundy / cream / antique gold). Better-looking props than placeholder primitives — use AB primitives but with more detail (Neon accents, gold trim, signage).
- **Named parts:** the 5 stalls each have a `CameraTarget` / `CameraOrigin` / `Bottle_1..30` / `Duck_1..6` etc. contract from the contest scripts. Preserve all named parts the existing minigame scripts reference. Search for usages first.
- **NEW: Foodball mini-game** (feature/ride-stalls includes this) — a basketball stall with a **donut hoop** (giant glazed donut as the rim with frosting) mounted on a backboard. Ball is a meatball. Build similar in shape/footprint to other stalls (~25×15×25 stud). Place at workspace.Foodball. Add a Seat + ProximityPrompt for boarding. Integration note: stub mini-game logic for v1.1 — for now, just the visual stall.

---

## Integration doc template (for each ride's RIDE_<NAME>_INTEGRATION.md)

```markdown
# <RideName> RideController Integration Notes

## Constants to update post-merge
- (e.g.) `SPIN_RIDES.PirateShipRide.pivotY`: was 28, should be **56** (measured from new model bbox center)
- (e.g.) `SPIN_RIDES.TeacupRide.rps`: no change

## New code modules needed
- (e.g.) None
- OR list any helper functions the subagent had to stub

## Named-part contract preserved
- Confirm each name RideController reads is present in the new model
- List any renamed parts (should be ZERO; if any exist, RideController needs an update)
```

---

## Output protocol (every subagent)

```bash
git log --oneline origin/main..HEAD     # must show 1 or 2 commits (rebuild + integration doc)
git push -u origin HEAD:feature/ride-<short>
```

Report back ≤ 150 words:
- Branch pushed
- Commit SHAs
- Part count of the new model
- RideController constants flagged for update (or "none")
- Any gotchas

---

## Orchestrator post-merge protocol

1. Merge each branch sequentially.
2. After every 3 merges, ask user to playtest the merged set.
3. After all 12 merged, single post-merge commit applies all `RIDE_<NAME>_INTEGRATION.md` constant updates to `RideController.luau`.
4. Final playtest covers all rides + stalls.
