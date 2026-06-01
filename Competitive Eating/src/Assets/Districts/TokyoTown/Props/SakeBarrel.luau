-- Sake Barrel — straw-wrapped cylindrical kazaridaru with a vermilion top
-- band + kanji-style band marker. Standalone prop.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STRAW       = Color3.fromRGB(230, 200, 140)
local STRAW_DARK  = Color3.fromRGB(180, 150, 100)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SakeBarrel", parent)

	-- Main barrel body
	local body = AB.cylinder(3.4, 4, STRAW,
		AB.offset(originCF, 0, 2, 0), model, "Body")

	-- Straw rope wrapping (3 dark bands around)
	for i, y in {0.7, 2, 3.3} do
		AB.cylinder(3.45, 0.25, STRAW_DARK,
			AB.offset(originCF, 0, y, 0), model, "RopeBand_" .. i)
	end

	-- Top vermilion lid
	AB.cylinder(3.45, 0.4, VERMILION,
		AB.offset(originCF, 0, 4.2, 0), model, "TopLid")
	-- Top glowing center label
	local label = AB.cylinder(2, 0.1, PAPER_WHITE,
		AB.offset(originCF, 0, 4.45, 0), model, "TopLabel")
	AB.neon(label)
	AB.glow(label, LANTERN_Y, 1)

	-- Bottom dark wood lid
	AB.cylinder(3.45, 0.3, DARK_WOOD,
		AB.offset(originCF, 0, 0.15, 0), model, "BottomLid")

	-- Side vermilion paper label (front)
	AB.block(Vector3.new(2.4, 2.6, 0.1), VERMILION,
		AB.offset(originCF, 0, 2.2, 1.75), model, "SideLabel")
	-- Label paper border
	AB.block(Vector3.new(2.6, 2.8, 0.05), PAPER_WHITE,
		AB.offset(originCF, 0, 2.2, 1.7), model, "LabelBorder")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
