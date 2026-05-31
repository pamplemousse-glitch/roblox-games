# Handoff — Carousel REBUILD (2026-05-31, 02:08)

## Accomplished

REBUILD of `Workspace.Carousel` driven by Coney Island B&B Carousell / Belle-Époque reference. Followed `CLAUDE.md` REBUILD discipline: teardown plan → rebuild → backup → verification.

### Teardown
58 parts moved from `Workspace.Carousel` to `ServerStorage.CarouselBackup_20260531` (tagged `rebuild-carousel-20260531-removed`):
- 16× `RoofStripe_*` (flat slabs at Y=35.25 — the "crumpled red ceiling")
- 32× `Scallop_*` (overlay, not the ones in `Generated.Carousel.Canopy`)
- 8× finial stack (`FinialBall`, `Finial`, `FinialTopBall`, `FinialSpire`, `FinialBallMid`, `FinialMidPole`, `FinialBallLow`, `FinialBase`)
- `DeckSkirtBase` (light brown wood cylinder)
- `DeckSkirtTrim` (gold ring)

### Rebuild — new parts (tagged `rebuild-carousel-20260531-added`)
- **16× ConePanel_1..16** — true conical roof (red+cream alternating, SmoothPlastic), apex at original Y=42, rim at original Y=33, radius 22, using `CFrame.lookAt` to align panels along the slant from rim to apex.
- **1× ConeApexCap** — small gold disc covering the apex seam.
- **1× DeckSkirtBase** — cream cylinder, replaces brown wood.
- **3× simplified finial** — `Finial_Base` (gold cone), `Finial_Spire` (gold rod), `Finial_Ball` (gold neon ball).
- **32× GoldBand_Top/Bot_1..16** — proper 16-segment ring trim around skirt at top + bottom (replaces a failed full-disc approach that read as a yellow platform from above).

### Repaints (pulled from `Palettes.ConeyIsland` — `src/Common/Palettes.luau`)
- 16 `Valance_*`: alternating CARNIVAL_WHITE / CARNIVAL_RED (was zebra red+yellow)
- 8 `HorseSeat`: WOOD_DARK leather (was bright yellow plastic)
- 8 `MirrorPanel_*`: CARNIVAL_WHITE Neon (was pale blue Neon)
- 16 `FestoonBulb_*`: NEON_WARM (palette-unified)
- 8 `SpireFlag_*`: alternating CARNIVAL_RED / CARNIVAL_WHITE

### Generated.Carousel underlayer cleanup
- `Platform`: yellow → CARNIVAL_WHITE
- `CenterColumn`: dark brown → METAL_GOLD
- `FenceRing`: → CARNIVAL_WHITE
- `Canopy` model: all 26 parts set to `Transparency=1` (hidden — new cone replaces it)
- `Poles` model: 12 parts → METAL_GOLD

### Scale-up
Uniform 1.4× scale around base center (-265, 7.3, -153). All 242 parts in `Workspace.Carousel` scaled (Size and Position) preserving rotations. New diameter ~62 studs, height ~51 studs.

`WorldPivot` recomputed to (-265, 30.7, -153) — locked to horizontal design center, Y from centroid. RideController's `fixPivot` will re-derive at next server init (`partCentroid` prefers Structural-tagged parts → none in carousel → falls back to all-parts average, which now lands at Y=30.7).

## Current state (verified by edit-mode screenshots, NOT play-mode)

- Cone closes cleanly at apex, alternating red+cream stripes.
- Valance reads cream + red panels with white SpireFlag triangles.
- Deck top is cream (was yellow).
- Skirt is white with gold band trim at top + bottom (16-segment polygonal ring).
- Finial simplified: gold cone → spire → ball.
- Brass HorsePoles + 8 MirrorPanels (now silver Neon) visible inside.

**NOT YET DONE:**
- Play-mode verification (sit a player in a HorseSeat, verify spin works at new scale, confirm RideController re-derives pivot correctly at the larger size).
- Reference-image side-by-side with B&B Carousell + 5-diff enumeration.
- Horse-model recolor (MeshPart Tail/Mane/Saddle are still saturated yellow-gold; only seats were repainted).

## Lessons

1. **`Workspace.Carousel` is a stacked 2-layer model.** `Generated.Carousel` (the original procedural one, contains `Canopy` Union dome + `Platform` slab + `Horses` model) sits *under* the decorative overlay (the 175 direct children we mostly worked with). Both rotate together via `Model:PivotTo` in RideController. Don't assume direct-children-only — always inspect Generated.* subtree before declaring an audit complete.
2. **Cylinder trim discs read as full discs from above** even when intended as side bands. Use polygonal segment rings (16+ box parts) instead of full-cylinder discs for "trim" geometry on a vertical cylinder skirt.
3. **My bbox math was wrong** when reporting `min Y = -18.6` after scaling — I used `Size.Y / 2` without accounting for the cylinder's 90° Z rotation (world height is along local X, not local Y). The actual world-Y bottom is correct (~7.3).
4. **Palettes.luau is undersubscribed**: the original overlay used 4 different yellows (gold metal 220,170,0 / seat plastic 212,175,55 / festoon plastic 255,240,180 / festoon-bulb neon 255,220,80) — none from the file. That's the "tacky" root cause. Tomorrow's REBUILDs must `require(ReplicatedStorage.Common.Palettes)` not invent colors.

## Files modified
- None — all changes were Studio data-model edits via `execute_luau`. No Lua/Luau source edited.
- Two new docs: `docs/handoffs/SESSION_QUEUE.md`, this file.

## Files NOT touched but should be checked in tomorrow's verify pass
- `src/Server/Services/RideController.luau` — `SPIN_RIDES["Carousel"].rps = 0.35` is unchanged. After 1.4× scale, the same 0.35 rps may feel too fast at the larger radius (tangential velocity goes up). Tomorrow: playtest and consider 0.25 rps if dizzying.

---

## v2 PASS (same session, later) — Parisian REBUILD

Driven by user reference photo (Place de la République style) and four named defects.

### Defects addressed
1. Base too thick + needed stairs → 1-stud `DeckFloor` cylinder at Y=0.5 (walk on from grass), 3× `CarouselStep_*` removed.
2. Too bright — Neon part count 74 → 22.
3. Wider by +50% radius — diameter 61.6 → ~92 stud.
4. Floating frills — new solid `Cornice` cylinder ring at Y=22 (sz 3×94×94, red); valance hangs flush from cornice bottom Y=20.5 down to 17.5.

### v2 teardown (136 parts → `ServerStorage.CarouselBackup_20260531_v2`, tagged `rebuild-carousel-v2-removed`)
- 3× CarouselStep, DeckSkirtBase, 16× v1 ConePanel + ConeApexCap, 3× v1 Finial parts, 16× v1 Valance, 8× SpireFlag, 32× v1 GoldBand
- 8× PoleBulb, 8× PoleStripe, 8× RoofLight, 16× Festoon, 16× FestoonBulb (light reduction)
- `Generated.Carousel.Canopy` subtree destroyed (was hidden Transparency=1 from v1; no longer needed)

### v2 reposition (56 kept items shifted by horizontal 1.5× + Y −17)
- 8× HorseSeat, 8× HorseModel_* (rigid-shifted as groups so horses don't stretch), 8× HorsePole_* (also extended from 14→21.8 height to reach new cornice)
- 8× MirrorPanel_* (Material dropped Neon → SmoothPlastic for less glow)
- All of `Generated.Carousel.*` (Platform/CenterColumn/CenterLightOrb/FenceRing — single-part shift; Horses sub-models rigid-shifted; Poles individually shifted + extended to 21.8)

### v2 new geometry (132 parts, tagged `rebuild-carousel-v2-added`)
- `DeckFloor` cylinder + 24× `DeckRim_*` gold polygon segments at perimeter
- `Cornice` solid red cylinder ring at Y=22 + 48× `CorniceTrim_Top/Bot_*` gold segments
- 16× new `ConePanel_*` at rim Y=23.5, apex Y=36, radius 46
- 2× `Finial_Spire` + `Finial_Ball` (simplified from 3 parts)
- 16× new `Valance_*` hanging from cornice (attached, no gap)
- 12× `LanternBracket_*` + 12× `LanternGlobe_*` Neon under cornice (only restrained light source remaining)

### Known v2 caveats
- **Spin tangential velocity is now 2.1× original** (1.4×1.5 = 2.1). At 0.35 rps × 46 stud horse radius, perimeter speed is ~101 stud/s. Likely too fast and dizzying. Strongly recommend dropping `SPIN_RIDES["Carousel"].rps = 0.35` → `0.18` in `src/Server/Services/RideController.luau` before playtest.
- WorldPivot Y dropped to 14.5 (from 30.7 in v1). RideController re-derives this at server init via `partCentroid`, so spin axis will be correct.
- Right side of post-v2 screenshot shows a separate ride (TeacupRide / BigTent) at this wide camera angle, not carousel artifacts.
- v1 backup `ServerStorage.CarouselBackup_20260531` still intact — both rollbacks available.
- Play-mode + reference-image side-by-side verification still NOT done.

### v9 PASS (same session) — mount fix + seam closure + horse variety

User caught after v8 mount test:
1. Mounted player ends up **inside** the horse (seat at horse body Y), facing the wrong direction
2. Mount ProximityPrompt persists after mounting (no occupancy gating)
3. Gaps still visible through cone roof (v8 drip-edge only sealed the rim line, not the vertical seams between flat panels)
4. Small grey/blue dots punching through ceiling — actually distant rides/sky visible through those vertical seams
5. Horses too uniform — wants variation

**v9 changes** (24 new parts, 2 script edits, 16 part repaints):
- **Seam ribs** (16 new parts, tagged `rebuild-carousel-v9-added`): burgundy thin slabs along each panel-to-panel seam from rim (Y=23.5) to apex (Y=36), CFrame-aligned with the cone slope. Closes both the geometric gaps and the visual seam shadows. The "grey dots" were distant Ferris wheel / TeacupRide / sky bleeding through these seams — now hidden.
- **Mount position fix**: each `HorseSeat` raised Y +1.5 stud (player sits ABOVE the saddle, not inside) and re-oriented via `CFrame.lookAt(seatPos, seatPos + tangent_CCW)` so the seat's -Z = direction of motion. Player now faces forward when seated.
- **Prompt occupancy gating** (script edit): added `seat:GetPropertyChangedSignal("Occupant"):Connect(function() prompt.Enabled = (seat.Occupant == nil) end)`. Prompt disappears when seat is taken, re-appears when seat empties.
- **Horse color variety**: alternating per index — odd horses (1/3/5/7) ivory body + antique gold mane/tail (classic carousel white); even horses (2/4/6/8) deep wood body + ivory mane/tail (chestnut variation). 16 Body+Feet parts repainted.

Net v1→v9: ~360 net structural parts, two palette overhauls, gallop animation, ridable seats with proper UX. **Verification gap**: v9 mount/prompt fixes are script-edits — Rojo synced, but the **prompt UX behavior needs a play-mode walk-through** by you (no programmatic way to confirm).

### v8 PASS (same session) — roof gap fix + full horse palette + ridable seats

User caught three remaining issues from v7 + one polish request:
1. Tiny sky-gaps visible at cone rim from underneath
2. Even-indexed horses (2/4/6/8) had **red/blue** Body+Feet (procedural-generated, my v7 repaint only hit Tail/Mane/Saddle/Pole/eye by name)
3. Horses weren't ridable
4. (audit-only: brief gray glitch reported under roof — color scan came up empty, likely camera artifact)

**Phase 1 — Drip-edge ring** (24 burgundy box segments, ~6-stud chord each, at cone rim radius 46.3 Y=23.55). Closes the 0.9-stud chord/arc valleys between 16-flat cone panels and the round 92-stud cornice.

**Phase 2 — Horse palette finalized**:
- Tail/Mane → antique gold `(200,150,60)`
- door knob (eye) → deep wood `(80,50,30)`
- Saddle → burgundy on odd horses / antique gold on even horses (per-horse variety)
- Pole → antique gold
- **v8 follow-up**: Body+Feet forced ivory `(230,220,195)` on all 8 horses (16 parts) — fixed the red/blue procedural bodies that survived v7.

**Phase 3 — Ridable horses** (`RideController.luau` edit):
- Skip `addBoardingPrompt` for spin rides with `gallopAmplitude` (BoardZone was buried inside the 92-stud-diameter deck — unreachable).
- After gallop init, attach a `ProximityPrompt` to each HorseSeat: ActionText `"Mount"`, ObjectText `cfg.name`, MaxActivationDistance 6, RequiresLineOfSight false.
- Triggered handler: if seat unoccupied + player has alive Humanoid, `Sit(hum)`. Seat is the carousel's actual horse seat, so player rides up/down with the gallop and around with the spin via the SeatWeld.

### v7 REBUILD (same session) — full aesthetic correction

User aesthetic critique of v5: poles like a jail cell, palette like a kindergarten, cornice over-ornamented (visual noise not design), horses dwarfed, finial taller than the roof, valance like construction-paper pennants. Plus: barren floor, barren roof interior, barren central column, no horse motion. Approved a multi-phase REBUILD addressing all of it.

**Phases 1–4** (script 1):
- **Teardown 200 parts** to `ServerStorage.CarouselBackup_20260531_v7` (tagged `rebuild-carousel-v7-removed`): all 48× CrownSpire/Ball/Fleur, 48× SwagRibbon/Chain/Bead, 16× PilasterStrip + 32× PendantChain/Drop, 32× ScrollAccent, 32× CorniceMedallion/MedTrim, 16× CorniceScroll, 16× Valance wedges.
- **Palette repaint** (229 parts): `200,35,35`→burgundy `110,30,40`; `252,252,248`+`248,240,220`→ivory `230,220,195`; `220,170,0`+`240,200,60`→antique gold `200,150,60`. Applied via color-distance tolerance match.
- **Thinner poles** (20 parts): 8× overlay HorsePole_* + 12× Generated.Poles, diameter 1.0→0.5, material Metal antique gold. Largest-axis-preserving shrink.
- **New cornice** (40 new parts): 8× large oval medallions every 45° (gold frame + ivory body, 3-stud diameter) + 8× rounding board panels between (ivory rectangles with antique-gold top/bottom trim).

**Phases 5–8** (script 2, 92 new parts):
- **Floor decoration**: 16× radial gold spokes (r=5→45), 1× compass rose center disc, 8× compass rose rays at 45° intervals, 8× burgundy floral medallions (with gold trim rings) at r=30.
- **Hanging chandelier**: chain rod from cone apex Y=42 down to Y=30, antique-gold cap, ivory-neon globe body, 4× candle arms branching out at 90° intervals, 4× warm-glow neon flame balls.
- **Pillar ornaments**: 8× small oval reliefs centered on each panel face (alternating ivory on burgundy panels, antique gold on ivory panels).
- **Scalloped valance**: 16× ivory hanging panels + 16× antique-gold rounded "hem" cylinders at the bottom edge (wavy fabric look replaces the v2 triangular pennants).

**Phase 9** — `RideController.luau` script edit (synced via Rojo, confirmed in Studio):
- `SPIN_RIDES["Carousel"]` config: added `gallopAmplitude=0.75, gallopFreq=0.6`.
- New `HorseGallop` type; `SpinState` extended with `gallopAmplitude/Freq/horses/totalTime`.
- Init pass: for any spin ride with `gallopAmplitude`, scans `HorseModel_1..16`, computes centroid, finds closest `HorseSeat`, builds gallop group with phase = (i−1)/8 × 2π.
- Heartbeat: after PivotTo, applies Y delta `sin(t × 2π × freq + phase) × amp` per horse + its seat.
- Verified in play mode: HorseModel_1 saddle Y oscillates 7.39 → 8.75 stud (range 1.36, target peak-to-peak 1.5).
- Hidden 16 parts in `Generated.Carousel.Horses` (duplicate static horses behind the overlay ones — would have z-fought during gallop).

**v7 finial**: kept the 14-part stack from v5, repainted in Phase 2 (burgundy flag, antique gold elsewhere).

**Net v7 change**: −200 + 132 = **−68 parts**, simpler overall. ~229 repainted, 20 poles thinned, 16 generated horses hidden, 1 script edit.

### v5 PASS (same session) — gold ornament polish + Creator Store cresting

User feedback after v4: cornice still felt plain. Researched options (Wikimedia oil paintings, Roblox-native mesh gen, Creator Store). Aesthetic-fit analysis: photorealistic decals/meshes would clash with cartoony Coney Island map. Decided to skip painted decals entirely (downloaded but unused: 11 panels in `assets/carousel-panels/`).

Two-track approach:
- **Track A**: Creator Store search for gold ornament categories. 3 samples evaluated, 1 hit (a lacy gold Edwardian crown, asset `13983705204`).
- **Track B**: Primitive gold ornament geometry on cornice.

v5 new geometry (96 total parts, tagged `rebuild-carousel-v5-added`):
- 16× `PilasterStrip_*` — vertical gold strips on cornice face between medallions
- 16× `PendantChain_*` + 16× `PendantDrop_*` — hanging gold ball drops below cornice (between valance segments)
- 32× `ScrollAccent_*` — spiral S-curve accents flanking each medallion (2 per medallion)
- 16× `CorniceCresting_*` — Creator Store lacy gold crowns cloned along cornice top edge between crown spires

Deferred to future session: Meshy.ai-driven horse mesh replacement (the high-value imports per user's art memory).

**v5 finial rebuild** (added after user caught it was a no-show): Removed 2-part v2 finial (puny gold rod + small ball, invisible from distance). Built 14-part layered stack at cone apex Y=36 going up to Y=55 (19-stud tower above cone). Layers: `Finial_BaseCap` (gold disc) → `Finial_LowerOrb` (3.2 stud gold ball) → 4× `Finial_LowerWing_*` (decorative gold flairs) → `Finial_Stem` (gold cylinder) → `Finial_MidRing` (decorative collar) → `Finial_MidOrb` (2-stud ball) → `Finial_Spire` (5-stud gold rod) → `Finial_TopOrb` (warm gold neon ball) → `Finial_FlagPole` (3.5-stud rod) → `Finial_Flag` (red wedge) → `Finial_TipOrb` (tip neon ball). All tagged `rebuild-carousel-v5-added`.

### v3 PASS (same session) — horse repositioning + cornice ornamentation

User feedback after v2: horses too far from edge, an oak tree intersected the new larger deck, cornice "too plain" vs reference image #4 (illustration with painted/sculpted figural panels and crown finials).

Changes:
- **Horses moved** from r=27 → r=38 (8-stud margin from deck rim at 46). Applied to 8× overlay `HorseModel_*` (rigid shift), 8× overlay `HorsePole_*`, 8× HorseSeat, plus `Generated.Carousel.Horses.Horse_*` (8 sub-models) and `Generated.Carousel.Poles.*` (12 poles) — all relocated to TARGET_HORSE_R = 38.
- **Trees relocated**: `Environment.Trees.Tree_Oak` at r=23 (dead center of new deck) and r=39 (inside footprint) both rigid-shifted outward to r=56. Third oak at r=47 left alone (already outside deck rim at 46).
- **Cornice decoration** — 88 new ornament parts, tagged `rebuild-carousel-v3-added`:
  - 16× `CrownSpire_*` (gold rod) + 16× `CrownSpireBall_*` (gold neon cap) + 16× `CrownFleur_*` (gold wedge silhouette) — 48 parts around cornice top at radius 47.2, Y=24.5–28
  - 16× `CorniceMedallion_*` (alternating cream/gold cylinders) + 16× `CorniceMedTrim_*` (gold ring) — 32 parts on cornice front face at radius 47.05
  - 8× `CorniceScroll_*` (gold accent strips) between medallion pairs

### v2 rollback
```lua
local CollectionService = game:GetService("CollectionService")
for _, p in ipairs(CollectionService:GetTagged("rebuild-carousel-v2-added")) do
  if p:IsDescendantOf(workspace.Carousel) then p:Destroy() end
end
local backup = game.ServerStorage:FindFirstChild("CarouselBackup_20260531_v2")
if backup then
  for _, p in ipairs(backup:GetChildren()) do p.Parent = workspace.Carousel end
  backup:Destroy()
end
-- Manual: undo the horizontal 1.5x shift + Y-17 on kept parts (no inverse helper saved)
```

---

## Next steps (queued)

See `docs/handoffs/SESSION_QUEUE.md` for the 6 remaining sessions. Recommended order:
1. **Session 2 (PirateShipRide)** — independent, well-scoped
2. **Session 3 (ScreamerCoaster)** — highest complexity, fresh context essential
3. **Session 4 (MiniTrain)**
4. **Session 5 (SwingCarousel)**
5. **Session 6 (scale-up pass on remaining rides)**
6. **Session 7 (mini-game stalls)**

## Blockers / Open Questions

1. **Horse recoloring**: should HorseModel Tail/Mane/Saddle MeshParts be repainted to a 4-color rotation (cream / palomino / dappled gray / chestnut) for a more classic look? Deferred to a tiny follow-up.
2. **Carousel rps tuning**: should `SPIN_RIDES["Carousel"].rps` be reduced from 0.35 → ~0.25 since perimeter speed increased 1.4× with scale? Needs playtest decision.
3. **Verification not run**: per `CLAUDE.md` Verification Discipline, REBUILDs require play-mode + reference-image diff before "done." This handoff captures state but does not declare verified. Recommend Session 1.5 verification pass before Session 2 starts.

## Rollback

```lua
-- Restores original Carousel by deleting tagged additions and reparenting backup
local CollectionService = game:GetService("CollectionService")
for _, p in ipairs(CollectionService:GetTagged("rebuild-carousel-20260531-added")) do
  if p:IsDescendantOf(workspace.Carousel) then p:Destroy() end
end
local backup = game.ServerStorage:FindFirstChild("CarouselBackup_20260531")
if backup then
  for _, p in ipairs(backup:GetChildren()) do p.Parent = workspace.Carousel end
  backup:Destroy()
end
-- Manual: undo Generated.* repaints from this session (no backup of original colors)
-- and undo the 1.4× scale (no inverse helper saved — would need to scale by 1/1.4 around same base center)
```
**Caveat**: rollback restores the parts but does *not* undo the 1.4× scale on parts I didn't back up (the 242 parts I scaled in place). Full rollback would require manual 1/1.4 inverse scale.
