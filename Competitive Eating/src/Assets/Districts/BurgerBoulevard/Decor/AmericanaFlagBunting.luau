-- AmericanaFlagBunting — patriotic red-white-blue draped bunting on a banner pole.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("AmericanaFlagBunting", parent)
	local RED   = Color3.fromRGB(200, 30, 40)
	local WHITE = Color3.fromRGB(245, 245, 240)
	local BLUE  = Color3.fromRGB(30, 60, 140)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local STAR  = Color3.fromRGB(255, 245, 200)

	-- Top horizontal rope
	AB.cylinder(0.2, 16, CHROME, AB.offset(originCF, 0, 5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "TopRope")

	-- Draped half-circle festoons (4 wedge-shape arcs hanging from rope)
	-- Each "drape" is a series of 3 semicircular bunting bumps
	local function drape(centerX: number, color: Color3, idx: number)
		-- Approximate semicircle with 3 stacked half-discs
		AB.block(Vector3.new(3, 1, 0.2), color, AB.offset(originCF, centerX, 3.8, 0), model, "Drape_" .. idx .. "_Bar")
		-- Tied-down points (small blobs at ends)
		AB.sphere(0.4, CHROME, AB.offset(originCF, centerX - 1.5, 4.6, 0), model, "Drape_" .. idx .. "_TieL")
		AB.sphere(0.4, CHROME, AB.offset(originCF, centerX + 1.5, 4.6, 0), model, "Drape_" .. idx .. "_TieR")
		-- Bottom hanging fringe (rectangles)
		AB.block(Vector3.new(3, 1.2, 0.15), color, AB.offset(originCF, centerX, 2.8, 0), model, "Drape_" .. idx .. "_Fringe")
		-- Star (only if blue)
		if color == BLUE then
			AB.sphere(0.5, STAR, AB.offset(originCF, centerX, 3, 0.1), model, "Drape_" .. idx .. "_Star")
		end
	end

	drape(-6, RED,   1)
	drape(-2, WHITE, 2)
	drape( 2, BLUE,  3)
	drape( 6, RED,   4)

	-- Tassels at each rope tie (small dangling fringes)
	for i, x in {-7, -3, 1, 5, 7} do
		AB.block(Vector3.new(0.1, 1.5, 0.1), CHROME, AB.offset(originCF, x, 3.7, 0), model, "Tassel_" .. i)
	end

	AB.pivot(model, model:FindFirstChild("TopRope"))
	AB.weldAll(model)
	return model
end
