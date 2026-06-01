-- TrashCanChrome — 50s-style ribbed chrome trash can with a swinging top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TrashCanChrome", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local DARK   = Color3.fromRGB(50, 50, 55)
	local NEON_R = Color3.fromRGB(255, 48, 48)

	local body = AB.cylinder(2.4, 4, CHROME, AB.offset(originCF, 0, 2, 0), model, "Body")
	body.Material = Enum.Material.Metal
	body.Reflectance = 0.15
	-- Ribbed rings
	for i = 1, 4 do
		AB.cylinder(2.5, 0.15, CHROME, AB.offset(originCF, 0, 0.6 + i * 0.8, 0), model, "Rib_" .. i).Material = Enum.Material.Metal
	end
	-- Domed lid + swinging flap
	AB.cylinder(2.5, 0.3, CHROME, AB.offset(originCF, 0, 4.1, 0), model, "Lid")
	AB.sphere(2, CHROME, AB.offset(originCF, 0, 4.5, 0), model, "Dome")
	-- Push-flap (visible dark opening)
	AB.block(Vector3.new(1.4, 0.8, 0.3), DARK, AB.offset(originCF, 0, 4.5, 1), model, "FlapOpening")
	-- Red "TRASH" decal
	local decal = AB.block(Vector3.new(1.8, 0.6, 0.05), NEON_R, AB.offset(originCF, 0, 2.5, 1.25), model, "Decal")
	AB.billboard(decal, "TRASH", Vector2.new(80, 30), 0)

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
