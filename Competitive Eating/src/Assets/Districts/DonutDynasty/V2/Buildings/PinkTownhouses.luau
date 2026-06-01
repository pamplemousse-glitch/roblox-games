-- PinkTownhouses — a row of 4 narrow connected townhouses in alternating
-- pastel pink shades, with cream doors, mint shutters, and gold lamps.
-- Acts as a backdrop along the back-of-district view.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local GLASS   = Color3.fromRGB(210, 235, 250)
local SOFTPK  = Color3.fromRGB(250, 220, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PinkTownhouses", parent)

	local colors = {PINK, SOFTPK, DEEP, PINK}
	local houseW = 10
	local rowLen = 4 * houseW

	-- Shared foundation
	AB.block(Vector3.new(rowLen, 0.5, 14), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	for h = 1, 4 do
		local x0 = -rowLen / 2 + (h - 1) * houseW + houseW / 2
		local wallColor = colors[h]
		-- House box
		AB.block(Vector3.new(houseW, 18, 1), wallColor,
			AB.offset(originCF, x0, 9, 6.5), model, "House" .. h .. "_Front")
		AB.block(Vector3.new(houseW, 18, 1), wallColor,
			AB.offset(originCF, x0, 9, -6.5), model, "House" .. h .. "_Back")
		AB.block(Vector3.new(1, 18, 14), wallColor,
			AB.offset(originCF, x0 - houseW/2, 9, 0), model, "House" .. h .. "_Left")

		-- Pitched roof (wedge front + back)
		AB.wedge(Vector3.new(houseW, 3, 7), BROWN,
			AB.offset(originCF, x0, 19, 3.5) * CFrame.Angles(math.rad(-30), 0, 0),
			model, "House" .. h .. "_RoofF")
		AB.wedge(Vector3.new(houseW, 3, 7), BROWN,
			AB.offset(originCF, x0, 19, -3.5) * CFrame.Angles(math.rad(30), math.rad(180), 0),
			model, "House" .. h .. "_RoofB")

		-- Door
		AB.block(Vector3.new(2.4, 5, 0.4), CREAM,
			AB.offset(originCF, x0, 2.7, 7), model, "House" .. h .. "_Door")
		AB.sphere(0.3, GOLD, AB.offset(originCF, x0 + 0.8, 2.5, 7.2), model, "House" .. h .. "_Knob")

		-- Upper window
		local g = AB.block(Vector3.new(3, 3, 0.2), GLASS,
			AB.offset(originCF, x0, 12, 7), model, "House" .. h .. "_Win")
		g.Transparency = 0.45
		g.Material = Enum.Material.Glass
		-- Shutters
		AB.block(Vector3.new(0.8, 3.2, 0.3), MINT,
			AB.offset(originCF, x0 - 2, 12, 7.1), model, "House" .. h .. "_ShutterL")
		AB.block(Vector3.new(0.8, 3.2, 0.3), MINT,
			AB.offset(originCF, x0 + 2, 12, 7.1), model, "House" .. h .. "_ShutterR")
		AB.block(Vector3.new(3.6, 0.3, 0.5), GOLD,
			AB.offset(originCF, x0, 13.7, 7.1), model, "House" .. h .. "_WinTrim")

		-- Door lamp (gold sconce, neon bulb)
		AB.block(Vector3.new(0.3, 0.3, 0.7), GOLD,
			AB.offset(originCF, x0 + 1.6, 6, 7.2), model, "House" .. h .. "_LampArm")
		local bulb = AB.sphere(0.6, DEEP, AB.offset(originCF, x0 + 1.6, 6, 7.6), model, "House" .. h .. "_LampBulb")
		AB.neon(bulb)
		AB.glow(bulb, DEEP, 1.5)

		-- Front step
		AB.block(Vector3.new(3, 0.4, 1.5), CREAM,
			AB.offset(originCF, x0, 0.7, 7.5), model, "House" .. h .. "_Step")

		-- Chimney
		AB.block(Vector3.new(1.4, 2.4, 1.4), BROWN,
			AB.offset(originCF, x0 + 3, 21, -1), model, "House" .. h .. "_Chimney")

		-- Decorative ribbon trim along roofline
		AB.block(Vector3.new(houseW, 0.4, 0.6), GOLD,
			AB.offset(originCF, x0, 17.8, 6.85), model, "House" .. h .. "_RoofTrim")
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
