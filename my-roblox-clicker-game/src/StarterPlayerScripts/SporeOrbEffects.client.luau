-- SporeOrbEffects: client-side visuals when a spore orb is collected.
-- Listens for the OrbCollected RemoteEvent fired by SporeOrbManager.
-- Shows a floating "+N Spores" BillboardGui that rises and fades out,
-- plus a brief particle burst at the collection position.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local Remotes      = ReplicatedStorage:WaitForChild("Remotes")
local OrbCollected = Remotes:WaitForChild("OrbCollected")

-- ─── CONSTANTS ────────────────────────────────────────────────────────────────

local LABEL_RISE     = 6    -- studs the label floats upward
local LABEL_DURATION = 1.1  -- seconds until fully faded
local BURST_RATE     = 30   -- particles in the burst
local BURST_SPEED    = 12   -- particle emit speed

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

-- Format a spore number nicely (e.g. 1250 → "+1.25K Spores")
local function fmtValue(n: number): string
	if n >= 1e9 then
		return string.format("+%.2fB Spores", n / 1e9)
	elseif n >= 1e6 then
		return string.format("+%.2fM Spores", n / 1e6)
	elseif n >= 1e3 then
		return string.format("+%.1fK Spores", n / 1e3)
	else
		return string.format("+%d Spores", n)
	end
end

-- ─── COLLECT EFFECT ──────────────────────────────────────────────────────────

local function playCollectEffect(worldPos: Vector3, color: Color3, value: number)

	-- ── 1. Particle burst (a brief emitter on a transparent anchor Part) ─────
	local anchor = Instance.new("Part")
	anchor.Size         = Vector3.new(0.1, 0.1, 0.1)
	anchor.Position     = worldPos
	anchor.Anchored     = true
	anchor.CanCollide   = false
	anchor.Transparency = 1
	anchor.Parent       = workspace

	local pe            = Instance.new("ParticleEmitter")
	pe.Color            = ColorSequence.new(color)
	pe.Size             = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.35),
		NumberSequenceKeypoint.new(1, 0),
	})
	pe.Lifetime         = NumberRange.new(0.4, 0.9)
	pe.Speed            = NumberRange.new(BURST_SPEED * 0.6, BURST_SPEED)
	pe.SpreadAngle      = Vector2.new(180, 180)
	pe.LightEmission    = 1
	pe.Enabled          = false
	pe.Parent           = anchor

	pe:Emit(BURST_RATE)
	task.delay(1.2, function() anchor:Destroy() end)

	-- ── 2. Floating "+N Spores" BillboardGui ─────────────────────────────────
	local billboard            = Instance.new("BillboardGui")
	billboard.Size             = UDim2.new(0, 120, 0, 36)
	billboard.StudsOffset      = Vector3.new(0, 0, 0)
	billboard.AlwaysOnTop      = false
	billboard.LightInfluence   = 0
	billboard.Adornee          = anchor
	billboard.Parent           = PlayerGui

	local lbl                  = Instance.new("TextLabel")
	lbl.Size                   = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text                   = fmtValue(value)
	lbl.TextColor3             = color
	lbl.TextStrokeColor3       = Color3.new(0, 0, 0)
	lbl.TextStrokeTransparency = 0.3
	lbl.TextSize               = 16
	lbl.Font                   = Enum.Font.GothamBold
	lbl.TextXAlignment         = Enum.TextXAlignment.Center
	lbl.Parent                 = billboard

	-- Rise + fade tween
	local startOffset = Vector3.new(0, 1.5, 0)
	local endOffset   = Vector3.new(0, 1.5 + LABEL_RISE, 0)
	billboard.StudsOffset = startOffset

	TweenService:Create(
		billboard,
		TweenInfo.new(LABEL_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ StudsOffset = endOffset }
	):Play()

	TweenService:Create(
		lbl,
		TweenInfo.new(LABEL_DURATION * 0.6, Enum.EasingStyle.Linear,
			Enum.EasingDirection.In, 0, false, LABEL_DURATION * 0.4),
		{ TextTransparency = 1, TextStrokeTransparency = 1 }
	):Play()

	task.delay(LABEL_DURATION + 0.05, function()
		billboard:Destroy()
	end)
end

-- ─── WIRE UP ─────────────────────────────────────────────────────────────────

OrbCollected.OnClientEvent:Connect(function(worldPos: Vector3, color: Color3, value: number)
	playCollectEffect(worldPos, color, value)
end)
