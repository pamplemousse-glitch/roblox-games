-- DriveInMarquee — large freestanding cinema marquee on a tall pole, with "NOW
-- PLAYING" listings, blinking borders, and a top neon star.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DriveInMarquee", parent)

	local CHROME    = Color3.fromRGB(176, 176, 176)
	local CREAM     = Color3.fromRGB(255, 245, 232)
	local NEON_RED  = Color3.fromRGB(255, 48, 48)
	local NEON_YELL = Color3.fromRGB(255, 220, 80)
	local TEAL      = Color3.fromRGB(127, 202, 194)
	local DARK      = Color3.fromRGB(40, 40, 45)

	-- Pylon base (concrete + chrome)
	local base = AB.cylinder(5, 1.5, Color3.fromRGB(120, 120, 120), AB.offset(originCF, 0, 0.75, 0), model, "Base")
	base.Material = Enum.Material.Concrete
	AB.cylinder(4, 0.5, CHROME, AB.offset(originCF, 0, 1.7, 0), model, "BaseRing")
	-- Tall pole
	AB.block(Vector3.new(3, 14, 3), CHROME, AB.offset(originCF, 0, 9, 0), model, "Pole").Material = Enum.Material.Metal

	-- Big marquee box (mounted high)
	local board = AB.block(Vector3.new(18, 12, 2), CREAM, AB.offset(originCF, 0, 22, 0), model, "Board")
	-- Border trim
	AB.block(Vector3.new(18.6, 0.8, 2.4), CHROME, AB.offset(originCF, 0, 28.4, 0), model, "BoardTopTrim")
	AB.block(Vector3.new(18.6, 0.8, 2.4), CHROME, AB.offset(originCF, 0, 15.6, 0), model, "BoardBotTrim")
	AB.block(Vector3.new(0.8, 12, 2.4), CHROME, AB.offset(originCF, -9, 22, 0), model, "BoardLTrim")
	AB.block(Vector3.new(0.8, 12, 2.4), CHROME, AB.offset(originCF,  9, 22, 0), model, "BoardRTrim")

	-- Blinking bulb border (20 around perimeter, 8 across)
	for i = 0, 7 do
		local bT = AB.sphere(0.55, NEON_YELL, AB.offset(originCF, -8 + i * (16/7), 28.6, 1.1), model, "BulbT_" .. i)
		AB.neon(bT); AB.glow(bT, NEON_YELL, 1.0)
		local bB = AB.sphere(0.55, NEON_YELL, AB.offset(originCF, -8 + i * (16/7), 15.4, 1.1), model, "BulbB_" .. i)
		AB.neon(bB); AB.glow(bB, NEON_YELL, 1.0)
	end
	for i = 0, 4 do
		local bL = AB.sphere(0.55, NEON_YELL, AB.offset(originCF, -9.2, 17 + i * 2.5, 1.1), model, "BulbL_" .. i)
		AB.neon(bL); AB.glow(bL, NEON_YELL, 1.0)
		local bR = AB.sphere(0.55, NEON_YELL, AB.offset(originCF, 9.2, 17 + i * 2.5, 1.1), model, "BulbR_" .. i)
		AB.neon(bR); AB.glow(bR, NEON_YELL, 1.0)
	end

	-- "NOW PLAYING" header strip (red neon)
	local header = AB.block(Vector3.new(16, 1.5, 0.5), NEON_RED, AB.offset(originCF, 0, 27, 1.05), model, "HeaderNeon")
	AB.neon(header); AB.glow(header, NEON_RED, 2.5)
	AB.billboard(header, "NOW PLAYING", Vector2.new(320, 50), 0)

	-- Movie listing rows (3 of them — black removable letters on cream)
	for i = 0, 2 do
		local y = 25 - i * 3
		-- Slot strip (a darker line behind)
		AB.block(Vector3.new(15, 2, 0.3), CREAM:Lerp(DARK, 0.05), AB.offset(originCF, 0, y, 1.05), model, "Row_" .. i)
		-- Texty plaque
		local plaque = AB.block(Vector3.new(15, 1.6, 0.4), CREAM, AB.offset(originCF, 0, y, 1.15), model, "RowFace_" .. i)
		local titles = {"REBELS RIDE TONIGHT", "DRIVE-IN DOUBLE FEATURE", "FRI 8PM — SHOWTIME!"}
		AB.billboard(plaque, titles[i + 1], Vector2.new(320, 40), 0)
	end

	-- Top star burst
	local hub = AB.sphere(1.5, CHROME, AB.offset(originCF, 0, 30, 0), model, "StarHub")
	for i = 0, 5 do
		local angle = (i / 6) * 2 * math.pi
		local ray = AB.block(Vector3.new(3, 0.3, 0.3), NEON_RED, AB.offset(originCF, math.cos(angle) * 2.5, 30 + math.sin(angle) * 2.5, 0) * CFrame.Angles(0, 0, math.rad(math.deg(angle))), model, "StarRay_" .. i)
		AB.neon(ray); AB.glow(ray, NEON_RED, 1.5)
	end

	-- Teal flag wave on top
	AB.block(Vector3.new(4, 1.5, 0.3), TEAL, AB.offset(originCF, 1.5, 32, 0), model, "TopFlag")

	-- Pole back support brace
	AB.block(Vector3.new(2, 6, 0.6), CHROME, AB.offset(originCF, 0, 19, -1.5), model, "PoleBrace")

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
