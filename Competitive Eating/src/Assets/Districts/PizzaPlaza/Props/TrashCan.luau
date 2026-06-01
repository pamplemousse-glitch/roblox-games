-- Trash Can — green metal city trash can with lid, label, foot pedal.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CAN_GRN   = Color3.fromRGB(60, 90, 60)
local DK_GRN    = Color3.fromRGB(40, 65, 40)
local STEEL     = Color3.fromRGB(170, 170, 175)
local LABEL_W   = Color3.fromRGB(245, 240, 230)
local TRASH_BLK = Color3.fromRGB(35, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TrashCan", parent)

	-- Body (cylinder upright)
	AB.cylinder(2.2, 4, CAN_GRN, AB.offset(originCF, 0, 2.5, 0), model, "Body")
	-- Top + bottom bands (darker)
	AB.cylinder(2.3, 0.3, DK_GRN, AB.offset(originCF, 0, 4.4, 0), model, "TopBand")
	AB.cylinder(2.3, 0.3, DK_GRN, AB.offset(originCF, 0, 0.6, 0), model, "BotBand")
	-- Vertical ribs
	for i = 0, 5 do
		local angle = i / 6 * 2 * math.pi
		AB.block(Vector3.new(0.2, 4, 0.2), DK_GRN,
			AB.offset(originCF, 1.1 * math.cos(angle), 2.5, 1.1 * math.sin(angle)), model, "Rib_" .. i)
	end

	-- Lid (slightly larger cylinder on top)
	AB.cylinder(2.4, 0.4, DK_GRN, AB.offset(originCF, 0, 4.7, 0), model, "Lid")
	-- Lid handle
	AB.cylinder(0.3, 1.2, STEEL,
		AB.offset(originCF, 0, 5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "LidHandle")
	-- Pedal arm
	AB.block(Vector3.new(0.2, 0.2, 1.6), STEEL, AB.offset(originCF, 0, 0.3, 1.1), model, "PedalArm")
	AB.block(Vector3.new(1.2, 0.2, 0.5), STEEL, AB.offset(originCF, 0, 0.3, 1.9), model, "PedalPad")

	-- "RIFIUTI" label plaque
	AB.block(Vector3.new(2, 1, 0.1), LABEL_W, AB.offset(originCF, 0, 3, 1.15), model, "Label")
	AB.block(Vector3.new(1.6, 0.25, 0.05), DK_GRN, AB.offset(originCF, 0, 3, 1.2), model, "LabelText")
	-- Label rivets
	for i, sx in {-1, 1} do
		AB.sphere(0.1, STEEL, AB.offset(originCF, sx * 0.85, 3, 1.16), model, "Rivet_" .. i)
	end

	-- Overflow trash bag pile beside it
	AB.sphere(1.1, TRASH_BLK, AB.offset(originCF, 2.4, 1.1, 0.5), model, "TrashBag1")
	AB.sphere(0.9, TRASH_BLK, AB.offset(originCF, 2.7, 0.9, -0.5), model, "TrashBag2")
	-- Crumpled paper sticking out of top
	AB.sphere(0.4, LABEL_W, AB.offset(originCF, 0.5, 5.1, 0.3), model, "Paper1")
	AB.sphere(0.3, LABEL_W, AB.offset(originCF, -0.4, 5.0, -0.4), model, "Paper2")
	-- Pizza box sticking out of trash
	AB.block(Vector3.new(1.4, 0.5, 1.4), Color3.fromRGB(160, 115, 70),
		AB.offset(originCF, 0, 5.3, 0) * CFrame.Angles(math.rad(15), math.rad(20), 0), model, "PizzaBoxInTrash")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
