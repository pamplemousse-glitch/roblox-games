-- Picnic Pavilion — open-sided wood structure with two picnic tables underneath.
-- Stained posts at each corner, slanted shingle roof, no walls.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SMOKED_WOOD = Color3.fromRGB(107, 68, 35)
local DARK_WOOD   = Color3.fromRGB(70, 45, 22)
local TABLE_TOP   = Color3.fromRGB(160, 110, 70)
local SHINGLE     = Color3.fromRGB(55, 35, 22)
local STRAW       = Color3.fromRGB(232, 200, 112)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PicnicPavilion", parent)

	-- Concrete pad
	local pad = AB.block(
		Vector3.new(28, 0.5, 20),
		Color3.fromRGB(180, 175, 165),
		AB.offset(originCF, 0, 0.25, 0),
		model, "Pad"
	)

	-- 4 corner posts
	for i, pos in {
		Vector3.new(-13, 0, -9),
		Vector3.new( 13, 0, -9),
		Vector3.new(-13, 0,  9),
		Vector3.new( 13, 0,  9),
	} do
		AB.block(
			Vector3.new(1.2, 12, 1.2),
			DARK_WOOD,
			originCF * CFrame.new(pos.X, 6.5, pos.Z),
			model, "Post_" .. i
		)
	end

	-- Top beams (long crossbeams along each side, connecting posts)
	AB.block(Vector3.new(28, 1.0, 1.2), SMOKED_WOOD, AB.offset(originCF, 0, 12.6, -9), model, "BeamN")
	AB.block(Vector3.new(28, 1.0, 1.2), SMOKED_WOOD, AB.offset(originCF, 0, 12.6,  9), model, "BeamS")
	AB.block(Vector3.new(1.2, 1.0, 18), SMOKED_WOOD, AB.offset(originCF, -13, 12.6, 0), model, "BeamE")
	AB.block(Vector3.new(1.2, 1.0, 18), SMOKED_WOOD, AB.offset(originCF,  13, 12.6, 0), model, "BeamW")

	-- Roof — two big wedge halves meeting at the ridge
	AB.wedge(
		Vector3.new(30, 3.5, 11), SHINGLE,
		AB.offset(originCF, 0, 14.5,  5.5) * CFrame.Angles(0, math.rad(180), 0),
		model, "RoofFront"
	)
	AB.wedge(
		Vector3.new(30, 3.5, 11), SHINGLE,
		AB.offset(originCF, 0, 14.5, -5.5),
		model, "RoofBack"
	)

	-- Two picnic tables under the roof
	for t, offX in {[1] = -6, [2] = 6} do
		-- Tabletop
		AB.block(
			Vector3.new(7, 0.3, 4),
			TABLE_TOP,
			originCF * CFrame.new(offX, 3.2, 0),
			model, "Table_" .. t .. "_Top"
		)
		-- Bench planks (one per side)
		AB.block(Vector3.new(7, 0.25, 1.0), TABLE_TOP, originCF * CFrame.new(offX, 2.0,  3), model, "Table_" .. t .. "_BenchN")
		AB.block(Vector3.new(7, 0.25, 1.0), TABLE_TOP, originCF * CFrame.new(offX, 2.0, -3), model, "Table_" .. t .. "_BenchS")
		-- Legs (4 simple bricks)
		for li, pos in {
			Vector3.new(-3,  2),
			Vector3.new( 3,  2),
			Vector3.new(-3, -2),
			Vector3.new( 3, -2),
		} do
			AB.block(
				Vector3.new(0.4, 3, 0.4),
				DARK_WOOD,
				originCF * CFrame.new(offX + pos.X, 1.5, pos.Y),
				model, "Table_" .. t .. "_Leg_" .. li
			)
		end
	end

	-- A straw bale near one corner (decoration nod to country feel)
	AB.block(
		Vector3.new(3.5, 2, 2),
		STRAW,
		AB.offset(originCF, 11, 1.25, 7),
		model, "StrawBale"
	)

	AB.pivot(model, pad)
	AB.weldAll(model)
	return model
end
