-- GiantDonutTower — monument-scale pink frosted donut sitting on a
-- ceramic-tier pedestal. A single Meshy.ai mesh (asset 97210872682813)
-- replaces the previous stacked-tier primitive build.

local AssetService = game:GetService("AssetService")
local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)

local DONUT_MESH_ID = "rbxassetid://97210872682813"
-- Scaled proportional to the mesh's native bbox (1.898 × 1.823 × 1.790).
local DONUT_SIZE = Vector3.new(48, 46, 45)
local DONUT_Y = 26

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantDonutTower", parent)

	-- Pedestal: stacked ceramic tiers (matches the prior landmark footprint)
	AB.cylinder(28, 1.6, BROWN, AB.offset(originCF, 0, 0.8, 0), model, "BasePlatform")
	AB.cylinder(26, 0.8, GOLD,  AB.offset(originCF, 0, 1.8, 0), model, "BaseGold")
	AB.cylinder(24, 1.0, CREAM, AB.offset(originCF, 0, 2.6, 0), model, "BaseCream")

	-- Ring of gold planters with mint shrubs around the pedestal
	for i = 1, 8 do
		local a = (i / 8) * math.pi * 2
		AB.block(Vector3.new(2, 1.4, 2), GOLD,
			AB.offset(originCF, math.cos(a) * 13, 3.8, math.sin(a) * 13), model, "Planter_" .. i)
		AB.sphere(2.2, MINT,
			AB.offset(originCF, math.cos(a) * 13, 5.3, math.sin(a) * 13), model, "PlanterShrub_" .. i)
	end

	-- The monument donut. MeshPart.MeshId is creation-time-only — we must
	-- build via AssetService:CreateMeshPartAsync (see memory:
	-- feedback-meshpart-loaded-at-runtime).
	local donut = AssetService:CreateMeshPartAsync(DONUT_MESH_ID, {
		CollisionFidelity = Enum.CollisionFidelity.Box,
	})
	donut.Name = "Donut"
	donut.Size = DONUT_SIZE
	donut.CFrame = AB.offset(originCF, 0, DONUT_Y, 0)
	donut.Anchored = true
	donut.Material = Enum.Material.SmoothPlastic
	donut.Color = PINK
	donut.Parent = model

	-- Spotlights ringing the pedestal, uplighting the donut
	for i = 1, 4 do
		local a = (i / 4) * math.pi * 2
		AB.cylinder(1.2, 0.6, GOLD,
			AB.offset(originCF, math.cos(a) * 10, 4, math.sin(a) * 10), model, "Spotlight_" .. i)
		local bulb = AB.sphere(0.9, NEONPK,
			AB.offset(originCF, math.cos(a) * 10, 4.7, math.sin(a) * 10), model, "SpotBulb_" .. i)
		AB.neon(bulb)
		AB.glow(bulb, NEONPK, 3)
	end

	AB.pivot(model, donut)
	AB.weldAll(model)
	return model
end
