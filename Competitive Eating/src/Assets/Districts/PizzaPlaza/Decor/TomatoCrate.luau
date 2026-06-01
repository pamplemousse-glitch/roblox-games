-- Tomato Crate — overflowing crate of red tomatoes on the vine.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CRATE  = Color3.fromRGB(160, 120, 75)
local DK_WD  = Color3.fromRGB(80, 50, 30)
local TOMATO = Color3.fromRGB(220, 60, 50)
local DK_TM  = Color3.fromRGB(180, 40, 35)
local VINE_G = Color3.fromRGB(80, 140, 60)
local LABEL  = Color3.fromRGB(245, 230, 200)
local TXT_R  = Color3.fromRGB(200, 40, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TomatoCrate", parent)

	-- Crate body
	AB.block(Vector3.new(4, 2, 4), CRATE, AB.offset(originCF, 0, 1, 0), model, "Body")
	for i = -1, 1, 2 do
		-- Slats
		for k, y in {0.5, 1, 1.5} do
			AB.block(Vector3.new(4.05, 0.15, 4.05), DK_WD, AB.offset(originCF, 0, y, 0), model, "Slat_" .. i .. "_" .. k)
		end
	end
	-- Corner posts
	for i, sx in {-1, 1} do
		for j, sz in {-1, 1} do
			AB.block(Vector3.new(0.4, 2.3, 0.4), DK_WD, AB.offset(originCF, sx * 2, 1.15, sz * 2), model, "Post_" .. i .. j)
		end
	end

	-- Tomatoes piled inside + overflowing
	for i = 1, 16 do
		local x = (math.random() - 0.5) * 3.2
		local z = (math.random() - 0.5) * 3.2
		local y = 2.2 + math.random() * 0.5
		AB.sphere(0.55 + math.random() * 0.15, TOMATO, AB.offset(originCF, x, y, z), model, "Tom_" .. i)
		-- Small green stem
		AB.sphere(0.12, VINE_G, AB.offset(originCF, x, y + 0.5, z), model, "TomStem_" .. i)
	end
	-- A vine running across the top
	AB.cylinder(0.15, 4, VINE_G,
		AB.offset(originCF, 0, 2.8, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "MainVine")
	-- Vine leaves
	for i = 1, 4 do
		AB.sphere(0.4, VINE_G, AB.offset(originCF, -1.5 + i, 2.9, math.random() - 0.5), model, "VineLeaf_" .. i)
	end

	-- "POMODORI" red sign
	AB.block(Vector3.new(2.5, 0.6, 0.1), LABEL, AB.offset(originCF, 0, 1, 2.1), model, "SignBg")
	AB.block(Vector3.new(2, 0.3, 0.05), TXT_R, AB.offset(originCF, 0, 1, 2.16), model, "SignTxt")

	-- A tomato that has fallen on the ground
	AB.sphere(0.6, DK_TM, AB.offset(originCF, 3, 0.5, 1), model, "FallenTomato")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
