-- NeonMotel — pink stucco motel, two-row of rooms, glowing "VACANCY" sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK_STUCCO = Color3.fromRGB(255, 200, 214)
local DEEP_PINK   = Color3.fromRGB(255, 130, 180)
local CHROME      = Color3.fromRGB(176, 176, 176)
local NEON_RED    = Color3.fromRGB(255, 48, 48)
local NEON_PINK   = Color3.fromRGB(255, 100, 180)
local CREAM       = Color3.fromRGB(255, 245, 232)
local TEAL        = Color3.fromRGB(127, 202, 194)
local SKY         = Color3.fromRGB(135, 206, 235)
local DARK_TEAL   = Color3.fromRGB(40, 70, 75)
local TILE_BROWN  = Color3.fromRGB(110, 70, 50)
local BLACK       = Color3.fromRGB(30, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("NeonMotel", parent)

	-- Concrete foundation
	local foundation = AB.block(Vector3.new(50, 0.6, 14), Color3.fromRGB(95, 95, 95), AB.offset(originCF, 0, 0.3, 0), model, "Foundation")
	foundation.Material = Enum.Material.Concrete

	-- Long pink stucco motel block (back row of rooms)
	local main = AB.block(Vector3.new(50, 9, 12), PINK_STUCCO, AB.offset(originCF, 0, 5.1, -1), model, "MotelBody")
	main.Material = Enum.Material.SmoothPlastic

	-- 6 doors along the front (motel-room doors with chrome numbers)
	for i = 0, 5 do
		local x = -20 + i * 8
		-- Door recess (dark)
		AB.block(Vector3.new(3, 6, 0.5), DARK_TEAL, AB.offset(originCF, x, 3.5, 5.05), model, "Door_" .. i)
		-- Chrome door handle
		AB.sphere(0.5, CHROME, AB.offset(originCF, x + 1.2, 3.5, 5.3), model, "DoorKnob_" .. i)
		-- Room number plate (small cream rectangle above door)
		local plate = AB.block(Vector3.new(1.5, 1, 0.4), CREAM, AB.offset(originCF, x, 7, 5.2), model, "Plate_" .. i)
		AB.billboard(plate, "10" .. i, Vector2.new(60, 50), 0)
		-- Window beside each door
		local win = AB.block(Vector3.new(3, 3, 0.4), SKY, AB.offset(originCF, x + 3.5, 4, 5.05), model, "Window_" .. i)
		win.Material = Enum.Material.Glass; win.Transparency = 0.5
		AB.block(Vector3.new(3.4, 0.3, 0.5), TEAL, AB.offset(originCF, x + 3.5, 5.55, 5.15), model, "WinT_" .. i)
		AB.block(Vector3.new(3.4, 0.3, 0.5), TEAL, AB.offset(originCF, x + 3.5, 2.45, 5.15), model, "WinB_" .. i)
	end

	-- Walkway/covered porch along the front
	AB.block(Vector3.new(50, 0.5, 4), TEAL, AB.offset(originCF, 0, 9.5, 7), model, "PorchRoof")
	-- Porch support poles (chrome)
	for i = 0, 6 do
		local x = -24 + i * 8
		AB.cylinder(0.5, 9.4, CHROME, AB.offset(originCF, x, 4.7, 9), model, "PorchPole_" .. i)
	end

	-- Flat roof + parapet
	AB.block(Vector3.new(51, 1, 13), CHROME, AB.offset(originCF, 0, 10.15, -1), model, "Roof").Material = Enum.Material.Metal
	AB.block(Vector3.new(51, 1.2, 0.3), TEAL, AB.offset(originCF, 0, 10.65, 5.1), model, "Parapet")

	-- Iconic neon pylon sign at the corner (left)
	AB.cylinder(1.5, 22, CHROME, AB.offset(originCF, -25, 11, 6), model, "PylonPole")
	-- Sign body (vertical tall rectangle)
	local pylon = AB.block(Vector3.new(8, 16, 1), CREAM, AB.offset(originCF, -25, 18, 6), model, "PylonBoard")
	-- Star at top
	local star = AB.sphere(3.5, NEON_PINK, AB.offset(originCF, -25, 27, 6), model, "PylonStar")
	AB.neon(star); AB.glow(star, NEON_PINK, 3.0)
	-- Neon body inset
	local neonBody = AB.block(Vector3.new(6, 14, 1.2), NEON_PINK, AB.offset(originCF, -25, 18, 6.4), model, "PylonNeon")
	AB.neon(neonBody); AB.glow(neonBody, NEON_PINK, 2.5)
	AB.billboard(pylon, "PINK\nFLAMINGO\nMOTEL", Vector2.new(160, 280), 0)

	-- "VACANCY" sub-sign on pylon
	local vacancy = AB.block(Vector3.new(7, 2, 1.2), NEON_RED, AB.offset(originCF, -25, 9, 6.4), model, "VacancySign")
	AB.neon(vacancy); AB.glow(vacancy, NEON_RED, 2.5)
	AB.billboard(vacancy, "VACANCY", Vector2.new(200, 60), 0)

	-- Pool out front (turquoise water rectangle) — for vibe
	local pool = AB.block(Vector3.new(10, 0.5, 4), TEAL, AB.offset(originCF, 12, 0.55, 9), model, "Pool")
	pool.Material = Enum.Material.Water
	pool.Transparency = 0.25
	-- Pool edge tile
	AB.block(Vector3.new(11, 0.3, 5), CREAM, AB.offset(originCF, 12, 0.45, 9), model, "PoolEdge")

	-- Lounge chair beside pool
	AB.block(Vector3.new(1.5, 0.4, 4), DEEP_PINK, AB.offset(originCF, 18, 1, 9), model, "LoungeChair")
	AB.cylinder(0.4, 1.5, CHROME, AB.offset(originCF, 18, 1.3, 7), model, "LoungeChairLeg1")
	AB.cylinder(0.4, 1.5, CHROME, AB.offset(originCF, 18, 1.3, 11), model, "LoungeChairLeg2")

	-- Palm tree planter beside pool
	AB.cylinder(1.5, 1.5, TILE_BROWN, AB.offset(originCF, 6, 1, 9), model, "PalmPlanter")
	AB.cylinder(0.8, 6, TILE_BROWN, AB.offset(originCF, 6, 5, 9), model, "PalmTrunk")
	for i = 0, 5 do
		local angle = (i / 6) * 2 * math.pi
		AB.block(Vector3.new(0.4, 0.3, 3), Color3.fromRGB(80, 180, 90), AB.offset(originCF, 6 + math.cos(angle) * 1.5, 8.5, 9 + math.sin(angle) * 1.5) * CFrame.Angles(0, -angle, math.rad(-15)), model, "PalmFrond_" .. i)
	end

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
