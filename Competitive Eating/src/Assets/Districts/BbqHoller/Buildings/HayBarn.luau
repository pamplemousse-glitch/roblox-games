-- Hay Barn — tall storage barn with a gambrel roof and a big loft opening
-- packed with golden hay bales spilling out. Smaller backdrop sibling to
-- BrisketBarn.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BARN_RED  = Color3.fromRGB(160, 40, 40)
local DARK_RED  = Color3.fromRGB(110, 28, 28)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local HAY       = Color3.fromRGB(232, 200, 112)
local HAY_DARK  = Color3.fromRGB(180, 145, 75)
local TRIM      = Color3.fromRGB(235, 225, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("HayBarn", parent)

	local foundation = AB.block(Vector3.new(24, 0.8, 18), DARK_WOOD, AB.offset(originCF, 0, 0.4, 0), model, "Foundation")

	-- Walls
	AB.block(Vector3.new(24, 18, 1), BARN_RED, AB.offset(originCF,  0, 9.8, -8.5), model, "BackWall")
	AB.block(Vector3.new(1, 18, 18), BARN_RED, AB.offset(originCF, -11.5, 9.8, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 18, 18), BARN_RED, AB.offset(originCF,  11.5, 9.8, 0), model, "RightWall")
	AB.block(Vector3.new(24, 7, 1),  BARN_RED, AB.offset(originCF,  0, 15.3, 8.5), model, "FrontUpper")
	AB.block(Vector3.new(7, 11, 1),  BARN_RED, AB.offset(originCF, -8.5, 6.3, 8.5), model, "FrontL")
	AB.block(Vector3.new(7, 11, 1),  BARN_RED, AB.offset(originCF,  8.5, 6.3, 8.5), model, "FrontR")

	-- Trim
	for i, x in {-11.5, 11.5} do
		AB.block(Vector3.new(0.7, 18, 0.7), TRIM, AB.offset(originCF, x, 9.8, 8.5), model, "TrimC_" .. i)
	end

	-- Loft opening — big rectangle near the top, hay overflow
	AB.block(Vector3.new(7, 5, 1), DARK_RED, AB.offset(originCF, 0, 17.5, 8.4), model, "LoftBack")
	for i = -2, 2 do
		AB.block(Vector3.new(2.4, 1.6, 1.5), HAY, AB.offset(originCF, i * 1.6, 16.5 + math.abs(i) * 0.3, 9.2), model, "HayOver_" .. i + 3)
	end
	-- Loose hay spilling
	AB.block(Vector3.new(6, 1, 1.5), HAY_DARK, AB.offset(originCF, 0, 15, 9.4), model, "HayLoose1")
	AB.block(Vector3.new(4, 0.6, 1.2), HAY, AB.offset(originCF, 0, 14.2, 9.7), model, "HayLoose2")

	-- Ground floor door (closed, simple)
	AB.block(Vector3.new(9, 11, 0.3), DARK_WOOD, AB.offset(originCF, 0, 6.3, 8.85), model, "BigDoor")
	-- Door X-brace
	local dX1 = AB.block(Vector3.new(0.3, 9, 0.3), TRIM, AB.offset(originCF, 0, 6.3, 9.0), model, "DX1")
	dX1.CFrame = dX1.CFrame * CFrame.Angles(0, 0, math.rad(45))
	local dX2 = AB.block(Vector3.new(0.3, 9, 0.3), TRIM, AB.offset(originCF, 0, 6.3, 9.0), model, "DX2")
	dX2.CFrame = dX2.CFrame * CFrame.Angles(0, 0, math.rad(-45))

	-- Gambrel roof
	AB.wedge(Vector3.new(26, 4, 5),  DARK_RED, AB.offset(originCF, 0, 20,    6) * CFrame.Angles(0, math.rad(180), 0), model, "LowRoofF")
	AB.wedge(Vector3.new(26, 4, 5),  DARK_RED, AB.offset(originCF, 0, 20,   -6), model, "LowRoofB")
	AB.wedge(Vector3.new(26, 2.5, 8),DARK_RED, AB.offset(originCF, 0, 23.3,  4) * CFrame.Angles(0, math.rad(180), 0), model, "UpRoofF")
	AB.wedge(Vector3.new(26, 2.5, 8),DARK_RED, AB.offset(originCF, 0, 23.3, -4), model, "UpRoofB")
	AB.block(Vector3.new(26, 0.5, 1.2), DARK_WOOD, AB.offset(originCF, 0, 24.8, 0), model, "Ridge")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
