-- Runs first: creates all RemoteEvents so other scripts can WaitForChild them
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function makeRemote(parent: Instance, name: string)
	if parent:FindFirstChild(name) then return end
	local e = Instance.new("RemoteEvent")
	e.Name = name
	e.Parent = parent
end

local Remotes = Instance.new("Folder")
Remotes.Name = "Remotes"
Remotes.Parent = ReplicatedStorage

makeRemote(Remotes, "UpdateSpores")
makeRemote(Remotes, "WeatherChanged")
makeRemote(Remotes, "PurchaseUpgrade")
makeRemote(Remotes, "UnlockSpecies")
makeRemote(Remotes, "Sporulate")
makeRemote(Remotes, "SyncData")
makeRemote(Remotes, "LeaderboardUpdated")
makeRemote(Remotes, "ShowcaseUpdated")
makeRemote(Remotes, "MutationOccurred")
makeRemote(Remotes, "ArrangeSwap")
makeRemote(Remotes, "OrbCollected")
makeRemote(Remotes, "MerchantStock")
makeRemote(Remotes, "PurchaseMerchant")
makeRemote(Remotes, "MyceliumPulse")
makeRemote(Remotes, "LoginStreakData")    -- server → client: streak info + reward on login
makeRemote(Remotes, "ClaimStreakReward")  -- client → server: claim today's streak reward
makeRemote(Remotes, "DailyQuestData")    -- server → client: quest definitions + progress
makeRemote(Remotes, "QuestProgress")     -- server → client: incremental progress update
makeRemote(Remotes, "ClaimQuestReward")  -- client → server: claim a completed quest reward
makeRemote(Remotes, "SeasonLeaderboardUpdated") -- server → client: seasonal top-10 spores
makeRemote(Remotes, "ShowPortalMessage")        -- server → client: portal blocked reason string
makeRemote(Remotes, "ZoneChanged")              -- server → client: notify which zone player is in
makeRemote(Remotes, "CaveEventActive")          -- server → client: cave event name when Spring starts
makeRemote(Remotes, "FishingBite")              -- server → client: mole bites, start mini-game
makeRemote(Remotes, "FishingResult")            -- client → server: pass=true/false + timestamp
makeRemote(Remotes, "LootGranted")              -- server → client: loot details after successful reel

-- Phase 5: Tending
makeRemote(Remotes, "TendSlot")                 -- client → server: speciesId, slotType
makeRemote(Remotes, "TendingState")             -- server → client: slot state table

-- Phase 6: Pets
makeRemote(Remotes, "PetCaught")                -- server → client: petId, species, variant
makeRemote(Remotes, "SetActivePets")            -- client → server: {petId, petId}
makeRemote(Remotes, "PetState")                 -- server → client: full pets table

-- Phase 8: Combat
makeRemote(Remotes, "PlayerAttack")             -- client → server: weaponId, targetMobId
makeRemote(Remotes, "PetsRetreat")              -- server → client: on death
makeRemote(Remotes, "HPUpdate")                 -- server → client: currentHP, maxHP

-- Phase 9: Vat
makeRemote(Remotes, "BrewPotion")               -- client → server: recipeId
makeRemote(Remotes, "UsePotion")                -- client → server: potionId
makeRemote(Remotes, "VatState")                 -- server → client: ingredients + brews

-- Phase 10: Journal
makeRemote(Remotes, "JournalUpdated")           -- server → client: full journal table
makeRemote(Remotes, "MilestoneReached")         -- server → client: count, reward

-- Sound
makeRemote(Remotes, "MobSound")                 -- server → client: mobType, soundType, position

-- Client-side BindableEvents (same-client signalling, no server involved)
local Bindables = Instance.new("Folder")
Bindables.Name = "Bindables"
Bindables.Parent = ReplicatedStorage

local function makeBindable(name: string)
	if Bindables:FindFirstChild(name) then return end
	local b = Instance.new("BindableEvent")
	b.Name = name
	b.Parent = Bindables
end

makeBindable("OpenShop")    -- NPCShopClient → GameClient: open the shop panel
