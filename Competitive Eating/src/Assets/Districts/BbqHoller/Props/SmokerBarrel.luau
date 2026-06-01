-- Smoker Barrel — upright 55-gallon drum smoker with side firebox, stovepipe
-- chimney, two legs, and a continuous ParticleEmitter puffing real smoke
-- (not just neon spheres) out of the stack.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BARREL_BLACK = Color3.fromRGB(45, 38, 35)
local RUST         = Color3.fromRGB(140, 80, 50)
local STEEL        = Color3.fromRGB(120, 120, 125)
local EMBER        = Color3.fromRGB(255, 128, 48)
local DARK_WOOD    = Color3.fromRGB(70, 45, 22)
local SMOKE_GRAY   = Color3.fromRGB(180, 180, 185)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SmokerBarrel", parent)

	-- Main horizontal drum (kettle-style smoker lays on its side)
	local body = AB.cylinder(4.5, 6.5, BARREL_BLACK, AB.offset(originCF, 0, 3.5, 0), model, "Body")
	-- Rust streaks (4 thin stripes)
	for i = 1, 4 do
		local angle = (i / 4) * math.pi * 2
		AB.cylinder(4.6, 0.3, RUST, AB.offset(originCF, 0, 3.5, 0) * CFrame.Angles(0, angle, 0), model, "RustBand_" .. i)
	end
	-- Drum end caps
	AB.sphere(4.4, BARREL_BLACK, AB.offset(originCF, 0, 3.5, 0), model, "BodyCore")

	-- Lid (top half rendered as a slight raise — kettle look)
	AB.cylinder(4.6, 0.4, BARREL_BLACK, AB.offset(originCF, 0, 5.9, 0), model, "Lid")
	-- Lid handle
	AB.block(Vector3.new(1.2, 0.4, 0.6), DARK_WOOD, AB.offset(originCF, 0, 6.2, 0), model, "LidHandle")

	-- Stovepipe chimney (vertical, on the back side)
	for layer = 1, 3 do
		AB.cylinder(0.9, 1.8, STEEL, AB.offset(originCF, 0, 6.5 + (layer - 1) * 1.8, -1.6), model, "Stack_" .. layer)
	end
	-- Cap
	AB.cylinder(1.2, 0.3, STEEL, AB.offset(originCF, 0, 11.4, -1.6), model, "StackCap")

	-- Stack emitter (ParticleEmitter for real smoke flow)
	local emitterPart = AB.cylinder(0.4, 0.2, BARREL_BLACK, AB.offset(originCF, 0, 11.7, -1.6), model, "EmitAnchor")
	emitterPart.Transparency = 1
	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture       = "rbxasset://textures/particles/smoke_main.dds"
	emitter.Rate          = 18
	emitter.Lifetime      = NumberRange.new(2.5, 4.5)
	emitter.Size          = NumberSequence.new({
		NumberSequenceKeypoint.new(0,   1.0),
		NumberSequenceKeypoint.new(0.5, 3.0),
		NumberSequenceKeypoint.new(1,   5.0),
	})
	emitter.Transparency  = NumberSequence.new({
		NumberSequenceKeypoint.new(0,   0.3),
		NumberSequenceKeypoint.new(0.7, 0.6),
		NumberSequenceKeypoint.new(1,   1.0),
	})
	emitter.Color         = ColorSequence.new(SMOKE_GRAY)
	emitter.Speed         = NumberRange.new(2, 4)
	emitter.SpreadAngle   = Vector2.new(15, 15)
	emitter.Rotation      = NumberRange.new(0, 360)
	emitter.RotSpeed      = NumberRange.new(-30, 30)
	emitter.Acceleration  = Vector3.new(0, 3, 0)
	emitter.LightEmission = 0.1
	emitter.LockedToPart  = false
	emitter.Parent        = emitterPart

	-- Side firebox (smaller drum offset to one side)
	AB.block(Vector3.new(2.6, 2.4, 2.6), RUST, AB.offset(originCF, 4.2, 2.5, 0), model, "Firebox")
	-- Firebox door
	AB.block(Vector3.new(0.2, 1.6, 1.6), STEEL, AB.offset(originCF, 5.6, 2.5, 0), model, "FireboxDoor")
	-- Ember glow inside firebox
	local glow = AB.sphere(0.7, EMBER, AB.offset(originCF, 4.2, 2.5, 0), model, "FireGlow")
	AB.neon(glow)
	AB.glow(glow, EMBER, 2.5)

	-- Legs (2)
	AB.block(Vector3.new(0.5, 3.2, 0.5), DARK_WOOD, AB.offset(originCF, -2.5, 1.6, 1.6), model, "LegL1")
	AB.block(Vector3.new(0.5, 3.2, 0.5), DARK_WOOD, AB.offset(originCF,  2.5, 1.6, 1.6), model, "LegR1")
	AB.block(Vector3.new(0.5, 3.2, 0.5), DARK_WOOD, AB.offset(originCF, -2.5, 1.6, -1.6), model, "LegL2")
	AB.block(Vector3.new(0.5, 3.2, 0.5), DARK_WOOD, AB.offset(originCF,  2.5, 1.6, -1.6), model, "LegR2")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
