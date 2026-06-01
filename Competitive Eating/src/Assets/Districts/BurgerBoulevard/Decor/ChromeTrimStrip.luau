-- ChromeTrimStrip — long horizontal chrome decorative strip, with rivets.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ChromeTrimStrip", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local DARK   = Color3.fromRGB(60, 60, 65)

	-- Main strip
	local strip = AB.block(Vector3.new(12, 0.8, 0.3), CHROME, AB.offset(originCF, 0, 0.4, 0), model, "Strip")
	strip.Material = Enum.Material.Metal
	strip.Reflectance = 0.3
	-- Edge bevels
	AB.block(Vector3.new(12.2, 0.1, 0.4), CHROME, AB.offset(originCF, 0, 0.85, 0), model, "EdgeT")
	AB.block(Vector3.new(12.2, 0.1, 0.4), CHROME, AB.offset(originCF, 0, -0.05, 0), model, "EdgeB")
	-- Rivets along length
	for i = 0, 5 do
		AB.sphere(0.15, DARK, AB.offset(originCF, -5 + i * 2, 0.4, 0.18), model, "Rivet_" .. i)
	end

	AB.pivot(model, strip)
	AB.weldAll(model)
	return model
end
