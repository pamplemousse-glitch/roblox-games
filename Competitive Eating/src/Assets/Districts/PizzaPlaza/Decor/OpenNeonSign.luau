-- Open Neon Sign — small standalone "OPEN" neon sign on a base, perfect
-- for placing in a window or beside a door.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local FRAME    = Color3.fromRGB(35, 35, 40)
local NEON_BLU = Color3.fromRGB(80, 200, 255)
local NEON_RED = Color3.fromRGB(255, 60, 60)
local CHAIN    = Color3.fromRGB(80, 70, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("OpenNeonSign", parent)

	-- Frame
	AB.block(Vector3.new(4, 2.5, 0.4), FRAME, AB.offset(originCF, 0, 2.5, 0), model, "Frame")
	-- Outer border (slightly larger)
	AB.block(Vector3.new(4.2, 2.7, 0.3), FRAME, AB.offset(originCF, 0, 2.5, -0.1), model, "Border")

	-- "OPEN" letters as 4 cylindrical blocks (one per letter, neon)
	for i, lbl in {"O", "P", "E", "N"} do
		local x = -1.5 + (i - 1) * 1
		local color = (i % 2 == 0) and NEON_BLU or NEON_RED
		local letter = AB.block(Vector3.new(0.8, 1.5, 0.3), color, AB.offset(originCF, x, 2.7, 0.25), model, "Letter_" .. lbl)
		AB.neon(letter)
		AB.glow(letter, letter.Color, 1.5)
		-- Letter inner hole (for O, P)
		if lbl == "O" or lbl == "P" then
			AB.block(Vector3.new(0.3, 0.6, 0.4), FRAME, AB.offset(originCF, x, 2.7, 0.3), model, "LetterHole_" .. lbl)
		end
	end

	-- "WE'RE" sub-text (small neon)
	local sub = AB.block(Vector3.new(2, 0.4, 0.2), NEON_RED, AB.offset(originCF, 0, 3.6, 0.25), model, "SubText")
	AB.neon(sub)
	AB.glow(sub, sub.Color, 1)

	-- Hanging chains
	AB.cylinder(0.08, 1.2, CHAIN, AB.offset(originCF, -1.8, 4.4, 0), model, "ChainL")
	AB.cylinder(0.08, 1.2, CHAIN, AB.offset(originCF,  1.8, 4.4, 0), model, "ChainR")

	-- Suction cup hangers (small black dots)
	AB.sphere(0.2, FRAME, AB.offset(originCF, -1.8, 5, 0), model, "SuctionL")
	AB.sphere(0.2, FRAME, AB.offset(originCF,  1.8, 5, 0), model, "SuctionR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
