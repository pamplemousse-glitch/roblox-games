-- Kindergarten Pull Cart — bright yellow wagon-style cart with red trim
-- and a long pull handle. The carts kindergartens roll groups of toddlers
-- in around Tokyo neighborhoods.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local YELLOW      = Color3.fromRGB(255, 210, 70)
local YELLOW_DARK = Color3.fromRGB(210, 170, 50)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local METAL_GREY  = Color3.fromRGB(110, 110, 120)
local FACE_PINK   = Color3.fromRGB(255, 200, 170)
local HAT_BLUE    = Color3.fromRGB(80, 130, 180)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("KindergartenPullCart", parent)

	-- Cart bed (open box on top of axles)
	AB.block(Vector3.new(8, 0.6, 3.5), YELLOW,
		AB.offset(originCF, 0, 1.6, 0), model, "CartBed")
	-- Side walls
	for i, z in {-1.8, 1.8} do
		AB.block(Vector3.new(8, 1.6, 0.3), YELLOW,
			AB.offset(originCF, 0, 2.6, z), model, "CartSide_" .. i)
	end
	-- Front + back walls
	for i, x in {-4, 4} do
		AB.block(Vector3.new(0.3, 1.6, 3.5), YELLOW,
			AB.offset(originCF, x, 2.6, 0), model, "CartEnd_" .. i)
	end
	-- Red trim band around top edge
	AB.block(Vector3.new(8.1, 0.3, 3.6), VERMILION,
		AB.offset(originCF, 0, 3.45, 0), model, "TrimTop")

	-- 4 wheels
	for i, offset in {
		Vector3.new(-3, 0.9, -1.5),
		Vector3.new( 3, 0.9, -1.5),
		Vector3.new(-3, 0.9,  1.5),
		Vector3.new( 3, 0.9,  1.5),
	} do
		AB.cylinder(1.6, 0.5, IRON_BLACK,
			AB.offset(originCF, offset.X, offset.Y, offset.Z) * CFrame.Angles(0, math.rad(90), 0),
			model, "Wheel_" .. i)
		-- Hub
		AB.cylinder(0.4, 0.55, METAL_GREY,
			AB.offset(originCF, offset.X, offset.Y, offset.Z) * CFrame.Angles(0, math.rad(90), 0),
			model, "Hub_" .. i)
	end

	-- Pull handle (long metal bar in front)
	AB.cylinder(0.25, 5, DARK_METAL,
		AB.offset(originCF, -6.5, 2, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "PullHandleArm")
	-- Grip
	AB.cylinder(0.4, 1.8, IRON_BLACK,
		AB.offset(originCF, -8.5, 2, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)),
		model, "PullGrip")
	-- Handle attachment to cart
	AB.block(Vector3.new(0.4, 0.4, 0.4), DARK_METAL,
		AB.offset(originCF, -4.2, 2, 0), model, "HandleAttach")

	-- Two visible toddler heads in the cart (cute round heads with hats)
	for i, x in {-1.5, 1.5} do
		AB.sphere(1.0, FACE_PINK, AB.offset(originCF, x, 4.4, 0), model, "ToddlerHead_" .. i)
		-- Hat (round flat top)
		AB.cylinder(1.1, 0.4, HAT_BLUE,
			AB.offset(originCF, x, 5.1, 0), model, "ToddlerHat_" .. i)
		-- Eyes (tiny black dots)
		AB.sphere(0.15, IRON_BLACK, AB.offset(originCF, x - 0.3, 4.45, 0.8), model, "ToddlerEyeL_" .. i)
		AB.sphere(0.15, IRON_BLACK, AB.offset(originCF, x + 0.3, 4.45, 0.8), model, "ToddlerEyeR_" .. i)
	end

	-- "幼稚園" decal on side (vermilion plate with white text indicator)
	AB.block(Vector3.new(2.6, 1, 0.1), VERMILION,
		AB.offset(originCF, 0, 2.6, 1.85), model, "SideDecal")
	AB.block(Vector3.new(2.4, 0.6, 0.15), PAPER_WHITE,
		AB.offset(originCF, 0, 2.6, 1.9), model, "SideDecalText")

	-- Yellow rear flag on a pole (for visibility)
	AB.cylinder(0.15, 4, DARK_METAL,
		AB.offset(originCF, 4.2, 4.5, 0), model, "FlagPole")
	AB.block(Vector3.new(1.4, 1, 0.1), YELLOW_DARK,
		AB.offset(originCF, 4.9, 6, 0), model, "Flag")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
