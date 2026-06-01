-- Katakana Neon — wall-mounted neon-light sign, 5 stacked colored tubes
-- arranged in vertical katakana-strokes-style pattern. Pure decor backdrop.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local NEON_PINK   = Color3.fromRGB(255, 90, 170)
local NEON_CYAN   = Color3.fromRGB(140, 220, 230)
local NEON_YELLOW = Color3.fromRGB(255, 220, 100)
local NEON_GREEN  = Color3.fromRGB(100, 255, 140)
local NEON_RED    = Color3.fromRGB(255, 80, 90)

local STROKES = {
	{NEON_PINK,   Vector3.new(0.3, 0.25, 4), Vector3.new(-1.0, 6.0, 0), 0},
	{NEON_CYAN,   Vector3.new(0.3, 0.25, 3), Vector3.new( 0.5, 5.0, 0), 0},
	{NEON_YELLOW, Vector3.new(0.25, 0.25, 2.5), Vector3.new( 1.5, 6.5, 0), math.rad(20)},
	{NEON_GREEN,  Vector3.new(0.3, 0.25, 3.5), Vector3.new(-0.5, 3.0, 0), 0},
	{NEON_RED,    Vector3.new(0.25, 0.25, 2), Vector3.new( 1.0, 4.0, 0), math.rad(-30)},
}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("KatakanaNeon", parent)

	-- Dark backplate
	AB.block(Vector3.new(6, 9, 0.3), DARK_METAL,
		AB.offset(originCF, 0, 4.5, 0), model, "Backplate")
	-- Backplate frame
	AB.block(Vector3.new(6.4, 0.3, 0.4), DARK_METAL, AB.offset(originCF, 0, 9.15, 0.05), model, "FrameTop")
	AB.block(Vector3.new(6.4, 0.3, 0.4), DARK_METAL, AB.offset(originCF, 0, -0.15, 0.05), model, "FrameBot")
	AB.block(Vector3.new(0.3, 9, 0.4),   DARK_METAL, AB.offset(originCF, -3.15, 4.5, 0.05), model, "FrameL")
	AB.block(Vector3.new(0.3, 9, 0.4),   DARK_METAL, AB.offset(originCF,  3.15, 4.5, 0.05), model, "FrameR")

	-- Neon stroke segments
	for i, stroke in STROKES do
		local color, size, pos, yaw = stroke[1], stroke[2], stroke[3], stroke[4]
		local cf = AB.offset(originCF, pos.X, pos.Y, pos.Z) * CFrame.Angles(0, 0, yaw)
		local tube = AB.part({
			size  = size,
			color = color,
			cf    = cf,
			name  = "Stroke_" .. i,
		}, model)
		AB.neon(tube)
		AB.glow(tube, color, 2)
	end

	-- A central bigger emblem (vermilion-pink circle)
	local emblem = AB.cylinder(2.6, 0.2, NEON_PINK,
		AB.offset(originCF, 0, 4.5, 0.2), model, "Emblem")
	AB.neon(emblem)
	AB.glow(emblem, NEON_PINK, 3)
	-- Inner dot
	local emblemDot = AB.sphere(0.8, NEON_YELLOW,
		AB.offset(originCF, 0, 4.5, 0.3), model, "EmblemDot")
	AB.neon(emblemDot)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
