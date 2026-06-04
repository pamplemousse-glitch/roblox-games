-- RideRebuildMiniTrain: classic 1900s Coney Island steam railway.
-- Belle-Époque palette, static v1.0 prop (no RideController coupling).
-- Oval track ~110×150 stud. Engine = burgundy boiler + brass bands +
-- deep_wood smokestack/cowcatcher + ivory cab roof. 2 passenger cars w/
-- bench seats. Universal contract: clone → clear → PivotAnchor → build → weld → PivotTo.
local ServerStorage     = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))
task.wait(1)
local m = workspace:FindFirstChild("MiniTrain")
if not m then
	warn("[RideRebuildMiniTrain] workspace.MiniTrain not found — skipping rebuild")
	return
end
local originalPivot = m:GetPivot()
local backup = m:Clone()
backup.Name = "MiniTrain_PreBelleEpoque_2026-06-03"
backup.Parent = ServerStorage
m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Belle-Époque palette (inline; no Palettes.luau module yet) ─────────────
local BURGUNDY     = Color3.fromRGB(130, 30, 50)
local IVORY        = Color3.fromRGB(245, 235, 205)
local ANTIQUE_GOLD = Color3.fromRGB(200, 160, 80)
local DEEP_WOOD    = Color3.fromRGB(110, 75, 45)
local WOOD_PLANK   = Color3.fromRGB(160, 110, 70)
local WROUGHT_IRON = Color3.fromRGB(40, 35, 40)
local CREAM        = Color3.fromRGB(230, 215, 180)
local CRIMSON_GLOW = Color3.fromRGB(220, 60, 70)
local STEAM_WHITE  = Color3.fromRGB(245, 240, 235)

-- ── Identity-rotation PivotAnchor (MANDATORY) ──────────────────────────────
local pivotAnchor = AB.part({
	size = Vector3.new(0.1, 0.1, 0.1), color = Color3.new(1,1,1),
	cf = CFrame.new(), canCollide = false, transparency = 1, name = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── Track geometry (oval, local space) ─────────────────────────────────────
local TRACK_RX, TRACK_RZ = 55, 75
local TIE_COUNT, RAIL_SEGS = 44, 52
local TIE_W, TIE_H, TIE_LEN = 1.4, 0.6, 8
local RAIL_W, RAIL_H, RAIL_GAUGE = 0.4, 0.5, 5
local TIE_Y = 0.3
local RAIL_TOP_Y = TIE_Y + TIE_H/2 + RAIL_H/2
local function ovalPos(t)     return Vector3.new(math.cos(t)*TRACK_RX, 0, math.sin(t)*TRACK_RZ) end
local function ovalTangent(t) return Vector3.new(-math.sin(t)*TRACK_RX, 0, math.cos(t)*TRACK_RZ).Unit end
local trackFolder = Instance.new("Folder")
trackFolder.Name = "Track"
trackFolder.Parent = m
-- Ballast bed beneath ties.
AB.block(Vector3.new(TRACK_RX*2 + 12, 0.2, TRACK_RZ*2 + 12), WOOD_PLANK,
	CFrame.new(0, -0.1, 0), trackFolder, "BallastBed")
-- Wooden ties (deep_wood).
for i = 1, TIE_COUNT do
	local th = (i / TIE_COUNT) * math.pi * 2
	local pos = ovalPos(th) + Vector3.new(0, TIE_Y, 0)
	local tg = ovalTangent(th)
	local look = Vector3.new(-tg.Z, 0, tg.X)
	AB.block(Vector3.new(TIE_W, TIE_H, TIE_LEN), DEEP_WOOD,
		CFrame.lookAt(pos, pos + look), trackFolder, "Tie_" .. i)
end
-- Wrought-iron rails — inner + outer, segmented along the ellipse.
for i = 1, RAIL_SEGS do
	local t0 = ((i - 1) / RAIL_SEGS) * math.pi * 2
	local t1 = (i        / RAIL_SEGS) * math.pi * 2
	local p0, p1 = ovalPos(t0), ovalPos(t1)
	local mid = (p0 + p1) / 2
	local segLen = (p1 - p0).Magnitude + 0.3
	local tg = (p1 - p0).Unit
	local nrm = Vector3.new(-tg.Z, 0, tg.X)
	for _, side in ipairs({-1, 1}) do
		local pos = mid + nrm * (side * RAIL_GAUGE / 2) + Vector3.new(0, RAIL_TOP_Y, 0)
		AB.block(Vector3.new(RAIL_W, RAIL_H, segLen), WROUGHT_IRON,
			CFrame.lookAt(pos, pos + tg), trackFolder,
			"Rail_" .. i .. "_" .. (side == -1 and "L" or "R"))
	end
end

-- ── Shared helper: spoked wheel (brass hub + iron rim) ─────────────────────
local function spokeWheel(parent, cf, dia, thickness, n)
	AB.part({size = Vector3.new(thickness, dia, dia), color = WROUGHT_IRON, cf = cf,
		shape = Enum.PartType.Cylinder, name = n .. "_Rim"}, parent)
	AB.part({size = Vector3.new(thickness + 0.2, dia*0.35, dia*0.35), color = ANTIQUE_GOLD, cf = cf,
		shape = Enum.PartType.Cylinder, name = n .. "_Hub"}, parent)
end

-- ── Steam locomotive ───────────────────────────────────────────────────────
local ENGINE_THETA = -math.pi / 2
local engineCF = CFrame.lookAt(
	ovalPos(ENGINE_THETA) + Vector3.new(0, RAIL_TOP_Y + RAIL_H/2 + 2.6, 0),
	ovalPos(ENGINE_THETA) + Vector3.new(0, RAIL_TOP_Y + RAIL_H/2 + 2.6, 0) + ovalTangent(ENGINE_THETA))
local engine = Instance.new("Model")
engine.Name = "Engine"
engine.Parent = m
local CHASSIS_W, CHASSIS_H = 5, 0.8
local BOILER_LEN, BOILER_DIA = 14, 4.8
local CAB_LEN, CAB_W, CAB_H = 5, 5.2, 4
-- Chassis (deep wood plank base).
local chassis = AB.block(Vector3.new(CHASSIS_W, CHASSIS_H, 22), DEEP_WOOD,
	engineCF * CFrame.new(0, -2.2, 0), engine, "Chassis")
engine.PrimaryPart = chassis
-- Boiler — burgundy cylinder along travel axis (X→Z rotation).
AB.part({size = Vector3.new(BOILER_LEN, BOILER_DIA, BOILER_DIA), color = BURGUNDY,
	cf = engineCF * CFrame.new(0, 0, 1.0) * CFrame.Angles(0, math.rad(90), 0),
	shape = Enum.PartType.Cylinder, name = "Boiler"}, engine)
-- Brass bands around the boiler.
for i = 1, 4 do
	local zOff = 1.0 - BOILER_LEN/2 + i * (BOILER_LEN / 5)
	AB.part({size = Vector3.new(0.4, BOILER_DIA + 0.2, BOILER_DIA + 0.2), color = ANTIQUE_GOLD,
		cf = engineCF * CFrame.new(0, 0, zOff) * CFrame.Angles(0, math.rad(90), 0),
		shape = Enum.PartType.Cylinder, name = "BrassBand_" .. i}, engine)
end
-- Boiler front cap.
AB.sphere(BOILER_DIA + 0.4, ANTIQUE_GOLD,
	engineCF * CFrame.new(0, 0, 1.0 + BOILER_LEN/2 - 0.2), engine, "BoilerFrontCap")
-- Headlamp + brass bezel.
AB.cylinder(1.8, 1.4, CREAM,
	engineCF * CFrame.new(0, 1.4, 1.0 + BOILER_LEN/2 + 0.6) * CFrame.Angles(math.rad(90), 0, 0),
	engine, "Headlamp")
AB.part({size = Vector3.new(0.4, 2.2, 2.2), color = ANTIQUE_GOLD,
	cf = engineCF * CFrame.new(0, 1.4, 1.0 + BOILER_LEN/2 + 0.4) * CFrame.Angles(0, math.rad(90), 0),
	shape = Enum.PartType.Cylinder, name = "HeadlampBezel"}, engine)
-- Smokestack — deep_wood flared chimney with brass cap.
local stackZ, STACK_H = 1.0 + BOILER_LEN/2 - 4, 5.5
AB.cylinder(2.2, STACK_H, DEEP_WOOD,
	engineCF * CFrame.new(0, BOILER_DIA/2 + STACK_H/2, stackZ), engine, "Smokestack")
AB.cylinder(3.5, 0.9, ANTIQUE_GOLD,
	engineCF * CFrame.new(0, BOILER_DIA/2 + STACK_H - 0.2, stackZ), engine, "SmokestackCap")
AB.sphere(3.2, STEAM_WHITE,
	engineCF * CFrame.new(0, BOILER_DIA/2 + STACK_H + 1.6, stackZ), engine, "SteamPuff_1")
AB.sphere(2.4, STEAM_WHITE,
	engineCF * CFrame.new(0.7, BOILER_DIA/2 + STACK_H + 3.0, stackZ - 0.4), engine, "SteamPuff_2")
-- Steam dome (brass) + whistle.
AB.sphere(2.6, ANTIQUE_GOLD,
	engineCF * CFrame.new(0, BOILER_DIA/2 + 0.6, 2.0), engine, "SteamDome")
AB.cylinder(0.7, 1.4, ANTIQUE_GOLD,
	engineCF * CFrame.new(0.6, BOILER_DIA/2 + 1.2, 0.4), engine, "Whistle")
-- Cab — burgundy walls + ivory roof + brass trim.
local cabZ = 1.0 - BOILER_LEN/2 - CAB_LEN/2 - 0.2
AB.block(Vector3.new(CAB_W, CAB_H, 0.4), BURGUNDY,
	engineCF * CFrame.new(0, CAB_H/2 - 1.8, cabZ - CAB_LEN/2), engine, "CabBackWall")
for _, sx in ipairs({-1, 1}) do
	local sTag = (sx == -1 and "L" or "R")
	AB.block(Vector3.new(0.4, 1.4, CAB_LEN), BURGUNDY,
		engineCF * CFrame.new(sx * CAB_W/2, CAB_H/2 - 2.9, cabZ), engine, "CabSideLower_" .. sTag)
	AB.block(Vector3.new(0.4, 0.6, CAB_LEN), BURGUNDY,
		engineCF * CFrame.new(sx * CAB_W/2, CAB_H/2 - 0.5, cabZ), engine, "CabSideUpper_" .. sTag)
	for _, sz in ipairs({-1, 1}) do
		AB.block(Vector3.new(0.4, 2.6, 0.4), BURGUNDY,
			engineCF * CFrame.new(sx * CAB_W/2, CAB_H/2 - 1.3, cabZ + sz * (CAB_LEN/2 - 0.2)),
			engine, "CabPillar_" .. sTag .. (sz == 1 and "F" or "R"))
	end
end
AB.block(Vector3.new(CAB_W + 0.6, 0.4, CAB_LEN + 0.6), IVORY,
	engineCF * CFrame.new(0, CAB_H/2 + 0.2, cabZ), engine, "CabRoof")
for _, sz in ipairs({-1, 1}) do
	AB.block(Vector3.new(CAB_W + 0.8, 0.2, 0.3), ANTIQUE_GOLD,
		engineCF * CFrame.new(0, CAB_H/2 + 0.4, cabZ + sz * ((CAB_LEN + 0.6)/2 - 0.15)),
		engine, "CabRoofTrim_" .. (sz == 1 and "F" or "R"))
end
-- Cowcatcher — deep_wood base + 5 angled slats + brass buffer beam.
local cowZ = 1.0 + BOILER_LEN/2 + 1.8
AB.block(Vector3.new(CHASSIS_W + 1, 1.0, 2.8), DEEP_WOOD,
	engineCF * CFrame.new(0, -1.8, cowZ), engine, "CowcatcherBase")
for i = 1, 5 do
	local xOff = -CHASSIS_W/2 - 0.4 + (i - 1) * ((CHASSIS_W + 0.8) / 4)
	AB.wedge(Vector3.new(0.5, 2.0, 2.2), DEEP_WOOD,
		engineCF * CFrame.new(xOff, -1.4, cowZ + 0.6) * CFrame.Angles(math.rad(-25), 0, 0),
		engine, "CowcatcherSlat_" .. i)
end
AB.block(Vector3.new(CHASSIS_W + 1.2, 0.4, 0.4), ANTIQUE_GOLD,
	engineCF * CFrame.new(0, -1.2, cowZ + 1.2), engine, "BufferBeam")
-- Drive wheels — 0-6-0 classic. 3 axles, spoked wheels, brass connecting rod.
for i = 1, 3 do
	local zOff = -BOILER_LEN/2 + 2 + (i - 1) * 5
	for _, side in ipairs({-1, 1}) do
		spokeWheel(engine, engineCF * CFrame.new(side * (CHASSIS_W/2 + 0.1), -2.6, zOff),
			3.0, 0.6, "DriveWheel_" .. i .. (side == -1 and "L" or "R"))
	end
end
for _, side in ipairs({-1, 1}) do
	AB.block(Vector3.new(0.3, 0.4, 11), ANTIQUE_GOLD,
		engineCF * CFrame.new(side * (CHASSIS_W/2 + 0.5), -2.6, -BOILER_LEN/2 + 7),
		engine, "ConnectingRod_" .. (side == -1 and "L" or "R"))
end

-- ── Passenger cars (2× open-air wooden excursion coaches) ──────────────────
local CAR_LEN, CAR_W, CAR_H, CAR_SPACING = 12, 5, 3.2, 5
local function buildPassengerCar(idx)
	local arcOff = BOILER_LEN/2 + CAB_LEN + CAR_SPACING + (idx - 0.5) * (CAR_LEN + CAR_SPACING)
	local avgR = (TRACK_RX + TRACK_RZ) / 2
	local theta = ENGINE_THETA - (arcOff / avgR)
	local pos = ovalPos(theta) + Vector3.new(0, RAIL_TOP_Y + RAIL_H/2 + CAR_H/2 + 0.5, 0)
	local cf = CFrame.lookAt(pos, pos + ovalTangent(theta))
	local car = Instance.new("Model")
	car.Name = "PassengerCar_" .. idx
	car.Parent = m
	local chassisCar = AB.block(Vector3.new(CAR_W, 0.5, CAR_LEN), DEEP_WOOD,
		cf * CFrame.new(0, -CAR_H/2 + 0.25, 0), car, "Chassis")
	car.PrimaryPart = chassisCar
	-- Side panels (burgundy wainscot + brass trim + ivory upper).
	for _, side in ipairs({-1, 1}) do
		local tag = (side == -1 and "L" or "R")
		AB.block(Vector3.new(0.3, 1.4, CAR_LEN), BURGUNDY,
			cf * CFrame.new(side * CAR_W/2, -CAR_H/2 + 1.2, 0), car, "SideLower_" .. tag)
		AB.block(Vector3.new(0.25, 0.4, CAR_LEN), ANTIQUE_GOLD,
			cf * CFrame.new(side * CAR_W/2, -CAR_H/2 + 1.95, 0), car, "SideTrim_" .. tag)
		AB.block(Vector3.new(0.3, 0.8, CAR_LEN), IVORY,
			cf * CFrame.new(side * CAR_W/2, -CAR_H/2 + 2.55, 0), car, "SideUpper_" .. tag)
	end
	-- End caps.
	for _, endSide in ipairs({-1, 1}) do
		local tag = (endSide == -1 and "Rear" or "Front")
		AB.block(Vector3.new(CAR_W, 2.6, 0.3), BURGUNDY,
			cf * CFrame.new(0, -CAR_H/2 + 1.7, endSide * CAR_LEN/2), car, "EndPanel_" .. tag)
		AB.block(Vector3.new(CAR_W + 0.4, 0.2, 0.25), ANTIQUE_GOLD,
			cf * CFrame.new(0, -CAR_H/2 + 1.95, endSide * CAR_LEN/2), car, "EndTrim_" .. tag)
	end
	-- 2 bench seats facing each other, deep_wood backrest + cream cushion.
	for s = 1, 2 do
		local zPos = -CAR_LEN/2 + 1.5 + (s - 1) * (CAR_LEN - 3)
		local seat = Instance.new("Seat")
		seat.Name = "Seat_" .. s
		seat.Size = Vector3.new(CAR_W - 0.8, 0.5, 2.4)
		seat.Color = WOOD_PLANK
		seat.Material = Enum.Material.SmoothPlastic
		seat.Anchored = true
		seat.TopSurface = Enum.SurfaceType.Smooth
		seat.BottomSurface = Enum.SurfaceType.Smooth
		seat.CFrame = cf * CFrame.new(0, -CAR_H/2 + 0.85, zPos)
		seat.Parent = car
		local backFacing = (s == 1) and 1 or -1
		AB.block(Vector3.new(CAR_W - 0.8, 1.6, 0.3), DEEP_WOOD,
			cf * CFrame.new(0, -CAR_H/2 + 1.5, zPos + backFacing * 1.1), car, "Backrest_" .. s)
		AB.block(Vector3.new(CAR_W - 1.0, 0.2, 2.0), CREAM,
			cf * CFrame.new(0, -CAR_H/2 + 1.15, zPos), car, "Cushion_" .. s)
	end
	-- Roof + 4 brass corner posts.
	AB.block(Vector3.new(CAR_W + 0.4, 0.3, CAR_LEN + 0.4), IVORY,
		cf * CFrame.new(0, -CAR_H/2 + 3.1, 0), car, "Roof")
	for _, sX in ipairs({-1, 1}) do
		for _, sZ in ipairs({-1, 1}) do
			AB.block(Vector3.new(0.25, 1.0, 0.25), ANTIQUE_GOLD,
				cf * CFrame.new(sX * (CAR_W/2 - 0.2), -CAR_H/2 + 2.6, sZ * (CAR_LEN/2 - 0.3)),
				car, "RoofPost_" .. (sX == -1 and "L" or "R") .. (sZ == -1 and "R" or "F"))
		end
	end
	-- Wheels — 2 axles, spoked.
	for i = 1, 2 do
		local zOff = -CAR_LEN/2 + 2.5 + (i - 1) * (CAR_LEN - 5)
		for _, side in ipairs({-1, 1}) do
			spokeWheel(car, cf * CFrame.new(side * (CAR_W/2 - 0.1), -CAR_H/2 - 0.5, zOff),
				2.4, 0.5, "CarWheel_" .. i .. (side == -1 and "L" or "R"))
		end
	end
	-- Rear coupling.
	AB.block(Vector3.new(0.5, 0.5, 1.5), ANTIQUE_GOLD,
		cf * CFrame.new(0, -CAR_H/2 + 0.5, -CAR_LEN/2 - 0.6), car, "RearCoupling")
end
buildPassengerCar(1)
buildPassengerCar(2)
-- Rear lantern (crimson_glow neon hero touch).
local lastTheta = ENGINE_THETA - ((BOILER_LEN/2 + CAB_LEN + CAR_SPACING * 3 + CAR_LEN * 2) / ((TRACK_RX + TRACK_RZ) / 2))
local lpos = ovalPos(lastTheta) + Vector3.new(0, RAIL_TOP_Y + 4.2, 0)
local lcf  = CFrame.lookAt(lpos, lpos + ovalTangent(lastTheta))
local lantern = AB.cylinder(0.9, 1.2, CRIMSON_GLOW,
	lcf * CFrame.new(0, 0, -7.2) * CFrame.Angles(math.rad(90), 0, 0), m, "RearLantern")
AB.neon(lantern)

-- ── Finalize ───────────────────────────────────────────────────────────────
AB.weldAll(m)
m:PivotTo(originalPivot)
print(string.format("[RideRebuildMiniTrain] Belle-Époque rebuild — %d descendants", #m:GetDescendants()))
