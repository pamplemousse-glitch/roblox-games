-- Daikon Ramen — flagship ramen shop. Cube 3D hero mesh.
-- Generated 2026-06-01 via mcp__Roblox_Studio__generate_mesh, prompt logged in
-- AssetManifest header. Replaces the previous primitive build.

local AssetService = game:GetService("AssetService")

local MESH_ID    = "rbxassetid://75544431962969"
local TEXTURE_ID = "rbxassetid://130965101370131"
local SIZE       = Vector3.new(29.5, 22, 26.9)

return function(parent: Instance, originCF: CFrame): Model
	local model = Instance.new("Model")
	model.Name  = "DaikonRamen"

	local mesh = AssetService:CreateMeshPartAsync(MESH_ID)
	mesh.Name       = "Body"
	mesh.Anchored   = true
	mesh.CanCollide = true
	mesh.Size       = SIZE
	mesh.TextureID  = TEXTURE_ID
	-- Rest mesh on ground; originCF is the ground anchor.
	mesh.CFrame     = originCF * CFrame.new(0, SIZE.Y / 2, 0)
	mesh.Parent     = model

	model.PrimaryPart = mesh
	model.Parent      = parent
	return model
end
