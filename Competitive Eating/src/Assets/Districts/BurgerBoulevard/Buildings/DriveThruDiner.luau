-- DriveThruDiner — 50s diner with red booths, chrome trim, neon "EAT" sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CHROME      = Color3.fromRGB(176, 176, 176)
local TEAL_50S    = Color3.fromRGB(127, 202, 194)
local NEON_RED    = Color3.fromRGB(255, 48, 48)
local CREAM       = Color3.fromRGB(255, 245, 232)
local BOOTH_RED   = Color3.fromRGB(180, 30, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DriveThruDiner", parent)

	-- Foundation (checkered diner floor — single block, color suggests pattern)
	local foundation = AB.block(
		Vector3.new(36, 0.5, 22),
		Color3.fromRGB(220, 220, 215),
		AB.offset(originCF, 0, 0.25, 0),
		model,
		"Foundation"
	)

	-- Back & side walls (cream)
	AB.block(Vector3.new(36, 12, 1), CREAM, AB.offset(originCF, 0, 6.5, -10.5), model, "BackWall")
	AB.block(Vector3.new(1, 12, 22), CREAM, AB.offset(originCF, -17.5, 6.5, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 12, 22), CREAM, AB.offset(originCF,  17.5, 6.5, 0), model, "RightWall")

	-- Front wall lower (with doorway gap)
	AB.block(Vector3.new(13, 12, 1), CREAM, AB.offset(originCF, -11.5, 6.5, 10.5), model, "FrontLeft")
	AB.block(Vector3.new(13, 12, 1), CREAM, AB.offset(originCF,  11.5, 6.5, 10.5), model, "FrontRight")
	AB.block(Vector3.new(10, 4,  1), CREAM, AB.offset(originCF,  0,    10.5,10.5), model, "FrontHeader")

	-- Chrome trim band (the classic 50s detail)
	local trimY = 4
	for i, z in {-10.5, 10.5} do
		local trim = AB.block(
			Vector3.new(36, 0.6, 0.3),
			CHROME,
			AB.offset(originCF, 0, trimY, z),
			model,
			"ChromeTrim_" .. i
		)
		trim.Material   = Enum.Material.Metal
		trim.Reflectance = 0.4
	end
	-- Side trim
	for i, x in {-17.5, 17.5} do
		local trim = AB.block(
			Vector3.new(0.3, 0.6, 22),
			CHROME,
			AB.offset(originCF, x, trimY, 0),
			model,
			"SideTrim_" .. i
		)
		trim.Material   = Enum.Material.Metal
		trim.Reflectance = 0.4
	end

	-- Teal accent stripe above chrome
	for i, z in {-10.5, 10.5} do
		AB.block(
			Vector3.new(36, 1.2, 0.4),
			TEAL_50S,
			AB.offset(originCF, 0, 5, z),
			model,
			"TealStripe_" .. i
		)
	end

	-- Curved roof (a flat slab with chrome trim — single block, simplified)
	local roof = AB.block(
		Vector3.new(38, 0.8, 24),
		CHROME,
		AB.offset(originCF, 0, 13, 0),
		model,
		"Roof"
	)
	roof.Material   = Enum.Material.Metal
	roof.Reflectance = 0.3

	-- Neon "EAT" sign (a glowing red bar on a pole)
	AB.block(Vector3.new(1, 8, 1), CHROME, AB.offset(originCF, 0, 17, -5), model, "SignPole")
	local sign = AB.block(
		Vector3.new(8, 4, 0.6),
		NEON_RED,
		AB.offset(originCF, 0, 19, -5),
		model,
		"EatSign"
	)
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3.0)

	-- Drive-thru window awning (red striped)
	AB.block(Vector3.new(8, 0.4, 3), BOOTH_RED, AB.offset(originCF, -10, 9, 12), model, "DriveAwning")

	-- Drive-thru speaker post
	AB.block(Vector3.new(0.6, 5, 0.6), CHROME, AB.offset(originCF, -22, 2.5, 8), model, "SpeakerPost")
	AB.block(Vector3.new(1.4, 1.4, 1.4), Color3.fromRGB(50, 50, 50), AB.offset(originCF, -22, 5.5, 8), model, "Speaker")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
