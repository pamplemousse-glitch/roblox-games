-- Rusted Shed — small corrugated-metal storage shed, leaning slightly,
-- rust streaks running down. Backdrop filler.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local RUST      = Color3.fromRGB(140, 80, 50)
local RUST_DARK = Color3.fromRGB(100, 55, 35)
local METAL     = Color3.fromRGB(130, 130, 135)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local SHADOW    = Color3.fromRGB(28, 24, 20)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RustedShed", parent)

	-- Slight lean: rotate the whole module via origin offset.
	local lean = originCF * CFrame.Angles(0, 0, math.rad(-3))

	local foundation = AB.block(Vector3.new(14, 0.4, 10), DARK_WOOD, AB.offset(lean, 0, 0.2, 0), model, "Foundation")

	-- Corrugated walls — alternating vertical bands
	for i = -6, 6 do
		local col = (i % 2 == 0) and RUST or RUST_DARK
		AB.block(Vector3.new(1, 9, 0.5), col, AB.offset(lean, i, 4.8, 5), model, "PanelF_" .. i)
		AB.block(Vector3.new(1, 9, 0.5), col, AB.offset(lean, i, 4.8, -5), model, "PanelB_" .. i)
	end
	-- Side walls
	for i = -4, 4 do
		local col = (i % 2 == 0) and RUST or RUST_DARK
		AB.block(Vector3.new(0.5, 9, 1), col, AB.offset(lean, 6.8, 4.8, i), model, "PanelR_" .. i)
		AB.block(Vector3.new(0.5, 9, 1), col, AB.offset(lean, -6.8, 4.8, i), model, "PanelL_" .. i)
	end

	-- Door (single sagging metal slab)
	local door = AB.block(Vector3.new(3.5, 7, 0.3), RUST_DARK, AB.offset(lean, 0, 3.7, 5.25), model, "Door")
	door.CFrame = door.CFrame * CFrame.Angles(0, 0, math.rad(-4))
	-- Door handle
	AB.sphere(0.3, METAL, AB.offset(lean, 1.5, 4, 5.4), model, "Handle")

	-- Slanted tin roof
	local roof = AB.block(Vector3.new(15, 0.4, 11), METAL, AB.offset(lean, 0, 9.8, 0), model, "Roof")
	roof.CFrame = roof.CFrame * CFrame.Angles(math.rad(-8), 0, 0)

	-- Rust streaks (vertical dark lines)
	for i, x in {-4, -1, 2, 5} do
		AB.block(Vector3.new(0.2, 6, 0.6), SHADOW, AB.offset(lean, x, 5.5, 5.3), model, "Streak_" .. i)
	end

	-- Pile of junk leaning against the side (random crates)
	AB.block(Vector3.new(2, 2, 2),  DARK_WOOD, AB.offset(lean, 8.5, 1, 2),  model, "JunkCrate1")
	AB.block(Vector3.new(1.6, 1.4, 1.6), DARK_WOOD, AB.offset(lean, 8.5, 2.7, 1.8), model, "JunkCrate2")
	AB.cylinder(1.2, 2.4, RUST, AB.offset(lean, 9, 1.2, 3.5) * CFrame.Angles(0, 0, math.rad(90)), model, "JunkBarrel")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
