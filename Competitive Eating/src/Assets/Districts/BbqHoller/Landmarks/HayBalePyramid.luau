-- Hay Bale Pyramid — large pyramid stack of hay bales, ~5 layers tall.
-- Photo-op centerpiece at the district entrance.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local HAY       = Color3.fromRGB(232, 200, 112)
local HAY_DARK  = Color3.fromRGB(180, 145, 75)
local HAY_LIGHT = Color3.fromRGB(245, 220, 150)
local TWINE     = Color3.fromRGB(120, 100, 70)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)

local function bale(parent, cf, name, palette)
	local b = AB.block(Vector3.new(4, 2.5, 2.5), palette[1], cf, parent, name)
	-- Striations
	for i, dy in {-0.7, 0, 0.7} do
		AB.block(Vector3.new(4.05, 0.2, 2.55), palette[2], cf * CFrame.new(0, dy, 0), parent, name .. "_Str_" .. i)
	end
	-- Twine bands
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, 0.5, 1.0), parent, name .. "_TwF1")
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, -0.5, 1.0), parent, name .. "_TwF2")
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, 0.5, -1.0), parent, name .. "_TwB1")
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, -0.5, -1.0), parent, name .. "_TwB2")
	return b
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("HayBalePyramid", parent)

	-- Wood pallet underneath
	AB.block(Vector3.new(22, 0.5, 14), DARK_WOOD, AB.offset(originCF, 0, 0.25, 0), model, "Pallet")
	-- Pallet slats (lines)
	for i = -4, 4 do
		AB.block(Vector3.new(22, 0.15, 0.4), HAY_DARK, AB.offset(originCF, 0, 0.55, i * 1.5), model, "PalletSlat_" .. i + 5)
	end

	-- Pyramid stack
	-- Row 1: 5 bales across (X), 3 deep (Z)
	for ix = -2, 2 do
		for iz = -1, 1 do
			bale(model, AB.offset(originCF, ix * 4, 1.75, iz * 2.6), "B1_" .. ix .. "_" .. iz, {HAY, HAY_DARK})
		end
	end
	-- Row 2: 4 bales across, 2 deep (offset)
	for ix = -1.5, 1.5, 1 do
		for iz = -0.5, 0.5, 1 do
			bale(model, AB.offset(originCF, ix * 4, 4.25, iz * 2.6), "B2_" .. tostring(ix):gsub("%.", "_") .. "_" .. tostring(iz):gsub("%.", "_"),
				{HAY_LIGHT, HAY_DARK})
		end
	end
	-- Row 3: 3 bales single line
	for ix = -1, 1 do
		bale(model, AB.offset(originCF, ix * 4, 6.75, 0), "B3_" .. ix, {HAY, HAY_DARK})
	end
	-- Row 4: 2 bales
	bale(model, AB.offset(originCF, -2, 9.25, 0), "B4_L", {HAY_LIGHT, HAY_DARK})
	bale(model, AB.offset(originCF,  2, 9.25, 0), "B4_R", {HAY_LIGHT, HAY_DARK})
	-- Row 5: 1 bale on top
	bale(model, AB.offset(originCF, 0, 11.75, 0), "B5_Top", {HAY, HAY_DARK})

	-- Pitchfork stuck in the top bale at angle
	local pfHandle = AB.block(Vector3.new(0.3, 6, 0.3), DARK_WOOD, AB.offset(originCF, 0, 14, 0.6), model, "PitchforkHandle")
	pfHandle.CFrame = pfHandle.CFrame * CFrame.Angles(math.rad(-25), 0, 0)
	-- Pitchfork tines (3 short prongs at the bottom — actually top of the fork stuck down)
	for i, x in {-0.4, 0, 0.4} do
		local prong = AB.block(Vector3.new(0.15, 1.2, 0.15), HAY_DARK, AB.offset(originCF, x, 11.6, 1.2), model, "Prong_" .. i)
		prong.CFrame = prong.CFrame * CFrame.Angles(math.rad(-25), 0, 0)
	end

	-- Welcome sign in front of pyramid
	local sign = AB.block(Vector3.new(6, 2, 0.3), DARK_WOOD, AB.offset(originCF, 0, 3, 8), model, "WelcomeSign")
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = sign
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBlack
	lbl.Text              = "WELCOME Y'ALL"
	lbl.TextColor3        = HAY
	lbl.TextStrokeColor3  = Color3.new(0, 0, 0)
	lbl.TextStrokeTransparency = 0.4
	lbl.TextScaled        = true
	lbl.Parent            = gui
	-- Two posts holding the sign
	AB.block(Vector3.new(0.4, 5, 0.4), DARK_WOOD, AB.offset(originCF, -2.6, 2, 8), model, "SignPostL")
	AB.block(Vector3.new(0.4, 5, 0.4), DARK_WOOD, AB.offset(originCF,  2.6, 2, 8), model, "SignPostR")

	AB.pivot(model, model:FindFirstChild("Pallet"))
	AB.weldAll(model)
	return model
end
