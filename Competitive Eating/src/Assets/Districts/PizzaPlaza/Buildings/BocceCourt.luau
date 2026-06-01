-- Bocce Court — gravel rectangle bounded by wood rails, white painted lines,
-- a small scorekeeper's chalkboard, and a few balls on the court.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local GRAVEL    = Color3.fromRGB(195, 180, 155)
local WD        = Color3.fromRGB(110, 75, 45)
local DARK_WD   = Color3.fromRGB(80, 50, 30)
local WHITE_LN  = Color3.fromRGB(245, 240, 230)
local BALL_RED  = Color3.fromRGB(200, 50, 50)
local BALL_GRN  = Color3.fromRGB(80, 140, 60)
local BALL_TAN  = Color3.fromRGB(220, 195, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BocceCourt", parent)

	-- Court surface (gravel)
	AB.block(Vector3.new(30, 0.3, 8), GRAVEL, AB.offset(originCF, 0, 0.15, 0), model, "Court")

	-- Wood rails (long sides + short ends)
	AB.block(Vector3.new(30, 1.2, 0.6), WD, AB.offset(originCF, 0, 0.7, 4.3), model, "RailFront")
	AB.block(Vector3.new(30, 1.2, 0.6), WD, AB.offset(originCF, 0, 0.7, -4.3), model, "RailBack")
	AB.block(Vector3.new(0.6, 1.2, 8.6), WD, AB.offset(originCF, -15.3, 0.7, 0), model, "RailLeft")
	AB.block(Vector3.new(0.6, 1.2, 8.6), WD, AB.offset(originCF,  15.3, 0.7, 0), model, "RailRight")
	-- Rail posts
	for i = -3, 3 do
		AB.block(Vector3.new(0.5, 1.6, 0.5), DARK_WD, AB.offset(originCF, i * 4.5, 0.9, 4.3), model, "PostF_" .. (i + 4))
		AB.block(Vector3.new(0.5, 1.6, 0.5), DARK_WD, AB.offset(originCF, i * 4.5, 0.9, -4.3), model, "PostB_" .. (i + 4))
	end

	-- White painted center line + halfway markers
	AB.block(Vector3.new(0.4, 0.35, 8), WHITE_LN, AB.offset(originCF, 0, 0.32, 0), model, "CenterLine")
	for i, x in {-10, -5, 5, 10} do
		AB.block(Vector3.new(0.3, 0.35, 1), WHITE_LN, AB.offset(originCF, x, 0.32, 0), model, "MarkerLine_" .. i)
	end

	-- Bocce balls scattered on court
	AB.sphere(1.2, BALL_RED, AB.offset(originCF, 7, 0.9, 1.5), model, "BallRed1")
	AB.sphere(1.2, BALL_RED, AB.offset(originCF, 9, 0.9, -1), model, "BallRed2")
	AB.sphere(1.2, BALL_GRN, AB.offset(originCF, 8, 0.9, 0.5), model, "BallGrn1")
	AB.sphere(1.2, BALL_GRN, AB.offset(originCF, 6, 0.9, -2), model, "BallGrn2")
	-- Pallino (small target ball)
	AB.sphere(0.6, BALL_TAN, AB.offset(originCF, 8.5, 0.6, 0), model, "Pallino")

	-- Scorekeeper's chalkboard at one end
	AB.block(Vector3.new(0.4, 3.5, 0.4), DARK_WD, AB.offset(originCF, -16, 1.75, 0), model, "ScorePost")
	AB.block(Vector3.new(3, 2.5, 0.2), Color3.fromRGB(30, 35, 30), AB.offset(originCF, -16, 4, 0), model, "ScoreBoard")
	AB.block(Vector3.new(3.4, 0.3, 0.3), DARK_WD, AB.offset(originCF, -16, 5.25, 0), model, "ScoreFrameTop")
	AB.block(Vector3.new(3.4, 0.3, 0.3), DARK_WD, AB.offset(originCF, -16, 2.75, 0), model, "ScoreFrameBot")
	-- Chalk scribbles (white blocks)
	for i = 1, 4 do
		AB.block(Vector3.new(0.4, 0.6, 0.05), WHITE_LN, AB.offset(originCF, -16.8 + (i * 0.5), 4, 0.15), model, "ScoreMark_" .. i)
	end

	-- Spectator bench (long wood plank)
	AB.block(Vector3.new(12, 0.4, 1.5), WD, AB.offset(originCF, 0, 2.5, 6.5), model, "BenchSeat")
	AB.block(Vector3.new(12, 2, 0.4), WD, AB.offset(originCF, 0, 3.5, 7.2), model, "BenchBack")
	for i, x in {-5, -1.5, 1.5, 5} do
		AB.block(Vector3.new(0.4, 2.5, 1.5), DARK_WD, AB.offset(originCF, x, 1.25, 6.5), model, "BenchLeg_" .. i)
	end

	-- Lamp post by court
	AB.cylinder(0.4, 9, DARK_WD, AB.offset(originCF, -16, 5, 7), model, "LampPost")
	local lamp = AB.sphere(1.4, Color3.fromRGB(255, 220, 140), AB.offset(originCF, -16, 9.5, 7), model, "LampGlobe")
	AB.neon(lamp)
	AB.glow(lamp, lamp.Color, 2)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
