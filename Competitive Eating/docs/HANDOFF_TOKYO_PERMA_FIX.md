# HANDOFF — Tokyo + Donut Meshy Mesh Fixes (2026-06-02)

A new Claude Code session is taking over to fix recurring bugs that the prior
session couldn't diagnose (MCP bridge died). All code described below is
already merged to `main` and pushed to `origin/main`.

## What's broken (from user's playtest)

1. **GiantManekiNeko (Tokyo)**: Meshy.ai mesh spawns lying on its back. Face
   points up, raised paw points horizontally (toward camera when viewed from
   south plaza). Prior fix attempt: added `CFrame.Angles(math.rad(-90), 0, 0)`
   to the module — unclear if it took effect.
2. **GiantDonutTower (Donut Dynasty)**: User reports "everything built with
   meshy.ai is not working". Donut tower may be invisible / wrong orientation
   / wrong scale.
3. **Tokyo buildings shake** in Play. Not stale state (AssetSpawner has
   `ClearAllChildren` patch). Root cause hypothesized as anchored-part
   overlap z-fighting between primitives and adjacent props. Prior fix
   attempt: moved 5 kanji signs from Z=93..110 to Z=83 to clear building
   footprint Z=87..113.

## What's already shipped to main

Latest commits (newest first):
- `ee25783` Remove accidentally-tracked worktree gitlinks
- `17c8da0` **Tokyo perma-fix: Maneki-neko rotation + kanji sign de-overlap**
- `c169dff` Merge Donut Session 4: ambient sound zones
- `c7dd25d` Merge Donut Session 3: PBR + lighting + atmosphere
- `ce5b0eb` Merge Donut R15 retrofit
- `0dfff3d` Merge Donut Session 2: R6 NPCs (later superseded by R15)
- `221d239` Merge Donut Session 1: GiantDonutTower Meshy.ai mesh swap

Tokyo pilot completed earlier (A through G):
- Cube 3D → primitive buildings (G)
- R6 NPCs + idle animator (B)
- PBR materials + atmosphere zone (C)
- Layout reorg (D — partially reverted)
- Sound zones (E)
- Maneki-neko Meshy.ai mesh import (E cleanup)

Donut pilot completed:
- Meshy GiantDonutTower
- R15 NPCs (Donut only — Tokyo still R6)
- PBR materials + atmosphere zone
- Sound zones

## Key files to know

- `src/Common/AssetManifest.luau` — districts positions, all 6 districts
- `src/Common/AssetBuilder.luau` — primitives + `r6Rig` + `r15Rig`
- `src/Common/TokyoPolish.luau`, `DonutPolish.luau` — material classifiers
- `src/Server/Services/AssetSpawner.luau` — runs at server start, calls each
  manifest module. Has `ClearAllChildren` patch.
- `src/Server/NpcAnimator.server.luau` — dual R6/R15 detection
- `src/Server/TokyoZoneSpawner.server.luau` + `DonutZoneSpawner.server.luau` —
  atmosphere region triggers
- `src/Client/TokyoAtmosphereClient.client.luau` +
  `DonutAtmosphereClient.client.luau` — atmosphere lerps
- `src/Server/TokyoSoundZoneSpawner.server.luau` +
  `DonutSoundZoneSpawner.server.luau` — sound region triggers
- `src/Client/TokyoSoundZoneClient.client.luau` +
  `DonutSoundZoneClient.client.luau` — sound fade
- `src/Assets/Districts/TokyoTown/Landmarks/GiantManekiNeko.luau` — the
  Meshy cat module with the `-90°` X rotation fix
- `src/Assets/Districts/DonutDynasty/V2/Landmarks/GiantDonutTower.luau` —
  the Meshy donut module
- `BillboardNormalizer.server.luau` — shrinks NPC nametags on server start

## Workflow rules learned (must respect)

- Studio's `screen_capture` returns dark frames in most states — DO NOT trust
  it for visual verification.
- `execute_luau` is Edit-VM only — cannot reach Play state.
- `MeshPart.MeshId = ...` setter is locked — must use
  `AssetService:CreateMeshPartAsync(meshId, {options})`.
- Rojo often desyncs silently — `Disconnect` then `Connect` forces re-sync.
- Layout via AI prompt fails because AI sessions are blind without working
  `screen_capture`. Layout decisions need human eyes.
- Primitives > Cube 3D for buildings; Meshy.ai is fine for one hero
  landmark per district.
- All NPCs going forward use R15 (Donut is the test case; Tokyo retrofit
  still pending).

## Credentials (NEVER echo to chat)

- Meshy.ai key: macOS Keychain entry `GameDevMeshy` (40 chars). Read via
  `KEY=$(security find-generic-password -s GameDevMeshy -w)`. Meshy API
  params: `mode=preview`, `art_style=realistic`, `ai_model=meshy-6`.
- Roblox Open Cloud key: macOS Keychain entry `roblox-funguy-assets`
  (964 chars). userId 2270535666. asset:write scope.

## Task for the new session

1. **Verify Studio MCP works** — call `mcp__Roblox_Studio__list_roblox_studios`
   then `set_active_studio`. If "frank's fairground" is the only place,
   that IS the Competitive Eating .rbxl (display name differs from project
   folder name — don't ask, just proceed).

2. **Verify Rojo sync** — use `execute_luau` to check that the place's
   loaded `AssetManifest` and `GiantManekiNeko` modules match disk:
   ```luau
   local mod = game:GetService("ReplicatedStorage").Common.AssetManifest
   local clone = mod:Clone(); clone.Parent = workspace
   local manifest = require(clone); clone:Destroy()
   local maneki = game:GetService("ReplicatedStorage").Assets.Districts.TokyoTown.Landmarks.GiantManekiNeko
   return {
       maneki_has_rotation = maneki.Source:find("CFrame%.Angles") ~= nil,
       kanji_sushi_z = (function()
           for _, e in manifest do
               if e.module == "Assets.Districts.TokyoTown.Props.KanjiSign_Sushi" then
                   return e.position.Z
               end
           end
       end)(),
   }
   ```
   If `kanji_sushi_z` is not 83, or `maneki_has_rotation` is false, Rojo
   is stale and the user needs to Disconnect/Connect Rojo plugin.

3. **Wipe and respawn Tokyo cleanly** via `execute_luau`. Use this exact
   pattern (proven elsewhere in this conversation):
   ```luau
   local d = workspace:FindFirstChild("Districts") or Instance.new("Folder", workspace)
   d.Name = "Districts"
   -- Wipe only Tokyo-named instances; preserve other districts
   local TOKYO = {DaikonRamen=true, SushiDaiko=true, IzakayaLantern=true,
     TakoyakiCart=true, DaikonRamenSignboard=true, GiantManekiNeko=true,
     ShintoTorii=true, MiniPagodaTower=true, SakeBar=true, CapsuleHotel=true,
     VendingMachineWall=true, NarrowAlleyShops=true, SalarymanApartments=true,
     LanternNoodleRow=true}
   -- ...etc, also iterate over all TokyoTown Props/Decor/NPCs by name from manifest
   ```
   Then spawn every Tokyo entry from the manifest at its `position` and `yaw`.

4. **Inspect Maneki orientation live**:
   ```luau
   local cat = workspace.Districts.GiantManekiNeko:FindFirstChild("Cat")
   return {
     pos = tostring(cat.Position),
     up = tostring(cat.CFrame.UpVector),  -- should be (0,1,0)
     look = tostring(cat.CFrame.LookVector),
     size = tostring(cat.Size),
   }
   ```
   If `up` is not approximately `(0, 1, 0)`, try the 3 other 90° rotations
   in-place via execute_luau (set `cat.CFrame` directly to test):
   - `CFrame.Angles(math.rad(90), 0, 0)` — flip from current
   - `CFrame.Angles(0, 0, math.rad(90))`
   - `CFrame.Angles(0, 0, math.rad(-90))`
   - Identity rotation (remove the angles entirely)
   
   For each, ask the user "is the cat upright now?" via SCREEN-CAPTURE-FREE
   reporting (e.g., describe the bbox extents and which axis is tallest).
   Once the right rotation is found, **edit the module to bake it in**
   and commit.

5. **Inspect Donut Tower live**:
   ```luau
   local tower = workspace.Districts:FindFirstChild("GiantDonutTower")
   ```
   Find the MeshPart inside it. Print Position, Size, MeshId, UpVector.
   The user reports it's broken — diagnose what's actually wrong (missing,
   wrong size, wrong axis) before changing code.

6. **Audit shaking** — search workspace.Districts for any pair of
   BaseParts within 5 studs of each other where both are Anchored and
   both CanCollide=true and bboxes intersect. Those pairs z-fight.
   Report the worst offenders. Fix by setting CanCollide=false on
   non-primary visual layers.

7. **Commit fixes on a focused branch** (e.g., `feature/tokyo-real-fix`).
   Single concern per commit. Push.

## Don't repeat past mistakes

- Don't rewrite CLAUDE.md.
- Don't run any of the v1.x / Tokyo pilot Sessions A-E again — they're
  done and merged.
- Don't run another big "session" with multiple phases. Make individual,
  small, testable changes.
- Don't claim something is fixed without inline verification through
  `execute_luau`.
- Don't trust `screen_capture` results.
- Don't use `MeshPart.MeshId = ...`.
- If user reports the cat is still tipped after a rotation change,
  trust them — your in-code UpVector check is not equivalent to "the
  cat looks upright in render".

## User context

The user is frustrated. They've spent the day iterating and many AI sessions
produced broken or partial output. Be terse, do not over-explain, do not
ask permission before making obvious fixes, do not start sentences with
"I". Verify in code, not in prose.
