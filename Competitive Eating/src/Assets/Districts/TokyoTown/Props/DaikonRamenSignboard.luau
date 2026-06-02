-- Daikon Ramen vertical hanging signboard. Cube 3D mesh, generated 2026-06-01.
-- Pairs with the DaikonRamen building — placed at the entry corner.

local AssetService = game:GetService("AssetService")

local MESH_ID    = "rbxassetid://101763521457586"
local TEXTURE_ID = "rbxassetid://106613461090793"
local SIZE       = Vector3.new(4, 7.1, 0.9)

return function(parent: Instance, originCF: CFrame): Model
	local model = Instance.new("Model")
	model.Name  = "DaikonRamenSignboard"

	local mesh = AssetService:CreateMeshPartAsync(MESH_ID)
	mesh.Name       = "Body"
	mesh.Anchored   = true
	mesh.CanCollide = false
	mesh.Size       = SIZE
	mesh.TextureID  = TEXTURE_ID
	mesh.CFrame     = originCF * CFrame.new(0, SIZE.Y / 2, 0)
	mesh.Parent     = model

	model.PrimaryPart = mesh
	model.Parent      = parent
	return model
end
