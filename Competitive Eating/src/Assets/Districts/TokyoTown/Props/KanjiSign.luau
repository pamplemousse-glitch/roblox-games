-- KanjiSign — shared builder for the 5 real-kanji signs that Session D adds
-- in front of the Cube 3D shops to overwrite their baked nonsense glyphs.
-- Returns a builder function matching the AssetSpawner contract.
--
-- Render strategy: a flat anchored Part with a SurfaceGui + TextLabel using
-- Roblox's built-in Gotham/SourceSans family, which already rasterise the
-- Japanese characters at runtime — no uploaded decals required.

local KanjiSign = {}

local FRONT_FACE  = Enum.NormalId.Front
local SIGN_SIZE   = Vector3.new(6, 3, 0.3)
local SIGN_HEIGHT = 7   -- center Y above the ground

function KanjiSign.create(charText: string, bgColor: Color3, fgColor: Color3, displayName: string?)
	return function(parent: Instance, originCF: CFrame): Model
		local model = Instance.new("Model")
		model.Name = displayName or ("KanjiSign_" .. charText)

		local plate = Instance.new("Part")
		plate.Name          = "Plate"
		plate.Size          = SIGN_SIZE
		plate.Color         = bgColor
		plate.Material      = Enum.Material.SmoothPlastic
		plate.Anchored      = true
		plate.CanCollide    = false
		plate.TopSurface    = Enum.SurfaceType.Smooth
		plate.BottomSurface = Enum.SurfaceType.Smooth
		plate.CFrame        = originCF * CFrame.new(0, SIGN_HEIGHT, 0)
		plate.Parent        = model

		local sgui = Instance.new("SurfaceGui")
		sgui.Face         = FRONT_FACE
		sgui.PixelsPerStud = 60
		sgui.LightInfluence = 0
		sgui.Parent       = plate

		local border = Instance.new("Frame")
		border.Size = UDim2.fromScale(1, 1)
		border.BackgroundColor3 = bgColor
		border.BorderSizePixel = 0
		border.Parent = sgui

		local inner = Instance.new("Frame")
		inner.Size = UDim2.new(1, -16, 1, -16)
		inner.Position = UDim2.fromOffset(8, 8)
		inner.BackgroundColor3 = bgColor
		inner.BorderSizePixel = 0
		inner.Parent = border

		local stroke = Instance.new("UIStroke")
		stroke.Color = fgColor
		stroke.Thickness = 4
		stroke.Parent = inner

		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Text = charText
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.TextColor3 = fgColor
		label.Parent = inner

		-- Subtle warm glow so the sign is visible at night under the Tokyo
		-- atmosphere fog/lighting.
		local glow = Instance.new("PointLight")
		glow.Color = bgColor
		glow.Brightness = 1.2
		glow.Range = 10
		glow.Parent = plate

		model.PrimaryPart = plate
		model.Parent      = parent
		return model
	end
end

return KanjiSign
