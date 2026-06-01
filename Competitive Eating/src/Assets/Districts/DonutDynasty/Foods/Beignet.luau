-- Beignet — a puffy fried dough cube dusted heavily in powdered sugar.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DOUGH  = Color3.fromRGB(230, 190, 140)
local POWDER = Color3.fromRGB(255, 250, 245)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Beignet", parent)

	-- Main dough cube — slightly tan, puffy proportions
	local body = AB.block(
		Vector3.new(2.6, 2.2, 2.6),
		DOUGH,
		AB.offset(originCF, 0, 1.3, 0),
		model,
		"Body"
	)

	-- Pillowy corner puffs — four spheres at the top corners to fake the
	-- "fried pillow" silhouette beignets are known for
	for i, corner in {
		Vector3.new( 1,  0,  1),
		Vector3.new( 1,  0, -1),
		Vector3.new(-1,  0,  1),
		Vector3.new(-1,  0, -1),
	} do
		AB.sphere(
			1.2,
			DOUGH,
			AB.offset(originCF, corner.X * 1.1, 2.1, corner.Z * 1.1),
			model,
			"Puff_" .. i
		)
	end

	-- Powdered sugar layer on top — a wider, thinner slab
	AB.block(
		Vector3.new(3.0, 0.25, 3.0),
		POWDER,
		AB.offset(originCF, 0, 2.7, 0),
		model,
		"SugarTop"
	)

	-- Powder dribbles down the sides
	for i, side in {
		Vector3.new( 1.35,  0),
		Vector3.new(-1.35,  0),
		Vector3.new( 0,  1.35),
		Vector3.new( 0, -1.35),
	} do
		AB.block(
			Vector3.new(0.4, 0.6, 0.4),
			POWDER,
			AB.offset(originCF, side.X, 2.4, side.Y),
			model,
			"Drip_" .. i
		)
	end

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
