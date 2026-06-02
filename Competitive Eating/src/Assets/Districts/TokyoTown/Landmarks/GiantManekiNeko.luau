-- Giant Maneki Neko — 30-stud-tall lucky cat statue.
--
-- Cat body is the Meshy.ai preview-mode mesh uploaded via Open Cloud Assets API
-- (Session E cleanup, 2026-06-02). Source GLB:
--   Competitive Eating/assets/raw/maneki-neko-preview.glb
-- Meshy task: 019e85a0-e403-7930-8706-a9a1374d0d22 (preview, untextured grey
-- clay — refine pass not run).
-- Open Cloud upload: Model asset 110471001690706 owned by user 2270535666.
-- Inner mesh: rbxassetid://140670280786657 — usable directly with
-- AssetService:CreateMeshPartAsync (verified in Studio at upload time).
--
-- Pedestal stays primitive — gives the kanji plate + stacked-stone look without
-- a second mesh upload.

local AssetService = game:GetService("AssetService")
local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local MESH_ID = "rbxassetid://140670280786657"

-- Native mesh bbox is ~1.20 × 1.91 × 1.12 studs; we want the cat ~26 studs tall
-- sitting on top of the 2-stud pedestal so its crown lands at ~30 studs and the
-- collar/bell sit around y≈17 (matching the previous primitive landmark).
local CAT_SIZE = Vector3.new(16.4, 26.0, 15.3)  -- uniform scale ≈ 13.6x native

local STONE      = Color3.fromRGB(120, 115, 105)
local VERMILION  = Color3.fromRGB(200, 50, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantManekiNeko", parent)

	-- Stone pedestal (kept primitive — two stacked rotated stone blocks +
	-- vermilion kanji plate; same shape as the pre-mesh landmark).
	AB.block(Vector3.new(14, 1, 14), STONE,
		AB.offset(originCF, 0, 0.5, 0), model, "Pedestal")
	AB.block(Vector3.new(12, 1, 12), STONE,
		AB.offset(originCF, 0, 1.5, 0) * CFrame.Angles(0, math.rad(22.5), 0),
		model, "Pedestal2")
	local plate = AB.block(Vector3.new(5, 1.5, 0.4), VERMILION,
		AB.offset(originCF, 0, 1.6, 6.1), model, "PedestalPlate")
	AB.neon(plate)
	AB.glow(plate, VERMILION, 2)

	-- Cat body (Meshy mesh). Center the mesh so its base rests on the pedestal
	-- top (Y=2) and its crown reaches ~28.
	local cat = AssetService:CreateMeshPartAsync(MESH_ID, {
		CollisionFidelity = Enum.CollisionFidelity.Box,
		RenderFidelity    = Enum.RenderFidelity.Automatic,
	})
	cat.Name       = "Cat"
	cat.Anchored   = true
	cat.CanCollide = true
	cat.Size       = CAT_SIZE
	-- Meshy GLB's native +Y is not world-up; the cat spawns lying on its back
	-- without a corrective rotation. Tilt -90° around X to bring +Z (mesh height)
	-- to world +Y. If the cat now lies face-down instead of upright, flip to +90.
	cat.CFrame     = originCF
		* CFrame.new(0, 2 + CAT_SIZE.Y / 2, 0)
		* CFrame.Angles(math.rad(-90), 0, 0)
	cat.Parent     = model

	model.PrimaryPart = cat
	return model
end
