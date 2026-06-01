-- StanchionRope — chrome stanchion pole with a red velvet rope (queue marker).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("StanchionRope", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local RED    = Color3.fromRGB(180, 30, 40)
	local DARK   = Color3.fromRGB(40, 30, 25)

	-- Two stanchion posts
	local function stanchion(x: number, name: string)
		AB.cylinder(1, 0.4, DARK, AB.offset(originCF, x, 0.2, 0), model, name .. "_Base").Material = Enum.Material.Metal
		AB.cylinder(0.4, 3.5, CHROME, AB.offset(originCF, x, 2, 0), model, name .. "_Pole").Material = Enum.Material.Metal
		-- Top finial
		AB.sphere(0.7, CHROME, AB.offset(originCF, x, 3.95, 0), model, name .. "_Finial")
		-- Rope-loop ring
		AB.cylinder(0.6, 0.2, CHROME, AB.offset(originCF, x, 3.3, 0) * CFrame.Angles(0, math.rad(90), 0), model, name .. "_Ring")
	end
	stanchion(-3, "Left")
	stanchion(3, "Right")

	-- Velvet rope sagging between
	-- Three segments approximating a catenary
	AB.cylinder(0.3, 3, RED, AB.offset(originCF, -1.5, 2.9, 0) * CFrame.Angles(0, 0, math.rad(80)), model, "RopeL")
	AB.cylinder(0.3, 3, RED, AB.offset(originCF,  1.5, 2.9, 0) * CFrame.Angles(0, 0, math.rad(100)), model, "RopeR")
	-- Center belly
	AB.cylinder(0.3, 1.5, RED, AB.offset(originCF, 0, 2.4, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "RopeMid")

	AB.pivot(model, model:FindFirstChild("Left_Pole"))
	AB.weldAll(model)
	return model
end
