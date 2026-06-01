-- Donut Shop — pastel pink storefront with neon "DONUTS" sign and a glass
-- display case showing rows of donuts.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local CREAM  = Color3.fromRGB(255, 240, 220)
local NEON   = Color3.fromRGB(255, 90, 160)
local GLASS  = Color3.fromRGB(200, 230, 245)
local ROOF   = Color3.fromRGB(120, 60, 80)
local DOUGH  = Color3.fromRGB(220, 170, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DonutShop", parent)

	AB.block(Vector3.new(36, 0.5, 28), Color3.fromRGB(100, 100, 100),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Pastel pink walls
	AB.block(Vector3.new(36, 14, 1),  PINK, AB.offset(originCF, 0,    7, -13.5), model, "BackWall")
	AB.block(Vector3.new(1,  14, 28), PINK, AB.offset(originCF, -17.5, 7,  0),   model, "LeftWall")
	AB.block(Vector3.new(1,  14, 28), PINK, AB.offset(originCF,  17.5, 7,  0),   model, "RightWall")
	AB.block(Vector3.new(10, 14, 1),  PINK, AB.offset(originCF, -13,  7,  13.5), model, "FrontLeft")
	AB.block(Vector3.new(10, 14, 1),  PINK, AB.offset(originCF,  13,  7,  13.5), model, "FrontRight")
	AB.block(Vector3.new(16, 4,  1),  PINK, AB.offset(originCF,  0,   12, 13.5), model, "FrontHeader")

	-- Glass display case projecting from the front
	local caseFrame = AB.block(Vector3.new(16, 4, 3), CREAM,
		AB.offset(originCF, 0, 3, 15), model, "CaseFrame")
	local caseGlass = AB.block(Vector3.new(15, 3, 2.6), GLASS,
		AB.offset(originCF, 0, 4, 15), model, "CaseGlass")
	caseGlass.Transparency = 0.5
	caseGlass.Material     = Enum.Material.Glass

	-- Donuts on display: 6 small tan/pink stacks behind the glass
	for i = 1, 6 do
		local x = -6.5 + (i - 1) * 2.6
		AB.cylinder(1.4, 0.4, DOUGH, AB.offset(originCF, x, 3.3, 15), model, "DispDonut_" .. i)
		AB.cylinder(1.2, 0.2, PINK,  AB.offset(originCF, x, 3.6, 15), model, "DispGlaze_" .. i)
	end

	-- Neon "DONUTS" sign
	local sign = AB.block(Vector3.new(20, 3, 0.5), NEON,
		AB.offset(originCF, 0, 12.5, 14.1), model, "NeonSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)

	-- Sign supports (cream brackets)
	for i, x in {-9.5, 9.5} do
		AB.block(Vector3.new(0.5, 3, 0.5), CREAM,
			AB.offset(originCF, x, 12.5, 13.85), model, "SignBracket_" .. i)
	end

	-- Roof
	AB.block(Vector3.new(38, 1, 30), ROOF,
		AB.offset(originCF, 0, 14.5, 0), model, "Roof")

	-- Giant donut perched on the roof corner
	AB.circleArrange(AB.offset(originCF, -12, 17.5, -8), 2.2, 10, model, function(i, cf, _)
		return AB.sphere(2.2, PINK, cf, model, "RoofDonut_" .. i)
	end)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
