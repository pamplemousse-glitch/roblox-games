-- Ciao Mural — small wall-mounted hand-painted "CIAO" sign in red on cream.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CREAM     = Color3.fromRGB(245, 230, 200)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local NEON_RED  = Color3.fromRGB(255, 60, 40)
local FLAG_GRN  = Color3.fromRGB(80, 140, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CiaoMural", parent)

	-- Backing board
	AB.block(Vector3.new(5, 3, 0.3), CREAM, AB.offset(originCF, 0, 2, 0), model, "Back")
	-- Wood frame
	AB.block(Vector3.new(5.4, 0.3, 0.4), DK_WD, AB.offset(originCF, 0, 3.5, 0), model, "FrameTop")
	AB.block(Vector3.new(5.4, 0.3, 0.4), DK_WD, AB.offset(originCF, 0, 0.5, 0), model, "FrameBot")
	AB.block(Vector3.new(0.3, 3, 0.4), DK_WD, AB.offset(originCF, -2.65, 2, 0), model, "FrameL")
	AB.block(Vector3.new(0.3, 3, 0.4), DK_WD, AB.offset(originCF,  2.65, 2, 0), model, "FrameR")

	-- "CIAO" as 4 letter blocks
	for i, lbl in {"C", "I", "A", "O"} do
		local x = -1.6 + (i - 1) * 1.1
		local letter = AB.block(Vector3.new(0.8, 1.4, 0.2), NEON_RED,
			AB.offset(originCF, x, 2.2, 0.18), model, "Letter_" .. lbl)
		AB.neon(letter)
		AB.glow(letter, letter.Color, 1.2)
	end

	-- Small Italian flag accent in upper-left
	AB.block(Vector3.new(0.4, 0.4, 0.05), FLAG_GRN, AB.offset(originCF, -2, 3.1, 0.18), model, "FlagG")
	AB.block(Vector3.new(0.4, 0.4, 0.05), CREAM,    AB.offset(originCF, -1.6, 3.1, 0.18), model, "FlagW")
	AB.block(Vector3.new(0.4, 0.4, 0.05), NEON_RED, AB.offset(originCF, -1.2, 3.1, 0.18), model, "FlagR")

	-- Tiny heart
	AB.sphere(0.25, NEON_RED, AB.offset(originCF, 2, 3, 0.2), model, "Heart")

	-- Mount nails (small)
	AB.sphere(0.12, DK_WD, AB.offset(originCF, -2.4, 3.2, 0.4), model, "Nail1")
	AB.sphere(0.12, DK_WD, AB.offset(originCF,  2.4, 3.2, 0.4), model, "Nail2")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
