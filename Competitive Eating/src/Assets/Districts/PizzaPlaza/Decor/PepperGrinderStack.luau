-- Pepper Grinder Stack — wooden pepper grinders of various heights stacked
-- in a display, like in a fancy restaurant.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DK_WD  = Color3.fromRGB(80, 50, 30)
local MD_WD  = Color3.fromRGB(110, 75, 45)
local LT_WD  = Color3.fromRGB(160, 120, 75)
local CHROME = Color3.fromRGB(220, 220, 230)
local BRASS  = Color3.fromRGB(200, 160, 80)

local function grinder(model, originCF, x, height, color, name)
	-- Body
	AB.cylinder(0.6, height, color, AB.offset(originCF, x, height / 2 + 0.4, 0), model, name .. "_Body")
	-- Crank knob
	AB.cylinder(0.6, 0.4, CHROME, AB.offset(originCF, x, height + 0.4, 0), model, name .. "_Knob")
	-- Crank wheel on top
	AB.sphere(0.3, BRASS, AB.offset(originCF, x, height + 0.7, 0), model, name .. "_Crank")
	-- Bottom band
	AB.cylinder(0.65, 0.2, CHROME, AB.offset(originCF, x, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, name .. "_BotBand")
	-- Grind hole at bottom
	AB.cylinder(0.4, 0.1, Color3.fromRGB(35, 30, 25),
		AB.offset(originCF, x, 0.3, 0) * CFrame.Angles(0, 0, math.rad(90)), model, name .. "_GrindHole")
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PepperGrinderStack", parent)

	-- Wooden tray
	AB.block(Vector3.new(6, 0.3, 1.5), MD_WD, AB.offset(originCF, 0, 0.15, 0), model, "Tray")
	AB.block(Vector3.new(6.2, 0.4, 1.7), DK_WD, AB.offset(originCF, 0, 0.4, 0), model, "TrayRim")

	-- 5 grinders in descending heights (left to right)
	grinder(model, originCF, -2.4, 5,   DK_WD, "Grinder1")
	grinder(model, originCF, -1.2, 4.2, MD_WD, "Grinder2")
	grinder(model, originCF, 0,    3.5, LT_WD, "Grinder3")
	grinder(model, originCF, 1.2,  4.8, DK_WD, "Grinder4")
	grinder(model, originCF, 2.4,  3,   MD_WD, "Grinder5")

	-- Pepper corns scattered around base
	for i = 1, 12 do
		AB.sphere(0.1, Color3.fromRGB(40, 30, 25),
			AB.offset(originCF, (math.random() - 0.5) * 5, 0.45, (math.random() - 0.5) * 1.2), model, "Corn_" .. i)
	end

	-- A scrap of paper with a recipe
	AB.block(Vector3.new(1.6, 0.05, 1.2), Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, -2, 0.5, -1.1) * CFrame.Angles(math.rad(5), math.rad(15), 0), model, "RecipeNote")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
