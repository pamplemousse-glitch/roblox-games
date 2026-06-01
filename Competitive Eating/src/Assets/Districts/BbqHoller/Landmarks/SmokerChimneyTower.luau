-- Smoker Chimney Tower — oversized 4-story brick chimney landmark, smoke
-- belching from the top (ParticleEmitter + neon puffs). Visible from across
-- the district. Square brick stack on a concrete pad.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BRICK_RED  = Color3.fromRGB(140, 60, 50)
local BRICK_DARK = Color3.fromRGB(95, 40, 35)
local MORTAR     = Color3.fromRGB(180, 175, 168)
local CONCRETE   = Color3.fromRGB(135, 130, 125)
local STEEL      = Color3.fromRGB(95, 95, 100)
local SMOKE      = Color3.fromRGB(200, 200, 205)
local EMBER      = Color3.fromRGB(255, 128, 48)
local STRAW      = Color3.fromRGB(232, 200, 112)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SmokerChimneyTower", parent)

	-- Concrete pad
	local pad = AB.block(Vector3.new(14, 0.8, 14), CONCRETE, AB.offset(originCF, 0, 0.4, 0), model, "Pad")

	-- 4-story chimney shaft (brick rows, slight taper)
	local rows = 24
	local rowH = 1.4
	for r = 1, rows do
		local y = 1 + (r - 1) * rowH
		local size = 7.5 - (r / rows) * 1.5   -- taper from 7.5 → 6 at top
		local col = (r % 2 == 0) and BRICK_RED or BRICK_DARK
		AB.block(Vector3.new(size, rowH, size), col, AB.offset(originCF, 0, y, 0), model, "Brick_" .. r)
		-- Subtle mortar bands every 3 rows
		if r % 3 == 0 then
			AB.block(Vector3.new(size + 0.2, 0.15, size + 0.2), MORTAR, AB.offset(originCF, 0, y + rowH * 0.4, 0), model, "Mortar_" .. r)
		end
	end

	-- Top cap (thicker stone)
	AB.block(Vector3.new(8, 1.5, 8), CONCRETE, AB.offset(originCF, 0, rows * rowH + 2, 0), model, "TopCap")
	-- Steel grate / opening (dark recess on the cap)
	AB.block(Vector3.new(5, 0.4, 5), Color3.fromRGB(30, 25, 22), AB.offset(originCF, 0, rows * rowH + 2.9, 0), model, "TopOpening")
	-- Steel grate lines
	for i = -2, 2 do
		AB.block(Vector3.new(5, 0.15, 0.2), STEEL, AB.offset(originCF, 0, rows * rowH + 3.05, i * 1.0), model, "Grate_" .. i + 3)
	end

	-- ParticleEmitter on top — bigger smoke than barrel
	local emitAnchor = AB.block(Vector3.new(2, 0.2, 2), Color3.fromRGB(40, 40, 40),
		AB.offset(originCF, 0, rows * rowH + 3.2, 0),
		model, "EmitAnchor")
	emitAnchor.Transparency = 1
	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture       = "rbxasset://textures/particles/smoke_main.dds"
	emitter.Rate          = 28
	emitter.Lifetime      = NumberRange.new(4, 7)
	emitter.Size          = NumberSequence.new({
		NumberSequenceKeypoint.new(0,   3),
		NumberSequenceKeypoint.new(0.4, 7),
		NumberSequenceKeypoint.new(1,   12),
	})
	emitter.Transparency  = NumberSequence.new({
		NumberSequenceKeypoint.new(0,   0.25),
		NumberSequenceKeypoint.new(0.7, 0.55),
		NumberSequenceKeypoint.new(1,   1.0),
	})
	emitter.Color         = ColorSequence.new(SMOKE)
	emitter.Speed         = NumberRange.new(3, 6)
	emitter.SpreadAngle   = Vector2.new(12, 12)
	emitter.Rotation      = NumberRange.new(0, 360)
	emitter.RotSpeed      = NumberRange.new(-30, 30)
	emitter.Acceleration  = Vector3.new(0, 5, 0)
	emitter.LightEmission = 0.1
	emitter.LockedToPart  = false
	emitter.Parent        = emitAnchor

	-- A few neon smoke puffs sitting just above the cap to seed the column
	for i = 1, 5 do
		local puff = AB.sphere(3 + i * 0.5, SMOKE,
			AB.offset(originCF, math.sin(i) * 0.6, rows * rowH + 4 + (i - 1) * 2.5, math.cos(i) * 0.4),
			model, "Puff_" .. i)
		puff.Material     = Enum.Material.Neon
		puff.Transparency = 0.35 + (i - 1) * 0.12
	end

	-- Plaque at the base
	local plaque = AB.block(Vector3.new(6, 1.6, 0.2), STRAW, AB.offset(originCF, 0, 2, 7.1), model, "Plaque")
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = plaque
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBlack
	lbl.Text              = "EST. 1923  ·  THE STACK"
	lbl.TextColor3        = Color3.fromRGB(120, 60, 40)
	lbl.TextScaled        = true
	lbl.Parent            = gui

	-- Glowing ember at the brick base (residual heat)
	local emberGlow = AB.sphere(0.8, EMBER, AB.offset(originCF, 0, 1.8, 5), model, "EmberGlow")
	AB.neon(emberGlow)
	AB.glow(emberGlow, EMBER, 2.5)
	emberGlow.Transparency = 0.4

	AB.pivot(model, pad)
	AB.weldAll(model)
	return model
end
