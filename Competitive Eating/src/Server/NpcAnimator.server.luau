-- NpcAnimator: finds every R6 NPC under workspace.Districts and starts the
-- default Roblox idle animation looping on it. Handles both rigs that exist
-- at startup and rigs spawned later by AssetSpawner / runtime systems.
--
-- Why a single sweeper instead of an animation per asset module:
--   * keeps NPC modules pure builders (no script lifecycle inside them)
--   * AnimationTrack:Play() must be called from a script, not from the module
--     return-value chain — a sweeper avoids touching the asset-module contract
--   * easy to swap to per-NPC animations later by tagging rigs with attributes

local IDLE_ANIM_ID = "rbxassetid://180435571"  -- classic R6 idle, Roblox-owned, always public

local idleAnim = Instance.new("Animation")
idleAnim.AnimationId = IDLE_ANIM_ID

local function isNpcRig(model: Instance): boolean
	if not model:IsA("Model") then return false end
	local hum = model:FindFirstChildOfClass("Humanoid")
	if not hum then return false end
	-- Skip player characters; they have their own animations
	if model:FindFirstChildOfClass("Humanoid") and hum.Parent.Name == "Player" then
		-- "Player" is actually a valid NPC name in Tokyo (PachinkoPlayer renders as "Player")
		-- so don't exclude by name. The Players service entries don't live under Districts.
	end
	return true
end

local function playIdle(rig: Model)
	-- Avoid double-starting if we sweep the same rig twice
	if rig:GetAttribute("_NpcAnimatorBound") then return end
	rig:SetAttribute("_NpcAnimatorBound", true)

	local hum = rig:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end

	local ok, track = pcall(function()
		return animator:LoadAnimation(idleAnim)
	end)
	if not ok or not track then
		warn("[NpcAnimator] LoadAnimation failed for " .. rig:GetFullName() .. ": " .. tostring(track))
		return
	end

	track.Looped = true
	-- Stagger phase so a row of NPCs isn't visually synchronised
	track.TimePosition = math.random() * 2
	track:Play()
end

local function sweep(root: Instance)
	for _, d in root:GetDescendants() do
		if isNpcRig(d) then
			playIdle(d :: Model)
		end
	end
end

task.spawn(function()
	-- Wait briefly for AssetSpawner to finish (it runs from Main.server.luau init).
	-- AssetSpawner is synchronous so by the time we get here it should be done,
	-- but we wait a frame just in case + retry-poll for late additions.
	task.wait(0.5)
	local districts = workspace:WaitForChild("Districts", 30)
	if not districts then
		warn("[NpcAnimator] Districts folder never appeared; aborting")
		return
	end
	sweep(districts)

	districts.DescendantAdded:Connect(function(d)
		-- A whole rig is added as a Model — wait one frame so its Humanoid is parented before we look
		task.defer(function()
			if isNpcRig(d) then
				playIdle(d :: Model)
			end
		end)
	end)

	print("[NpcAnimator] online")
end)
