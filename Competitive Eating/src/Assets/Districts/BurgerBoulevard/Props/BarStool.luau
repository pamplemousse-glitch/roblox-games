-- BarStool — chrome-and-red-vinyl swivel stool, the kind you see at a diner counter.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BarStool", parent)

	local CHROME = Color3.fromRGB(176, 176, 176)
	local RED    = Color3.fromRGB(220, 50, 50)
	local DARK   = Color3.fromRGB(40, 40, 45)

	-- Floor base disc
	AB.cylinder(2.4, 0.3, CHROME, AB.offset(originCF, 0, 0.15, 0), model, "BaseDisc").Material = Enum.Material.Metal
	-- Center post
	AB.cylinder(0.6, 3, CHROME, AB.offset(originCF, 0, 1.65, 0), model, "Post").Material = Enum.Material.Metal
	-- Seat ring + cushion
	AB.cylinder(2.6, 0.4, CHROME, AB.offset(originCF, 0, 3.3, 0), model, "SeatRing")
	local seat = AB.cylinder(2.2, 0.6, RED, AB.offset(originCF, 0, 3.7, 0), model, "Seat")
	seat.Material = Enum.Material.SmoothPlastic
	-- Center button
	AB.cylinder(0.4, 0.3, DARK, AB.offset(originCF, 0, 4.05, 0), model, "Button")
	-- Footrest ring
	AB.cylinder(2.6, 0.2, CHROME, AB.offset(originCF, 0, 1.4, 0) * CFrame.Angles(0, math.rad(90), 0), model, "Footrest")
	-- Subtle reflectance
	seat.Reflectance = 0.05

	AB.pivot(model, model:FindFirstChild("BaseDisc"))
	AB.weldAll(model)
	return model
end
