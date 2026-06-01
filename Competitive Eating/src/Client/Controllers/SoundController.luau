-- Centralized sound effect player.
-- Roblox free SFX library asset IDs — none of these require uploading.
-- Sounds are parented to SoundService so they play globally regardless of camera.

local SoundService      = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SoundController = {}

-- Roblox-hosted SFX IDs (all free, all from Roblox's official library).
-- If any of these ever 404, swap with another from the same category — they're
-- interchangeable for the purpose of "carnival atmosphere + win/lose feedback".
local SFX = {
	-- Contest feedback
	PerfectBite    = "rbxassetid://5786458588",   -- bright ding
	GoodBite       = "rbxassetid://3199934562",   -- soft pop
	MissBite       = "rbxassetid://9046087844",   -- light buzz
	Countdown3     = "rbxassetid://6890470776",   -- beep
	CountdownGo    = "rbxassetid://6890471027",   -- whistle / start
	-- Results
	WinChime       = "rbxassetid://9046065085",   -- victory chime
	LoseBuzz       = "rbxassetid://5805848098",   -- lose buzzer
	-- Upgrade
	UpgradeDing    = "rbxassetid://6890469831",   -- level-up
	-- Crowd
	CrowdCheer     = "rbxassetid://9046219584",
	CrowdGasp      = "rbxassetid://9046087844",   -- (reuse miss sound)
	-- Foodgasm
	FoodgasmBurst  = "rbxassetid://6890469831",   -- (reuse level-up for now)
}

local cache: { [string]: Sound } = {}

local function getSound(key: string): Sound?
	if cache[key] then return cache[key] end
	local id = SFX[key]
	if not id then return nil end

	local s = Instance.new("Sound")
	s.Name      = "SFX_" .. key
	s.SoundId   = id
	s.Volume    = 0.5
	s.RollOffMode = Enum.RollOffMode.InverseTapered
	s.Parent    = SoundService
	cache[key]  = s
	return s
end

-- Play a sound once (clones if already playing so overlaps work)
function SoundController.play(key: string, volume: number?)
	local s = getSound(key)
	if not s then return end
	-- Clone so overlapping plays don't cut each other off (e.g. multiple perfect bites in a row)
	local clone = s:Clone()
	clone.Volume = volume or 0.5
	clone.Parent = SoundService
	clone:Play()
	-- Auto-destroy after sound finishes
	task.delay(5, function()
		clone:Destroy()
	end)
end

function SoundController.init()
	-- Pre-load by referencing each ID once
	for key in pairs(SFX) do
		getSound(key)
	end
end

return SoundController
