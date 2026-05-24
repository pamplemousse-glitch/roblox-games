-- SoundManager.luau
-- Central audio engine. Require this module from GameClient to start it.
-- Wires all remote-event listeners internally; exposes UI hook methods.
--
-- Audio IDs sourced from Roblox's official licensed catalog (post-2022 privacy
-- update) and the public DevForum free-SFX library. All are free to use.
--
-- SoundGroups let players adjust Music / SFX volume independently in a
-- future settings menu: just change grpMusic.Volume / grpSFX.Volume.

local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService      = game:GetService("SoundService")

-- ─── SOUND GROUPS ────────────────────────────────────────────────────────────

local grpMusic  = Instance.new("SoundGroup")
grpMusic.Name   = "Music";  grpMusic.Volume  = 0.30; grpMusic.Parent = SoundService

local grpAmb    = Instance.new("SoundGroup")
grpAmb.Name     = "Ambient"; grpAmb.Volume   = 0.20; grpAmb.Parent  = SoundService

local grpSFX    = Instance.new("SoundGroup")
grpSFX.Name     = "SFX";    grpSFX.Volume    = 0.70; grpSFX.Parent  = SoundService

local grpReward = Instance.new("SoundGroup")
grpReward.Name  = "Reward"; grpReward.Volume = 0.85; grpReward.Parent = SoundService

-- ─── SOUND CATALOG ───────────────────────────────────────────────────────────
--
-- Sources:
--   Music  — Roblox official licensed catalog (roblox.com free audio library)
--   SFX    — DevForum free-SFX thread (IDs 7381xxxxxx family, permanently public)
--   Others — Roblox public library (pre-privacy-update, grant-all assets)
--
-- To swap any sound: change the "id" field. The rest of the system adapts.

local CATALOG = {
    -- ── BGM (looping) ──────────────────────────────────────────────────────
    bgm_main    = { id = "rbxassetid://9043887091",  grp = grpMusic,  loop = true,  vol = 1.0  },
    -- Crossfades in during weather events for atmospheric tension
    bgm_weather = { id = "rbxassetid://1838825693",  grp = grpMusic,  loop = true,  vol = 0.85 },

    -- ── Ambient (looping, quiet) ────────────────────────────────────────────
    amb_cave    = { id = "rbxassetid://1842181702",  grp = grpAmb,   loop = true,  vol = 0.6  },

    -- ── UI SFX ─────────────────────────────────────────────────────────────
    click       = { id = "rbxassetid://7381722372",  grp = grpSFX,   loop = false, vol = 0.55 },
    close       = { id = "rbxassetid://7381722902",  grp = grpSFX,   loop = false, vol = 0.50 },
    panel_open  = { id = "rbxassetid://7381726284",  grp = grpSFX,   loop = false, vol = 0.55 },

    -- ── Collect / Resource ─────────────────────────────────────────────────
    orb_collect = { id = "rbxassetid://7381723507",  grp = grpSFX,   loop = false, vol = 0.65 },

    -- ── Purchases ──────────────────────────────────────────────────────────
    purchase    = { id = "rbxassetid://131886985",   grp = grpSFX,   loop = false, vol = 0.65 },
    new_species = { id = "rbxassetid://1170853519",  grp = grpReward,loop = false, vol = 0.90 },

    -- ── Rewards / Achievements ─────────────────────────────────────────────
    level_up    = { id = "rbxassetid://7381724959",  grp = grpReward,loop = false, vol = 0.80 },
    quest_done  = { id = "rbxassetid://133379260",   grp = grpReward,loop = false, vol = 0.90 },
    streak      = { id = "rbxassetid://7381724959",  grp = grpReward,loop = false, vol = 0.85 },

    -- ── World Events ──────────────────────────────────────────────────────
    weather_hit = { id = "rbxassetid://7489673348",  grp = grpSFX,   loop = false, vol = 0.55 },
    mutation_sm = { id = "rbxassetid://7381724959",  grp = grpReward,loop = false, vol = 0.75 },
    mutation_md = { id = "rbxassetid://1170853519",  grp = grpReward,loop = false, vol = 0.80 },
    mutation_lg = { id = "rbxassetid://7489673348",  grp = grpReward,loop = false, vol = 0.85 },
    prestige    = { id = "rbxassetid://1170853519",  grp = grpReward,loop = false, vol = 1.00 },
    pulse       = { id = "rbxassetid://7381726284",  grp = grpSFX,   loop = false, vol = 0.75 },
}

-- ─── SOUND CACHE ─────────────────────────────────────────────────────────────
-- Pre-create all sounds so first play has no latency.

local cache: { [string]: Sound } = {}

for name, def in pairs(CATALOG) do
    local s        = Instance.new("Sound")
    s.Name         = "SM_" .. name
    s.SoundId      = def.id
    s.Volume       = def.vol
    s.Looped       = def.loop
    s.SoundGroup   = def.grp
    s.Parent       = SoundService
    cache[name]    = s
end

-- ─── PLAY HELPERS ─────────────────────────────────────────────────────────────

-- One-shot: clones the cached sound so it can overlap itself.
-- speedMul tweaks PlaybackSpeed (1.1 = slightly higher pitch).
local function play(name: string, speedMul: number?)
    local src = cache[name]
    if not src then return end

    if src.Looped then
        if not src.IsPlaying then src:Play() end
        return
    end

    local s        = src:Clone()
    s.Parent       = SoundService
    if speedMul then s.PlaybackSpeed = speedMul end
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function stop(name: string)
    local s = cache[name]
    if s then s:Stop() end
end

-- Crossfade between two looping BGM tracks.
local function crossfade(from: string, to: string, dur: number?)
    dur = dur or 1.8
    local a = cache[from]
    local b = cache[to]
    if not a or not b then return end
    b.Volume = 0
    if not b.IsPlaying then b:Play() end
    TweenService:Create(a, TweenInfo.new(dur), { Volume = 0 }):Play()
    TweenService:Create(b, TweenInfo.new(dur), { Volume = CATALOG[to].vol }):Play()
    task.delay(dur + 0.05, function()
        a:Stop()
        a.Volume = CATALOG[from].vol
    end)
end

-- ─── STARTUP ─────────────────────────────────────────────────────────────────

play("bgm_main")
play("amb_cave")

-- ─── REMOTE WIRING ───────────────────────────────────────────────────────────

local Remotes          = ReplicatedStorage:WaitForChild("Remotes")
local OrbCollected     = Remotes:WaitForChild("OrbCollected")
local MutationOccurred = Remotes:WaitForChild("MutationOccurred")
local WeatherChanged   = Remotes:WaitForChild("WeatherChanged")
local MyceliumPulse    = Remotes:WaitForChild("MyceliumPulse")
local QuestProgress    = Remotes:WaitForChild("QuestProgress")
local LoginStreakData  = Remotes:WaitForChild("LoginStreakData")
local SyncData         = Remotes:WaitForChild("SyncData")

-- Orb: subtle pitch randomisation makes rapid collection feel varied
OrbCollected.OnClientEvent:Connect(function()
    play("orb_collect", 0.92 + math.random() * 0.22)
end)

-- Mutation: escalate the sound drama with mutCount (1 / 2 / 3 stars)
MutationOccurred.OnClientEvent:Connect(function(_speciesId: string, mutCount: number)
    if mutCount >= 3 then
        play("mutation_lg")
        task.delay(0.18, function() play("new_species", 1.05) end)
    elseif mutCount == 2 then
        play("mutation_md")
        task.delay(0.12, function() play("level_up", 1.15) end)
    else
        play("mutation_sm")
    end
end)

-- Weather: crossfade BGM; play low-pitched rumble on arrival
local weatherOn = false
WeatherChanged.OnClientEvent:Connect(function(event)
    if event and not weatherOn then
        weatherOn = true
        crossfade("bgm_main", "bgm_weather", 2.2)
        task.delay(0.4, function() play("weather_hit", 0.68) end)
    elseif not event and weatherOn then
        weatherOn = false
        crossfade("bgm_weather", "bgm_main", 2.8)
    end
end)

-- Mycelium Pulse: network activation whoosh (lower pitch = deeper sweep)
MyceliumPulse.OnClientEvent:Connect(function()
    play("pulse", 0.80)
    task.delay(0.3, function() play("level_up", 0.90) end)
end)

-- Quest: chime only when a quest tips into completed state
QuestProgress.OnClientEvent:Connect(function(update)
    if update.progress >= update.goal then
        task.delay(0.15, function() play("quest_done") end)
    end
end)

-- Login streak popup: warm sound if unclaimed reward waiting
LoginStreakData.OnClientEvent:Connect(function(data)
    if data and data.canClaim then
        task.delay(0.45, function() play("streak", 1.06) end)
    end
end)

-- Prestige: detect level-up from SyncData delta
local lastPrestige = 0
SyncData.OnClientEvent:Connect(function(data)
    local lv = data.prestigeLevel or 0
    if lv > lastPrestige then
        lastPrestige = lv
        play("prestige")
        task.delay(0.22, function() play("level_up", 1.25) end)
        task.delay(0.55, function() play("new_species", 1.10) end)
    else
        lastPrestige = lv
    end
end)

-- ─── PUBLIC API (called by GameClient for UI feedback) ───────────────────────

local SoundManager = {}

function SoundManager.click()         play("click")               end
function SoundManager.close()         play("close")               end
function SoundManager.panelOpen()     play("panel_open")          end
function SoundManager.purchase()      play("purchase")            end
function SoundManager.speciesUnlock() play("new_species")         end
function SoundManager.levelUp()       play("level_up")            end
function SoundManager.questClaim()    play("quest_done")          end
function SoundManager.streakClaim()   play("streak", 1.08)        end

return SoundManager
