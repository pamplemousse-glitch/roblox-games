# District Polish Session Playbook

The per-district "polish" pattern that took Donut Dynasty and Tokyo Town from V2-built to fully atmospheric. **One subagent per district, one commit per session.** Donut/Tokyo are the worked examples — read those modules instead of designing fresh.

This playbook captures sessions **A → C** (pure code). Meshy hero landmarks (Session D) are handled by the orchestrator in a separate batch after A/B/C ship, because Meshy upload + mesh-id extraction needs Studio runtime and is a singleton step per district.

---

## Strict rules every subagent must follow

1. **Pure code only.** NO `mcp__Roblox_Studio__*` tool calls. Studio MCP is a singleton; peer agents on other districts will collide.
2. **NO edits to `src/Server/Services/AssetSpawner.luau`.** The orchestrator wires every district's Polish gate in a single post-merge commit. Otherwise every subagent fights over the same lines.
3. **NO edits to `src/Common/AssetManifest.luau`.** Positions are correct. Don't touch.
4. **Do not modify other districts' files.** Only `<District>` folders and `<District>*` filenames.
5. **Reference, don't invent.** Mirror the Donut modules — every architectural choice (AABB derivation, MaterialVariant naming, lighting bump, sound bed pattern) is already proven there.

---

## Reference modules (mirror these — same shape, district-specific colors / names)

| Reference | What to copy |
|---|---|
| `src/Common/DonutPolish.luau` | Polish classifier pattern (5 variants + name-based routing + lighting bump) |
| `src/Server/DonutZoneSpawner.server.luau` | Atmosphere AABB derived from manifest |
| `src/Server/DonutSoundZoneSpawner.server.luau` | Sound AABB + 4–6 micro-zones |
| `src/Client/DonutAtmosphereClient.client.luau` | Atmosphere lerp on enter/exit |
| `src/Client/DonutSoundZoneClient.client.luau` | Sound fade-in/out |
| `src/Assets/Districts/DonutDynasty/V2/Npcs/BakerWithApron.luau` | R15 NPC with `AB.r15Rig` + `AB.r15Hat` + `weldTo` |
| `src/Common/AssetBuilder.luau` | All primitive + rig helpers |

---

## Session A — R15 NPC retrofit (one commit)

Every NPC under `src/Assets/Districts/<District>/Npcs/` is currently a hand-built block figure. Convert each to the R15 rig pattern.

Per NPC:
- Replace the per-part `AB.part`/`AB.block`/`AB.sphere` body construction with a single `AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {skin = ..., shirt = ..., pants = ...})` call.
- Attach district-themed accessories (apron, hair, hat, props) using the `weldTo(rig, hrp, name, size, color, offset, shape?)` helper exactly as `BakerWithApron.luau` does.
- Add hats / hair via `AB.r15Hat(rig, size, color, yOffset, name, shape?)`.
- Held props ride on `rig:FindFirstChild("RightHand")` / `LeftHand`. R15 hand origin differs from R6 — apply the `+1.2` Y shift documented in BakerWithApron.
- Preserve each NPC's color identity (hair tone, signature accessory, prop color).
- Each module stays ≤ 250 lines. Top-line comment: `<NAME> — R15 retrofit (polish A)`.

Commit message: `<District>: R15 NPC retrofit (Session A) — N NPCs migrated`

---

## Session B — Polish module + atmosphere region (one commit)

Three new files, all named after the district. **No MaterialVariant generation in this session** — the Polish module just references variant names by string. The orchestrator (or a follow-up MCP pass) generates the actual MaterialVariants in MaterialService. This matches the Donut/Tokyo pattern exactly.

### 1. `src/Common/<District>Polish.luau`
Mirror `DonutPolish.luau`. Define 5 `VARIANTS` keyed `stucco/brick/path/signage/<district-specific>`. Variant strings are `<district_lower>_<material>` (e.g. `pizza_brick_red`).

Write a `classify(part)` function that routes part names to a variant key. Use the per-district name conventions in your input table. Order matters — narrow rules first (so `RoofIcing` doesn't get claimed by the broader `roof` rule).

Implement `bumpLampPointLight` + `addSignSurfaceLight` for the lighting pass exactly as DonutPolish does, with district-themed lamp color and brightness/range.

Export `<District>Polish.apply(model)` matching the DonutPolish signature.

### 2. `src/Server/<District>ZoneSpawner.server.luau`
Mirror `DonutZoneSpawner.server.luau` (read it — short file). Derive district AABB from manifest entries whose `module` starts with the district's prefix. Spawn one Part `<District>AtmosphereZone` tagged for the client. Park it under `workspace.<District>AtmosphereZones` (so AssetSpawner's `:ClearAllChildren("Districts")` doesn't wipe it).

### 3. `src/Client/<District>AtmosphereClient.client.luau`
Mirror `DonutAtmosphereClient.client.luau`. On region enter, lerp `Lighting.ColorShift_Top`, `Lighting.FogColor`, `Lighting.FogStart`, `Lighting.FogEnd`, `Lighting.Brightness` toward the district's atmosphere theme over ~1.5s. On exit, lerp back to default.

Commit message: `<District>: PBR polish + atmosphere region (Session B)`

---

## Session C — Ambient sound zones (one commit)

Two new files.

### 1. `src/Server/<District>SoundZoneSpawner.server.luau`
Mirror `DonutSoundZoneSpawner.server.luau`. Same AABB derivation from manifest. Define a `MICRO_SPECS` list of 4–6 zones, each tied to a specific manifest module hint (e.g. `Buildings.TonysPizzeria` for Pizza). Park under `workspace.<District>SoundZones`.

### 2. `src/Client/<District>SoundZoneClient.client.luau`
Mirror `DonutSoundZoneClient.client.luau`. Wire a layer config:
- Layer `District`: the looping ambient bed (3-min loop, volume 0.35).
- Per-micro-zone layer: short loop or stinger sound (volume 0.5, looped).

For SoundIds, **search the codebase** for `rbxassetid` (grep) and prefer IDs already proven safe (TokyoSoundZoneClient and DonutSoundZoneClient both have known-working sets). Hand-curate district-themed IDs from those known-safe pools.

Commit message: `<District>: ambient sound zones (Session C)`

---

## Output protocol

After session C:

```bash
git log --oneline origin/main..HEAD   # must show exactly 3 commits
git push -u origin HEAD:feature/polish-<short>
```

Report back to the orchestrator (≤ 200 words):
- Branch pushed
- 3 commit SHAs
- # NPCs retrofitted
- Polish variant names defined
- # sound zones spawned
- Any TODOs or open concerns

---

## What the orchestrator does after all 4 push

1. Merge `feature/polish-pizza` → `main` (orchestrator resolves no conflicts — files are district-scoped).
2. **User playtests Pizza Plaza** before continuing.
3. Merge `feature/polish-burger` → playtest → merge `feature/polish-bbq` → playtest → merge `feature/polish-mercado` → playtest.
4. **Single post-merge commit** wires all four Polish modules into `src/Server/Services/AssetSpawner.luau` (one `require` lookup + one gate per district).
5. Separately, the orchestrator runs Session D (Meshy hero) one district at a time using Studio MCP, since extracting the inner Mesh asset id from each Open Cloud upload requires `InsertService:LoadAsset` at runtime. Hero landmark targets:
   - Pizza Plaza → `TreviFountain.luau` (sculpture, not building)
   - Burger Boulevard → `GiantBurgerTower.luau` (food monument)
   - BBQ Holler → `GiantPigStatue.luau` (fiberglass statue)
   - Mercado del Sol → `GiantCactusSculpture.luau` (saguaro 40-stud)

Per user direction: Meshy is allowed for sculptures and non-building landmarks only. No Meshy on actual buildings.
