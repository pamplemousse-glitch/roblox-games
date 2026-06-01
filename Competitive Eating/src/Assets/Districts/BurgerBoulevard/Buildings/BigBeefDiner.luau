-- BigBeefDiner — classic streamlined dining-car (railroad-car style) diner.
-- Long aluminum body, rounded ends, ribbed sides, "EAT" rooftop sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local ALUMINUM  = Color3.fromRGB(190, 195, 200)
local CHROME    = Color3.fromRGB(176, 176, 176)
local NEON_RED  = Color3.fromRGB(255, 48, 48)
local CREAM     = Color3.fromRGB(255, 245, 232)
local TEAL      = Color3.fromRGB(127, 202, 194)
local DARK_GREY = Color3.fromRGB(70, 70, 80)
local SKY       = Color3.fromRGB(135, 206, 235)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BigBeefDiner", parent)

	-- Concrete pad
	local pad = AB.block(Vector3.new(38, 0.6, 14), DARK_GREY, AB.offset(originCF, 0, 0.3, 0), model, "Pad")
	pad.Material = Enum.Material.Concrete

	-- Diner body — long rectangular hull
	local body = AB.block(Vector3.new(32, 8, 10), ALUMINUM, AB.offset(originCF, 0, 4.6, 0), model, "Body")
	body.Material = Enum.Material.Metal
	body.Reflectance = 0.15

	-- Rounded ends (cylinder caps oriented along Z, ie thru body's short axis)
	-- We use cylinders along X then rotate them so their axis aligns with Y
	local endL = AB.cylinder(10, 1, ALUMINUM, AB.offset(originCF, -16, 4.6, 0) * CFrame.Angles(0, math.rad(90), 0), model, "EndCapL")
	endL.Material = Enum.Material.Metal; endL.Reflectance = 0.15
	local endR = AB.cylinder(10, 1, ALUMINUM, AB.offset(originCF,  16, 4.6, 0) * CFrame.Angles(0, math.rad(90), 0), model, "EndCapR")
	endR.Material = Enum.Material.Metal; endR.Reflectance = 0.15

	-- Horizontal ribs along sides (classic streamline) — 5 ribs
	for i = 1, 5 do
		local y = 1.8 + (i - 1) * 1.4
		AB.block(Vector3.new(32.4, 0.25, 0.3), CHROME, AB.offset(originCF, 0, y, 5.15), model, "RibFront_" .. i)
		AB.block(Vector3.new(32.4, 0.25, 0.3), CHROME, AB.offset(originCF, 0, y, -5.15), model, "RibBack_" .. i)
	end

	-- Long ribbon of windows along front (8 windows in a row)
	for i = 1, 8 do
		local x = -14 + (i - 1) * 4
		local win = AB.block(Vector3.new(3, 3, 0.4), SKY, AB.offset(originCF, x, 6.5, 5.1), model, "Window_" .. i)
		win.Material = Enum.Material.Glass
		win.Transparency = 0.5
		win.Reflectance = 0.25
		-- Window frame chrome
		AB.block(Vector3.new(3.4, 0.3, 0.5), CHROME, AB.offset(originCF, x, 8.15, 5.15), model, "WinTop_" .. i)
		AB.block(Vector3.new(3.4, 0.3, 0.5), CHROME, AB.offset(originCF, x, 4.85, 5.15), model, "WinBot_" .. i)
	end

	-- Doorway in center
	local doorRecess = AB.block(Vector3.new(4, 5.5, 0.5), CHROME, AB.offset(originCF, 0, 3.25, 5.25), model, "DoorRecess")
	doorRecess.Material = Enum.Material.Metal
	local doorPanel = AB.block(Vector3.new(3, 4.8, 0.3), SKY, AB.offset(originCF, 0, 3, 5.4), model, "DoorPanel")
	doorPanel.Material = Enum.Material.Glass
	doorPanel.Transparency = 0.45

	-- Step in front of door
	AB.block(Vector3.new(5, 0.5, 2), CHROME, AB.offset(originCF, 0, 0.85, 6.2), model, "DoorStep")

	-- Flat roof + chrome trim
	AB.block(Vector3.new(34, 0.5, 12), ALUMINUM, AB.offset(originCF, 0, 8.85, 0), model, "Roof").Material = Enum.Material.Metal
	AB.block(Vector3.new(34, 0.4, 0.3), CHROME, AB.offset(originCF, 0, 9.1, 5.9), model, "RoofTrimFront")
	AB.block(Vector3.new(34, 0.4, 0.3), CHROME, AB.offset(originCF, 0, 9.1, -5.9), model, "RoofTrimBack")

	-- Big rooftop "EAT" pylon sign — large red box with 3 letters
	AB.block(Vector3.new(14, 5, 1.5), CREAM, AB.offset(originCF, 0, 11.8, 0), model, "PylonBody")
	-- Red border
	AB.block(Vector3.new(14.4, 0.4, 1.7), NEON_RED, AB.offset(originCF, 0, 14.5, 0), model, "PylonTop")
	AB.block(Vector3.new(14.4, 0.4, 1.7), NEON_RED, AB.offset(originCF, 0, 9.1, 0), model, "PylonBot")
	-- Letter blocks (E A T) — neon red bars approximating letters
	local function letterBlock(x: number, name: string)
		local b = AB.block(Vector3.new(3.6, 3.2, 0.4), NEON_RED, AB.offset(originCF, x, 11.8, 0.8), model, name)
		AB.neon(b); AB.glow(b, NEON_RED, 2.5)
		return b
	end
	letterBlock(-4.4, "Letter_E")
	letterBlock(0,    "Letter_A")
	letterBlock(4.4,  "Letter_T")
	-- BillboardGui spelling out "EAT"
	local readable = AB.block(Vector3.new(0.2, 0.2, 0.2), CREAM, AB.offset(originCF, 0, 11.8, 1.1), model, "ReadableAnchor")
	readable.Transparency = 1
	AB.billboard(readable, "E   A   T", Vector2.new(280, 70), 0)

	-- Neon teal underlight strip along the body bottom (50s glow effect)
	local underNeon = AB.block(Vector3.new(32, 0.4, 0.4), TEAL, AB.offset(originCF, 0, 0.85, 5.2), model, "UnderNeon")
	AB.neon(underNeon); AB.glow(underNeon, TEAL, 2.0)

	-- "OPEN 24 HRS" small neon sign in window
	local openSign = AB.block(Vector3.new(4, 1.2, 0.3), NEON_RED, AB.offset(originCF, 12, 6.5, 5.3), model, "Open24Sign")
	AB.neon(openSign); AB.glow(openSign, NEON_RED, 1.8)

	-- Trash can outside
	AB.cylinder(2, 2.5, CHROME, AB.offset(originCF, 15, 1.25, 6.5), model, "TrashCan")

	AB.pivot(model, pad)
	AB.weldAll(model)
	return model
end
