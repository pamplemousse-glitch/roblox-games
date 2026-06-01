-- Omikuji Rack — wooden display stand holding tubes of fortune paper strips
-- + a few omikuji papers tied to a rope above (the "bad fortune" disposal).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local STONE       = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("OmikujiRack", parent)

	-- Stone base
	AB.block(Vector3.new(6, 0.4, 3), STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Base")

	-- Wood rack frame (low table with back board)
	AB.block(Vector3.new(6, 3, 0.3), WARM_WOOD,
		AB.offset(originCF, 0, 1.9, -1.3), model, "BackBoard")
	-- Top tray
	AB.block(Vector3.new(6, 0.3, 2.4), WARM_WOOD,
		AB.offset(originCF, 0, 1.55, 0), model, "TrayTop")
	-- Tray legs (4 small)
	for i, offset in {
		Vector3.new(-2.7, 0.7, -1),
		Vector3.new( 2.7, 0.7, -1),
		Vector3.new(-2.7, 0.7,  1),
		Vector3.new( 2.7, 0.7,  1),
	} do
		AB.block(Vector3.new(0.3, 1.4, 0.3), DARK_WOOD,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "Leg_" .. i)
	end

	-- 5 vermilion-painted hex-style tubes (cylinders) holding omikuji sticks
	for i = 1, 5 do
		local x = (i - 3) * 1.0
		AB.cylinder(0.6, 2.4, VERMILION,
			AB.offset(originCF, x, 2.9, 0.2), model, "Tube_" .. i)
		-- Tube top cap
		AB.cylinder(0.65, 0.15, DARK_WOOD,
			AB.offset(originCF, x, 4.05, 0.2), model, "TubeCap_" .. i)
		-- Sticks poking out
		for j = 1, 3 do
			AB.cylinder(0.06, 0.7, PAPER_WHITE,
				AB.offset(originCF, x + (j - 2) * 0.15, 4.4, 0.2), model, "Stick_" .. i .. "_" .. j)
		end
	end

	-- Back board sign — vermilion with glowing yellow center
	local sign = AB.block(Vector3.new(5, 1.6, 0.1), VERMILION,
		AB.offset(originCF, 0, 3, -1.18), model, "Sign")
	AB.neon(sign)
	local signText = AB.block(Vector3.new(2.4, 0.6, 0.12), LANTERN_Y,
		AB.offset(originCF, 0, 3, -1.16), model, "SignText")
	AB.neon(signText)
	AB.glow(signText, LANTERN_Y, 1.5)

	-- Rope above the rack with 4 tied bad-fortune omikuji papers
	AB.cylinder(0.06, 6, DARK_WOOD,
		AB.offset(originCF, 0, 5, -1) * CFrame.Angles(0, 0, math.rad(90)),
		model, "Rope")
	for i = 1, 4 do
		local x = (i - 2.5) * 1.3
		AB.block(Vector3.new(0.3, 1, 0.05), PAPER_WHITE,
			AB.offset(originCF, x, 4.5, -1), model, "TiedPaper_" .. i)
	end

	-- Coin-offering box at front (small wood box with slot)
	AB.block(Vector3.new(1.6, 1, 1), DARK_WOOD,
		AB.offset(originCF, 0, 0.9, 1.4), model, "OfferingBox")
	AB.block(Vector3.new(1.0, 0.05, 0.2), Color3.fromRGB(30, 25, 25),
		AB.offset(originCF, 0, 1.42, 1.4), model, "OfferingSlot")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
