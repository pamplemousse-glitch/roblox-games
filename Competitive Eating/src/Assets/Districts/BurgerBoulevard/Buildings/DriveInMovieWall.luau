-- DriveInMovieWall — large outdoor movie screen with vintage film displayed
-- on it, support pylons, projector booth at base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SCREEN_WHITE = Color3.fromRGB(240, 240, 230)
local SCREEN_PIC   = Color3.fromRGB(200, 180, 160) -- warm sepia tone
local DARK_BROWN   = Color3.fromRGB(70, 45, 30)
local NEON_RED     = Color3.fromRGB(255, 48, 48)
local CHROME       = Color3.fromRGB(176, 176, 176)
local CREAM        = Color3.fromRGB(255, 245, 232)
local BLACK        = Color3.fromRGB(30, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DriveInMovieWall", parent)

	-- Concrete base
	local base = AB.block(Vector3.new(38, 1, 6), Color3.fromRGB(95, 95, 95), AB.offset(originCF, 0, 0.5, 0), model, "Base")
	base.Material = Enum.Material.Concrete

	-- Two side support pylons
	AB.block(Vector3.new(3, 24, 3), DARK_BROWN, AB.offset(originCF, -16, 13, 0), model, "PylonL").Material = Enum.Material.Wood
	AB.block(Vector3.new(3, 24, 3), DARK_BROWN, AB.offset(originCF,  16, 13, 0), model, "PylonR").Material = Enum.Material.Wood

	-- Lateral braces (X-pattern wood truss between pylons)
	for i = 1, 3 do
		AB.block(Vector3.new(32, 1, 0.6), DARK_BROWN, AB.offset(originCF, 0, 4 + i * 5, 0), model, "Brace_H_" .. i).Material = Enum.Material.Wood
	end

	-- The screen body (huge white panel)
	local screen = AB.block(Vector3.new(30, 18, 1), SCREEN_WHITE, AB.offset(originCF, 0, 16, 1), model, "Screen")
	screen.Material = Enum.Material.SmoothPlastic

	-- Vintage "film image" — abstracted figures on screen (silhouettes against sepia)
	local pic = AB.block(Vector3.new(28, 16, 0.4), SCREEN_PIC, AB.offset(originCF, 0, 16, 1.55), model, "Picture")
	pic.Material = Enum.Material.SmoothPlastic

	-- Silhouetted "people" on screen
	-- Two figures (couple watching sunset)
	AB.block(Vector3.new(2, 5, 0.3), BLACK, AB.offset(originCF, -4, 14, 1.8), model, "Figure1")
	AB.sphere(2, BLACK, AB.offset(originCF, -4, 17, 1.8), model, "Figure1Head")
	AB.block(Vector3.new(2, 5, 0.3), BLACK, AB.offset(originCF,  4, 14, 1.8), model, "Figure2")
	AB.sphere(2, BLACK, AB.offset(originCF,  4, 17, 1.8), model, "Figure2Head")
	-- Setting "sun"
	local sun = AB.sphere(5, Color3.fromRGB(255, 180, 80), AB.offset(originCF, 0, 12, 1.8), model, "Sun")
	AB.glow(sun, Color3.fromRGB(255, 180, 80), 1.5)

	-- Top frame trim
	AB.block(Vector3.new(31, 1, 1.2), DARK_BROWN, AB.offset(originCF, 0, 25.5, 1), model, "TopFrame").Material = Enum.Material.Wood
	AB.block(Vector3.new(31, 1, 1.2), DARK_BROWN, AB.offset(originCF, 0, 6.5, 1), model, "BotFrame").Material = Enum.Material.Wood

	-- "NOW PLAYING" marquee at bottom
	local marquee = AB.block(Vector3.new(20, 2, 1), CREAM, AB.offset(originCF, 0, 2.5, 3), model, "MarqueeBoard")
	AB.billboard(marquee, "NOW PLAYING: REBELS RIDE TONIGHT", Vector2.new(400, 50), 0)
	local neonStrip = AB.block(Vector3.new(20.4, 0.4, 1.1), NEON_RED, AB.offset(originCF, 0, 3.6, 3), model, "MarqueeNeon")
	AB.neon(neonStrip); AB.glow(neonStrip, NEON_RED, 1.8)

	-- Speaker poles (rows of drive-in speaker posts) in front
	for i = 0, 5 do
		local x = -12 + i * 5
		AB.cylinder(0.6, 4, CHROME, AB.offset(originCF, x, 2, 4.5), model, "SpkPole_" .. i)
		AB.block(Vector3.new(1.2, 1.5, 1.2), BLACK, AB.offset(originCF, x, 4.5, 4.5), model, "SpkHead_" .. i)
	end

	-- Floodlights aimed at screen base
	local flood1 = AB.sphere(1, CREAM, AB.offset(originCF, -12, 5, 4), model, "Flood1")
	AB.neon(flood1); AB.glow(flood1, CREAM, 2.0)
	local flood2 = AB.sphere(1, CREAM, AB.offset(originCF, 12, 5, 4), model, "Flood2")
	AB.neon(flood2); AB.glow(flood2, CREAM, 2.0)

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
