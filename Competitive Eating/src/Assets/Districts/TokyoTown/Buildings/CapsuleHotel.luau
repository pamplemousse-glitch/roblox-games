-- Capsule Hotel — tall tower backdrop. Stacked rows of small pod windows
-- glowing soft white-yellow, dark metal frame, lobby sign at base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local METAL_GREY  = Color3.fromRGB(90, 90, 100)
local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local POD_WHITE   = Color3.fromRGB(240, 235, 220)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local CYAN_GLOW   = Color3.fromRGB(140, 220, 230)
local STONE       = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CapsuleHotel", parent)

	-- Stone base / lobby footprint
	AB.block(Vector3.new(24, 0.4, 14), STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Lobby (first floor, brighter)
	AB.block(Vector3.new(24, 6, 14), METAL_GREY,
		AB.offset(originCF, 0, 3.4, 0), model, "Lobby")
	-- Lobby glass front
	AB.part({
		size  = Vector3.new(20, 5, 0.4),
		color = CYAN_GLOW, transparency = 0.4,
		cf    = AB.offset(originCF, 0, 3.5, 7.2),
		name  = "LobbyGlass",
	}, model)
	-- Lobby door frame
	AB.block(Vector3.new(20, 0.4, 0.5), DARK_METAL, AB.offset(originCF, 0, 6.2, 7.3), model, "LobbyTopFrame")
	AB.block(Vector3.new(20, 0.4, 0.5), DARK_METAL, AB.offset(originCF, 0, 0.8, 7.3), model, "LobbyBotFrame")
	-- Lobby door (gap centered)
	AB.block(Vector3.new(0.4, 5.5, 0.6), DARK_METAL, AB.offset(originCF, -3, 3.5, 7.4), model, "LobbyDoorL")
	AB.block(Vector3.new(0.4, 5.5, 0.6), DARK_METAL, AB.offset(originCF,  3, 3.5, 7.4), model, "LobbyDoorR")

	-- Tall tower body (above lobby)
	AB.block(Vector3.new(22, 40, 13), DARK_METAL,
		AB.offset(originCF, 0, 26.4, 0), model, "Tower")

	-- Pod windows — 10 rows × 8 columns on the front face
	for row = 0, 9 do
		for col = 0, 7 do
			local x = (col - 3.5) * 2.4
			local y = 9 + row * 4
			-- Pod glass (slightly glowing)
			local pod = AB.block(Vector3.new(1.8, 1.8, 0.4), POD_WHITE,
				AB.offset(originCF, x, y, 6.6), model, "Pod_" .. row .. "_" .. col)
			-- Random pods are "lit"
			if (row + col) % 3 == 0 then
				AB.neon(pod)
				pod.Color = LANTERN_Y
			end
			-- Pod frame
			AB.block(Vector3.new(2, 0.15, 0.5), DARK_METAL, AB.offset(originCF, x, y + 1, 6.62), model, "PodTop_" .. row .. "_" .. col)
			AB.block(Vector3.new(2, 0.15, 0.5), DARK_METAL, AB.offset(originCF, x, y - 1, 6.62), model, "PodBot_" .. row .. "_" .. col)
		end
	end

	-- Side narrow band of pod windows (left + right side, single column each)
	for i, x in {-11.2, 11.2} do
		for row = 0, 9 do
			local y = 9 + row * 4
			local pod = AB.block(Vector3.new(0.4, 1.4, 1.4), POD_WHITE,
				AB.offset(originCF, x, y, -3), model, "SidePod_" .. i .. "_" .. row)
			if row % 2 == 0 then AB.neon(pod) end
		end
	end

	-- Roof crown — dark band + small antenna
	AB.block(Vector3.new(24, 1.5, 14), VERMILION,
		AB.offset(originCF, 0, 47, 0), model, "RoofCrown")
	-- Glowing top edge band
	local roofGlow = AB.block(Vector3.new(24.1, 0.3, 14.1), LANTERN_Y,
		AB.offset(originCF, 0, 47.9, 0), model, "RoofGlow")
	AB.neon(roofGlow)

	-- Antenna
	AB.cylinder(0.3, 8, METAL_GREY,
		AB.offset(originCF, 0, 52, 0), model, "Antenna")
	-- Blinking red beacon
	local beacon = AB.sphere(0.6, VERMILION,
		AB.offset(originCF, 0, 56, 0), model, "Beacon")
	AB.neon(beacon)
	AB.glow(beacon, VERMILION, 3)

	-- "CAPSULE" sign — vertical banner along left side of lobby
	local sign = AB.block(Vector3.new(0.4, 5, 1.5), VERMILION,
		AB.offset(originCF, -11.7, 3.5, 4), model, "CapsuleSign")
	AB.neon(sign)
	AB.glow(sign, VERMILION, 2)
	AB.block(Vector3.new(0.45, 5.4, 1.9), DARK_METAL,
		AB.offset(originCF, -11.7, 3.5, 4), model, "CapsuleSignBorder")

	-- Lobby paper plaque (right side of door)
	AB.block(Vector3.new(2, 1, 0.4), PAPER_WHITE,
		AB.offset(originCF, 5, 4.5, 7.4), model, "LobbyPlaque")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
