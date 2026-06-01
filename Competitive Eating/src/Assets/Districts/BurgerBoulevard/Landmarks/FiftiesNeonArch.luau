-- FiftiesNeonArch — soaring googie entry archway. Two angled support legs,
-- a curved (segmented) overhead arch, glowing neon, big "BURGER BLVD" sign in the
-- center. ~50 studs wide, ~30 studs tall.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FiftiesNeonArch", parent)

	local CHROME    = Color3.fromRGB(176, 176, 176)
	local TEAL      = Color3.fromRGB(127, 202, 194)
	local NEON_RED  = Color3.fromRGB(255, 48, 48)
	local NEON_PINK = Color3.fromRGB(255, 130, 180)
	local CREAM     = Color3.fromRGB(255, 245, 232)
	local SKY       = Color3.fromRGB(135, 206, 235)
	local DARK      = Color3.fromRGB(50, 50, 55)

	-- Two concrete bases
	local baseL = AB.cylinder(6, 1.5, Color3.fromRGB(120, 120, 120), AB.offset(originCF, -22, 0.75, 0), model, "BaseL")
	baseL.Material = Enum.Material.Concrete
	local baseR = AB.cylinder(6, 1.5, Color3.fromRGB(120, 120, 120), AB.offset(originCF,  22, 0.75, 0), model, "BaseR")
	baseR.Material = Enum.Material.Concrete

	-- Two angled support legs (lean inward — googie style)
	AB.block(Vector3.new(2, 20, 2), CHROME, AB.offset(originCF, -22, 11, 0) * CFrame.Angles(0, 0, math.rad(8)), model, "LegL")
	AB.block(Vector3.new(2, 20, 2), CHROME, AB.offset(originCF,  22, 11, 0) * CFrame.Angles(0, 0, math.rad(-8)), model, "LegR")
	-- Teal accent stripes on legs
	AB.block(Vector3.new(2.2, 4, 2.2), TEAL, AB.offset(originCF, -22, 5, 0) * CFrame.Angles(0, 0, math.rad(8)), model, "LegL_Accent")
	AB.block(Vector3.new(2.2, 4, 2.2), TEAL, AB.offset(originCF,  22, 5, 0) * CFrame.Angles(0, 0, math.rad(-8)), model, "LegR_Accent")

	-- Big swooping overhead arch (curved — approximated by 9 segments)
	local archSegments = 9
	local archRadius = 22
	local archCenterY = 18
	for i = 0, archSegments - 1 do
		local t1 = i / archSegments
		local t2 = (i + 1) / archSegments
		local angle1 = math.pi - t1 * math.pi
		local angle2 = math.pi - t2 * math.pi
		local x1 = math.cos(angle1) * archRadius
		local y1 = math.sin(angle1) * 8 + archCenterY
		local x2 = math.cos(angle2) * archRadius
		local y2 = math.sin(angle2) * 8 + archCenterY
		local midX = (x1 + x2) / 2
		local midY = (y1 + y2) / 2
		local dx = x2 - x1
		local dy = y2 - y1
		local segLen = math.sqrt(dx * dx + dy * dy)
		local rot = math.atan2(dy, dx)
		local seg = AB.block(Vector3.new(segLen, 2.5, 2.5), CHROME, AB.offset(originCF, midX, midY, 0) * CFrame.Angles(0, 0, rot), model, "Arch_" .. i)
		seg.Material = Enum.Material.Metal
		seg.Reflectance = 0.2
		-- Neon strip along inner edge
		local neonSeg = AB.block(Vector3.new(segLen - 0.5, 0.6, 2.7), NEON_RED, AB.offset(originCF, midX, midY - 0.8, 0) * CFrame.Angles(0, 0, rot), model, "ArchNeon_" .. i)
		AB.neon(neonSeg); AB.glow(neonSeg, NEON_RED, 2.0)
	end

	-- Big central marquee (between the arch's legs)
	local marquee = AB.block(Vector3.new(20, 8, 1), CREAM, AB.offset(originCF, 0, 15, 0), model, "MarqueeBoard")
	-- Border
	AB.block(Vector3.new(20.4, 0.6, 1.2), CHROME, AB.offset(originCF, 0, 19.4, 0), model, "MarqueeTopTrim")
	AB.block(Vector3.new(20.4, 0.6, 1.2), CHROME, AB.offset(originCF, 0, 10.6, 0), model, "MarqueeBotTrim")
	AB.block(Vector3.new(0.6, 8, 1.2), CHROME, AB.offset(originCF, -10, 15, 0), model, "MarqueeLTrim")
	AB.block(Vector3.new(0.6, 8, 1.2), CHROME, AB.offset(originCF, 10, 15, 0), model, "MarqueeRTrim")

	-- Light bulbs around marquee (16 around perimeter)
	for i = 0, 9 do
		local bT = AB.sphere(0.6, CREAM, AB.offset(originCF, -9 + i * 2, 19.5, 0.4), model, "BulbT_" .. i)
		AB.neon(bT); AB.glow(bT, CREAM, 1.0)
		local bB = AB.sphere(0.6, CREAM, AB.offset(originCF, -9 + i * 2, 10.5, 0.4), model, "BulbB_" .. i)
		AB.neon(bB); AB.glow(bB, CREAM, 1.0)
	end

	-- Sign text (neon pink) inside marquee
	local signNeon = AB.block(Vector3.new(17, 6, 0.6), NEON_PINK, AB.offset(originCF, 0, 15, 0.4), model, "SignNeon")
	AB.neon(signNeon); AB.glow(signNeon, NEON_PINK, 3.0)
	AB.billboard(marquee, "BURGER BLVD", Vector2.new(420, 120), 0)

	-- Vertical "DRIVE-IN" sub-sign on top
	local topSign = AB.block(Vector3.new(8, 4, 1), CHROME, AB.offset(originCF, 0, 22, 0), model, "TopSign")
	local topNeon = AB.block(Vector3.new(7, 3, 1.1), NEON_RED, AB.offset(originCF, 0, 22, 0.2), model, "TopNeon")
	AB.neon(topNeon); AB.glow(topNeon, NEON_RED, 2.5)
	AB.billboard(topSign, "DRIVE-IN", Vector2.new(180, 60), 0)

	-- Big star burst capping the arch (atomic-age detail)
	local starHub = AB.sphere(2, CHROME, AB.offset(originCF, 0, 27, 0), model, "StarHub")
	for i = 0, 7 do
		local angle = (i / 8) * 2 * math.pi
		local ray = AB.block(Vector3.new(4, 0.4, 0.4), NEON_RED, AB.offset(originCF, math.cos(angle) * 3, 27 + math.sin(angle) * 3, 0) * CFrame.Angles(0, 0, math.rad(math.deg(angle))), model, "StarRay_" .. i)
		AB.neon(ray); AB.glow(ray, NEON_RED, 1.5)
	end

	-- Decorative round ornaments on the leg tops
	AB.sphere(1.5, NEON_RED, AB.offset(originCF, -22, 20, 0), model, "LegTopOrnL")
	AB.sphere(1.5, NEON_RED, AB.offset(originCF,  22, 20, 0), model, "LegTopOrnR")

	AB.pivot(model, baseL)
	AB.weldAll(model)
	return model
end
