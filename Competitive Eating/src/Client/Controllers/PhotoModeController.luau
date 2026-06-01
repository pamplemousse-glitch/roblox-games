-- PhotoModeController — free-camera "photo mode" with filter overlays.
-- Triggered by a camera-icon HUD button (top-right). WASD / on-screen joystick
-- to move, Q/E to roll, scroll (or +/- buttons on mobile) for FOV. 4 filter
-- overlays applied via ColorCorrectionEffect + a UI Frame for Vignette.
-- Player character is anchored while active. Re-toggle or Escape exits.

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")

local PhotoModeController = {}

local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")
local camera      = workspace.CurrentCamera

-- ── State ────────────────────────────────────────────────────────────────────

local active = false

local savedCameraType
local savedCameraSubject
local savedFov

local photoPos             = Vector3.new(0, 50, 0)
local yaw, pitch, roll     = 0, 0, 0
local currentFov           = 70

local MOVE_SPEED      = 60
local SPRINT_MULT     = 2.5
local ROLL_SPEED      = math.rad(90)
local LOOK_SENS       = 0.0025
local TOUCH_LOOK_SENS = 0.005
local FOV_MIN, FOV_MAX = 20, 110

local keysDown       = {}
local touchMoveDelta = Vector2.zero
local rollInput      = 0

local renderConn
local mouseLookActive = false
local lookTouchId
local moveTouchId
local moveTouchOrigin = Vector2.zero

-- ── UI refs ──────────────────────────────────────────────────────────────────

local screenGui
local toggleBtn
local exitBtn
local controlsFrame
local filterButtons    = {}
local vignetteFrames   = {}
local joystickBg, joystickThumb
local rollLeftBtn, rollRightBtn
local fovUpBtn, fovDownBtn

-- ── Effect ───────────────────────────────────────────────────────────────────

local ccEffect
local activeFilterIdx = 0

local FILTERS = {
	{name="Sepia",    tint=Color3.fromRGB(255,220,170), sat=-0.7, brt=0.05, con=0.15, vignette=false},
	{name="Vibrant",  tint=Color3.fromRGB(255,255,255), sat=0.5,  brt=0.05, con=0.20, vignette=false},
	{name="B&W",      tint=Color3.fromRGB(255,255,255), sat=-1.0, brt=0.00, con=0.25, vignette=false},
	{name="Vignette", tint=Color3.fromRGB(255,255,255), sat=0.0,  brt=-0.05,con=0.05, vignette=true},
}

-- ── Saved scene state ────────────────────────────────────────────────────────

local hiddenGuis    = {}
local anchoredParts = {}

-- ── Helpers ──────────────────────────────────────────────────────────────────

local function isMobile(): boolean
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function setVignetteVisible(on: boolean)
	for _, f in vignetteFrames do
		f.Visible = on
	end
end

local function applyFilter(idx: number)
	activeFilterIdx = idx
	if idx == 0 then
		ccEffect.TintColor  = Color3.fromRGB(255, 255, 255)
		ccEffect.Saturation = 0
		ccEffect.Brightness = 0
		ccEffect.Contrast   = 0
		setVignetteVisible(false)
	else
		local f = FILTERS[idx]
		ccEffect.TintColor  = f.tint
		ccEffect.Saturation = f.sat
		ccEffect.Brightness = f.brt
		ccEffect.Contrast   = f.con
		setVignetteVisible(f.vignette)
	end
	for i, btn in filterButtons do
		local on = (i == idx)
		btn.BackgroundColor3 = on and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(40, 40, 40)
		btn.TextColor3       = on and Color3.fromRGB(20, 20, 20)   or Color3.fromRGB(240, 240, 240)
	end
end

-- ── Build vignette overlay (4 edge-fade frames) ──────────────────────────────

local function buildVignette(parent: Instance)
	local function fadeFrame(size: UDim2, pos: UDim2, gradStart: number, gradEnd: number, rot: number)
		local f = Instance.new("Frame")
		f.Size                  = size
		f.Position              = pos
		f.BackgroundColor3      = Color3.new(0, 0, 0)
		f.BorderSizePixel       = 0
		f.Visible               = false
		f.ZIndex                = 5
		f.Parent                = parent

		local g = Instance.new("UIGradient")
		g.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, gradStart),
			NumberSequenceKeypoint.new(1, gradEnd),
		})
		g.Rotation = rot
		g.Parent   = f
		return f
	end

	vignetteFrames = {
		fadeFrame(UDim2.new(1, 0, 0.35, 0), UDim2.new(0, 0, 0,    0), 0.0, 1.0, 90),  -- top
		fadeFrame(UDim2.new(1, 0, 0.35, 0), UDim2.new(0, 0, 0.65, 0), 1.0, 0.0, 90),  -- bot
		fadeFrame(UDim2.new(0.35, 0, 1, 0), UDim2.new(0,    0, 0, 0), 0.0, 1.0, 0),   -- left
		fadeFrame(UDim2.new(0.35, 0, 1, 0), UDim2.new(0.65, 0, 0, 0), 1.0, 0.0, 0),   -- right
	}
end

-- ── Build UI ─────────────────────────────────────────────────────────────────

local function buildUI()
	screenGui = Instance.new("ScreenGui")
	screenGui.Name           = "PhotoModeGui"
	screenGui.ResetOnSpawn   = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder   = 50
	screenGui.Parent         = playerGui

	-- Toggle camera button (always visible) ----------------------------------
	toggleBtn = Instance.new("TextButton")
	toggleBtn.Name                  = "ToggleButton"
	toggleBtn.Size                  = UDim2.fromOffset(56, 56)
	toggleBtn.Position              = UDim2.new(0, 20, 0, 152)  -- top-left, below VAULT (which is below BOOK)
	toggleBtn.BackgroundColor3      = Color3.fromRGB(20, 20, 20)
	toggleBtn.BackgroundTransparency = 0.25
	toggleBtn.TextColor3            = Color3.new(1, 1, 1)
	toggleBtn.Font                  = Enum.Font.GothamBold
	toggleBtn.TextScaled            = true
	toggleBtn.Text                  = "📷"
	toggleBtn.ZIndex                = 10
	toggleBtn.Parent                = screenGui
	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

	buildVignette(screenGui)

	-- Filter strip (bottom center) -------------------------------------------
	controlsFrame = Instance.new("Frame")
	controlsFrame.Name                 = "Controls"
	controlsFrame.Size                 = UDim2.new(1, 0, 0, 64)
	controlsFrame.Position             = UDim2.new(0, 0, 1, -84)
	controlsFrame.BackgroundTransparency = 1
	controlsFrame.Visible              = false
	controlsFrame.ZIndex               = 10
	controlsFrame.Parent               = screenGui

	local row = Instance.new("Frame")
	row.Size                  = UDim2.fromOffset(456, 56)
	row.Position              = UDim2.new(0.5, -228, 0, 4)
	row.BackgroundTransparency = 1
	row.Parent                = controlsFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection      = Enum.FillDirection.Horizontal
	listLayout.Padding            = UDim.new(0, 8)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.VerticalAlignment  = Enum.VerticalAlignment.Center
	listLayout.Parent             = row

	for i, f in FILTERS do
		local btn = Instance.new("TextButton")
		btn.Name                  = "Filter_" .. f.name
		btn.Size                  = UDim2.fromOffset(104, 48)
		btn.BackgroundColor3      = Color3.fromRGB(40, 40, 40)
		btn.BackgroundTransparency = 0.15
		btn.TextColor3            = Color3.fromRGB(240, 240, 240)
		btn.TextScaled            = true
		btn.Font                  = Enum.Font.GothamBold
		btn.Text                  = f.name
		btn.AutoButtonColor       = false
		btn.Parent                = row
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			applyFilter(activeFilterIdx == i and 0 or i)
		end)
		filterButtons[i] = btn
	end

	-- Exit button (top right, replaces toggle while active) ------------------
	exitBtn = Instance.new("TextButton")
	exitBtn.Name                  = "ExitButton"
	exitBtn.Size                  = UDim2.fromOffset(56, 56)
	exitBtn.Position              = UDim2.new(1, -72, 0, 56)
	exitBtn.BackgroundColor3      = Color3.fromRGB(180, 40, 40)
	exitBtn.BackgroundTransparency = 0.1
	exitBtn.TextColor3            = Color3.new(1, 1, 1)
	exitBtn.Font                  = Enum.Font.GothamBold
	exitBtn.TextScaled            = true
	exitBtn.Text                  = "✕"
	exitBtn.Visible               = false
	exitBtn.ZIndex                = 11
	exitBtn.Parent                = screenGui
	Instance.new("UICorner", exitBtn).CornerRadius = UDim.new(0, 8)

	-- Mobile-only on-screen controls -----------------------------------------
	if isMobile() then
		joystickBg = Instance.new("Frame")
		joystickBg.Name              = "JoystickBase"
		joystickBg.Size              = UDim2.fromOffset(140, 140)
		joystickBg.Position          = UDim2.new(0, 30, 1, -170)
		joystickBg.BackgroundColor3  = Color3.fromRGB(0, 0, 0)
		joystickBg.BackgroundTransparency = 0.55
		joystickBg.Visible           = false
		joystickBg.ZIndex            = 10
		joystickBg.Parent            = screenGui
		Instance.new("UICorner", joystickBg).CornerRadius = UDim.new(1, 0)

		joystickThumb = Instance.new("Frame")
		joystickThumb.Name              = "Thumb"
		joystickThumb.Size              = UDim2.fromOffset(60, 60)
		joystickThumb.Position          = UDim2.new(0.5, -30, 0.5, -30)
		joystickThumb.BackgroundColor3  = Color3.fromRGB(255, 255, 255)
		joystickThumb.BackgroundTransparency = 0.15
		joystickThumb.ZIndex            = 11
		joystickThumb.Parent            = joystickBg
		Instance.new("UICorner", joystickThumb).CornerRadius = UDim.new(1, 0)

		local function smallBtn(text: string, sx: number, sy: number, posX: number, posY: number): TextButton
			local b = Instance.new("TextButton")
			b.Size                  = UDim2.fromOffset(sx, sy)
			b.Position              = UDim2.new(1, posX, 1, posY)
			b.BackgroundColor3      = Color3.fromRGB(40, 40, 40)
			b.BackgroundTransparency = 0.3
			b.TextColor3            = Color3.new(1, 1, 1)
			b.Font                  = Enum.Font.GothamBold
			b.TextScaled            = true
			b.Text                  = text
			b.Visible               = false
			b.ZIndex                = 10
			b.Parent                = screenGui
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
			return b
		end

		rollLeftBtn  = smallBtn("↺", 56, 56, -200, -80)
		rollRightBtn = smallBtn("↻", 56, 56, -140, -80)
		fovUpBtn     = smallBtn("FOV+", 56, 40, -200, -150)
		fovDownBtn   = smallBtn("FOV-", 56, 40, -140, -150)

		rollLeftBtn.MouseButton1Down:Connect(function() rollInput = -1 end)
		rollLeftBtn.MouseButton1Up:Connect(function() if rollInput == -1 then rollInput = 0 end end)
		rollRightBtn.MouseButton1Down:Connect(function() rollInput = 1 end)
		rollRightBtn.MouseButton1Up:Connect(function() if rollInput == 1 then rollInput = 0 end end)

		fovUpBtn.MouseButton1Click:Connect(function()
			currentFov = math.clamp(currentFov - 5, FOV_MIN, FOV_MAX)
		end)
		fovDownBtn.MouseButton1Click:Connect(function()
			currentFov = math.clamp(currentFov + 5, FOV_MIN, FOV_MAX)
		end)
	end

	toggleBtn.MouseButton1Click:Connect(function()
		if active then PhotoModeController.exit() else PhotoModeController.enter() end
	end)
	exitBtn.MouseButton1Click:Connect(function() PhotoModeController.exit() end)
end

local function buildEffects()
	ccEffect = Instance.new("ColorCorrectionEffect")
	ccEffect.Name    = "PhotoModeCC"
	ccEffect.Enabled = false
	ccEffect.Parent  = Lighting
end

-- ── Render loop ──────────────────────────────────────────────────────────────

local function onRender(dt: number)
	if keysDown[Enum.KeyCode.Q] then roll += ROLL_SPEED * dt end
	if keysDown[Enum.KeyCode.E] then roll -= ROLL_SPEED * dt end
	if rollInput ~= 0 then roll += rollInput * ROLL_SPEED * dt end

	local moveLocal = Vector3.zero
	if keysDown[Enum.KeyCode.W] then moveLocal += Vector3.new(0, 0, -1) end
	if keysDown[Enum.KeyCode.S] then moveLocal += Vector3.new(0, 0,  1) end
	if keysDown[Enum.KeyCode.A] then moveLocal += Vector3.new(-1, 0, 0) end
	if keysDown[Enum.KeyCode.D] then moveLocal += Vector3.new( 1, 0, 0) end
	if keysDown[Enum.KeyCode.Space] then moveLocal += Vector3.new(0,  1, 0) end
	if keysDown[Enum.KeyCode.LeftControl] or keysDown[Enum.KeyCode.C] then
		moveLocal += Vector3.new(0, -1, 0)
	end
	if touchMoveDelta.Magnitude > 0 then
		moveLocal += Vector3.new(touchMoveDelta.X, 0, -touchMoveDelta.Y)
	end

	if moveLocal.Magnitude > 0 then
		local speed = MOVE_SPEED * ((keysDown[Enum.KeyCode.LeftShift] and SPRINT_MULT) or 1)
		local m  = moveLocal.Unit * speed * dt
		local cf = CFrame.new(photoPos) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
		photoPos = photoPos + cf:VectorToWorldSpace(m)
	end

	camera.CFrame = CFrame.new(photoPos)
		* CFrame.Angles(0, yaw, 0)
		* CFrame.Angles(pitch, 0, 0)
		* CFrame.Angles(0, 0, roll)
	camera.FieldOfView = currentFov
end

-- ── Input wiring ─────────────────────────────────────────────────────────────

local function onInputBegan(input: InputObject, _gp: boolean)
	if not active then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		keysDown[input.KeyCode] = true
		if input.KeyCode == Enum.KeyCode.Escape then
			PhotoModeController.exit()
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		mouseLookActive = true
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
	end
end

local function onInputChanged(input: InputObject, _gp: boolean)
	if not active then return end
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		currentFov = math.clamp(currentFov - input.Position.Z * 5, FOV_MIN, FOV_MAX)
	elseif input.UserInputType == Enum.UserInputType.MouseMovement and mouseLookActive then
		yaw   = yaw - input.Delta.X * LOOK_SENS
		pitch = math.clamp(pitch - input.Delta.Y * LOOK_SENS, -math.pi/2 + 0.1, math.pi/2 - 0.1)
	end
end

local function onInputEnded(input: InputObject)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		keysDown[input.KeyCode] = nil
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		mouseLookActive = false
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

local function onTouchStarted(input: InputObject, _gp: boolean)
	if not active then return end
	if joystickBg and joystickBg.Visible then
		local p, s = joystickBg.AbsolutePosition, joystickBg.AbsoluteSize
		if input.Position.X >= p.X and input.Position.X <= p.X + s.X
			and input.Position.Y >= p.Y and input.Position.Y <= p.Y + s.Y then
			moveTouchId     = input
			moveTouchOrigin = Vector2.new(p.X + s.X/2, p.Y + s.Y/2)
			return
		end
	end
	if not lookTouchId then lookTouchId = input end
end

local function onTouchMoved(input: InputObject, _gp: boolean)
	if not active then return end
	if input == moveTouchId then
		local d = Vector2.new(input.Position.X, input.Position.Y) - moveTouchOrigin
		local maxR = 60
		local cx = math.clamp(d.X, -maxR, maxR)
		local cy = math.clamp(d.Y, -maxR, maxR)
		touchMoveDelta = Vector2.new(cx / maxR, cy / maxR)
		if joystickThumb then
			joystickThumb.Position = UDim2.new(0.5, cx - 30, 0.5, cy - 30)
		end
	elseif input == lookTouchId then
		yaw   = yaw - input.Delta.X * TOUCH_LOOK_SENS
		pitch = math.clamp(pitch - input.Delta.Y * TOUCH_LOOK_SENS, -math.pi/2 + 0.1, math.pi/2 - 0.1)
	end
end

local function onTouchEnded(input: InputObject)
	if input == moveTouchId then
		moveTouchId    = nil
		touchMoveDelta = Vector2.zero
		if joystickThumb then
			joystickThumb.Position = UDim2.new(0.5, -30, 0.5, -30)
		end
	elseif input == lookTouchId then
		lookTouchId = nil
	end
end

-- ── Enter / exit ─────────────────────────────────────────────────────────────

function PhotoModeController.enter()
	if active then return end
	active = true

	savedCameraType    = camera.CameraType
	savedCameraSubject = camera.CameraSubject
	savedFov           = camera.FieldOfView

	local char = localPlayer.Character
	if char then
		for _, d in char:GetDescendants() do
			if d:IsA("BasePart") then
				anchoredParts[d] = d.Anchored
				d.Anchored       = true
			end
		end
	end

	local startCF = camera.CFrame
	photoPos = startCF.Position
	local look = startCF.LookVector
	yaw    = math.atan2(-look.X, -look.Z)
	pitch  = math.asin(math.clamp(look.Y, -0.999, 0.999))
	roll   = 0
	currentFov         = savedFov
	camera.CameraType  = Enum.CameraType.Scriptable
	camera.FieldOfView = currentFov

	for _, gui in playerGui:GetChildren() do
		if gui:IsA("ScreenGui") and gui ~= screenGui then
			hiddenGuis[gui] = gui.Enabled
			gui.Enabled     = false
		end
	end

	toggleBtn.Visible     = false
	exitBtn.Visible       = true
	controlsFrame.Visible = true
	if joystickBg   then joystickBg.Visible   = true end
	if rollLeftBtn  then rollLeftBtn.Visible  = true end
	if rollRightBtn then rollRightBtn.Visible = true end
	if fovUpBtn     then fovUpBtn.Visible     = true end
	if fovDownBtn   then fovDownBtn.Visible   = true end

	ccEffect.Enabled = true
	applyFilter(0)

	renderConn = RunService.RenderStepped:Connect(onRender)
end

function PhotoModeController.exit()
	if not active then return end
	active = false

	if renderConn then renderConn:Disconnect(); renderConn = nil end

	camera.CameraType  = savedCameraType    or Enum.CameraType.Custom
	camera.FieldOfView = savedFov           or 70
	if savedCameraSubject then camera.CameraSubject = savedCameraSubject end

	for part, wasAnchored in anchoredParts do
		if part and part.Parent then part.Anchored = wasAnchored end
	end
	table.clear(anchoredParts)

	for gui, wasEnabled in hiddenGuis do
		if gui and gui.Parent then gui.Enabled = wasEnabled end
	end
	table.clear(hiddenGuis)

	toggleBtn.Visible     = true
	exitBtn.Visible       = false
	controlsFrame.Visible = false
	if joystickBg   then joystickBg.Visible   = false end
	if rollLeftBtn  then rollLeftBtn.Visible  = false end
	if rollRightBtn then rollRightBtn.Visible = false end
	if fovUpBtn     then fovUpBtn.Visible     = false end
	if fovDownBtn   then fovDownBtn.Visible   = false end

	ccEffect.Enabled  = false
	activeFilterIdx   = 0
	setVignetteVisible(false)

	yaw, pitch, roll  = 0, 0, 0
	touchMoveDelta    = Vector2.zero
	rollInput         = 0
	mouseLookActive   = false
	moveTouchId, lookTouchId = nil, nil
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	table.clear(keysDown)
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function PhotoModeController.init()
	buildEffects()
	buildUI()

	UserInputService.InputBegan:Connect(onInputBegan)
	UserInputService.InputChanged:Connect(onInputChanged)
	UserInputService.InputEnded:Connect(onInputEnded)
	UserInputService.TouchStarted:Connect(onTouchStarted)
	UserInputService.TouchMoved:Connect(onTouchMoved)
	UserInputService.TouchEnded:Connect(onTouchEnded)

	-- Safety: bail out of photo mode if the character respawns (anchor refs go stale)
	localPlayer.CharacterAdded:Connect(function()
		if active then PhotoModeController.exit() end
	end)
end

PhotoModeController.init()

return PhotoModeController
