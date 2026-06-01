-- Handles the Hot Dog Ring skill-check: renders the ring UI, captures input,
-- fires SkillCheckResult back to the server.

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService      = game:GetService("SoundService")
local HapticService     = game:GetService("HapticService")

local Common    = ReplicatedStorage:WaitForChild("Common")
local Constants = require(Common:WaitForChild("Constants"))
local Types     = require(Common:WaitForChild("Types"))

local GloryReelController = require(script.Parent:WaitForChild("GloryReelController"))

local ContestController = {}

local remotes: { [string]: RemoteEvent } = {}
local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

-- ── Ring UI ───────────────────────────────────────────────────────────────────
-- Built entirely from code so Rojo sync doesn't need art assets for MVP.

local ringGui: ScreenGui
local ringFrame: Frame
local arcImage: ImageLabel  -- placeholder arc (solid arc drawn via Frame rotation)
local needleFrame: Frame
local feedbackLabel: TextLabel

-- Ring size scales by device. Touch (mobile/tablet) gets ~1.5× larger
-- because fingers are imprecise vs cursor and tap zones need real estate.
local function isTouchDevice(): boolean
	return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

local RING_PX        = isTouchDevice() and 320 or 220
local RING_HALF      = RING_PX / 2
local RING_SIZE      = UDim2.fromOffset(RING_PX, RING_PX)
local NEEDLE_LEN     = math.floor(RING_PX * 0.4)
local NEEDLE_THICK   = isTouchDevice() and 6 or 4
local FEEDBACK_W     = math.floor(RING_PX * 1.0)
local FEEDBACK_H     = isTouchDevice() and 56 or 40
local CENTER         = UDim2.new(0.5, 0, 0.5, 0)

local function buildRingGui()
	ringGui = Instance.new("ScreenGui")
	ringGui.Name            = "RingGui"
	ringGui.ResetOnSpawn    = false
	ringGui.IgnoreGuiInset  = true
	ringGui.Enabled         = false
	ringGui.Parent          = playerGui

	-- Outer circle background
	local bg = Instance.new("Frame")
	bg.Name              = "RingBg"
	bg.Size              = RING_SIZE
	bg.Position          = UDim2.new(0.5, -RING_HALF, 0.5, -RING_HALF)
	bg.BackgroundColor3  = Color3.fromRGB(30, 30, 30)
	bg.BorderSizePixel   = 0
	bg.Parent            = ringGui
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
	ringFrame = bg

	-- Green success arc (rotated frame = visual approximation for MVP)
	local arc = Instance.new("Frame")
	arc.Name              = "Arc"
	arc.Size              = UDim2.new(0.8, 0, 0.8, 0)
	arc.Position          = UDim2.new(0.1, 0, 0.1, 0)
	arc.BackgroundColor3  = Color3.fromRGB(80, 220, 80)
	arc.BorderSizePixel   = 0
	arc.Rotation          = 0
	arc.Parent            = bg
	arc.BackgroundTransparency = 0.4
	Instance.new("UICorner", arc).CornerRadius = UDim.new(1, 0)
	arcImage = arc :: any

	-- Gold great-zone ring (inner)
	local great = Instance.new("Frame")
	great.Name              = "GreatArc"
	great.Size              = UDim2.new(0.6, 0, 0.6, 0)
	great.Position          = UDim2.new(0.2, 0, 0.2, 0)
	great.BackgroundColor3  = Color3.fromRGB(255, 200, 0)
	great.BorderSizePixel   = 0
	great.Rotation          = 0
	great.Parent            = bg
	great.BackgroundTransparency = 0.6
	Instance.new("UICorner", great).CornerRadius = UDim.new(1, 0)

	-- Needle (thin frame rotated from center)
	local needle = Instance.new("Frame")
	needle.Name              = "Needle"
	needle.Size              = UDim2.fromOffset(NEEDLE_THICK, NEEDLE_LEN)
	needle.Position          = UDim2.new(0.5, -math.floor(NEEDLE_THICK/2), 0.5, -NEEDLE_LEN)
	needle.BackgroundColor3  = Color3.fromRGB(255, 60, 60)
	needle.BorderSizePixel   = 0
	needle.Rotation          = 0
	needle.Parent            = bg
	needleFrame = needle

	-- Feedback label
	local lbl = Instance.new("TextLabel")
	lbl.Name                = "Feedback"
	lbl.Size                = UDim2.fromOffset(FEEDBACK_W, FEEDBACK_H)
	lbl.Position            = UDim2.new(0.5, -math.floor(FEEDBACK_W/2), 0.5, RING_HALF + 10)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3          = Color3.new(1, 1, 1)
	lbl.TextScaled          = true
	lbl.Font                = Enum.Font.GothamBold
	lbl.Text                = ""
	lbl.Parent              = ringGui
	feedbackLabel = lbl

	-- "HIT HERE" onboarding label
	local hitLabel = Instance.new("TextLabel")
	hitLabel.Name  = "HitHere"
	hitLabel.Size  = UDim2.fromOffset(160, 30)
	hitLabel.Position = UDim2.new(0.5, -80, 0.5, -145)
	hitLabel.BackgroundTransparency = 1
	hitLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
	hitLabel.TextScaled = true
	hitLabel.Font       = Enum.Font.GothamBold
	hitLabel.Text       = "HIT HERE ↓"
	hitLabel.Visible    = false
	hitLabel.Parent     = ringGui
end

-- ── Active ring state ─────────────────────────────────────────────────────────

local activeRing: Types.SkillCheckParams? = nil
local needleAngle = 0   -- degrees, updated every frame
local ringConn: RBXScriptConnection?
local inputConn: RBXScriptConnection?
local hitThisRing = false

local function clearRing()
	activeRing = nil
	hitThisRing = false
	ringGui.Enabled = false
	feedbackLabel.Text = ""
	if ringConn then ringConn:Disconnect(); ringConn = nil end
	if inputConn then inputConn:Disconnect(); inputConn = nil end
end

local function showFeedback(text: string, color: Color3)
	feedbackLabel.Text       = text
	feedbackLabel.TextColor3 = color
	task.delay(0.6, function()
		if feedbackLabel then feedbackLabel.Text = "" end
	end)
end

local function isInArc(angle: number, arcStart: number, arcWidth: number): (boolean, boolean)
	-- Normalize angle into [0, 360)
	local a = angle % 360
	local s = arcStart % 360
	local e = (s + arcWidth) % 360

	local inArc: boolean
	if s <= e then
		inArc = a >= s and a <= e
	else
		inArc = a >= s or a <= e
	end

	if not inArc then return false, false end

	-- Great zone: center ±RING_GREAT_WIDTH/2
	local center = (s + arcWidth / 2) % 360
	local half   = Constants.RING_GREAT_WIDTH / 2
	local diff   = math.abs((a - center + 540) % 360 - 180)
	return true, diff <= half
end

local function startRing(params: Types.SkillCheckParams)
	activeRing   = params
	hitThisRing  = false
	needleAngle  = 0
	ringGui.Enabled = true

	-- Show onboarding hint for first N bites
	local hitHere = ringGui:FindFirstChild("HitHere") :: TextLabel?
	if hitHere then
		-- Only visible if server sends biteIndex ≤ threshold
		hitHere.Visible = (params.biteIndex <= Constants.ONBOARDING_HIT_LABEL_BITES)
	end

	-- Position arc visually
	arcImage.Rotation = params.arcStart

	-- Needle rotation loop
	local startTime = tick()
	ringConn = game:GetService("RunService").RenderStepped:Connect(function()
		if not activeRing then return end
		local elapsed = tick() - startTime
		needleAngle   = (elapsed * params.needleSpeed) % 360
		needleFrame.Rotation = needleAngle
	end)

	-- Input: tap/click fires the result
	inputConn = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if hitThisRing or not activeRing then return end
		hitThisRing = true

		local hit, isGreat = isInArc(needleAngle, params.arcStart, params.arcWidth)
		local alignment = 0.0
		if hit then
			-- alignment: 1.0 at center, 0.5 at edge
			local center = (params.arcStart + params.arcWidth / 2) % 360
			local diff   = math.abs((needleAngle - center + 540) % 360 - 180)
			alignment    = 1 - (diff / (params.arcWidth / 2)) * 0.5
			alignment    = math.clamp(alignment, 0, 1)
		end

		local result: Types.SkillCheckResult = {
			arenaId   = params.arenaId,
			biteIndex = params.biteIndex,
			hit       = hit,
			alignment = alignment,
			isGreat   = isGreat,
		}
		remotes.SkillCheckResult:FireServer(result)
		GloryReelController.recordBite(hit, isGreat, params.biteIndex)

		-- Player bite-bob: lean character forward + down briefly on every successful bite
		if hit then
			local char = localPlayer.Character
			local hrp  = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local original = hrp.CFrame
				local bobOffset = CFrame.new(0, -0.4, -0.4) * CFrame.Angles(math.rad(-15), 0, 0)
				TweenService:Create(hrp, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
					CFrame = original * bobOffset,
				}):Play()
				task.delay(0.12, function()
					if hrp and hrp.Parent then
						TweenService:Create(hrp, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
							CFrame = original,
						}):Play()
					end
				end)
			end
		end

		-- Haptic feedback on mobile (haptic motor pulse)
		if UserInputService.TouchEnabled and HapticService and HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) then
			pcall(function()
				HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, isGreat and 1.0 or (hit and 0.4 or 0))
				task.delay(0.08, function()
					HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
				end)
			end)
		end

		if isGreat then
			showFeedback("GREAT!", Color3.fromRGB(255, 200, 0))
			-- Foodgasm reaction burst (Food Wars-coded): cheap TikTok bait, screenshot-bait
			task.spawn(function()
				local foodgasm = Instance.new("ScreenGui")
				foodgasm.Name           = "FoodgasmBurst"
				foodgasm.ResetOnSpawn   = false
				foodgasm.IgnoreGuiInset = true
				foodgasm.DisplayOrder   = 10
				foodgasm.Parent         = playerGui

				-- 12 radial sparkle bursts emanating from screen center
				for i = 1, 12 do
					local sparkle = Instance.new("TextLabel")
					sparkle.Size                = UDim2.fromOffset(64, 64)
					sparkle.Position            = UDim2.new(0.5, -32, 0.5, -32)
					sparkle.BackgroundTransparency = 1
					sparkle.TextColor3          = Color3.fromRGB(255, 220, 80)
					sparkle.TextStrokeColor3    = Color3.fromRGB(255, 80, 80)
					sparkle.TextStrokeTransparency = 0
					sparkle.TextScaled          = true
					sparkle.Font                = Enum.Font.LuckiestGuy
					sparkle.Text                = ({"✨", "⭐", "💥", "✦"})[((i - 1) % 4) + 1]
					sparkle.Rotation            = math.random(0, 360)
					sparkle.Parent              = foodgasm
					local angle = (i / 12) * math.pi * 2
					local dx, dy = math.cos(angle) * 280, math.sin(angle) * 280
					TweenService:Create(sparkle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(0.5, -32 + dx, 0.5, -32 + dy),
						TextTransparency = 1,
						TextStrokeTransparency = 1,
						Rotation = sparkle.Rotation + 360,
					}):Play()
				end

				-- Big "PERFECT!" text burst in center
				local bang = Instance.new("TextLabel")
				bang.Size                = UDim2.fromOffset(360, 120)
				bang.Position            = UDim2.new(0.5, -180, 0.5, -250)
				bang.BackgroundTransparency = 1
				bang.TextColor3          = Color3.fromRGB(255, 255, 100)
				bang.TextStrokeColor3    = Color3.fromRGB(220, 30, 30)
				bang.TextStrokeTransparency = 0
				bang.TextScaled          = true
				bang.Font                = Enum.Font.LuckiestGuy
				bang.Text                = ({"FOODGASM!", "PERFECT!", "SUBLIME!", "GLORIOUS!"})[math.random(4)]
				bang.Rotation            = math.random(-8, 8)
				bang.Parent              = foodgasm
				TweenService:Create(bang, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.fromOffset(520, 160),
					Position = UDim2.new(0.5, -260, 0.5, -270),
					TextTransparency = 1,
					TextStrokeTransparency = 1,
				}):Play()

				task.wait(0.7)
				foodgasm:Destroy()
			end)
		elseif hit then
			showFeedback("GOOD", Color3.fromRGB(100, 255, 100))
		else
			showFeedback("MISS", Color3.fromRGB(255, 80, 80))
		end

		-- Ring clears after brief visual pause
		task.delay(0.2, clearRing)
	end)

	-- Auto-expire
	task.delay(params.duration + 0.1, function()
		if activeRing == params then
			clearRing()
		end
	end)
end

-- ── ContestPhase listener (enable/disable ring input) ────────────────────────

local activeArenaId: number? = nil

local function onPhaseChanged(arenaId: number, state: string)
	-- Only track the arena we're personally in (Active/Results/Idle messages are per-player).
	-- Queuing broadcasts go to all players — don't auto-join.
	if state == "Active" or state == "Results" or state == "Idle" then
		activeArenaId = if state ~= "Idle" then arenaId else nil
	end

	if state ~= "Active" then
		clearRing()
	end
end

-- Wire contest stage ProximityPrompts → JoinQueue. Chairs may replicate to the
-- client AFTER controller init, so we also listen for DescendantAdded.
local function setupContestPrompts()
	local stage = workspace:WaitForChild("ContestStage_T1", 60)
	if not stage then
		warn("[ContestController] ContestStage_T1 not found")
		return
	end
	local function connectPrompt(inst: Instance)
		if inst:IsA("ProximityPrompt") then
			inst.Triggered:Connect(function()
				remotes.JoinQueue:FireServer(nil)
			end)
		end
	end
	for _, desc in stage:GetDescendants() do
		connectPrompt(desc)
	end
	stage.DescendantAdded:Connect(connectPrompt)
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function ContestController.init(remotesFolder: Folder)
	remotes.SkillCheckStart    = remotesFolder:WaitForChild("SkillCheckStart")   :: RemoteEvent
	remotes.SkillCheckResult   = remotesFolder:WaitForChild("SkillCheckResult")  :: RemoteEvent
	remotes.ContestPhaseChanged = remotesFolder:WaitForChild("ContestPhaseChanged") :: RemoteEvent
	remotes.JoinQueue           = remotesFolder:WaitForChild("JoinQueue")          :: RemoteEvent

	buildRingGui()

	remotes.SkillCheckStart.OnClientEvent:Connect(function(params: any)
		if activeArenaId == params.arenaId then
			startRing(params)
		end
	end)

	remotes.ContestPhaseChanged.OnClientEvent:Connect(function(arenaId: any, state: any)
		onPhaseChanged(arenaId, state)
	end)

	task.spawn(setupContestPrompts)
end

return ContestController
