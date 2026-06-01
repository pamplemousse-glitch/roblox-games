-- LollipopSignpost — directional signpost styled as a giant swirly
-- lollipop. Cream stick, pink-and-mint swirl head, gold base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("LollipopSignpost", parent)

	-- Gold base
	AB.cylinder(2.4, 0.6, GOLD,
		AB.offset(originCF, 0, 0.3, 0), model, "Base")
	AB.block(Vector3.new(1, 1, 1), GOLD,
		AB.offset(originCF, 0, 1.2, 0), model, "BaseBlock")

	-- Stick
	local stick = AB.cylinder(0.6, 11, CREAM,
		AB.offset(originCF, 0, 7, 0), model, "Stick")

	-- Lollipop head (large disc with swirl)
	AB.cylinder(7, 0.8, CREAM,
		AB.offset(originCF, 0, 13, 0) * CFrame.Angles(math.rad(90), 0, 0), model, "HeadDisc")
	-- Swirl: ring of alternating pink/mint chunks
	AB.circleArrange(AB.offset(originCF, 0, 13, 0), 2.6, 8, model, function(i, cf, _)
		local col = (i % 2 == 0) and DEEP or MINT
		return AB.block(Vector3.new(0.7, 0.6, 1.2), col, cf, model, "SwirlChunk_" .. i)
	end)
	AB.circleArrange(AB.offset(originCF, 0, 13, 0), 1.4, 6, model, function(i, cf, _)
		return AB.block(Vector3.new(0.5, 0.6, 0.9), PINK, cf, model, "SwirlInner_" .. i)
	end)
	-- Center pop
	local pop = AB.sphere(1.2, NEONPK, AB.offset(originCF, 0, 13, 0), model, "Center")
	AB.neon(pop)
	AB.glow(pop, NEONPK, 1.5)

	-- Arrow sign nailed to stick (points right)
	AB.block(Vector3.new(3, 1.4, 0.3), PINK,
		AB.offset(originCF, 1.6, 5, 0), model, "Arrow")
	AB.wedge(Vector3.new(0.3, 1.4, 1), PINK,
		AB.offset(originCF, 3.5, 5, 0) * CFrame.Angles(0, math.rad(-90), 0), model, "ArrowTip")

	AB.pivot(model, stick)
	AB.weldAll(model)
	return model
end
