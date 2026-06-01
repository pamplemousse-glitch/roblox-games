-- Parmesan Shaker Set — wooden tray with parmesan shaker, red pepper flake
-- shaker, salt + pepper, and small jars.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD     = Color3.fromRGB(110, 75, 45)
local CHROME = Color3.fromRGB(220, 220, 230)
local WHITE  = Color3.fromRGB(245, 240, 230)
local CHEESE = Color3.fromRGB(245, 230, 175)
local CHILI  = Color3.fromRGB(210, 50, 50)
local PEP_BL = Color3.fromRGB(40, 40, 40)
local LID_R  = Color3.fromRGB(180, 30, 40)
local GLASS  = Color3.fromRGB(220, 240, 255)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ParmesanShakerSet", parent)

	-- Wooden tray
	AB.block(Vector3.new(5, 0.3, 2), WD, AB.offset(originCF, 0, 0.15, 0), model, "Tray")
	AB.block(Vector3.new(5.2, 0.4, 2.2), Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, 0, 0.5, 0), model, "TrayRim")

	-- Parmesan shaker (tall white cylinder, red lid)
	AB.cylinder(0.7, 2.5, WHITE, AB.offset(originCF, -1.7, 1.5, 0), model, "ParmShaker")
	AB.cylinder(0.75, 0.4, LID_R, AB.offset(originCF, -1.7, 2.9, 0), model, "ParmLid")
	-- Holes in lid (small dark dots)
	for i = 0, 5 do
		local angle = i / 6 * 2 * math.pi
		AB.cylinder(0.08, 0.05, PEP_BL,
			AB.offset(originCF, -1.7 + math.cos(angle) * 0.4, 3.12, math.sin(angle) * 0.4) * CFrame.Angles(0, 0, math.rad(90)),
			model, "ParmHole_" .. i)
	end
	-- Parmesan grains visible inside
	AB.cylinder(0.65, 1.8, CHEESE, AB.offset(originCF, -1.7, 1.5, 0), model, "ParmContent")
	-- Label
	AB.block(Vector3.new(1.2, 0.6, 0.05), Color3.fromRGB(110, 30, 40),
		AB.offset(originCF, -1.7, 1.5, 0.75), model, "ParmLabel")

	-- Red pepper flake shaker (similar)
	AB.cylinder(0.7, 2.5, WHITE, AB.offset(originCF, 1.7, 1.5, 0), model, "ChiliShaker")
	AB.cylinder(0.75, 0.4, CHILI, AB.offset(originCF, 1.7, 2.9, 0), model, "ChiliLid")
	for i = 0, 5 do
		local angle = i / 6 * 2 * math.pi
		AB.cylinder(0.08, 0.05, PEP_BL,
			AB.offset(originCF, 1.7 + math.cos(angle) * 0.4, 3.12, math.sin(angle) * 0.4) * CFrame.Angles(0, 0, math.rad(90)),
			model, "ChiliHole_" .. i)
	end
	AB.cylinder(0.65, 1.8, CHILI, AB.offset(originCF, 1.7, 1.5, 0), model, "ChiliContent")
	AB.block(Vector3.new(1.2, 0.6, 0.05), CHILI,
		AB.offset(originCF, 1.7, 1.5, 0.75), model, "ChiliLabel")

	-- Salt + pepper grinder pair in middle
	AB.cylinder(0.5, 2, WD, AB.offset(originCF, -0.5, 1.3, 0), model, "Salt")
	AB.cylinder(0.5, 0.3, CHROME, AB.offset(originCF, -0.5, 2.4, 0), model, "SaltKnob")
	AB.cylinder(0.5, 2, PEP_BL, AB.offset(originCF, 0.5, 1.3, 0), model, "Pepper")
	AB.cylinder(0.5, 0.3, CHROME, AB.offset(originCF, 0.5, 2.4, 0), model, "PepperKnob")

	-- A small glass jar of olives in back
	AB.cylinder(0.6, 1, GLASS, AB.offset(originCF, -2.5, 0.9, -0.8), model, "OliveJar")
	AB.cylinder(0.65, 0.2, LID_R, AB.offset(originCF, -2.5, 1.5, -0.8), model, "OliveJarLid")
	-- Olives inside (tiny dark green dots)
	for i = 1, 4 do
		AB.sphere(0.15, Color3.fromRGB(60, 90, 40),
			AB.offset(originCF, -2.5 + math.cos(i) * 0.2, 0.7 + i * 0.15, -0.8 + math.sin(i) * 0.2), model, "Olive_" .. i)
	end

	-- Small bottle of balsamic
	AB.cylinder(0.4, 1.5, Color3.fromRGB(50, 30, 25), AB.offset(originCF, 2.5, 1, -0.8), model, "Balsamic")
	AB.cylinder(0.2, 0.4, Color3.fromRGB(50, 30, 25), AB.offset(originCF, 2.5, 1.95, -0.8), model, "BalsamicNeck")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
