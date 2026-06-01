-- Wooden Crate — simple shipping crate with plank ribbing and a stenciled side.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PLANK     = Color3.fromRGB(140, 90, 55)
local DARK_WOOD = Color3.fromRGB(85, 55, 35)
local STENCIL   = Color3.fromRGB(40, 30, 20)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WoodenCrate", parent)

	local body = AB.block(Vector3.new(3.5, 3.2, 3.5), PLANK, AB.offset(originCF, 0, 1.6, 0), model, "Body")

	-- Vertical plank ribs on each face
	for i, x in {-1.5, -0.5, 0.5, 1.5} do
		AB.block(Vector3.new(0.3, 3.2, 0.1), DARK_WOOD, AB.offset(originCF, x, 1.6,  1.8), model, "RibF_" .. i)
		AB.block(Vector3.new(0.3, 3.2, 0.1), DARK_WOOD, AB.offset(originCF, x, 1.6, -1.8), model, "RibB_" .. i)
		AB.block(Vector3.new(0.1, 3.2, 0.3), DARK_WOOD, AB.offset(originCF, 1.8, 1.6, x), model, "RibR_" .. i)
		AB.block(Vector3.new(0.1, 3.2, 0.3), DARK_WOOD, AB.offset(originCF, -1.8, 1.6, x), model, "RibL_" .. i)
	end

	-- Top frame
	AB.block(Vector3.new(3.7, 0.2, 0.4), DARK_WOOD, AB.offset(originCF, 0, 3.25,  1.6), model, "TopBeamF")
	AB.block(Vector3.new(3.7, 0.2, 0.4), DARK_WOOD, AB.offset(originCF, 0, 3.25, -1.6), model, "TopBeamB")
	AB.block(Vector3.new(0.4, 0.2, 3.7), DARK_WOOD, AB.offset(originCF, -1.6, 3.25, 0), model, "TopBeamL")
	AB.block(Vector3.new(0.4, 0.2, 3.7), DARK_WOOD, AB.offset(originCF,  1.6, 3.25, 0), model, "TopBeamR")

	-- Stencil on the front (use a SurfaceGui with text "FRAGILE")
	local stencilFace = AB.block(Vector3.new(2, 1, 0.06), PLANK, AB.offset(originCF, 0, 1.6, 1.85), model, "StencilFace")
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = stencilFace
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBold
	lbl.Text              = "FRAGILE"
	lbl.TextColor3        = STENCIL
	lbl.TextScaled        = true
	lbl.Parent            = gui

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
