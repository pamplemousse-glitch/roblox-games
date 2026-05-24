# FunGuy — Session Handoff
*Updated May 16, 2026 — Backend complete. Studio world built. Mushroom FBXs ready. Sounds + weapons added. Myco the Merchant NPC built (code complete, requires one Studio run). Blockers: mushroom models not yet imported to Studio, no world playtested since session 4, monetization IDs missing.*

---

## Dev environment — FULLY AUTOMATED
Both services start automatically at macOS login via LaunchAgents. No manual steps.

| Service | LaunchAgent | What it does |
|---|---|---|
| MCP server | `com.robloxstudio.mcp.plist` | boshyxd/robloxstudio-mcp on port 58741 |
| Rojo | `com.funguy.rojo.plist` | Serves `~/Roblox/my-roblox-clicker-game` |

**Open Studio → Rojo plugin shows "Connected" → Accept → you're live.**

To restart manually if needed:
```bash
launchctl unload ~/Library/LaunchAgents/com.funguy.rojo.plist && launchctl load ~/Library/LaunchAgents/com.funguy.rojo.plist
launchctl unload ~/Library/LaunchAgents/com.robloxstudio.mcp.plist && launchctl load ~/Library/LaunchAgents/com.robloxstudio.mcp.plist
```

### MCP tools available (robloxstudio server — 43 tools)
Key tools: `execute_luau`, `insert_asset`, `get_file_tree`, `set_script_source`, `create_object`, `mass_create_objects`, `set_property`, `grep_scripts`, `capture_screenshot`

**IMPORTANT — MCP namespace:** Use `mcp__Roblox_Studio__*` tools (uppercase, boshyxd server on port 58741). The lowercase `mcp__robloxstudio__*` tools exist but don't respond. **Always call `mcp__Roblox_Studio__list_roblox_studios` then `mcp__Roblox_Studio__set_active_studio` at the start of every session before using any other MCP tool.**

**IMPORTANT:** MCP tools only load at session start. If you add MCP during a session, start a new Claude Code session before calling MCP tools.

Start Claude Code from project dir:
```bash
cd ~/Roblox/my-roblox-clicker-game && claude
```

---

## 🚀 SHIP PLAN — Week of May 17, 2026

### MVP Core Loop (4 loops, nothing else)

| # | Loop | Status |
|---|---|---|
| 1 | Tend mushrooms → earn spores (active, per-species payouts) | 🟡 In progress — TendingManager rewritten, SporeLoop passive 10%, TendingLoop fires UpdateSpores |
| 2 | Buy better species in Shop → bigger tend payouts | ✅ ShopUI + PurchaseHandler complete |
| 3 | Portal to The Deep → kill mobs → earn spores | 🟡 Mob drops need 15× buff in Config |
| 4 | Prestige → reset → earn faster | ✅ Sporulate flow complete |

### Pre-launch checklist (ordered)
- [ ] Buff mob drop amounts 15× (Config.luau MOB_LOOT table)
- [ ] Hide disabled features in GameClient nav bar: Fishing, Pets, Vat, Arrange, Water Grotto
- [ ] Wire TutorialManager in GameClient (module already written — just needs init call)
- [ ] Playtest: tend payouts feel rewarding, mobs die in ≤4 hits, shop costs feel reachable
- [ ] Set max players to 6 in Studio Place Settings
- [ ] Publish via File → Publish to Roblox

### Features hidden at launch (NOT deleted — restore per update roadmap below)
| Feature | Action |
|---|---|
| Mole Fishing | Remove fishing button/prompt from GameClient |
| Pets | Remove PETS button from nav |
| Mycology Vat | Remove VAT button from nav |
| Arrange Mode | Remove ARRANGE button from nav |
| Water Grotto | Already gated (20 species + Deepblood potion) — just don't surface UI for it |
| Mushroom Journal | Keep — it's passive and shows collection progress |

---

## 🗺️ POST-LAUNCH UPDATE ROADMAP

### Update 1 — "The Fisher's Cave" (~2 weeks post-launch)
- Unhide Mole Fishing (already built)
- 3 new Common/Uncommon mushroom species
- Mycelium Surge event rewards tweak based on play data

### Update 2 — "Companions" (~4 weeks post-launch)
- Unhide Pets (already built — Cricket + Mole)
- Pet cosmetic variants (fur color)

### Update 3 — "The Mycologist" (~6 weeks post-launch)
- Unhide Mycology Vat (already built)
- Grand Vat in Hub (cooperative brewing — design only, needs build)
- 3 new potion recipes

### Update 4 — "The Deep Expands" (~8 weeks post-launch)
- New Deep sub-zone: Crystal Caverns
- 5 new Rare/Epic mushroom species
- New mob types + weapon tier

### Update 5 — "The Water Grotto" (~12 weeks post-launch)
- Remove Water Grotto gate (PortalManager + UI)
- Axolotl pet
- 5 Mythic species exclusive to Grotto

### Long-term expansion targets
- Seasonal holiday events
- Species batches toward 350+ total
- Trading Post (player-to-player species + spore swap)
- Auction Grotto (90-second live auctions, from Pet Sim 99 research)
- True personal cave instancing (per-player cloned caves)

---

## Full codebase inventory

### Server (`src/Server/`)
| File | Status | Notes |
|------|--------|-------|
| `GameInit.server.luau` | ✅ | Creates 40 RemoteEvents + Bindables folder (OpenShop BindableEvent) on start |
| `DataManager.luau` | ✅ | ProfileStore, 180s auto-save, full schema incl. pets/tending/combat/vat/journal |
| `SporeLoop.server.luau` | ✅ | 1s tick, cave events, mutations, TendingManager+VatManager+DeathManager mults |
| `MoleFishing.server.luau` | ✅ | ProximityPrompt→bite timer→FishingBite→reel→FishingResult→loot; mole pet catch 8% |
| `TendingManager.luau` | ✅ | 3 slots (water/nutrients/pollinate), 10-min cooldowns, per-species boost mult |
| `TendingLoop.server.luau` | ✅ | Wires TendSlot remote; sends TendingState on join |
| `PetManager.luau` | ✅ | Pet ownership (owned/active), addPet, setActive (max 2) |
| `PetLoop.server.luau` | ✅ | Cricket spawn loop (240s), SetActivePets remote, PetState sync |
| `MobManager.luau` | ✅ | spawnMob/damageMob/getMob; mob Parts as neon balls in TheDeep |
| `MobLoop.server.luau` | ✅ | 3 mobs on boot, replenish every 45s up to 6; reads MobSpawn_ markers |
| `DeathManager.luau` | ✅ | onPlayerDied (teleport Hub, add debt), applyDebtPenalty (15%/harvest) |
| `CombatManager.luau` | ✅ | playerAttack (range+cooldown validated), mobAttack (→ death) |
| `CombatLoop.server.luau` | ✅ | Boots CombatManager; wires PlayerAttack remote |
| `VatManager.luau` | ✅ | canBrew, brew, usePotion, getProductionMult (spore_surge) |
| `VatLoop.server.luau` | ✅ | Wires BrewPotion/UsePotion remotes; VatState sync on join |
| `JournalManager.luau` | ✅ | discover(player, speciesId), milestone rewards, syncPlayer |
| `JournalLoop.server.luau` | ✅ | Syncs journal on join |
| `PortalManager.server.luau` | ✅ | Touch portals: Hub↔Cave↔Deep; WaterGrotto gate (20 species + deepblood) |
| `VIPManager.luau` | ✅ | Checks VIP sub + 2× pass via MarketplaceService, re-checks every 5 min |
| `VIPLoop.server.luau` | ✅ | Boots VIPManager |
| `PurchaseHandler.server.luau` | ✅ | Upgrades/unlock/prestige; calls JournalManager.discover on unlock |
| `CaveManager.luau` | ✅ | Top 3 rarest species showcase per player |
| `LeaderboardManager.server.luau` | ✅ | All-time + 30-day seasonal leaderboards; 60s broadcast |
| `PlotManager.luau` | ✅ | Assigns cave plots, RootSpot list helper |
| `AuraSystem.luau` | ✅ | Mutated neighbor boost cache |
| `MushroomManager.luau` | ✅ | Spawn/despawn/swap 3D models, mutation visuals, root glow |
| `MushroomPlacer.server.luau` | ✅ | PlayerAdded/Removing — plot assign, spawnAll, despawnAll |
| `WeatherState.luau` | ✅ | currentEvent, surgeActive, current (compat table) |
| `SporeOrbManager.luau` | ✅ | Orb Parts, 5× value, Surge 2× density, grants ingredient on collect |
| `SporeOrbLoop.server.luau` | ✅ | Wires PlayerAdded/Removing to orb loop |
| `MerchantManager.luau` | ✅ | Rotating stock, purchase validation |
| `MerchantLoop.server.luau` | ✅ | 6-min rotation + PurchaseMerchant handler |
| `MyceliumPulse.luau` | ✅ | 3+ players → +20% spores/sec cooperative pulse |
| `MyceliumPulseLoop.server.luau` | ✅ | Wires orb collected → pulse |
| `MutationHook.luau` | ✅ | Pub-sub for mutation events |
| `LoginStreakManager.luau` | ✅ | Streak popup + ClaimStreakReward |
| `DailyQuestManager.luau` | ✅ | 3 seeded daily quests, 24h reset |
| `RetentionLoop.server.luau` | ✅ | Wires all retention hooks |
| `GameEventsBroadcast.luau` | ✅ | Cross-server pub/sub via MessagingService |
| `AnalyticsManager.luau` | ✅ | Roblox AnalyticsService events throughout |
| `AnalyticsLoop.server.luau` | ✅ | Boots AnalyticsManager early (name starts 'A') |

### Common (`src/Common/`)
| File | Status |
|------|--------|
| `Config.luau` | ✅ — 37 species, cave events, prestige, tending, pets, mobs/weapons, vat recipes, journal milestones, VIP config |

### Client (`src/Client/`)
| File | Status | Notes |
|------|--------|-------|
| `UI/HUD.luau` | ✅ | Spore counter, cave event banner, mutation notification, HP bar |
| `UI/TendingUI.luau` | ✅ | Tending slot panel (Water/Nutrients/Pollinate + cooldown display) |
| `UI/PetDenUI.luau` | ✅ | Pet grid, 2 active slots, toggle via tap |
| `UI/VatUI.luau` | ✅ | Recipe browser + ingredient counts + potions inventory |
| `UI/JournalUI.luau` | ✅ | 5×7 species grid (discovered=color, undiscovered=silhouette) + milestone bar |
| `UI/ShopUI.luau` | ✅ | Upgrades + Species tabs |
| `UI/MerchantUI.luau` | ✅ | Rotating merchant panel |
| `UI/LoginStreakUI.luau` | ✅ | Login streak popup |
| `UI/DailyQuestUI.luau` | ✅ | Daily quest panel |
| `SharedCaveUI.luau` | ✅ | THE CAVE panel — leaderboard + showcases |
| `VaultUI.luau` | ✅ | Vault species selection before prestige |
| `ArrangeMode.luau` | ✅ | SelectionBox + raycast pedestal swapping |
| `TutorialManager.luau` | ✅ | 4-step new player onboarding |
| `SoundManager.luau` | ✅ | Click/open/close sounds |

### StarterPlayerScripts (`src/StarterPlayerScripts/`)
| File | Status | Notes |
|------|--------|-------|
| `GameClient.client.luau` | ✅ | Main client startup — inits all UI modules, wires all remotes, nav bar, zone banner, hub billboard updater |
| `FishingUI.client.luau` | ✅ | Self-contained LocalScript — Stardew reel mini-game; ⚠️ was incorrectly in src/Client/UI — moved here (session 5) |
| `SporeOrbEffects.client.luau` | ✅ | Floating "+N Spores" BillboardGui; ⚠️ was incorrectly in src/Client — moved here (session 5) |
| `PetFollower.client.luau` | ✅ | Glowing sphere Parts that lerp toward player for each active pet; responds to PetState remote |
| `SoundClient.client.luau` | ✅ | Cave ambient, 3 event loops, 5 mobs × 4 sounds, player HP feedback |
| `CombatClient.client.luau` | ✅ | 2-slot weapon hotbar; click-to-attack; fires PlayerAttack remote |
| `NPCShopClient.client.luau` | ✅ | Proximity speech bubble (20 stud radius) + ProximityPrompt E-key → fires OpenShop BindableEvent |

### Packages installed (`Packages/`)
- `Janitor.lua` — per-orb connection/timer cleanup (`1foreverhd/janitor@1.18.15`)
- `Signal.lua` — pub/sub events (`sleitnick/signal@2.0.3`)
- `Sift.lua` — table utilities (`csqrl/sift@0.0.11`)
- `ProfileStore.lua` — session-locking DataStore (`madstudioroblox/profilestore@1.1.0`)

### Bindables (`ReplicatedStorage.Bindables`) — 1 total
`OpenShop` — NPCShopClient fires → GameClient listens; opens shop panel same as clicking the HUD shop button

### All RemoteEvents (`ReplicatedStorage.Remotes`) — 40 total
`UpdateSpores`, `WeatherChanged`, `PurchaseUpgrade`, `UnlockSpecies`, `Sporulate`, `SyncData`, `LeaderboardUpdated`, `ShowcaseUpdated`, `MutationOccurred`, `ArrangeSwap`, `OrbCollected`, `MerchantStock`, `PurchaseMerchant`, `MyceliumPulse`, `LoginStreakData`, `ClaimStreakReward`, `DailyQuestData`, `QuestProgress`, `ClaimQuestReward`, `SeasonLeaderboardUpdated`, `ShowPortalMessage`, `ZoneChanged`, `CaveEventActive`, `FishingBite`, `FishingResult`, `LootGranted`, `TendSlot`, `TendingState`, `PetCaught`, `SetActivePets`, `PetState`, `PlayerAttack`, `PetsRetreat`, `HPUpdate`, `BrewPotion`, `UsePotion`, `VatState`, `JournalUpdated`, `MilestoneReached`, `MobSound`

---

## Studio assets needed before first playtest
1. `Workspace > Plots > Plot_1` (Folder) containing:
   - `RootSpot_1`…`RootSpot_N` (BaseParts) — one part per slot, this is both the visual base and the spawn anchor
2. `ReplicatedStorage > MushroomModels` folder with all 35 species models
3. Each model needs: `Root` (PrimaryPart, y=0), `Cap` (Part), `GlowLight` (PointLight **inside** Cap — recursive FindFirstChild)
4. SporeOrbs are parented to the plot folder at runtime — no Studio work needed

---

## Known bugs / gotchas
- `GlowLight` must use `model:FindFirstChild("GlowLight", true)` — it's nested inside Cap
- **Personal cave instancing** — All players still share Plot_1 at origin. The code (PlotManager, MushroomPlacer, PortalManager, MoleFishing) is fully ready for multiple plots. To enable instancing: duplicate CaveEnvironment + PersonalCaveExtras geometry in Studio at x=500, x=1000, etc., then create matching Plot_2, Plot_3 folders under workspace.Plots with the same RootSpot structure offset to each x position. PortalManager auto-wires new cave folders via `Workspace.ChildAdded`. MoleFishing auto-wires new MoleHoles via `workspace.DescendantAdded`. MushroomPlacer retries plot assignment for up to 3 seconds on join.

---

## ✅ PRIORITY 1 — Retention infrastructure — DONE

ProfileStore migration, 180s auto-save, 12 new data fields, login streak logic, offline earnings snapshot. See previous session notes for full detail.

---

## ✅ PRIORITY 4 — Daily retention systems — DONE

Login streak rewards (7-day cycle), daily quests (3 per day, seeded, 24h reset). Full server + client implementation. See previous session notes for full detail.

---

## ✅ THIS SESSION — Analytics & cross-server infrastructure — DONE

### GameEventsBroadcast.luau
Cross-server pub/sub over MessagingService. Single topic `FunGuyEvents_v1`. API:
```lua
GameEventsBroadcast.publish("multiplier_start", { type="weekend", multiplier=2, expiresAt=os.time()+3600 })
GameEventsBroadcast.on("multiplier_start", function(data) ... end)
local mult = GameEventsBroadcast.getSporeMultiplier()  -- product of all active non-expired multipliers
```
Payload capped at 900 bytes (under MessagingService 1 KB limit). Built-in `multiplier_start`/`multiplier_end` handlers maintain `activeModifiers` with TTL-based cleanup.

### Seasonal leaderboard (LeaderboardManager rewrite)
`MemoryStoreSortedMap("FunGuy_Season_v1_N")` where `N = math.floor(os.time() / 2592000)` — rotates automatically every 30 days. TTL = remaining season time + 1-day buffer, capped at MemoryStore's 45-day max. Sort key = `peakSpores`. Fires `SeasonLeaderboardUpdated` to all clients every 60s alongside the existing `LeaderboardUpdated`.

### AnalyticsManager.luau
Roblox `AnalyticsService` wired throughout the server. Events tracked:

| Category | Events |
|---|---|
| Session | `session_start` (totalSessions, streak, prestige, species count), `session_end` (duration in seconds) |
| Onboarding funnel | Steps 1–5: `first_join`, `first_species_unlocked`, `first_upgrade_purchased`, `first_orb_collected`, `first_prestige` |
| Economy — Sink | Upgrade purchases, species shop unlocks, merchant purchases (all with exact cost + ending balance) |
| Economy — Source | Login streak rewards, daily quest rewards |
| Progression | `LogProgressionCompleteEvent` on each prestige level |
| Engagement | `mutation_triggered` (with prestige level + species count), `weather_event_start` (per player online, with multiplier) |

**Architecture note:** Session/mutation/orb events self-subscribe via `Players` events and callbacks. Economy/progression events fire via explicit calls from the owning module (no RemoteEvent race condition). `AnalyticsLoop.server.luau` (name starts with 'A') ensures the module loads before purchase handlers connect.

**Files that call AnalyticsManager:**
- `PurchaseHandler.server.luau` → `onUpgradePurchase`, `onSpeciesUnlock`, `onPrestige`
- `MerchantManager.luau` → `onMerchantPurchase`
- `LoginStreakManager.luau` → `onStreakClaimed`
- `DailyQuestManager.luau` → `onQuestClaimed`
- `SporeLoop.server.luau` → `onWeatherEvent` (iterates all online players)

**DataManager not wired** — circular dependency (AnalyticsManager requires DataManager). Session tracking uses the `PlayerAdded` polling loop already in AnalyticsManager; session-end uses a `sessionCache` snapshot that survives DataManager's `PlayerRemoving` cleanup.

---

## 3D Model Sizing (canonical — match in Blender and Studio)

Roblox character = ~5.5 studs tall. Size by tier:

| Tier | Height | Width | Visual feel |
|---|---|---|---|
| Common | 1–1.5 studs | 1–2 studs | Ankle-height, cute |
| Uncommon | 2–2.5 studs | 2–3 studs | Knee-height |
| Rare | 3–3.5 studs | 3–4 studs | Waist-height |
| Epic | 4–4.5 studs | 4–5 studs | Chest-height, imposing |
| Mythic | 5–7 studs | 5–6 studs | Towering over player |

**Blender export rule:** Model at 1 BU = 1 stud. Export FBX with scale 1.0.
**Appearance descriptions:** `assets/mushrooms/SPECIES_DESCRIPTIONS.md` — all 35 species, one paragraph each.
**Asset folder:** `assets/mushrooms/` — save all .fbx files here.

---

## ✅ THIS SESSION — Full dev tooling + API setup + asset upload (May 16, 2026)

### Roblox Open Cloud API keys — stored in macOS Keychain
Universe ID: `10165724294` (Dev.0 / FunGuy). All keys scoped to this universe only.

| Keychain name | Scopes |
|---|---|
| `roblox-funguy-assets` | assets (r/w), asset-permissions, universe-places (w), thumbnails |
| `roblox-funguy-game` | universe-datastores, ordered-data-stores, memory-stores, messaging-service, notifications, subscriptions, game-passes, developer-products, inventory, secret-store |
| `roblox-funguy-admin` | universe (r/w), universe-place-instances (r/w), users, luau-execution-sessions, user-restrictions |

Retrieve a key:
```bash
security find-generic-password -s "roblox-funguy-assets" -a "antoinewiley" -w
```

**Per-game rule:** create 3 new keys per new game scoped to that game's Universe ID. Same scopes every time.

### All 37 mushroom assets uploaded to Roblox
- Script: `scripts/upload_mushrooms.py`
- Asset IDs: `scripts/asset_ids.json`
- Status: 37/37 uploaded successfully via Open Cloud Assets API
- Next step: insert them into Studio via MCP `insert_asset` tool in a new Claude session

To insert into Studio (run in new Claude session with MCP available):
```
Use MCP insert_asset to load all 37 mushroom models from scripts/asset_ids.json into ServerStorage > Mushrooms
```

---

## ✅ THIS SESSION — Game design overhaul + asset pipeline complete (May 16, 2026)

### Art direction pivot
Moving from dark bioluminescent to **bright cozy cave** — warm amber lighting, saturated mushroom colors, charming aesthetic. Reason: mole fishing mechanic is inherently whimsical and the overall game feel drifted cozy/adventure. Dark aesthetic was chosen for differentiation but no longer fits the tone. Mushroom FBX models are geometry-only — palette/lighting change happens in Studio, no models are wasted.

### New active mechanics design (not yet built)

#### Mole Fishing (signature mechanic — highest priority)
- Tunnel branches off the main cave with mole holes at varying depths
- Press E at a hole to cast a spore lure → wait for bite (seconds of tension) → timing mini-game to reel in (hold/release to keep needle in green zone, Stardew fishing style)
- Common moles near entrance, rarer moles deeper
- **Rare mole drops:** species fragments (only way to unlock top-tier species) + mutation catalysts (guarantee next mutation on a chosen mushroom)
- More mole holes + faster/rarer moles spawn during Underground Spring event

#### Three cave events (replace the old "weather" system — cave-native)
Fires randomly every 10-15 min. Players never know which is coming — FOMO hook.

| Event | Visual | Benefit |
|---|---|---|
| **Mycelium Surge** | Cave floor pulses, roots glow bright | Spore clusters bloom everywhere — collect or miss |
| **Underground Spring** | Water drips from ceiling, mist fills cave | More mole holes, rarer moles surface, faster respawn |
| **Bioluminescent Bloom** | Every mushroom flares to full glow | Mutation chances spike, tending yields doubled |

Each event rewards a different playstyle: Surge → collectors, Spring → fishers, Bloom → tenders.

#### Mycelium Tending (daily routine)
Walk to each mushroom, press E, choose Water / Nutrients / Pollinate. Each slot refills every 10-15 min. Active player tending all mushrooms = ~2.5× passive baseline. Reason to log in and walk your cave daily.

### Retention loop summary
1. Log in → collect offline spores → tend mushrooms (daily routine)
2. Fish mole holes in tunnel → fragments → unlock species (collection hook)
3. Cave event fires → be present to capitalize (FOMO)
4. Accumulate fragments + catalysts → trigger mutations → rarer species
5. Prestige → reset + multiplier → repeat faster
6. Social — The Deep leaderboard, trading, seeing others' caves

---

## ✅ THIS SESSION — RootSpot redesign (May 16, 2026)

### Pedestal → RootSpot rename (all files updated)
Replaced the confusing dual-part pedestal system (`Pedestal_N` + `PedestalTop_N`) with a single part per slot named `RootSpot_N`. Full change log:

| File | Change |
|---|---|
| `PlotManager.luau` | `getPedestals()` → `getRootSpots()`, pattern `^Pedestal_` → `^RootSpot_` |
| `MushroomManager.luau` | `PedestalName` attribute → `RootSpotName`; `findFreePedestal` simplified to `findFreeRootSpot` (no more dual-part lookup); `placeOnPedestal` → `placeOnRootSpot` |
| `ArrangeMode.luau` | `PedestalName` → `RootSpotName`; empty-slot raycast match `^PedestalTop_` → `^RootSpot_` |
| `PurchaseHandler.server.luau` | `targetPedestalName` → `targetRootSpotName` |

**Studio implication:** Plot folder only needs `RootSpot_1`…`RootSpot_N` BaseParts — no paired parts.

### Root spot glow (MushroomManager.luau)
New `setRootGlow(rootSpot, color?)` helper. Wired into:
- `spawnOne` — enables glow in tier color when a mushroom lands on a slot
- `swapMushroom` — recolors both affected slots after a swap; turns off vacated slot
- `despawnAll` — disables all root glows when player leaves

Tier → color mapping reuses the existing `TIER_GLOW` table (already defined in the file).

### Root spot mesh (Meshy)
Added `rootspot` as entry 37 in `scripts/generate_mushrooms.py`. One credit, one shared model used across all slots. Prompt: dark mycelium root cluster radiating from center, flat low-profile, faint bioluminescent white glow at tips. Runs automatically after all 36 mushrooms finish. Output: `assets/mushrooms/rootspot.fbx`.

---

## ✅ PRIORITY 0a — 3D Mushroom Models — DONE

### Art direction (updated May 16)
**Style: Bright Cozy Cave.** Warm amber cave lighting, saturated mushroom colors, charming aesthetic. Shifted from dark bioluminescent — mole fishing + exploration mechanics are inherently whimsical. Mushroom geometry is reusable, palette change happens in Studio lighting/materials.

### Meshy AI generation — COMPLETE
- **Tool:** Meshy AI text-to-3D REST API (Pro plan, $10/mo, 2000 credits first month)
- **API key:** stored in macOS Keychain as `GameDevMeshy` (never in code)
- **Script:** `scripts/generate_mushrooms.py` — runs fully automated, skips already-downloaded files
- **Output:** `assets/mushrooms/{id}.fbx` (raw) + `assets/mushrooms/{id}_reduced.fbx` (game-ready)
- **Appearance descriptions:** `assets/mushrooms/SPECIES_DESCRIPTIONS.md` (all 36 species)

All 37 assets generated and poly-reduced. maitake + lionsmane regenerated via Meshy at `target_polycount=5000` (2 extra credits). All `_reduced.fbx` files are under 10K triangles and scaled to tier height. Ready for Studio import.

### ✅ Poly reduction — DONE
All 37 models (36 species + rootspot) reduced to ~5,000 triangles via `scripts/blender_reduce.py`. Output: `assets/mushrooms/{id}_reduced.fbx`. Safe to import to Studio.
- maitake and lionsmane were regenerated via Meshy at `target_polycount=5000` (2 extra credits) — their original topology couldn't be decimated below 16K in Blender.
- Script does: join meshes → scale to tier height → decimate (up to 3 passes) → export.

### Studio model structure required
Every species needs a Studio `Model` with exactly:
- `Root` — PrimaryPart, anchored, `Position.Y = 0`
- `Cap` — Part child of model
- `GlowLight` — `PointLight` nested inside `Cap` (server code uses `model:FindFirstChild("GlowLight", true)`)

All 36 mushroom models go into `ReplicatedStorage > MushroomModels`. Named by species id (e.g. `button`, `chanterelle`).

### Root spot model structure required
One shared `rootspot.fbx` placed at every `RootSpot_N` slot in the plot. Studio setup:
- Place the reduced `rootspot` mesh as a decorative Model at each slot position
- Add a `PointLight` named `RootGlow` **directly inside the `RootSpot_N` BasePart** (not inside the mesh model)
- Server code (`MushroomManager.setRootGlow`) finds it via `rootSpot:FindFirstChild("RootGlow")` and sets color + enabled state automatically
- Glow color is driven by the mushroom tier sitting above it (Common=warm white, Uncommon=green, Rare=blue, Epic=purple, Mythic=gold). No manual color needed — leave it white in Studio.

---

## ✅ PRIORITY 0 — First playtest — DONE

**Playtest confirmed passing (May 16, session 2).** All bugs fixed and synced. Player spawns in Hub, 6 mushrooms + 6 orbs active, ProfileStore + Analytics firing, no errors.

Playtest checklist:
1. ✅ MushroomModels folder: 36 models, all structured (Root PrimaryPart + Cap + GlowLight)
2. ✅ `Workspace > Plots > Plot_1` rebuilt with RootSpot_1…6 + RootGlow PointLight each
3. ✅ `SeasonLeaderboardUpdated` wired in `SharedCaveUI`
4. ✅ Template script bugs fixed and synced (Runtime.server.lua + Runtime.client.lua stubbed)
5. ✅ `SporeOrbManager.luau` Janitor API fixed (j:add/j:destroy lowercase)
6. ✅ Playtest run: ProfileStore saves, Analytics fires, mushrooms spawn, orbs active
7. ☐ Prestige flow end-to-end (vault selection → reset → restore) — deferred, not blocking
8. ☐ DataManager cross-session save/load verify — deferred
9. ☐ Leaderboard 60s tick verify — deferred (no errors observed, likely working)

---

## 🟡 PRIORITY 2 — Active mechanics (partially built)

**⚠️ Research May 16: full design overhaul completed. Weather system replaced with 3 cave-native events. Mole fishing is the new signature mechanic. See THIS SESSION block above for full designs.**

| Mechanic | Status |
|---|---|
| Spore orbs (physical collect, 5× passive) | ✅ Built |
| Mycelium Pulse (3+ players active → +20% boost) | ✅ Built |
| Spore Merchant (rotating shop, 6-min refresh) | ✅ Built |
| **Mycelium Tending** (walk to root spot, press E, 3 slots: Water/Nutrients/Pollinate) | ❌ Not built — HIGH PRIORITY |
| **Mole Fishing** (tunnel + mole holes + Stardew-style reel mini-game) | ❌ Not built — HIGH PRIORITY (signature mechanic) |
| **Cave Events** (Mycelium Surge / Underground Spring / Bioluminescent Bloom) | ❌ Not built — HIGH PRIORITY (replaces weather system) |
| Mutation mini-game | ❌ Deprioritised — covered by Bloom event + mole catalysts |

Active engagement multiplier targets:
- AFK: 1× passive
- Light active (orbs + tending): ~3×
- Fully engaged (tending + fishing + event): ~8×

---

## 🟡 PRIORITY 3 — Monetization (post 15-min gate)

None built yet. Subscription (VIP pass) is highest priority — builds recurring revenue from day one.

| Item | Notes |
|---|---|
| VIP subscription | 2× offline cap, +20% passive, exclusive aura cosmetic. Use `MarketplaceService:PromptSubscriptionPurchase`. Gate UI behind 15-min playtime check. |
| Game Passes | 2× production, exclusive species, VIP access |
| Developer Products | Consumable spore boosts |
| Rewarded ads | Opt-in 2× boost for 30 min |
| Limited seasonal drops | Cosmetic-only, timed events |

Implementation rule from CLAUDE.md: **no monetization UI before 15 min of play** — check `data.totalPlaytimeSeconds >= 900` server-side before showing any purchase prompt.

---

## 🟡 PRIORITY 5 — World redesign (not built)

### "The Mycelium Network"
- **The Deep** — shared central cavern / social hub:
  - Hall of Legends (top 5 peakSpores with mutation displays)
  - Daily Quest board (NPC)
  - Spore Fountain (ambient)
  - Weather forecast board
  - Trade Post (species + spore swap, RAP system)
  - **Physical billboard leaderboard** — glowing bioluminescent Part with SurfaceGui, two sides (All-Time / Season), animated row pulses on rank change. `LeaderboardUpdated` already fires every 60s — just needs a SurfaceGui client renderer. See RESEARCH.md for full design.
  - Auction Grotto (90-second live auctions — from Pet Sim 99 research)
- **Grotto slots** — open-fronted personal caves off The Deep:
  - Each player's mushrooms + pedestals
  - Arrange mode here
  - Other players can walk in

### Pedestal slot unlock
- Start with 3 slots
- Unlock more by spending spores (up to max set by prestige level)

---

## 🟢 PRIORITY 6 — Remaining features

- **Trade Post** — species+spore swap, RAP system, VIP slots
- **Balance pass** — all spore/cost numbers untested
- **Experience Notifications** — OpenCloud push when vault approaching full (requires `offlineEarningsRate` + `lastLogoutTimestamp`, both already saved in DataManager)

---

## Retention benchmarks to aim for (Roblox simulator genre)

| Metric | Genre avg | Good target |
|---|---|---|
| D1 retention | 32% | 28–35% |
| D7 retention | 14% | 12–16% |
| Avg session time | 7 min (algorithm floor) | 12–17 min |

The algorithm penalises games below ~7 min average session time. Idle games naturally stay above this via offline reward claim loop (log in → collect → upgrade → leave).

---

## Rojo project mapping
```
src/Server               → ServerScriptService.Server
src/Common               → ReplicatedStorage.Common
src/Client               → ReplicatedStorage.Client
src/StarterPlayerScripts → StarterPlayer.StarterPlayerScripts
Packages/                → ReplicatedStorage.Packages
```

---

## ✅ THIS SESSION — Full game design (May 16, 2026)

Complete game design overhaul. All decisions documented in GAME_DESIGN.md.

### Key decisions locked in
- **World map:** Surface entrance → Shared Hub (spawn) → Personal Cave (instanced) → The Deep (shared, gated)
- **Hub:** Subterranean, warm amber bioluminescent, social heart. Merchant, Grand Vat, leaderboard wall, mushroom ring social area, The Deep portal (visible but locked from day 1)
- **Personal cave:** 6 plots, pet den, personal vat, mole fishing tunnel. Instanced per player.
- **The Deep:** Shared space, physically connected sub-chambers (no portal gates within). Central spine → Bat Colony (left), Crystal Formation (center), Glowworm Ceiling (right), Water Grotto (far back)
- **Pets:** Mole + Cricket (personal cave), Bat + Glowworm + Axolotl (The Deep). Pet den system — all owned pets live in cave, 2 active at a time. Pets never die permanently.
- **Combat:** Optional. Event-only mobs in personal cave (Bloom → spore beetles, Spring → cave leeches). Permanent ambient hostiles in The Deep (cave beetles, blind cave fish, shadow spore clouds). Mobs don't aggro unprovoked — casual players can ignore combat entirely.
- **Weapons:** 14 weapons across 3 tiers, crafted at Mycology Vat (mob drops + mushroom harvests). See GAME_DESIGN.md for full list.
- **Mycology Vat:** Personal vat (basic, in cave) + Grand Vat in hub (cooperative, 2–3 players). 6 potions designed.
- **Death mechanic:** Spore Debt — die → plots yield 15% less for next 3 harvests. Stacks with repeated deaths in same session. Clears automatically. Pets retreat to cave, 60s rest. Respawn in hub.
- **The Deep gating:** 500 total mushrooms grown → Deep entry. 20 Journal species + Deepblood potion → Water Grotto.
- **Roblox demographics:** 51% male / 44% female. Combat is optional to preserve broad appeal.
- **Death reference games:** BSS (bees sleep 30s), Stardew (lose 25% carried items), Fantastic Frontier (drop unequipped items, gold loss removed after backlash). Spore Debt is original — no comparable game does it.

---

## ✅ THIS SESSION — Phase 0 setup + first playtest attempt (May 16, 2026)

### What was completed

**MCP server identification:**
- Correct namespace is `mcp__Roblox_Studio__*` (boshyxd, port 58741). The lowercase `mcp__robloxstudio__*` tools exist in Claude's tool list but time out every time — ignore them completely.
- Must call `list_roblox_studios` → `set_active_studio` (studio_id = `ebed948a-0d70-4670-a1ff-9cd18e0d8c86`, named "Dev.0") at the start of every session.

**Studio assets confirmed ready:**
- `ReplicatedStorage > MushroomModels`: 36 models, all properly structured with `Root` (PrimaryPart, Anchored), `Cap` (MeshPart), `GlowLight` (PointLight inside Cap). Zero mismatches against Config species.
- `Workspace > Plots > Plot_1` **rebuilt**: old `Pedestal_N / PedestalTop_N / Bowl*` system wiped. 6 new `RootSpot_1`…`RootSpot_6` BaseParts created (3×0.5×3 studs, dark orange, at x=−12.5…12.5, z=0, y=0.25). Each has a `RootGlow` PointLight (disabled by default — MushroomManager enables it on spawn).
- `SharedCaveUI` already had `SeasonLeaderboardUpdated` wired — no change needed.

**Template scripts stubbed (disk only, not yet synced to Studio):**

| File | Problem | Fix |
|---|---|---|
| `src/Server/Runtime.server.lua` | Called `require("@Services/TestService")` — `@Services` is not a valid Roblox alias | Replaced body with comment |
| `src/Client/Runtime.client.lua` | Called `require("@Controllers/UIController")` — same broken alias | Replaced body with comment |

**SporeOrbManager bug fixed (disk only, not yet synced to Studio):**
- Janitor v1.18.15 (`1foreverhd/janitor@1.18.15`) uses **lowercase** method names. The code used `j:Add()` / `j:Destroy()` (uppercase) → changed to `j:add()` / `j:destroy()`.
- Also fixed thread cleanup: `j:Add(task.delay(...), "cancel")` → `j:add(task.delay(...), true)` (Janitor expects `true` not `"cancel"` for threads).
- File: `src/Server/SporeOrbManager.luau`, lines 177–213.

### What was NOT synced to Studio yet

Rojo disconnected during the session. The three file fixes above exist on disk but have not been synced into Studio. **Before the next playtest:**
1. Reconnect Rojo in Studio: in the Rojo plugin panel, click Connect (or wait for auto-reconnect after `rojo serve` is running). You should see your file changes reflected.
2. Verify Rojo shows "Connected" and the change count ticks.
3. Run the playtest again.

### First playtest output (partial — stopped after 2 errors found)

```
[ProfileStore]: Roblox API services available - data will be saved   ← GOOD
AnalyticsService: LogCustomEvent event fired.                          ← GOOD
error requiring "@Controllers/UIController": @controllers is not a valid alias  ← FIXED
SporeOrbManager:177: attempt to call missing method 'Add' of table    ← FIXED
```

DataManager/ProfileStore initialized correctly. Core server loop started. Both errors are now fixed on disk.

### Known remaining risks for playtest

- `GameClient` warning about "non-legacy RunContext" running multiple times from StarterPlayerScripts — monitor but likely harmless.
- Balance numbers entirely untested (spore rates, costs). Don't block on this — just note observations.
- If Janitor `add()` call for `task.delay` thread still errors, check the Janitor source: `true` is the correct second arg for threads (triggers `task.cancel` at cleanup).

---

## Master Build Plan

### Phase 0 — First Playtest (✅ DONE)
1. ✅ `ReplicatedStorage > MushroomModels` — 36 models, correct structure
2. ✅ `Workspace > Plots > Plot_1` — 6 RootSpot_N + RootGlow each
3. ✅ `SeasonLeaderboardUpdated` wired in `SharedCaveUI`
4. ✅ Template Runtime scripts stubbed + synced
5. ✅ `SporeOrbManager` Janitor API fixed + synced (j:add/j:destroy lowercase)
6. ✅ Playtest confirmed clean: ProfileStore, Analytics, mushrooms, orbs, 22 remotes
7. ✅ GameClient RunContext set to Legacy (warning suppressed)

### Phase 1 — World / Map (✅ DONE)
1. ✅ Hub Cavern at z=400 — floor/walls/ceiling, 6 fill lights, 8 glow patches, stalactites
2. ✅ Hub interactives — HubSpawn, Merchant placeholder, Grand Vat placeholder, Leaderboard Wall (SurfaceGui), Cave Portal (green glow), Deep Portal (purple, locked red X bars), Mushroom Ring (8 mushrooms + 4 seats + Spore Fountain)
3. ✅ Personal Cave extras — Pet Den (platform, beds, lantern post), Personal Vat (cylinder), Tunnel (arch + 3 mole holes, depth 1–3), Hub Return Portal (east wall, green glow)
4. ✅ The Deep at z=-400 — Central Spine (130-stud corridor, purple glow), Bat Colony (left, high ceiling, roost stalactites), Crystal Formation (center, 8 crystal pillars, Mythic node), Glowworm Ceiling (right, 20 hanging glowworm dots), Water Grotto (far back, underground lake, 5-bar locked gate, billboard "20 Species + Deepblood")
5. ✅ All portal Parts tagged with `PortalType` attribute for PortalManager

### Phase 2 — Portal & Spawn System (✅ DONE)
1. ✅ `PortalManager.server.luau` — touch-based teleportation: Hub↔Cave, Hub↔Deep (500-mushroom gate), Deep↔Grotto (20-species gate), ShowPortalMessage on block
2. ✅ `DataManager.luau` — added `totalMushroomsGrown` field (Reconcile-safe schema migration)
3. ✅ `GameInit.server.luau` — added `ShowPortalMessage` + `ZoneChanged` remotes (22 total)
4. ✅ `PurchaseHandler.server.luau` — increments `totalMushroomsGrown` on species unlock
5. ✅ `MushroomPlacer.server.luau` — syncs `totalMushroomsGrown` floor to owned-species count on join
6. ✅ SpawnLocation moved to Hub (z=410); PortalManager also teleports on CharacterAdded
7. ⚠️ Personal cave instancing: single shared cave for now (Plot_1 at origin). True per-player cloning deferred to Phase 3 iteration.

### Phase 3 — Cave Events (replaces weather system) ✅ DONE
8. ✅ Rewrote `SporeLoop` — Mycelium Surge, Underground Spring, Bioluminescent Bloom (10–15 min cycle, 3 min active)
9. ☐ Event mob spawning (spore beetles, cave leeches) — deferred to Phase 8 (Combat)
10. ☐ Rotating Rare Vendor during Surge — deferred
11. ✅ Client UI: cave event banner with per-event colors; MoleHole highlight during Spring

### Phase 4 — Mole Fishing ✅ DONE
12. ✅ MoleHole_1/2/3 in tunnel with ProximityPrompts (E key, depth 1–3)
13. ✅ `MoleFishing.server.luau` — hole lock, bite timer (Spring halves it), 15s anti-exploit, per-depth loot
14. ✅ `UI/FishingUI.client.luau` — Stardew-style reel mini-game (hold to push needle, 2s in green zone to win)
15. ✅ Loot table: depth1=spores 500–2K, depth2=species fragment, depth3=70% catalyst / 30% Epic/Mythic fragment
16. ✅ Fragment auto-unlock at 10 fragments; `fragments`+`catalysts` added to DataManager schema

### Phase 5 — Mycelium Tending ✅ DONE
17. ✅ `TendingManager.luau` — 3 slots (water/nutrients/pollinate), 10-min cooldowns, per-species mult
18. ✅ `TendingLoop.server.luau` — wires TendSlot remote, sends TendingState on join
19. ✅ `TendingUI.luau` (client) — prompt panel with slot buttons + cooldown countdown
20. ✅ ProximityPrompts added to all 6 RootSpots in Studio
21. ✅ SporeLoop modified to call `TendingManager.getBoostMult(player, id)` per species

### Phase 6 — Pets (Mole + Cricket) ✅ DONE
22. ✅ `PetManager.luau` — pet ownership (owned/active), addPet, setActive (max 2)
23. ✅ `PetLoop.server.luau` — cricket spawn loop, SetActivePets remote, PetState sync on join
24. ✅ `PetDenUI.luau` (client) — grid of owned pets, 2 active slots, toggle active via tap
25. ✅ MoleFishing modified — 8% depth-3 catch chance before regular loot
26. ✅ CricketRock parts added in Studio (3 positions in PersonalCaveExtras)

### Phase 7 — The Deep Content (framework) ✅ DONE
27. ✅ `MobManager.luau` — spawnMob, damageMob, getMob, getActiveMobCount; mob Parts in TheDeep
28. ✅ `MobLoop.server.luau` — 3 initial mobs on start, replenish every 45s up to max 6
29. ✅ 4 MobSpawn_ markers added to TheDeep in Studio

### Phase 8 — Combat + Spore Debt ✅ DONE
30. ✅ `DeathManager.luau` — onPlayerDied (teleport Hub, add debt), applyDebtPenalty (15% per harvest)
31. ✅ `CombatManager.luau` — playerAttack (range/cooldown validated), mobAttack (triggers death)
32. ✅ `CombatLoop.server.luau` — boots CombatManager + wires PlayerAttack remote
33. ✅ SporeLoop calls `DeathManager.applyDebtPenalty` on every earned tick
34. ✅ HP bar added to HUD (red bar, HP: X/Y label)
35. ✅ HPUpdate remote wired in GameClient

### Phase 9 — Mycology Vat ✅ DONE
36. ✅ `VatManager.luau` — canBrew, brew (consumes ingredients), usePotion, getProductionMult (spore_surge)
37. ✅ `VatLoop.server.luau` — BrewPotion / UsePotion remotes, VatState sync on join
38. ✅ `VatUI.luau` (client) — recipe list with ingredient counts, brew button, potions inventory with Use
39. ✅ SporeOrbManager grants 1 ingredient per orb collected (speciesId key)
40. ✅ SporeLoop calls `VatManager.getProductionMult` in final mult chain
41. ✅ 6 recipes + 6 potion effects in Config

### Phase 10 — Mushroom Journal ✅ DONE
42. ✅ `JournalManager.luau` — discover(player, speciesId), milestone rewards, syncPlayer
43. ✅ `JournalLoop.server.luau` — syncs journal on join
44. ✅ `JournalUI.luau` (client) — 5×7 grid (35 species), discovered=color, undiscovered=silhouette, milestone bar
45. ✅ PurchaseHandler wired: unlock → JournalManager.discover
46. ✅ MoleFishing wired: fragment auto-unlock → JournalManager.discover
47. ✅ PortalManager updated: Water Grotto gate = 20 journal species + Deepblood potion

### Phase 11 — Polish & Balance ✅ DONE
48. ✅ Prestige requirements lowered (5e8/5e9/5e10/5e11 vs old 1e9/1e10/1e11/1e12)
49. ✅ Cave event frequency tightened (8–12 min vs old 10–15 min)
50. ✅ ShowPortalMessage now shows toast notification in GameClient (red banner, 3s fade)
51. ✅ Nav bar updated with PETS / VAT / JOURNAL buttons
52. ✅ Monetization config stubs in Config.luau (SUBSCRIPTION_VIP_ID=0, GAME_PASS_2X_ID=0, etc.)

### Phase 12 — Update Content (post-launch)
- Bat expansion (new bat variants, bat-specific combat moves)
- Crystal Caverns (portal in Water Grotto, new zone)
- New mushroom species batches (target 350+ total)
- Grand Vat new cooperative recipes
- Seasonal events

---

## ✅ THIS SESSION — Phase 3 (Cave Events) + Phase 4 (Mole Fishing) complete (May 16, session 3)

### What was done

**Phase 3 — Cave Events (replaces old weather system):**
- `Config.luau`: replaced `WEATHER_*` constants with `CAVE_EVENT_MIN_INTERVAL=600`, `CAVE_EVENT_MAX_INTERVAL=900`, `CAVE_EVENT_DURATION=180`, `CAVE_EVENTS=[Surge/Spring/Bloom]`, `BLOOM_MUTATION_WEIGHT_MULT=3`; `MUTATION_TRIGGER_EVENTS` updated to `{"Bioluminescent Bloom"}` only
- `WeatherState.luau`: rewritten — new fields `currentEvent` (string), `surgeActive` (bool), kept `current` with `affectsTiers={}` for backward compat with SporeOrbManager
- `SporeLoop.server.luau`: full rewrite — removed per-species weather production bonus; 3 cave events with weighted random selection; Surge sets `surgeActive`, Spring fires `CaveEventActive` to clients, Bloom triggers mutations with 3× weight at end; fires `onCaveEvent` analytics
- `SporeOrbManager.luau`: guarded `affectsTiers` nil check; reads `WeatherState.surgeActive` to allow 2 orbs/species during Surge
- `HUD.luau`: cave event banner shows event name in Surge=amber / Spring=cyan / Bloom=purple
- `AnalyticsManager.luau`: `onWeatherEvent` → `onCaveEvent`
- `GameInit.server.luau`: added `CaveEventActive`, `FishingBite`, `FishingResult`, `LootGranted` remotes (26 total)
- `GameClient.client.luau`: wires `CaveEventActive` → cyan Highlight on MoleHole_1/2/3; clears on `WeatherChanged(nil)`

**Phase 4 — Mole Fishing (signature mechanic):**
- `DataManager.luau`: added `fragments = {}` + `catalysts = 0` to Reconcile defaults
- `MoleFishing.server.luau` (new): ProximityPrompt triggers → bite timer (halved during Spring) → FishingBite fires → FishingResult validated (15s timeout) → rollLoot by depth (1=spores, 2=fragment, 3=catalyst or Epic/Mythic fragment); 1 player/hole lock; auto-unlock at 10 fragments
- `FishingUI.client.luau` (new): Stardew-style reel — needle physics (random walk, speed grows), hold REEL or E to push toward center, 25% green zone, win = 2s in zone, lose = 12s timeout; loot popup on LootGranted
- Studio: ProximityPrompts added to MoleHole_1/2/3 (E key, `Cast Lure`, depth label); removed from decorative Ring parts

**Playtest result:** ✅ Clean — 26 remotes, ProfileStore, Analytics, all new modules no errors

### Known gaps / next priorities
- MoleHole highlight (Spring): workspace:GetDescendants scan works but client needs to be in cave zone — fine for now since cave is instanced
- Event mob spawning (spore beetles during Bloom, cave leeches during Spring) deferred to Phase 8 (Combat)
- Rotating Rare Vendor during Surge — deferred to Phase 11 (Polish)
- GameClient RunContext warning still appears (harmless, previously suppressed — Rojo may reset it on re-sync)

---

## ✅ THIS SESSION — Phase 0 + Phase 1 + Phase 2 complete (May 16, session 2)

### What was done
- **Phase 0**: Confirmed playtest clean. All fixes synced. Player spawns in Hub at (0,4,408). ProfileStore + Analytics firing. 22 remotes. 6 mushrooms + 6 orbs. Zero errors.
- **Phase 1**: Built all three world zones entirely via MCP execute_luau:
  - **Hub Cavern** at z=400: shell + amber lighting + HubSpawn + Merchant/GrandVat placeholders + Leaderboard Wall (SurfaceGui) + Cave Portal (green, `PortalType=PersonalCave`) + Deep Portal (purple locked, `PortalType=TheDeep`) + Mushroom Ring (8 mushrooms + 4 seats + Spore Fountain)
  - **Personal Cave extras**: Pet Den (platform, 2 beds, lantern post), Personal Mycology Vat (cylinder), Tunnel arch + 3 MoleHole_N parts (depth 1–3, ZoneType attribute), Hub Return Portal (east wall, `PortalType=Hub`)
  - **The Deep** at z=-400: Central Spine (130 studs, purple glow), Bat Colony (left, 50×60 chamber, roost stalactites, bat spawn marker), Crystal Formation (center, 8 cyan crystal pillars, MythicNode marker), Glowworm Ceiling (right, 20 hanging glowworm dots), Water Grotto (far back, glass water surface, 5-bar locked gate, `ZoneType=WaterGrottoGate`)
- **Phase 2**: Full portal + spawn system:
  - `PortalManager.server.luau` (new file) — touch detection, cooldowns, gate checks, ZoneChanged broadcast
  - `DataManager.luau` — added `totalMushroomsGrown` field
  - `GameInit.server.luau` — added `ShowPortalMessage` + `ZoneChanged` remotes (22 total)
  - `PurchaseHandler.server.luau` — increments `totalMushroomsGrown` on unlock
  - `MushroomPlacer.server.luau` — syncs `totalMushroomsGrown` on session start
  - SpawnLocation moved to Hub (z=410)

### Coordinate layout (for future work)
| Zone | Center Position |
|---|---|
| Personal Cave (template) | (0, 0, 0) |
| Hub Cavern | (0, 0, 400) |
| The Deep | (0, 0, -400) |

### Known gaps / next priorities
- **Personal cave instancing**: All players share Plot_1 at origin. True per-player cloning needed (allocate x=0, 300, 600… per player and clone CaveEnvironment+Extras). PortalManager.caveSpawnFor() already uses plot position — just need more plots.
- **Studio geometry backup**: `scripts/rebuild_world.luau` — 428-line Luau script that recreates Hub (72 parts), TheDeep (117 parts), PersonalCaveExtras (28 parts), CaveEnvironment (70 parts), and Plot_1 (6 RootSpots) from scratch. If Studio is lost, paste this into a Studio execute_luau call to rebuild. MushroomModels are backed up separately via `scripts/asset_ids.json` (re-insert via MCP `insert_asset`). **Best option: Ctrl+S in Studio saves everything to Roblox cloud and avoids needing the script.**
- **Cave event system**: SporeLoop still uses old weather events. Replace with Mycelium Surge/Underground Spring/Bioluminescent Bloom (Phase 3).
- **Mole Fishing**: Tunnel opening and 3 MoleHole_N markers exist in Studio, no gameplay yet.
- **ShowPortalMessage client handler**: Remote fires but no client UI shows the message yet.

---

## Prompt for next session (copy exactly)

```
Read CLAUDE.md, HANDOFF.md, and GAME_DESIGN.md in full before doing anything.

Project: FunGuy — Roblox cozy mushroom cave game.

VERIFIED STUDIO STATE (confirmed May 16, 2026):
- Phase 0 (playtest): ✅ clean — ProfileStore, Analytics, 6 mushrooms + orbs, 22 remotes at runtime
- Phase 1 (world build): ✅ in Studio — Hub (z=400), PersonalCaveExtras (origin), TheDeep (z=-400)
- Phase 2 (portal system): ✅ in Studio — PortalManager, 6 RootSpots + RootGlows, SpawnLocation at (0,0,410)

MCP SERVER: use mcp__Roblox_Studio__* (uppercase, boshyxd server port 58741).
ALWAYS call list_roblox_studios → set_active_studio FIRST before any other MCP call.
Do NOT use mcp__robloxstudio__* (lowercase) — those tools time out.

COORDINATE LAYOUT:
- Personal Cave template: (0, 0, 0) — CaveEnvironment + Plot_1 (6 RootSpots) + PersonalCaveExtras
- Hub Cavern: (0, 0, 400) — Hub folder
- The Deep: (0, 0, -400) — TheDeep folder

OUTSTANDING KNOWN GAPS (aware but not blocking):
- ShowPortalMessage remote fires from PortalManager but no client UI renders the message yet
- Personal cave instancing not done — all players share Plot_1 at origin, deferred

---

PHASE 3 — CAVE EVENTS (replaces old weather system)

Goal: swap SporeLoop's weather system for 3 cave-native events that fire randomly every
10–15 min, last 3 min each, and reward different playstyles.

1. Rewrite SporeLoop.server.luau:
   - Remove existing weather logic (keep the tick structure)
   - Add 3 events: Mycelium Surge, Underground Spring, Bioluminescent Bloom
   - Random selection each cycle, 10–15 min between events, 3 min active duration
   - Reuse WeatherChanged remote — same client pattern, just new event names

2. Per-event server effects:
   - Surge: call SporeOrbManager with 2× orb spawn rate for the duration
   - Spring: fire a new CaveEventActive remote to client (client highlights MoleHole parts);
     also halve bite timer in MoleFishing when Spring is active (check WeatherState)
   - Bloom: multiply mutation roll weight by 3× for the duration (already in SporeLoop)

3. Update WeatherState.luau: store currentEvent name instead of weather name

4. Update HUD.luau (client): rename "weather banner" → cave event banner;
   map event names to colors (Surge=amber, Spring=cyan, Bloom=purple)

5. Update AnalyticsManager: rename onWeatherEvent → onCaveEvent, update callers in SporeLoop

---

PHASE 4 — MOLE FISHING (signature mechanic)

Goal: player presses E at a MoleHole → waits for a bite → Stardew-style reel mini-game
→ loot granted server-side. Depth of hole = rarity of loot.

Studio setup (do first via execute_luau):
- Add a ProximityPrompt (ActionText="Cast Lure", KeyboardKeyCode=E) as child of each
  MoleHole_1, MoleHole_2, MoleHole_3 in PersonalCaveExtras

Server — MoleFishing.server.luau (new file in src/Server/):
- On ProximityPrompt.Triggered: lock hole (one player at a time), start bite timer (3–8s random)
- Fire FishingBite remote to that player when timer expires
- Listen for FishingResult remote from client (pass=true/false + timestamp)
- Validate: result must arrive within 15s of FishingBite fire (anti-exploit)
- On pass: roll loot by hole depth attribute:
    depth=1 → spores (500–2000)
    depth=2 → species fragment (partial unlock token, stored in data.fragments[speciesId])
    depth=3 → rare mole drop: 70% mutation catalyst, 30% species fragment for a locked Epic/Mythic
- Grant loot via DataManager, fire UpdateSpores or new LootGranted remote to client
- Spring event active (read WeatherState.currentEvent): halve bite timer
- Unlock hole after result received or 15s timeout

Client — UI/FishingUI.client.luau (new file in src/Client/UI/):
- On FishingBite received: show reel mini-game UI full-screen
- Needle drifts left/right (random walk, speed increases over time)
- Player holds/releases ScreenGui button (or E key) to push needle toward center
- Green zone in center — hold needle there for 2 continuous seconds to win
- On win: fire FishingResult(true). On 12s timeout: fire FishingResult(false), hide UI
- Show loot popup on LootGranted (or UpdateSpores) received

Remotes to add in GameInit.server.luau (22 → 24 total):
- FishingBite (server→client, fires when mole bites)
- FishingResult (client→server, player sends pass/fail)

Data schema — add to DataManager.luau Reconcile defaults:
- fragments = {} (table of speciesId → fragment count; N fragments = unlock)
- catalysts = 0 (mutation catalyst count)

Work autonomously. Use mcp__Roblox_Studio__execute_luau for all Studio mutations.
Complete Phase 3 fully before starting Phase 4. Playtest after each phase.
```

---

## Prompt for next session (copy exactly)

```
Read CLAUDE.md, HANDOFF.md, and GAME_DESIGN.md in full before doing anything.

Project: FunGuy — Roblox cozy mushroom cave game.

VERIFIED STUDIO STATE (confirmed May 16, 2026 — session 3):
- Phase 3 (cave events): ✅ Mycelium Surge / Underground Spring / Bioluminescent Bloom
- Phase 4 (mole fishing): ✅ MoleFishing.server.luau + FishingUI.client.luau, 3 wired MoleHoles
- Remotes: 26 total in Studio at runtime

MCP SERVER: use mcp__Roblox_Studio__* (uppercase, boshyxd server port 58741).
ALWAYS call list_roblox_studios → set_active_studio FIRST before any other MCP call.
Do NOT use mcp__robloxstudio__* (lowercase) — those tools time out.

COORDINATE LAYOUT:
- Personal Cave template: (0, 0, 0) — CaveEnvironment + Plot_1 (6 RootSpots) + PersonalCaveExtras
- Hub Cavern: (0, 0, 400) — Hub folder
- The Deep: (0, 0, -400) — TheDeep folder

---

PHASE 5 — MYCELIUM TENDING

Goal: player presses E at each RootSpot → chooses Water / Nutrients / Pollinate → 
slot refills every 10–15 min. Active tending all 6 plots ≈ 2.5× passive baseline.

Server — TendingManager.luau (new module in src/Server/):
- Track 3 slots per RootSpot per player: { water, nutrients, pollinate } with cooldown timestamps
- On TendSlot remote (client→server): validate slot available + player near plot → apply bonus
  - Water: +15% spore rate on that species for duration
  - Nutrients: +10% mutation chance for that species
  - Pollinate: +5% to aura neighbors
- Slot refills after random 600–900s (10–15 min)
- Broadcast slot state to client via TendingState remote

Client — UI/TendingUI.client.luau (new):
- ProximityPrompt (E) at each RootSpot → show radial/list: Water / Nutrients / Pollinate
- Show cooldown countdown per slot
- On selection → fire TendSlot to server

Remotes to add (26 → 28):
- TendSlot (client→server)
- TendingState (server→client: per-plot slot cooldown state)

---

PHASE 6 — PETS (Mole + Cricket first)

Goal: player can catch a Mole via fishing (rare depth-3 drop), catch a Cricket
in the cave, see both in a Pet Den area. Choose 2 active pets that follow you.

Server — PetManager.luau (new module in src/Server/):
- petData schema: { owned = {}, active = {} }  — add to DataManager Reconcile
- Mole catch: 5% chance on depth-3 FishingResult pass (before loot roll in MoleFishing)
- Cricket catch: random spawn under rocks (Part with ZoneType=CricketRock) every 3–5 min
  per player; ProximityPrompt "Catch Cricket" with 10% catch rate
- Pets: { id, variant, hp=100 }; pets never deleted
- Active = max 2; swap is instant; idle pets rest in den

Client — PetDenUI.client.luau (new):
- Show all owned pets in den (grid); highlight 2 active slots
- Tap a pet card → set active (fires SetActivePets remote)

Remotes to add (28 → 31):
- PetCaught (server→client)
- SetActivePets (client→server)
- PetState (server→client: full pet inventory sync)

Work autonomously. Complete Phase 5 fully before starting Phase 6. Playtest after each phase.
```

---

## ✅ THIS SESSION — Phases 5–11 complete (May 16, 2026 — session 4)

### What was done
All 7 remaining phases implemented, playtested (39 remotes verified, 3 mobs active, all UIs in PlayerGui).

**New server files:**
- `TendingManager.luau` + `TendingLoop.server.luau` — tending system (3 slots × 10 min cooldown)
- `PetManager.luau` + `PetLoop.server.luau` — pet ownership + cricket spawning
- `MobManager.luau` + `MobLoop.server.luau` — mob spawning framework in TheDeep
- `DeathManager.luau` — spore debt + death teleport
- `CombatManager.luau` + `CombatLoop.server.luau` — player attack + mob attack
- `VatManager.luau` + `VatLoop.server.luau` — brew potions, usePotion, production mult
- `JournalManager.luau` + `JournalLoop.server.luau` — species discovery + milestones

**New client files:**
- `Client/UI/TendingUI.luau` — tending slot panel triggered by RootSpot ProximityPrompts
- `Client/UI/PetDenUI.luau` — pet grid with active slot toggle
- `Client/UI/VatUI.luau` — recipe browser + potions inventory
- `Client/UI/JournalUI.luau` — 5×7 species grid (discovered / silhouette)

**Modified:**
- `DataManager.luau` — 11 new schema fields (tendingBonuses, pets, mobKills, sporeDebt, playerHP, maxPlayerHP, ingredients, brews, journal, deepUnlocked)
- `Config.luau` — Phase 5–11 constants + balance pass (lower prestige reqs, tighter cave events)
- `SporeLoop.server.luau` — integrates TendingManager, DeathManager, VatManager mults
- `SporeOrbManager.luau` — grants 1 ingredient on orb collect
- `GameInit.server.luau` — 39 total remotes (was 26)
- `PurchaseHandler.server.luau` — calls JournalManager.discover on species unlock
- `MoleFishing.server.luau` — mole pet catch (8%), JournalManager.discover on fragment unlock
- `PortalManager.server.luau` — Water Grotto gate now checks journal (20 species) + brews (deepblood)
- `HUD.luau` — HP bar (red, HP: X/Y)
- `GameClient.client.luau` — HPUpdate listener, ShowPortalMessage toast, 3 new nav buttons (PETS/VAT/JOURNAL)

**Studio changes via execute_luau:**
- ProximityPrompts added to RootSpot_1..6 (Tend action)
- CricketRock_1..3 added to PersonalCaveExtras
- MobSpawn_1..4 added to TheDeep

**Playtest result:** ✅ Clean — 39 remotes, 3 mobs in TheDeep, all 4 new UIs in PlayerGui, no new errors

### Bug fix — LocalScript placement (session 5)
`FishingUI.client.luau` and `SporeOrbEffects.client.luau` were in `src/Client/UI/` and `src/Client/` respectively — both map to `ReplicatedStorage.Client` where LocalScripts never auto-run. Moved both to `src/StarterPlayerScripts/` where they execute correctly on join. No code changes, only path.

---

## Last Audit — May 16, 2026 (session 5)

Rigorous 10-target audit of the full codebase. All issues fixed. Results below.

| # | Target | Result | Action |
|---|--------|--------|--------|
| 1 | **Remote Event integrity** | ✅ PASS | All 39 remotes in GameInit match every server/client reference. No missing or extra remotes. |
| 2 | **LocalScript placement** | ❌ FIXED | FishingUI and SporeOrbEffects existed as wrong-type `Script` in stale `ReplicatedStorage.Client` subfolders. Deleted old instances, created correct `LocalScript` instances in `StarterPlayerScripts` with `RunContext=Legacy` via execute_luau. Created `.meta.json` files for all 3 StarterPlayerScripts to lock RunContext=Legacy across Rojo syncs. |
| 3 | **DataStore safety** | ✅ PASS | ProfileStore handles all persistence with session-locking. No raw DataStore calls anywhere. BindToClose guard present in DataManager. |
| 4 | **Server/client trust** | ❌ FIXED | `MoleFishing.server.luau`: FishingResult handler accepted any truthy value and had no minimum time guard. Client could send `passed=true` immediately after FishingBite to bypass the mini-game. Fixed: added `type(passed) ~= "boolean"` reject at top; added `elapsed < 2` guard (client must spend ≥2s in green zone before a win counts). |
| 5 | **SporeLoop multiplier chain** | ✅ PASS | Chain verified: `total * prodMult * prestigeMult * pulseMult * vipMult * passMult * vatMult`, then `DeathManager.applyDebtPenalty` applied after. TendingManager.getBoostMult called per-species. VatManager.getProductionMult is vatMult. All paths correct. |
| 6 | **Rojo sync correctness** | ❌ FIXED | Studio had FishingUI as `Script` in `Client.UI` and SporeOrbEffects as `Script` in `Client` — both never ran. Root cause: disk files moved to StarterPlayerScripts in session 5 but Rojo wasn't connected at that point. Fixed via execute_luau (delete stale, create correct). Also fixed stale `Client.Runtime` Script (old session-0 stub). |
| 7 | **Missing pcalls / unguarded yields** | ❌ FIXED | `TendingLoop.server.luau` and `VatLoop.server.luau`: PlayerAdded handlers called `task.wait(3)` directly on the event thread without `task.spawn`. Fixed both to wrap in `task.spawn(function() ... end)`. |
| 8 | **Dead code / orphaned modules** | ❌ FIXED | `GameEventsBroadcast.luau` was a dead module — never `require()`d by any script, so `MessagingService:SubscribeAsync` was never called and cross-server pub/sub never activated. Fixed: added `require(script.Parent.GameEventsBroadcast)` to `AnalyticsLoop.server.luau` (boots early, name starts 'A', guaranteed before PurchaseHandler). |
| 9 | **Config completeness** | ✅ PASS | All constants referenced by server modules (`MOLE_CATCH_CHANCE`, `FRAGMENTS_TO_UNLOCK`, `SPECIES_BY_ID`, `CAVE_EVENT_*`, weapon configs, vat recipes, journal milestones, VIP IDs) confirmed present. `MOB_AGGRO_RADIUS` defined but unused — CombatManager uses `weaponCfg.range` instead. Minor orphaned constant, not dangerous. |
| 10 | **MCP live console errors** | ✅ PASS | Two stale errors investigated: `MobManager:117 "Expected identifier"` and `GameClient:58 "require invalid argument"`. Both confirmed historical (old playtest artifacts, not current Studio state). Current disk files match Studio exactly. GameClient RunContext double-run warning resolved by meta.json (Enum 0 = Legacy). |

### Files changed in this audit
| File | Change |
|---|---|
| `src/Server/MoleFishing.server.luau` | Added boolean type-check + 2s elapsed guard on FishingResult handler |
| `src/Server/TendingLoop.server.luau` | Wrapped PlayerAdded body in `task.spawn` |
| `src/Server/VatLoop.server.luau` | Wrapped PlayerAdded body in `task.spawn` |
| `src/Server/AnalyticsLoop.server.luau` | Added `require(script.Parent.GameEventsBroadcast)` to activate MessagingService pub/sub |
| `src/StarterPlayerScripts/GameClient.client.meta.json` | Created — locks RunContext=Legacy (Enum 0) on Rojo sync |
| `src/StarterPlayerScripts/FishingUI.client.meta.json` | Created — locks RunContext=Legacy (Enum 0) on Rojo sync |
| `src/StarterPlayerScripts/SporeOrbEffects.client.meta.json` | Created — locks RunContext=Legacy (Enum 0) on Rojo sync |
| Studio only | Deleted stale `Client.UI.FishingUI` Script + `Client.SporeOrbEffects` Script + `Client.Runtime` Script; created FishingUI + SporeOrbEffects as correct LocalScripts in StarterPlayerScripts |

### Outstanding (low priority, not blocking MVP)
- `ZoneChanged` remote fires from PortalManager on every zone change but GameClient has no `OnClientEvent` handler. Remote is unused client-side — add a handler if zone-specific UI is ever needed.
- Personal cave instancing still deferred (all players share Plot_1 at origin).

---

---

## ✅ THIS SESSION — Sound system + Weapons (May 16, 2026 — session 6)

### Sound system — SoundClient.client.luau (new)
Full client-side audio via `MobSound` RemoteEvent (server→all clients: mobType, soundType, position).

- **Cave ambient**: always-on loop (ID 4764746601)
- **Event loops**: Mycelium Surge (warden heartbeat), Underground Spring (cave water flow), Bioluminescent Bloom (fairy magic shimmer) — start/stop on `WeatherChanged`
- **Mob sounds** (5 mobs × 4 events = 20 unique audio cues):
  - Each of spawn/attack/hit/death has its own Roblox audio ID + pitch multiplier
  - `playSpatial()` — temporary Part at mob position with `RollOffMaxDistance=80`, auto-destroys after playback
  - `play2D()` — parented to `SoundService`, auto-destroys after playback
- **Player feedback**: `HPUpdate` fires hurt sound when `hp < lastHP`, death sound when `hp ≤ 0`
- `SoundClient.client.meta.json` — RunContext=Legacy lock

Also added `MobSound:FireAllClients(mobTypeId, "attack", mobPart.Position)` to `CombatManager.mobAttack` so mob attacks emit sound.

### Weapons — CombatClient.client.luau (new) + CombatManager edits

**DataManager**: added `weapons = { "truffle_trowel", "spore_launcher" }` + `equippedWeapon = "truffle_trowel"` to PROFILE_TEMPLATE. All players start with both weapons via `profile:Reconcile()`.

**Config**: fixed `flyagaric_flask` cooldown `0.0 → 3.0` (was infinitely spammable).

**CombatManager** — two additions:
1. Server-side ownership check — rejects attacks from weapons not in `data.weapons`
2. `applyDot()` — token-based DOT loop (prevents double-ticking on refresh); fires for `isDot=true` weapons; clears DOT entry when mob killed by initial hit or DOT tick

**CombatClient.client.luau** — weapon hotbar at bottom-center of screen:
- 2 slots (Trowel / Spore Gun), press 1/2 or click to switch
- Mouse.Button1Down → checks `Target:GetAttribute("MobId")` → fires `PlayerAttack:FireServer(weaponId, mobId)`
- White flash on hit part as visual feedback
- 0.3s client-side spam gate (server is authoritative)
- `CombatClient.client.meta.json` — RunContext=Legacy lock

**Weapon balance vs. mob HP:**

| Weapon | DPS | Kills cave_beetle (60 HP) | Kills shadow_spore (40 HP) |
|---|---|---|---|
| Truffle Trowel (melee, r=8) | 31 | 3 hits / 2.4s | 2 hits / 1.6s |
| Spore Launcher (ranged, r=30) | 37 | 4 hits / 1.6s | 3 hits / 1.2s |
| Flyagaric Flask (DOT, r=15) | ~6 sustained | 4+ casts / 12s | 3 casts / 6s |

Flask is intentionally slow DPS — apply-poison-then-dodge utility weapon. Earned via Vat (pipeline not yet wired).

### Files changed this session
| File | Change |
|---|---|
| `src/StarterPlayerScripts/SoundClient.client.luau` | New — full audio system |
| `src/StarterPlayerScripts/SoundClient.client.meta.json` | New — RunContext=Legacy |
| `src/StarterPlayerScripts/CombatClient.client.luau` | New — weapon hotbar + attack input |
| `src/StarterPlayerScripts/CombatClient.client.meta.json` | New — RunContext=Legacy |
| `src/Server/CombatManager.luau` | Added ownership check + DOT system |
| `src/Server/DataManager.luau` | Added `weapons` + `equippedWeapon` fields |
| `src/Common/Config.luau` | Fixed flyagaric_flask cooldown; prestige 1 req 500M→50M; Lighting scaling 2.0→1.6 |
| `src/Server/GameInit.server.luau` | Added `MobSound` remote (40 total) |

### Balance fixes applied
Two critical balance errors found and fixed by calculating the full progression timeline from Config numbers:

| Fix | Old | New | Why |
|---|---|---|---|
| Prestige 1 requirement | 500M lifetime spores (~22–25h) | 50M lifetime spores (~4–5h) | Config comment claimed "3–4h active" — actual math showed it was off by 10×. All 4 prestige thresholds shifted down one order of magnitude. |
| Lighting upgrade scaling | 2.0× per level | 1.6× per level | At 2.0×, max Lighting cost was 524M spores (unreachable). At 1.6×, max cost is ~40M — expensive but achievable late-game. |

**Progression timeline post-fix (no passes, active play):**
- 0–7 min: all Commons → 40/s
- 7–15 min: all Uncommons → 149/s
- 15–58 min: all Rares → 644/s
- 1–3.5 hr: all Epics → 1,734/s base
- ~4–5 hr: Prestige 1 (with tending + cave events)
- Post-prestige: Mythics unlockable, 2× multiplier kicks in

**Tier payback ratios (balanced):** Common 1.7min → Uncommon 6.4min → Rare 26min → Epic 1.5hr → Mythic 15hr (post-prestige). Each tier ~4–6× longer than the last — correct curve for the genre.

### Post-launch feature noted: Pet Cosmetics Store
Pet hats/accessories (pure cosmetic, no gameplay effect) flagged as high-value post-launch monetization. Requires player volume before cosmetics sell. Implementation: `Accessory` objects parented to pet Parts. Add to Creator Dashboard as Developer Products once playerbase exists.

---

## Completion plan — what's left before publish

### Can be done in code only (next Claude session)
| Task | Effort |
|---|---|
| Deep zone music (position-based, 5 zones, IDs already researched) | ~1h |
| Vat sound effects (brew start/complete/use — IDs found) | ~30min |
| Flyagaric Flask acquisition path (Vat recipe or kill-count gate) | ~30min |
| `ZoneChanged` client handler (already fires, never consumed) | ~15min |

### Needs Studio open + Rojo connected
| Task | How |
|---|---|
| Import 36 `_reduced.fbx` mushroom models into `ReplicatedStorage > MushroomModels` | MCP `insert_asset` from `scripts/asset_ids.json` |
| Verify world geometry still correct (Hub, Cave, Deep) | MCP `capture_screenshot` or quick playtest |
| Add ProximityPrompt labels + weapon pickup points in TheDeep | MCP `execute_luau` |

### Needs you (creator dashboard actions)
| Task | Where |
|---|---|
| Create VIP subscription product → paste ID into `Config.SUBSCRIPTION_VIP_ID` | creator.roblox.com → Monetization |
| Create 2× Production game pass → paste ID into `Config.GAME_PASS_2X_ID` | creator.roblox.com → Monetization |
| Add game thumbnail + icon + description | creator.roblox.com → Places |
| Set place to Public, set max players (recommend 20–30) | creator.roblox.com → Places |
| Publish | Studio → File → Publish to Roblox |

### Deferred (post-launch, not blocking)
- Personal cave instancing (all players still share Plot_1 at origin)
- Trading system
- Seasonal events
- Balance pass (needs real player data)

---

## Prompt for next session

```
Read CLAUDE.md, HANDOFF.md, and GAME_DESIGN.md in full before doing anything.

Project: FunGuy — Roblox cozy mushroom cave game.

CODEBASE STATE (May 16, 2026 — session 6):
- Phases 0–11: ✅ complete on disk
- Sound system: ✅ SoundClient.client.luau — 5 mobs × 4 sounds, cave ambient, event loops, player feedback
- Weapons: ✅ CombatClient.client.luau — 2-slot hotbar (trowel/spore gun), click-to-attack, DOT system in CombatManager
- 40 RemoteEvents total (MobSound added)
- DataManager: weapons + equippedWeapon fields added

STUDIO STATE (last confirmed session 4 — verify at session start):
- Hub at (0,0,400), PersonalCaveExtras at origin, TheDeep at (0,0,-400)
- 6 RootSpots in Plot_1, ProximityPrompts on each
- 3 MobSpawn markers in TheDeep, 3 CricketRocks in PersonalCaveExtras
- MushroomModels: 36 models structured (Root+Cap+GlowLight)
- ⚠️ Mushroom FBXs at assets/mushrooms/ — 36 _reduced.fbx files ready but NOT confirmed inserted

MCP SERVER: use mcp__Roblox_Studio__* (uppercase, boshyxd server port 58741).
ALWAYS call list_roblox_studios → set_active_studio FIRST before any other MCP call.
Do NOT use mcp__robloxstudio__* (lowercase) — those tools time out.

PRIORITY ORDER FOR THIS SESSION:

1. VERIFY STUDIO — capture_screenshot or quick playtest to confirm world geometry intact

2. CODE-ONLY tasks (no Studio needed):
   a. Deep zone music — position-based zone detection, 5 music loops for The Deep sub-zones
      IDs already researched: Central Spine=139743346356072, Bat Colony=9112775175,
      Crystal Formation=1842660840, Glowworm Ceiling=9046865270, Water Grotto=76563295380575
   b. Vat sounds — brew start (7322736504), brew complete (9126073011), use potion (1481574895)
      Wire into VatUI.luau brew/use button callbacks via SoundManager or play2D
   c. ZoneChanged client handler — PortalManager fires it but GameClient never consumes it
      Needed for zone music to know which Deep sub-zone player is in

3. STUDIO tasks (if MCP connected):
   a. Confirm MushroomModels are in Studio — if missing, insert from scripts/asset_ids.json
   b. Run full playtest — verify 40 remotes, mobs, sounds, weapons all work together

4. STUDIO — Run `scripts/create_myco_npc.luau` once in Studio Command Bar to place Myco the Merchant NPC in workspace.Hub. Verify it appears at (0, 5, 388) relative to Hub origin. NPCShopClient will auto-wire to it.

5. AWAITING USER: monetization IDs — cannot proceed to publish without:
   - Config.SUBSCRIPTION_VIP_ID (create VIP subscription in Creator Dashboard)
   - Config.GAME_PASS_2X_ID (create 2× Production game pass)
```

---

## ✅ THIS SESSION — Myco the Merchant NPC (May 16, 2026 — session 7)

### What was done

**Architecture:** BindableEvent pattern — NPC client fires `ReplicatedStorage.Bindables.OpenShop`, GameClient listens. No server involvement needed. Same result as tapping the HUD shop button.

**GameInit.server.luau** — Bindables folder + `OpenShop` BindableEvent added. 40 RemoteEvents unchanged.

**GameClient.client.luau** — Added `OpenShop` listener after `shopBtn.Activated`:
```lua
Bindables:WaitForChild("OpenShop").Event:Connect(function()
    merchant.hide(); quests.hide()
    SoundManager.panelOpen(); shop.show()
    TutorialManager.onShopOpened()
end)
```

**NPCShopClient.client.luau** (new LocalScript):
- Waits for `workspace.Hub.MycoNPC` on join
- `RunService.Heartbeat` proximity check (20 stud radius) — enables/disables BillboardGui speech bubble
- 8 idle lines rotate every 9s when player is within range (`lineTimer += dt`)
- `lineTimer = -4` trick to hold a greeting 4 extra seconds before idle resumes
- `ProximityPrompt.Triggered` → picks a random greeting line + fires `OpenShop:Fire()`

**NPCShopClient.client.meta.json** (new) — RunContext=Legacy lock

**scripts/create_myco_npc.luau** (new — paste into Studio Command Bar once):
- Re-runnable: destroys any existing `Hub.MycoNPC` first
- Creates `MycoNPC` Model with: Stem (cylinder, cream), Cap (Ball, Neon violet + PointLight), EyeL/EyeR (Ball, Neon amber + PointLight)
- `Cap` is PrimaryPart (all 3 client scripts reference it)
- `ShopPrompt` ProximityPrompt on Cap (E key, "Browse", 10 stud activation distance)
- `SpeechBillboard` BillboardGui on Cap (240×60px, dark purple panel, GothamMedium TextLabel)
- Position: `Hub.PrimaryPart.CFrame * CFrame.new(0, 5, -12)` — adjustable via `HUB_OFFSET`

### Files changed
| File | Change |
|---|---|
| `src/StarterPlayerScripts/NPCShopClient.client.luau` | New — proximity NPC client |
| `src/StarterPlayerScripts/NPCShopClient.client.meta.json` | New — RunContext=Legacy |
| `src/StarterPlayerScripts/GameClient.client.luau` | Added OpenShop BindableEvent listener |
| `src/Server/GameInit.server.luau` | Added Bindables folder + OpenShop BindableEvent |
| `scripts/create_myco_npc.luau` | New — one-time Studio creation script |

### Studio action required (user or next session with MCP)
Run `scripts/create_myco_npc.luau` once in Studio:
1. Open Studio → Command Bar (View → Command Bar)
2. Paste the full contents of `scripts/create_myco_npc.luau` and press Enter
3. Confirm `✓ MycoNPC created at ...` prints in Output
4. If Hub has no PrimaryPart set, NPC spawns at world origin + offset — set Hub PrimaryPart first or adjust `HUB_OFFSET` in the script to absolute position

### NPC dialogue lines
8 idle lines (rotate every 9s on proximity):
- "The mycelium whispers of rare finds today..."
- "Ah, the cave provides for those who tend it well."
- "I've seen a thousand species. Each one worth the wait."
- "A fresh Bleeding Tooth came in just this morning."
- "Did you know? Mutations multiply. Patience compounds."
- "The Deep holds secrets even I haven't catalogued yet."
- "Your spores smell particularly fine today, if I may say so."
- "Rare species aren't bought — they're earned. Then bought."

4 greeting lines (random on interact):
- "Welcome, cultivator. What'll it be?"
- "Ah, just the farmer I wanted to see!"
- "Come in, come in. My finest stock awaits."
- "The spores have led you to the right place."

---

## ✅ THIS SESSION — UI polish + mushroom models + audio (session 8, out-of-context)

### Mushroom models inserted into Studio
- All 36 `_reduced.fbx` mushroom models inserted via MCP `insert_asset` from `scripts/asset_ids.json`
- Each model restructured in Studio: renamed mesh to `Cap`, added `Root` PrimaryPart (anchored, 0.2 studs), added `GlowLight` PointLight inside Cap
- **FBX scale bug fixed**: Meshy exports in cm, Roblox reads as studs → models were 100× oversized. Fixed by computing `scale = targetHeight / currentHeight` per tier and resizing Cap. Heights match tier table in this doc.
- Root models (`rootspot_deco`) placed at each RootSpot_1..6 as decorative children

### UI polish
| File | Change |
|---|---|
| `src/Client/UI/ShopUI.luau` | Close button `"✕"` → `"X"` (GothamBold doesn't render ✕ on live platform) |
| `src/Client/UI/MerchantUI.luau` | Close button `"✕"` → `"X"`; removed redundant grey original-price label above green button |
| `src/Client/UI/HUD.luau` | Full redesign: full-width dark bar → compact 210×88px rounded corner card (top-left). Event banner moved to independent top-right position. HP bar moved below rate label with clear gap. |
| `src/Client/UI/VatUI.luau` | Added 3 sound IDs + `playVatSound` helper. Brew button plays `VAT_BREW_START_ID` (7322736504). Use button plays `VAT_USE_POTION_ID` (1481574895). `VatState` handler plays `VAT_BREW_DONE_ID` (9126073011) when brew count increases. |

### Audio — Deep zone music
`src/StarterPlayerScripts/SoundClient.client.luau` extended:
- Added `ZoneChanged` listener to set `inTheDeep` flag; stops zone music on zone exit
- Position poll every 3s while in TheDeep → picks sub-zone track:

| Sub-zone | Trigger | Sound ID |
|---|---|---|
| Water Grotto | z < -540 | 76563295380575 |
| Bat Colony | x < -55 | 9112775175 |
| Glowworm Ceiling | x > 55 | 9046865270 |
| Crystal Formation | z < -460 | 1842660840 |
| Central Spine | default | 139743346356072 |

### Combat — Flask acquisition
`src/Server/CombatManager.luau` — `playerAttack()` now checks `data.mobKills == 10` after a kill. If true and player doesn't have `flyagaric_flask`, inserts it into `data.weapons` and fires `LootGranted` to client. One-time unlock.

### Portal gate — The Deep
`src/Server/PortalManager.server.luau` — removed the 500-mushroom gate on `TheDeep` handler entirely for testing. Gate will be restored to 12 mushrooms before wider launch.

### Bug fix — BillboardGui signs bleeding through walls
Root cause: all `BillboardGui`s had `AlwaysOnTop = true`, causing them to render through any geometry. Fixed in next session (see session 9).

---

## ✅ THIS SESSION — Signs overhaul + mushroom floor roots (session 9, May 16 2026)

### Signs overhaul — BillboardGui → physical SurfaceGui plaques

All 8 `BillboardGui` zone labels removed (they bled through walls due to `AlwaysOnTop`). Replaced with physical sign plaques in a new `Workspace > ZoneSigns` folder.

**Each plaque** = dark Part (6 × 1.6 × 0.25 studs) + `PointLight` + `SurfaceGui` on Front face. Mounted on a thin dark post. Front face faces toward the player's approach direction — naturally occluded by walls (`SurfaceGui` on a Part cannot bleed through geometry).

| Sign | Color | Position | Notes |
|---|---|---|---|
| GRAND VAT | Gold | (18, 7.5, 374) faces hub | — |
| MERCHANT | Green | (-18, 7.5, 374) faces hub | — |
| THE DEEP | Purple | (0, 13, 341) faces hub | Moved from z=337 — was clipping inside `LeaderboardWall` (z=336–338) |
| YOUR CAVE | Cyan | (-62, 9.5, 400) faces east | — |
| PET DEN | Green | (-44, 4, 45) faces east | — |
| MYCOLOGY VAT | Gold | (39, 3.5, -15) faces west | — |
| RETURN TO HUB | Cyan | (69, 8.5, 0) faces west | — |
| WATER GROTTO | Cyan + sub-label | On existing `WaterGrotto_GateSign` BasePart | `SurfaceGui` added to the physical gate sign Part directly |

**Speech bubble** (`SpeechBillboard` on MycoNPC Cap) was left as-is — a floating speech bubble above an NPC is intentional.

**Studio only** — these are Workspace Parts created via `execute_luau`. They exist in Studio's place file and must be saved (Ctrl+S) and published to persist.

### Mushroom anchoring fix
`src/Server/MushroomManager.luau` — `spawnOne()` and `placeOnRootSpot()` now iterate `model:GetDescendants()` after `SetPrimaryPartCFrame` and set `Anchored = true` on every `BasePart`. Previously the Cap mesh was a free rigid body that physics immediately sent tumbling off the spot.

### Mushroom floor roots — RootSpot redesign
`src/Server/MushroomManager.luau` — replaced the rectangular prism pedestal look:

**Before:** Mushroom placed on top of visible `RootSpot_N` pedestal (raised orange block).
**After:**
- `RootSpot.Transparency = 1` + `CanCollide = false` — pedestal is invisible
- Mushroom positioned at floor level: `topY = (rootSpot.Y - rootSpot.Size.Y/2) + root.Size.Y/2`
- `spawnTendrils(rootSpot, color)` spawns 7 flat Neon Parts radiating from the base at floor level. Each tendril: 0.08 studs tall, 0.12–0.5 wide, 1.5–4.5 studs long, random angle with ±0.45 rad jitter. Color = 45% of tier glow color. Material = `Neon` (self-illuminating).
- `clearTendrils(rootSpot)` destroys all `"RootTendril"` children when spot is vacated
- `PointLight RootGlow` inside the RootSpot Part still works (emits through transparent Part) to cast a pool of tier-colored light upward

**New functions added:** `clearTendrils`, `spawnTendrils` (replaces `ROOT_DEFAULT_COLOR` + old `setRootGlow` approach)

### Files changed this session
| File | Change |
|---|---|
| `src/Server/MushroomManager.luau` | Anchoring fix in `spawnOne` + `placeOnRootSpot`; full root spread system replacing pedestal coloring |
| Studio only | Removed 8 BillboardGuis; created `ZoneSigns` folder with 7 sign plaques + posts; added SurfaceGui to `WaterGrotto_GateSign` |

---

## Current known state (session 9 end)

### Studio — requires Ctrl+S + Publish to persist
- `ZoneSigns` folder with 7 sign plaques: created via `execute_luau`, in memory only until saved
- All BillboardGuis removed except `SpeechBillboard` on MycoNPC

### Outstanding before wider launch
| Task | Priority |
|---|---|
| Restore The Deep gate (currently open) — suggest 12 mushrooms | Before launch |
| Onboarding / tutorial for new players (game loop not obvious) | High |
| Personal cave instancing (all players share Plot_1) | High |
| Monetization IDs in Config (SUBSCRIPTION_VIP_ID, GAME_PASS_2X_ID) | Before monetization |
| Balance pass (all numbers untested on real players) | Post-launch |
| Mole fishing mini-game feel (untested since build) | Verify in playtest |
| Grand Vat cooperative recipes (requires 2+ players to test) | Post-launch |

### Prompt for next session

```
Read CLAUDE.md, HANDOFF.md, and GAME_DESIGN.md in full before doing anything.

Project: FunGuy — Roblox cozy mushroom cave game.

CODEBASE STATE (session 9, May 16 2026):
- All Phases 0–11 complete on disk
- Sound: SoundClient has cave ambient, event loops, 5-mob sounds, Deep zone music (5 sub-zones)
- Mushroom models: 36 in Studio (Root+Cap+GlowLight), scaled to tier heights, anchored
- Floor roots: MushroomManager spawns 7 Neon tendrils at floor level per mushroom (no pedestal)
- Signs: ZoneSigns folder (7 physical plaques + posts) replacing all BillboardGuis
- The Deep: gate removed for testing — restore to 12 mushrooms before launch
- 40 RemoteEvents, 1 BindableEvent (OpenShop)

MCP SERVER: use mcp__Roblox_Studio__* (uppercase, boshyxd server port 58741).
ALWAYS call list_roblox_studios → set_active_studio FIRST before any other MCP call.

COORDINATE LAYOUT:
- Personal Cave template: (0, 0, 0)
- Hub Cavern: (0, 0, 400)
- The Deep: (0, 0, -400)

HIGHEST PRIORITY NEXT TASKS:
1. Tutorial / onboarding — new players have no idea what the game is or what to do.
   Minimum viable: a 3-step prompt sequence on first join explaining mushrooms → spores → shop.
   TutorialManager.luau already exists — wire it properly.

2. Personal cave instancing — all players share Plot_1 at origin. Fix: on PlayerAdded,
   clone CaveEnvironment + PersonalCaveExtras to a unique position (x=0, 500, 1000...),
   create a matching Plot_N folder under workspace.Plots with RootSpots offset to that position.
   PortalManager.caveSpawnFor() already uses plot position — just needs more plots.

3. Restore The Deep gate to 12 mushrooms in PortalManager.server.luau.
```

---

## ✅ THIS SESSION — Native mushroom models rebuilt from species descriptions (session 10, May 17 2026)

### What was done

Read `assets/mushrooms/SPECIES_DESCRIPTIONS.md` in full (all 36 species, one paragraph each) and rebuilt `ReplicatedStorage > MushroomModels_Native` from scratch using those appearance descriptions to drive every shape, color, and detail.

**Previous native models** (built session 9 without reading descriptions) were deleted and replaced.

### Shape families used

| Function | Used for |
|---|---|
| `mkStd(id, stemH, stemD, capW, capH, ...)` | Standard stem + domed/ball cap (button, cremini, porcini, morel, kingtrumpet, matsutake, saffronmilk, indigomilk, hedgehog, amethyst, goldenteacher) |
| `mkWide(id, ...)` | Wide flat cap with optional warts + volva egg sac (chanterelle, shiitake, portobello, flyagaric, caesars) |
| `mkCluster(id, n, ...)` | N stems in cluster with small caps (enoki×12, chestnut×7, velvetpiop×5, nameko×9, coralfungus×8, cauliflower×6) |
| `mkShelf(id, layers, ...)` | Stacked overlapping flat fronds (oyster×4, maitake×5, henofwoods×6, lobster×3, chickenwoods×6, ghostfungus×5, biolumpanellus×4, azuredragon×7) |
| `mkPuff(id, r, ...)` | Sphere only, no stem (lionsmane, giantpuffball) |
| `mkFunnel(id, h, ...)` | Narrow base + wide opening (chanterelle, blacktrumpet) |
| Custom inline | bleedingtooth (lumpy puff + red drip Neon spots), violetweb (club-stem + Neon web threads), starfire (dark cap + 8 radiating Neon veins) |

### Key species-specific details from descriptions

| Species | Shape decision | Color |
|---|---|---|
| flyagaric | Wide cap + 6 white wart spots + white volva sac + white annulus ring | Scarlet red cap, white wartsparts |
| caesars | Wide orange-red cap + yellow stem + white egg volva at base | Orange-red cap, yellow stem, white volva |
| bleedingtooth | Lumpy white puff with 4 irregular bumps + 5 crimson Neon drip spheres | White body, crimson Neon drips |
| violetweb | Club-shaped stem base + 4 Neon violet web thread spokes | All-over violet/lilac |
| starfire | Near-black large cap + 8 Neon white-gold radiating veins from center | Near-black cap, gold-white Neon veins |
| lionsmane | Puffball (all white, cool blue-white glow — simulates icicle spine cluster) | White + blue-white glow |
| azuredragon | Shelf×7 layers (sapphire blue, iridescent teal glow — largest mythic) | Deep sapphire blue |
| goldenteacher | Std with wide golden cap + white annulus ring | Golden-caramel cap, white ring |

### Studio state

`ReplicatedStorage > MushroomModels_Native` — 36 models, all with `Root` (PrimaryPart, transparent), `Cap` (Part or Ball), and `GlowLight` (PointLight inside Cap). Structure is compatible with `MushroomManager.luau`'s `FindFirstChild("GlowLight", true)` call.

Three model sets now exist in ReplicatedStorage:
- `MushroomModels` — original Meshy FBX imports (structured Root+Cap+GlowLight)
- `MushroomModels_Meshy` — backup clone of original Meshy set
- `MushroomModels_Native` — Roblox Part primitives, description-accurate (built this session)

**Studio only — requires Ctrl+S to persist.** To swap the active set MushroomManager uses, rename/swap the folder names.

### Tier height enforcement (same session, second pass)

After discovering that parts in ReplicatedStorage lose world position (`pos = -1e6`), the scale-in-place approach failed. Rebuilt the entire folder from scratch a second time using height-derived geometry:

Each shape family parameterised by `T` (target height) with algebraically guaranteed tops:
- `std`: `top = stemH + capH×0.85 = T` (where `cH = (T-sH)/0.85`)
- `wide`: `top = stemH + capH×0.75 = T` (where `cH = (T-sH)/0.75`)
- `cluster`: center stem at `sH=T×0.80`, cap top = `sH + cR×1.35 = T` (where `cR=(T-sH)/1.35`)
- `shelf`: `lH = T/((layers-1)×0.7+0.4)` → top layer top = T
- `puff`: sphere diameter = T → top = T
- `funnel`: cap center at T×0.85, size.Y = T×0.30 → top = T

Verified by reading `Size.Y` from ReplicatedStorage (sizes ARE preserved unlike Position):
- button Common T=1.25: stem=0.52, cap=0.85 → top=1.25 ✓
- chestnut Uncommon T=2.25: center stem=1.80, cR=0.333 → top=2.25 ✓
- flyagaric Rare T=3.25: stem=1.79, cap=1.95 → top=3.25 ✓
- amethyst Epic T=4.25: stem=2.34, cap=2.25 → top=4.25 ✓
- starfire Mythic T=6.0: stem=3.48, cap=2.96 → top=6.0 ✓

### No code files changed this session
