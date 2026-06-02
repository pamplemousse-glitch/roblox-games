-- Sushi Daiko — sushi bar hero mesh (Cube 3D, generated 2026-06-01).

local AssetService = game:GetService("AssetService")

local MESH_ID    = "rbxassetid://77402181455281"
local TEXTURE_ID = "rbxassetid://86689699985059"
local SIZE       = Vector3.new(25.6, 20, 24.5)

return function(parent: Instance, originCF: CFrame): Model
	local model = Instance.new("Model")
	model.Name  = "SushiDaiko"

	local mesh = AssetService:CreateMeshPartAsync(MESH_ID)
	mesh.Name       = "Body"
	mesh.Anchored   = true
	mesh.CanCollide = true
	mesh.Size       = SIZE
	mesh.TextureID  = TEXTURE_ID
	mesh.CFrame     = originCF * CFrame.new(0, SIZE.Y / 2, 0)
	mesh.Parent     = model

	model.PrimaryPart = mesh
	model.Parent      = parent
	return model
end
