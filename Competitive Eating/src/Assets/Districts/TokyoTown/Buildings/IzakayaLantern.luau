-- Izakaya Lantern — izakaya pub hero mesh (Cube 3D, generated 2026-06-01).

local AssetService = game:GetService("AssetService")

local MESH_ID    = "rbxassetid://76671062547649"
local TEXTURE_ID = "rbxassetid://103008225475970"
local SIZE       = Vector3.new(23.8, 22, 22.9)

return function(parent: Instance, originCF: CFrame): Model
	local model = Instance.new("Model")
	model.Name  = "IzakayaLantern"

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
