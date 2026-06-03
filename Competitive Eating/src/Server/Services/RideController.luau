-- Animates all carnival rides. Runs server-side.
-- Spin rides rotate via PivotTo(). PirateShip pendulums. Drop Tower rises/drops.
-- ScreamerCoaster: ProximityPrompt boarding, PivotTo cart movement, fade RemoteEvent.
-- Boarding: ProximityPrompts → Seat:Sit() + Motor6D carry riders along.

local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")

local RideController = {}

local SPIN_RIDES = {
	{ name = "Carousel",       rps = 0.35, gallopAmplitude = 0.75, gallopFreq = 0.6 },
	{ name = "TeacupRide",     rps = 0.55 },
	-- SwingCarousel cycle: 15s rest → 15s spin-up → 20s peak → 15s spin-down → loop.
	-- Chairs swing out radially (Roblox-faked centrifugal) AND lift Y
	-- (chains "shorten" visually as rotation speeds — rope-physics analog).
	{ name = "SwingCarousel",  rps = 0.55,
	  cyclePause = 15, cycleAccel = 15, cyclePeak = 20, cycleDecel = 15,
	  swingOutAmplitude = 8,           -- radial outward at peak
	  swingDropAmplitude = 9,          -- Y rise at peak (was a drop at rest)
	},
	{ name = "TiltAWhirl",     rps = 0.75 },
}

-- ParachuteJump: parachutes ride up, hold, drop, brief stop, repeat
local PARACHUTE_TOP_Y    = 183   -- where ChuteBasket sits at top
local PARACHUTE_BOTTOM_Y = 7     -- ground-level position
local PARACHUTE_HOLD_TOP = 3     -- seconds hold at top
local PARACHUTE_FALL_T   = 6     -- seconds slow fall
local PARACHUTE_HOLD_BOT = 1     -- seconds at bottom
local PARACHUTE_RISE_T   = 2     -- seconds fast rise back to top
local PARACHUTE_CYCLE    = PARACHUTE_HOLD_TOP + PARACHUTE_FALL_T + PARACHUTE_HOLD_BOT + PARACHUTE_RISE_T  -- 12s

local PENDULUM_RIDES = {
	-- pivotY: override WorldPivot Y to this value instead of part centroid
	-- (needed when static support frame inflates centroid away from true swing axis)
	-- axis: "X" or "Z" — rotation axis perpendicular to ship's length
	{ name = "PirateShipRide", amplitude = 0.55, frequency = 0.7, pivotY = 28, axis = "Z" },  -- banana boat axle kept at Y=28 so hull hangs near ground
}

local COASTER_SPEED = 28
local RIDE_DURATION = 25
local FLUME_SPEED   = 14  -- studs/s

-- Drop Tower
local DROP_RISE  = 8;  local DROP_FALL  = 45; local DROP_BRAKE = 10
local DROP_HOLD  = 2.5; local DROP_LOAD  = 8
local DROP_Y_MIN = 7;  local DROP_Y_MAX = 50; local DROP_BRAKE_Y = 15
local DROP_CX, DROP_CZ = 155, -175
local SCRAMBLER_MAIN_RPS = 0.28   -- main arm rotation speed
local SCRAMBLER_SUB_RPS  = -0.84  -- sub-hub counter-rotation (3× main, opposite)

-- ── Types ─────────────────────────────────────────────────────────────────────

type HorseGallop   = { parts: { BasePart }, seat: Seat?, phase: number, prevOffset: number }
type ChairSwing    = { parts: { BasePart }, chains: { BasePart }, seat: Seat?, prevOffset: number, prevY: number }
type SpinState     = { model: Model, angle: number, rps: number, currentRps: number,
                       rampRate: number, baseCF: CFrame,
                       gallopAmplitude: number?, gallopFreq: number?,
                       horses: { HorseGallop }?, totalTime: number?,
                       swingOutAmplitude: number?, swingDropAmplitude: number?, chairs: { ChairSwing }?,
                       cyclePause: number?, cycleAccel: number?, cyclePeak: number?, cycleDecel: number?,
                       cycleT: number? }
type PendulumState = { model: Model, amp: number, freq: number, t: number, baseCF: CFrame, axis: string }
type CoasterState  = {
	cartModel  : Model,
	primaryPart: BasePart,
	seat       : Seat,
	prompt     : ProximityPrompt,
	waypoints  : { Vector3 },
	cumDist    : { number },
	totalDist  : number,
	dist       : number,
	rider      : Player?,       -- current rider, nil if empty
	riding     : boolean,       -- true while player is actively seated
	fadeRemote : RemoteEvent,
}
type DropPhase     = "idle" | "loading" | "rising" | "hold" | "dropping"
type DropData      = { gondola: Part, seatParts: { Seat }, seatOffsets: { CFrame },
                       state: DropPhase, y: number, tHold: number, tLoad: number,
                       prompt: ProximityPrompt }
type FlumeState    = { boat: Model, hull: BasePart, seat: Seat, prompt: ProximityPrompt,
                       waypoints: { Vector3 }, cumDist: { number }, totalDist: number,
                       dist: number, rider: Player?, riding: boolean, fadeRemote: RemoteEvent }
type ScramblerData = {
    baseStructure : Model,
    bsOffset      : CFrame,       -- BaseStructure pivot offset from baseCF (constant)
    armGroups     : { Model },
    armOffsets    : { CFrame },   -- each arm pivot offset from baseCF (constant)
    seats         : { Seat },
    seatArmIdx    : { number },   -- which armGroup (1-indexed) each seat belongs to
    seatOffset    : { CFrame },   -- seat CFrame relative to arm's rest WorldPivot (constant)
    mainAngle     : number,
    subAngle      : number,
    baseCF        : CFrame,
}

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function anchorAll(model: Model)
	for _, p in model:GetDescendants() do
		if p:IsA("BasePart") and not p.Anchored then p.Anchored = true end
	end
end

-- Averages part positions. If any descendants are tagged "Structural", ONLY those are
-- counted — decorative additions (canopy stripes, lights, signage) cannot poison the
-- centroid and cause the ride to drift around the wrong pivot point.
local function partCentroid(model: Model): Vector3
	local sx, sy, sz, n = 0, 0, 0, 0

	-- First pass: prefer Structural-tagged parts if any exist
	for _, p in model:GetDescendants() do
		if p:IsA("BasePart") and p:HasTag("Structural") then
			sx += p.Position.X; sy += p.Position.Y; sz += p.Position.Z; n += 1
		end
	end

	-- Fallback: average all parts (legacy rides without structural tagging)
	if n == 0 then
		for _, p in model:GetDescendants() do
			if p:IsA("BasePart") then
				sx += p.Position.X; sy += p.Position.Y; sz += p.Position.Z; n += 1
			end
		end
	end

	if n == 0 then return model:GetPivot().Position end
	return Vector3.new(sx / n, sy / n, sz / n)
end

local function fixPivot(model: Model): Vector3
	local center = partCentroid(model)
	model.WorldPivot = CFrame.new(center)
	return center
end

local function getSeats(model: Model): { Seat }
	local seats: { Seat } = {}
	for _, v in model:GetChildren() do
		if v.ClassName == "Seat" then table.insert(seats, v :: Seat) end
	end
	return seats
end

local function addBoardingPrompt(model: Model, pivPos: Vector3, seats: { Seat })
	if #seats == 0 then return end

	local anchor = Instance.new("Part")
	anchor.Name = "BoardZone_" .. model.Name
	anchor.Size = Vector3.new(1, 4, 1)
	anchor.Transparency = 1; anchor.Anchored = true
	anchor.CanCollide = false; anchor.CastShadow = false
	anchor.Position = pivPos + Vector3.new(0, 2, 14)
	anchor.Parent = workspace

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Board"
	prompt.ObjectText = model.Name:gsub("(%l)(%u)", "%1 %2"):gsub("Ride", " Ride")
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = anchor

	prompt.Triggered:Connect(function(player: Player)
		local char = player.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
		if not hum or hum.Health <= 0 then return end
		local chosen: Seat? = nil
		for _, s in seats do if not s.Occupant then chosen = s; break end end
		if not chosen then return end
		hum.Sit = false; task.wait(); chosen:Sit(hum)
		task.delay(RIDE_DURATION, function()
			if chosen.Occupant == hum then hum.Sit = false end
		end)
	end)
end

-- ── Drop Tower ────────────────────────────────────────────────────────────────

local function buildDropTower(): DropData?
	local tower = workspace:FindFirstChild("DropTower") :: Model?
	if not tower then return nil end

	-- Gondola disc
	local gond = Instance.new("Part")
	gond.Name = "DropGondola"; gond.Size = Vector3.new(13, 1.5, 13)
	gond.Color = Color3.fromRGB(210, 35, 35); gond.Material = Enum.Material.SmoothPlastic
	gond.Anchored = true; gond.CanCollide = true; gond.CastShadow = false
	gond.CFrame = CFrame.new(DROP_CX, DROP_Y_MIN, DROP_CZ)
	gond.Parent = tower

	-- 6 seats facing outward at radius 5
	local seatParts: { Seat } = {}
	local seatOffsets: { CFrame } = {}

	for i = 1, 6 do
		local a = (i / 6) * math.pi * 2
		local rx, rz = math.cos(a) * 5, math.sin(a) * 5

		local seat = Instance.new("Seat"); seat.Name = "DropSeat_" .. i
		seat.Size = Vector3.new(2, 0.5, 1.5)
		seat.Color = Color3.fromRGB(255, 200, 40); seat.Material = Enum.Material.SmoothPlastic
		seat.Anchored = true; seat.CanCollide = true
		local seatPos = Vector3.new(DROP_CX + rx, DROP_Y_MIN + 1.25, DROP_CZ + rz)
		seat.CFrame = CFrame.lookAt(seatPos, seatPos + Vector3.new(rx, 0, rz).Unit)
		seat.Parent = tower
		seatOffsets[i] = gond.CFrame:Inverse() * seat.CFrame
		table.insert(seatParts, seat)
	end

	-- Safety railing visuals (8 thin posts around the gondola)
	for i = 1, 8 do
		local a = (i / 8) * math.pi * 2
		local rail = Instance.new("Part"); rail.Size = Vector3.new(0.3, 2, 0.3)
		rail.Color = Color3.fromRGB(220, 160, 0); rail.Material = Enum.Material.Metal
		rail.Anchored = true; rail.CanCollide = false
		rail.Position = Vector3.new(DROP_CX + math.cos(a)*6.5, DROP_Y_MIN + 1.5, DROP_CZ + math.sin(a)*6.5)
		rail.Parent = tower
	end

	-- Boarding prompt south of tower
	local anchor = Instance.new("Part"); anchor.Name = "DropBoardZone"
	anchor.Size = Vector3.new(1, 4, 1); anchor.Transparency = 1
	anchor.Anchored = true; anchor.CanCollide = false
	anchor.Position = Vector3.new(DROP_CX, 5, DROP_CZ - 13)
	anchor.Parent = workspace

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Board"; prompt.ObjectText = "Drop Tower"
	prompt.MaxActivationDistance = 14; prompt.RequiresLineOfSight = false
	prompt.Parent = anchor

	return {
		gondola = gond, seatParts = seatParts, seatOffsets = seatOffsets,
		state = "idle" :: DropPhase, y = DROP_Y_MIN,
		tHold = 0, tLoad = 0, prompt = prompt,
	}
end

-- ── Coaster helpers ───────────────────────────────────────────────────────────

local function buildWaypoints(sc: Model): { Vector3 }
	local function collect(prefix: string, count: number, suffix: string): { Vector3 }
		local list: { Vector3 } = {}
		for i = 0, count - 1 do
			local p = sc:FindFirstChild(prefix .. i .. suffix) :: BasePart?
			if p then table.insert(list, p.Position) end
		end
		return list
	end
	local arcN = collect("ArcN", 16, "_2"); local railA = collect("RailA", 50, "_2")
	local arcF  = collect("ArcF",  16, "_2"); local railB = collect("RailB", 50, "_2")
	local wps: { Vector3 } = {}
	for _, v in arcN  do table.insert(wps, v) end
	for _, v in railA do table.insert(wps, v) end
	for _, v in arcF  do table.insert(wps, v) end
	for i = #railB, 1, -1 do table.insert(wps, railB[i]) end
	return wps
end

-- ── ScreamerCoaster helpers ───────────────────────────────────────────────────

-- Finds the ScreamerCart model, anchors all parts, picks the primary part (Body),
-- adds a Seat and welds the whole cart so PivotTo() moves everything as one unit.
-- Returns the model and its primary BasePart, or nil if not found.
local function setupScreamerCart(): (Model?, BasePart?, Seat?)
	local cartModel = workspace:FindFirstChild("ScreamerCart") :: Model?
	if not cartModel then
		warn("[RideController] ScreamerCart model not found in workspace.")
		return nil, nil, nil
	end

	-- Anchor every part
	for _, p in cartModel:GetDescendants() do
		if p:IsA("BasePart") then p.Anchored = true end
	end

	-- Primary part: prefer the part named "Body", else fallback to any BasePart
	local primary: BasePart? = cartModel:FindFirstChild("Body") :: BasePart?
	if not primary then
		for _, p in cartModel:GetDescendants() do
			if p:IsA("BasePart") then primary = p :: BasePart; break end
		end
	end
	if not primary then
		warn("[RideController] ScreamerCart has no BasePart — cannot set up cart.")
		return nil, nil, nil
	end

	-- Set the model's primary part so PivotTo() uses it as the anchor
	cartModel.PrimaryPart = primary

	-- Add a Seat directly inside the Body part's position (slightly above centre)
	local seat = Instance.new("Seat")
	seat.Name             = "CoasterSeat"
	seat.Size             = Vector3.new(2, 0.4, 2)
	seat.Color            = Color3.fromRGB(30, 30, 30)
	seat.Material         = Enum.Material.SmoothPlastic
	seat.Transparency     = 1         -- invisible; player sits inside the model visually
	seat.Anchored         = true
	seat.CanCollide       = false
	seat.CastShadow       = false
	-- Position the seat above the body so the player sits ON the cart, not inside it
	seat.CFrame           = primary.CFrame * CFrame.new(0, 2.5, 0)
	seat.Parent           = cartModel

	-- Weld the seat to the primary part so it moves with PivotTo()
	local seatWeld = Instance.new("WeldConstraint")
	seatWeld.Part0  = primary
	seatWeld.Part1  = seat
	seatWeld.Parent = primary

	-- Weld every other BasePart in the model to the primary part.
	-- This ensures PivotTo() on the model (which uses PrimaryPart) carries all parts.
	-- Roblox's Model:PivotTo() handles welded children correctly when all are Anchored,
	-- but the WeldConstraints also guard against any future physics interactions.
	for _, p in cartModel:GetDescendants() do
		if p:IsA("BasePart") and p ~= primary and p ~= seat then
			local w = Instance.new("WeldConstraint")
			w.Part0  = primary
			w.Part1  = p :: BasePart
			w.Parent = primary
		end
	end

	return cartModel, primary, seat
end

-- Create the invisible boarding ProximityPrompt anchor near waypoints[1]
local function buildCoasterBoardPrompt(stationPos: Vector3): ProximityPrompt
	local anchor = Instance.new("Part")
	anchor.Name           = "CoasterBoardZone"
	anchor.Size           = Vector3.new(1, 4, 1)
	anchor.Transparency   = 1
	anchor.Anchored       = true
	anchor.CanCollide     = false
	anchor.CastShadow     = false
	-- Place slightly south of the station waypoint, at standing height
	anchor.Position       = stationPos + Vector3.new(0, 2, 6)
	anchor.Parent         = workspace

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText             = "Ride"
	prompt.ObjectText             = "ScreamerCoaster"
	prompt.MaxActivationDistance  = 12
	prompt.RequiresLineOfSight    = false
	prompt.Parent                 = anchor

	return prompt
end

-- ── Log Flume ─────────────────────────────────────────────────────────────────

local function buildLogFlume(fadeRemote: RemoteEvent): FlumeState?
	if not workspace:FindFirstChild("LogFlume") then return nil end

	-- Channel centerline waypoints (boat hull center Y)
	local wps: { Vector3 } = {
		Vector3.new(235, 23.5, -445),
		Vector3.new(235, 21.0, -440),
		Vector3.new(235, 18.5, -435),
		Vector3.new(235, 15.0, -425),
		Vector3.new(235, 11.5, -415),
		Vector3.new(235,  8.0, -405),
		Vector3.new(235,  4.5, -395),
		Vector3.new(235,  1.5, -385),
		Vector3.new(235,  1.0, -375),
		Vector3.new(235,  1.0, -363),
		Vector3.new(235,  1.0, -351),
		Vector3.new(235,  1.0, -339),
		Vector3.new(235,  1.0, -327),
		Vector3.new(235,  1.0, -315),
		Vector3.new(235,  0.5, -295),
	}
	local cumDist: { number } = { 0 }
	for i = 2, #wps do
		cumDist[i] = cumDist[i - 1] + (wps[i] - wps[i - 1]).Magnitude
	end

	-- Destroy any leftover temporary boat
	local old = workspace:FindFirstChild("FlumeBoat")
	if old then old:Destroy() end

	-- Build boat model
	local boat = Instance.new("Model"); boat.Name = "FlumeBoat"; boat.Parent = workspace

	local hull = Instance.new("Part"); hull.Name = "BoatHull"
	hull.Size = Vector3.new(3.5, 1.8, 6)
	hull.Color = Color3.fromRGB(80, 52, 22); hull.Material = Enum.Material.Wood
	hull.Anchored = true; hull.CanCollide = true
	hull.CFrame = CFrame.new(wps[1]); hull.Parent = boat

	local bow = Instance.new("Part"); bow.Name = "BoatBow"
	bow.Size = Vector3.new(3, 1.4, 2.5)
	bow.Color = Color3.fromRGB(80, 52, 22); bow.Material = Enum.Material.Wood
	bow.Anchored = true; bow.CanCollide = false
	bow.CFrame = CFrame.new(wps[1] + Vector3.new(0, 0, -4)); bow.Parent = boat

	local rim = Instance.new("Part"); rim.Name = "BoatRim"
	rim.Size = Vector3.new(3.8, 0.6, 6.3)
	rim.Color = Color3.fromRGB(110, 75, 30); rim.Material = Enum.Material.Wood
	rim.Anchored = true; rim.CanCollide = false
	rim.CFrame = CFrame.new(wps[1] + Vector3.new(0, 1.0, 0)); rim.Parent = boat

	local seat = Instance.new("Seat"); seat.Name = "FlumeBoatSeat"
	seat.Size = Vector3.new(3, 0.3, 4)
	seat.Color = Color3.fromRGB(50, 30, 10); seat.Material = Enum.Material.Wood
	seat.Anchored = true; seat.CanCollide = false
	seat.CFrame = CFrame.new(wps[1] + Vector3.new(0, 0.25, 0.5)); seat.Parent = boat

	boat.PrimaryPart = hull
	for _, p in boat:GetDescendants() do
		if p:IsA("BasePart") and p ~= hull then
			local w = Instance.new("WeldConstraint")
			w.Part0 = hull; w.Part1 = p :: BasePart; w.Parent = hull
		end
	end

	-- Boarding prompt near loading dock (top of flume)
	local anchor = Instance.new("Part"); anchor.Name = "FlumeBoardZone"
	anchor.Size = Vector3.new(1, 4, 1); anchor.Transparency = 1
	anchor.Anchored = true; anchor.CanCollide = false
	anchor.Position = wps[1] + Vector3.new(0, 2, 9); anchor.Parent = workspace

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Board"; prompt.ObjectText = "Log Flume"
	prompt.MaxActivationDistance = 14; prompt.RequiresLineOfSight = false
	prompt.Parent = anchor

	return {
		boat = boat, hull = hull, seat = seat, prompt = prompt,
		waypoints = wps, cumDist = cumDist, totalDist = cumDist[#cumDist],
		dist = 0, rider = nil, riding = false, fadeRemote = fadeRemote,
	}
end

-- ── Scrambler Ride (dual-rotation epicyclic) ──────────────────────────────────

local function buildScrambler(): ScramblerData?
	local model = workspace:FindFirstChild("ScramblerRide") :: Model?
	if not model then return nil end

	local genFolder = model:FindFirstChild("Generated")
	local inner     = genFolder and genFolder:FindFirstChild("ScramblerRide") :: Model?
	if not inner then
		warn("[RideController] ScramblerRide: no Generated/ScramblerRide inner model")
		return nil
	end
	local mechanics = inner:FindFirstChild("Mechanics") :: Model?
	local bsModel   = inner:FindFirstChild("BaseStructure") :: Model?
	if not mechanics or not bsModel then
		warn("[RideController] ScramblerRide: missing Mechanics or BaseStructure")
		return nil
	end

	anchorAll(model)

	-- Main model centroid → WorldPivot
	local mainCenter = partCentroid(model)
	model.WorldPivot = CFrame.new(mainCenter)
	local baseCF = CFrame.new(mainCenter)

	-- BaseStructure offset (constant, computed once)
	local bsCenter = partCentroid(bsModel)
	bsModel.WorldPivot = CFrame.new(bsCenter)
	local bsOffset = baseCF:Inverse() * CFrame.new(bsCenter)

	-- Arm groups: sort by Name for deterministic order
	local armGroups: { Model } = {}
	local armOffsets: { CFrame } = {}
	local armNames: { string } = {}
	for _, arm in mechanics:GetChildren() do
		if arm:IsA("Model") then table.insert(armNames, arm.Name) end
	end
	table.sort(armNames)
	for _, name in armNames do
		local arm = mechanics:FindFirstChild(name) :: Model
		local c = partCentroid(arm)
		arm.WorldPivot = CFrame.new(c)
		table.insert(armGroups, arm)
		table.insert(armOffsets, baseCF:Inverse() * CFrame.new(c))
	end

	if #armGroups == 0 then
		warn("[RideController] ScramblerRide: no arm group models in Mechanics")
		return nil
	end

	-- Seats: assign each to nearest arm group
	local seats = getSeats(model)
	local seatArmIdx: { number } = {}
	local seatOffsetList: { CFrame } = {}
	for _, seat in seats do
		local nearestIdx, nearestDist = 1, math.huge
		for i, arm in armGroups do
			local d = (seat.Position - arm.WorldPivot.Position).Magnitude
			if d < nearestDist then nearestDist = d; nearestIdx = i end
		end
		table.insert(seatArmIdx, nearestIdx)
		-- Seat's rest CFrame relative to its arm's rest WorldPivot
		table.insert(seatOffsetList, CFrame.new(armGroups[nearestIdx].WorldPivot.Position):Inverse() * seat.CFrame)
	end

	addBoardingPrompt(model, mainCenter, seats)

	return {
		baseStructure = bsModel,
		bsOffset      = bsOffset,
		armGroups     = armGroups,
		armOffsets    = armOffsets,
		seats         = seats,
		seatArmIdx    = seatArmIdx,
		seatOffset    = seatOffsetList,
		mainAngle     = 0,
		subAngle      = 0,
		baseCF        = baseCF,
	}
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function RideController.init(remotesFolder: Folder)
	local spinList: { SpinState }     = {}
	local pendList: { PendulumState } = {}
	local coasters: { CoasterState }  = {}

	for _, cfg in SPIN_RIDES do
		local m = workspace:FindFirstChild(cfg.name) :: Model?
		if not m then continue end
		anchorAll(m)
		local center = fixPivot(m)
		local seats  = getSeats(m)
		-- Spin rides with gallop animation use per-horse mount prompts instead of a
		-- shared BoardZone (which gets buried inside the deck at large carousel scales).
		if not (cfg :: any).gallopAmplitude then
			addBoardingPrompt(m, center, seats)
		end
		local rampSecs: number = (cfg :: any).rampSecs or 0
		local cyclePause = (cfg :: any).cyclePause :: number?
		local cycleAccel = (cfg :: any).cycleAccel :: number?
		local cyclePeak  = (cfg :: any).cyclePeak :: number?
		local cycleDecel = (cfg :: any).cycleDecel :: number?
		local spinState: SpinState = {
			model      = m,
			angle      = 0,
			rps        = cfg.rps,
			currentRps = (cyclePause or rampSecs > 0) and 0 or cfg.rps,
			rampRate   = rampSecs > 0 and (cfg.rps / rampSecs) or 0,
			baseCF     = CFrame.new(center),
			cyclePause = cyclePause,
			cycleAccel = cycleAccel,
			cyclePeak  = cyclePeak,
			cycleDecel = cycleDecel,
			cycleT     = cyclePause and 0 or nil,
		}

		-- Optional gallop: horses Y-oscillate while ride spins.
		local gallopAmp = (cfg :: any).gallopAmplitude :: number?
		if gallopAmp then
			local horses: { HorseGallop } = {}
			for i = 1, 16 do
				local h = m:FindFirstChild("HorseModel_" .. i) :: Model?
				if h then
					local parts: { BasePart } = {}
					local sx, sz, n = 0, 0, 0
					for _, p in h:GetDescendants() do
						if p:IsA("BasePart") then
							table.insert(parts, p :: BasePart)
							sx += p.Position.X; sz += p.Position.Z; n += 1
						end
					end
					if n > 0 then
						local cxh, czh = sx / n, sz / n
						local seat: Seat? = nil
						local bestDist = math.huge
						for _, ch in m:GetChildren() do
							if ch.Name == "HorseSeat" and ch:IsA("Seat") then
								local d = math.sqrt((ch.Position.X - cxh)^2 + (ch.Position.Z - czh)^2)
								if d < bestDist then bestDist = d; seat = ch :: Seat end
							end
						end
						table.insert(horses, {
							parts      = parts,
							seat       = seat,
							phase      = (i - 1) / 8 * (2 * math.pi),
							prevOffset = 0,
						})
					end
				end
			end
			spinState.horses          = horses
			spinState.gallopAmplitude = gallopAmp
			spinState.gallopFreq      = (cfg :: any).gallopFreq or 0.6
			spinState.totalTime       = 0

			-- Per-horse mount ProximityPrompts. Player walks up to a horse, presses E,
			-- gets seated on THAT horse. Replaces the BoardZone for gallop-equipped rides.
			-- Prompt hides while seat is occupied so it doesn't linger after mounting.
			for _, h in horses do
				local seat = h.seat
				if seat then
					local prompt = Instance.new("ProximityPrompt")
					prompt.ActionText            = "Mount"
					prompt.ObjectText            = cfg.name
					prompt.MaxActivationDistance = 6
					prompt.RequiresLineOfSight   = false
					prompt.Parent                = seat
					prompt.Triggered:Connect(function(player: Player)
						if seat.Occupant then return end
						local char = player.Character
						local hum  = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
						if not hum or hum.Health <= 0 then return end
						hum.Sit = false; task.wait()
						seat:Sit(hum)
					end)
					seat:GetPropertyChangedSignal("Occupant"):Connect(function()
						prompt.Enabled = (seat.Occupant == nil)
					end)
				end
			end
		end

		-- Optional swing-out: chairs translate radially outward as ride speeds up.
		local swingAmp = (cfg :: any).swingOutAmplitude :: number?
		if swingAmp then
			local chairs: { ChairSwing } = {}
			for i = 1, 16 do
				local group = m:FindFirstChild("ChairGroup_" .. i)
				if group and group:IsA("Model") then
					local parts: { BasePart } = {}
					local chains: { BasePart } = {}
					local seat: Seat? = nil
					for _, ch in group:GetChildren() do
						if ch:IsA("Seat") then
							seat = ch :: Seat
						elseif ch:IsA("BasePart") then
							if ch.Name:match("^Chain") then
								table.insert(chains, ch :: BasePart)
							else
								table.insert(parts, ch :: BasePart)
							end
						end
					end
					if #parts > 0 then
						table.insert(chairs, {
							parts      = parts,
							chains     = chains,
							seat       = seat,
							prevOffset = 0,
							prevY      = 0,
						})
					end
				end
			end
			spinState.chairs             = chairs
			spinState.swingOutAmplitude  = swingAmp
			spinState.swingDropAmplitude = (cfg :: any).swingDropAmplitude :: number?
		end

		table.insert(spinList, spinState)
	end

	for _, cfg in PENDULUM_RIDES do
		local m = workspace:FindFirstChild(cfg.name) :: Model?
		if not m then continue end
		anchorAll(m)
		local center: Vector3
		local pivotYOverride = (cfg :: any).pivotY :: number?
		if pivotYOverride then
			-- Use explicit Y for the swing axis (e.g. axle position), keep X/Z from centroid
			local cp = partCentroid(m)
			center = Vector3.new(cp.X, pivotYOverride, cp.Z)
			m.WorldPivot = CFrame.new(center)
		else
			center = fixPivot(m)
		end
		local seats = getSeats(m); addBoardingPrompt(m, center, seats)
		local axis = ((cfg :: any).axis :: string?) or "X"
		table.insert(pendList, { model=m, amp=cfg.amplitude, freq=cfg.frequency, t=0, baseCF=CFrame.new(center), axis=axis })
	end

	-- Scrambler (dual-rotation — NOT in SPIN_RIDES; handled separately)
	local scramblerData: ScramblerData? = buildScrambler()

	-- ParachuteJump — 8 chutes rise/fall with phase offset
	local parachuteState: { chuteParts: { { BasePart } }, originalPos: { { Vector3 } }, t: number }? = nil
	do
		local pj = workspace:FindFirstChild("ParachuteJump") :: Model?
		if pj then
			anchorAll(pj)
			local chuteParts: { { BasePart } } = {}
			local originalPos: { { Vector3 } } = {}
			for chuteIdx = 1, 8 do
				local parts: { BasePart } = {}
				local positions: { Vector3 } = {}
				for _, d in pj:GetDescendants() do
					if d:IsA("BasePart") then
						local n = d.Name
						-- Match ChuteBasket_N, ChuteRider_N, ChuteFrame_N, ChutFrame_N, ChuteD_N, ChuteS_N (suffix is chute index)
						if n:match("^Chute[A-Za-z]+" .. chuteIdx .. "$") or n:match("^ChuteS" .. chuteIdx .. "_%d+$") or n:match("^ChutFrame" .. chuteIdx .. "$") then
							table.insert(parts, d :: BasePart)
							table.insert(positions, d.Position)
						end
					end
				end
				chuteParts[chuteIdx] = parts
				originalPos[chuteIdx] = positions
			end
			parachuteState = { chuteParts = chuteParts, originalPos = originalPos, t = 0 }
		end
	end

	-- ScreamerCoaster — full boarding system
	local fadeRemote = remotesFolder:WaitForChild("CoasterFade", 10) :: RemoteEvent?
	local sc = workspace:FindFirstChild("ScreamerCoaster") :: Model?

	if sc and fadeRemote then
		local wps = buildWaypoints(sc)

		if #wps >= 2 then
			-- Build cumulative distance lookup table
			local cumDist: { number } = { 0 }
			for i = 2, #wps do
				cumDist[i] = cumDist[i - 1] + (wps[i] - wps[i - 1]).Magnitude
			end

			-- Set up the ScreamerCart model
			local cartModel, primaryPart, coasterSeat = setupScreamerCart()

			if cartModel and primaryPart and coasterSeat then
				-- Move the cart to station (waypoint 1) at startup
				local startCF = CFrame.new(wps[1] + Vector3.new(0, 1.5, 0))
				cartModel:PivotTo(startCF)

				-- Build the boarding prompt near the station
				local boardPrompt = buildCoasterBoardPrompt(wps[1])

				local coasterState: CoasterState = {
					cartModel   = cartModel,
					primaryPart = primaryPart,
					seat        = coasterSeat,
					prompt      = boardPrompt,
					waypoints   = wps,
					cumDist     = cumDist,
					totalDist   = cumDist[#cumDist],
					dist        = 0,
					rider       = nil,
					riding      = false,
					fadeRemote  = fadeRemote :: RemoteEvent,
				}
				table.insert(coasters, coasterState)

				-- ── Boarding flow ──────────────────────────────────────────────────
				boardPrompt.Triggered:Connect(function(player: Player)
					-- Gate: one rider at a time; prompt already disabled while riding
					if coasterState.rider ~= nil then return end

					local char = player.Character
					local hum  = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
					if not hum or hum.Health <= 0 then return end

					-- Lock out other players immediately
					coasterState.rider  = player
					coasterState.riding = false
					boardPrompt.Enabled = false

					-- Reset cart to station so player teleports to a known stable position
					coasterState.dist = 0
					coasterState.cartModel:PivotTo(CFrame.new(coasterState.waypoints[1] + Vector3.new(0, 1.5, 0)))

					-- Fade to black
					fadeRemote:FireClient(player, false)
					task.wait(0.5)   -- let the fade finish

					-- Sit the player
					hum.Sit = false
					task.wait()      -- one frame to clear any prior SeatWeld
					coasterSeat:Sit(hum)

					-- Fade back in — they're now seated in the cart
					fadeRemote:FireClient(player, true)
					coasterState.riding = true
				end)

				-- ── Disconnect / disconnect cleanup ────────────────────────────────
				Players.PlayerRemoving:Connect(function(leavingPlayer: Player)
					if coasterState.rider ~= leavingPlayer then return end
					-- Player left mid-ride — clean up without trying to fade/eject
					coasterState.rider  = nil
					coasterState.riding = false
					boardPrompt.Enabled = true
				end)
			else
				warn("[RideController] ScreamerCart setup failed — coaster will not have boarding.")
			end
		else
			warn("[RideController] ScreamerCoaster: fewer than 2 waypoints found — skipping.")
		end
	elseif not fadeRemote then
		warn("[RideController] CoasterFade RemoteEvent not found in Remotes folder.")
	end

	-- Log Flume
	local flumeData: FlumeState? = nil
	if fadeRemote then
		flumeData = buildLogFlume(fadeRemote :: RemoteEvent)
		if flumeData then
			local fd = flumeData :: FlumeState
			fd.prompt.Triggered:Connect(function(player: Player)
				if fd.rider ~= nil then return end
				local char = player.Character
				local hum  = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
				if not hum or hum.Health <= 0 then return end
				fd.rider = player; fd.riding = false; fd.prompt.Enabled = false
				fd.fadeRemote:FireClient(player, false); task.wait(0.5)
				hum.Sit = false; task.wait(); fd.seat:Sit(hum)
				fd.fadeRemote:FireClient(player, true); fd.riding = true
			end)
		end
	end

	-- Drop Tower
	local dropData: DropData? = buildDropTower()
	if dropData then
		local dd = dropData :: DropData
		dd.prompt.Triggered:Connect(function(player: Player)
			if dd.state ~= "idle" then return end
			local char = player.Character
			local hum  = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
			if not hum or hum.Health <= 0 then return end
			local chosen: Seat? = nil
			for _, s in dd.seatParts do if not s.Occupant then chosen = s; break end end
			if not chosen then return end
			hum.Sit = false; task.wait(); chosen:Sit(hum)
			dd.state = "loading" :: DropPhase; dd.tLoad = 0; dd.prompt.Enabled = false
		end)
	end

	-- ── Heartbeat ─────────────────────────────────────────────────────────────
	RunService.Heartbeat:Connect(function(dt)

		for _, s in spinList do
			-- Cycle phases: rest → spin-up → peak → spin-down → loop.
			-- Overrides the simple ramp-once behavior for rides that opt in
			-- via cyclePause/Accel/Peak/Decel SPIN_RIDES fields.
			if s.cyclePause then
				local pauseT = s.cyclePause :: number
				local accelT = s.cycleAccel :: number
				local peakT  = s.cyclePeak :: number
				local decelT = s.cycleDecel :: number
				local total  = pauseT + accelT + peakT + decelT
				s.cycleT = ((s.cycleT :: number) + dt) % total
				local t = s.cycleT :: number
				if t < pauseT then
					s.currentRps = 0
				elseif t < pauseT + accelT then
					s.currentRps = s.rps * ((t - pauseT) / accelT)
				elseif t < pauseT + accelT + peakT then
					s.currentRps = s.rps
				else
					s.currentRps = s.rps * (1 - ((t - pauseT - accelT - peakT) / decelT))
				end
			elseif s.rampRate > 0 and s.currentRps < s.rps then
				s.currentRps = math.min(s.currentRps + s.rampRate * dt, s.rps)
			end
			s.angle += s.currentRps * dt
			s.model:PivotTo(s.baseCF * CFrame.Angles(0, s.angle, 0))

			-- Chair swing-out: radial outward translation + Y rise proportional to
			-- (currentRps/rps)². Centrifugal-style — at rest the chairs hang at full
			-- rope drop; at peak rpm the chairs raise to rim level (chains horizontal).
			local chairs = s.chairs
			if chairs then
				local amp     = s.swingOutAmplitude :: number
				local dropAmp = (s.swingDropAmplitude :: number?) or 0
				local rpsRatio = s.rps > 0 and (s.currentRps / s.rps) or 0
				local r2 = rpsRatio * rpsRatio                  -- centrifugal ∝ ω²
				local desiredMag = r2 * amp                       -- radial outward
				local desiredY   = -dropAmp * (1 - r2)            -- Y drop (negative = below rest)
				local centerX = s.baseCF.Position.X
				local centerZ = s.baseCF.Position.Z
				for _, c in chairs do
					local anchor = c.parts[1]
					local relX = anchor.Position.X - centerX
					local relZ = anchor.Position.Z - centerZ
					local mag = math.sqrt(relX*relX + relZ*relZ)
					if mag > 0.1 then
						local radX = relX / mag
						local radZ = relZ / mag
						local dMag = desiredMag - c.prevOffset
						local dY   = desiredY  - c.prevY
						local offset = Vector3.new(radX * dMag, dY, radZ * dMag)
						for _, p in c.parts do
							p.CFrame = p.CFrame + offset
						end
						local seat = c.seat
						if seat then
							seat.CFrame = seat.CFrame + offset
						end
						-- Chains move half radial + half Y so they tilt outward AND
						-- shorten visually (rim anchor stays put-ish).
						local halfOffset = Vector3.new(radX * dMag * 0.5, dY * 0.5, radZ * dMag * 0.5)
						for _, ch in c.chains do
							ch.CFrame = ch.CFrame + halfOffset
						end
						c.prevOffset = desiredMag
						c.prevY      = desiredY
					end
				end
			end

			-- Horse gallop: per-horse Y oscillation overlaid on the spin.
			-- PivotTo above rotates parts around Y axis only (no Y change), so
			-- applying a Y delta directly after PivotTo is correct.
			local horses = s.horses
			if horses then
				s.totalTime = (s.totalTime or 0) + dt
				local gAmp = s.gallopAmplitude :: number
				local gFreq = s.gallopFreq :: number
				for _, h in horses do
					local desired = math.sin((s.totalTime :: number) * gFreq * 2 * math.pi + h.phase) * gAmp
					local dy = desired - h.prevOffset
					for _, p in h.parts do
						p.CFrame = p.CFrame + Vector3.new(0, dy, 0)
					end
					local seat = h.seat
					if seat then
						seat.CFrame = seat.CFrame + Vector3.new(0, dy, 0)
					end
					h.prevOffset = desired
				end
			end
		end

		for _, p in pendList do
			p.t += dt
			local ang = math.sin(p.t * p.freq) * p.amp
			local rot = if p.axis == "Z" then CFrame.Angles(0, 0, ang) else CFrame.Angles(ang, 0, 0)
			p.model:PivotTo(p.baseCF * rot)
		end

		-- ParachuteJump: per-chute rise/fall cycle with phase offset
		if parachuteState then
			parachuteState.t += dt
			local dropHeight = PARACHUTE_TOP_Y - PARACHUTE_BOTTOM_Y
			for chuteIdx = 1, 8 do
				local phaseOffset = ((chuteIdx - 1) / 8) * PARACHUTE_CYCLE
				local phaseT = (parachuteState.t + phaseOffset) % PARACHUTE_CYCLE
				-- Compute Y offset relative to TOP position (negative = below top)
				local offsetY: number
				if phaseT < PARACHUTE_HOLD_TOP then
					offsetY = 0
				elseif phaseT < PARACHUTE_HOLD_TOP + PARACHUTE_FALL_T then
					local fallT = (phaseT - PARACHUTE_HOLD_TOP) / PARACHUTE_FALL_T
					offsetY = -dropHeight * fallT
				elseif phaseT < PARACHUTE_HOLD_TOP + PARACHUTE_FALL_T + PARACHUTE_HOLD_BOT then
					offsetY = -dropHeight
				else
					local riseT = (phaseT - PARACHUTE_HOLD_TOP - PARACHUTE_FALL_T - PARACHUTE_HOLD_BOT) / PARACHUTE_RISE_T
					offsetY = -dropHeight * (1 - riseT)
				end
				local parts = parachuteState.chuteParts[chuteIdx]
				local origs = parachuteState.originalPos[chuteIdx]
				for i, part in parts do
					part.Position = origs[i] + Vector3.new(0, offsetY, 0)
				end
			end
		end

		-- Scrambler: main arm rotation + sub-hub counter-rotation
		if scramblerData then
			local sd = scramblerData :: ScramblerData
			sd.mainAngle += SCRAMBLER_MAIN_RPS * dt
			sd.subAngle  += SCRAMBLER_SUB_RPS  * dt

			local mainRotCF = sd.baseCF * CFrame.Angles(0, sd.mainAngle, 0)

			-- Central hub follows main rotation only
			sd.baseStructure:PivotTo(mainRotCF * sd.bsOffset)

			-- Each arm group: main rotation + sub counter-rotation around its own center
			for i, arm in sd.armGroups do
				arm:PivotTo(mainRotCF * sd.armOffsets[i] * CFrame.Angles(0, sd.subAngle, 0))
			end

			-- Seats: manually follow their assigned arm group (like DropTower pattern)
			for j, seat in sd.seats do
				local ai  = sd.seatArmIdx[j]
				local armCF = mainRotCF * sd.armOffsets[ai] * CFrame.Angles(0, sd.subAngle, 0)
				seat.CFrame = armCF * sd.seatOffset[j]
			end
		end

		for _, c in coasters do
			-- Cart stays parked at the station until a rider boards
			if not c.riding then continue end

			-- Advance cart position
			c.dist = c.dist + COASTER_SPEED * dt

			-- Detect lap completion before wrapping
			local lapped = c.dist >= c.totalDist
			c.dist = c.dist % c.totalDist

			-- Binary search for current segment
			local lo, hi = 1, #c.cumDist - 1
			while lo < hi do
				local mid = math.floor((lo + hi) / 2)
				if c.cumDist[mid + 1] < c.dist then lo = mid + 1 else hi = mid end
			end

			local segLen = c.cumDist[lo + 1] - c.cumDist[lo]
			local t      = segLen > 0 and (c.dist - c.cumDist[lo]) / segLen or 0
			local pos    = c.waypoints[lo]:Lerp(c.waypoints[lo + 1], t) + Vector3.new(0, 1.5, 0)
			local fwd    = (c.waypoints[lo + 1] - c.waypoints[lo]).Unit
			local right  = fwd:Cross(Vector3.new(0, 1, 0)).Unit
			local newCF  = CFrame.fromMatrix(pos, right, right:Cross(fwd).Unit)

			-- Move the ScreamerCart model as a whole unit
			c.cartModel:PivotTo(newCF)

			-- ── Deboard on lap completion ──────────────────────────────────────
			if lapped and c.rider then
				local rider = c.rider :: Player
				-- Clear rider state immediately so subsequent frames don't re-trigger
				c.rider  = nil
				c.riding = false

				task.spawn(function()
					local char = rider.Character
					local hum  = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
					if not hum then
						-- Player left mid-ride; just re-enable the prompt
						c.prompt.Enabled = true
						return
					end

					-- Fade to black before unseating
					c.fadeRemote:FireClient(rider, false)
					task.wait(0.5)

					-- Unseat the player
					hum.Sit = false
					task.wait()   -- one frame to let SeatWeld clear

					-- Teleport to exit platform (south of station)
					local hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart?
					if hrp then
						hrp.CFrame = CFrame.new(c.waypoints[1] + Vector3.new(0, 3, 10))
					end

					-- Fade back in
					c.fadeRemote:FireClient(rider, true)

					-- Brief grace period before re-enabling boarding
					task.wait(1)
					c.prompt.Enabled = true
				end)
			end
		end

		-- Log Flume
		if flumeData and flumeData.riding then
			local fd = flumeData :: FlumeState
			fd.dist = math.min(fd.dist + FLUME_SPEED * dt, fd.totalDist)

			local lo, hi = 1, #fd.cumDist - 1
			while lo < hi do
				local mid = math.floor((lo + hi) / 2)
				if fd.cumDist[mid + 1] < fd.dist then lo = mid + 1 else hi = mid end
			end
			local segLen = fd.cumDist[lo + 1] - fd.cumDist[lo]
			local t      = segLen > 0 and (fd.dist - fd.cumDist[lo]) / segLen or 0
			local pos    = fd.waypoints[lo]:Lerp(fd.waypoints[lo + 1], t)
			local fwd    = (fd.waypoints[lo + 1] - fd.waypoints[lo]).Unit
			local right  = fwd:Cross(Vector3.new(0, 1, 0)).Unit
			fd.hull.CFrame = CFrame.fromMatrix(pos, right, right:Cross(fwd))

			if fd.dist >= fd.totalDist then
				local rider = fd.rider :: Player
				fd.rider = nil; fd.riding = false
				task.spawn(function()
					local char = rider.Character
					local hum  = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
					fd.fadeRemote:FireClient(rider, false); task.wait(0.5)
					if hum then hum.Sit = false; task.wait() end
					fd.dist = 0
					fd.hull.CFrame = CFrame.new(fd.waypoints[1])
					if char then
						local hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart?
						if hrp then hrp.CFrame = CFrame.new(fd.waypoints[1] + Vector3.new(0, 3, 10)) end
					end
					fd.fadeRemote:FireClient(rider, true)
					task.wait(1); fd.prompt.Enabled = true
				end)
			end
		end

		if dropData then
			local dd = dropData :: DropData

			if dd.state == "loading" then
				dd.tLoad += dt
				if dd.tLoad >= DROP_LOAD then dd.state = "rising" :: DropPhase end

			elseif dd.state == "rising" then
				dd.y = math.min(dd.y + DROP_RISE * dt, DROP_Y_MAX)
				if dd.y >= DROP_Y_MAX then dd.state = "hold" :: DropPhase; dd.tHold = 0 end

			elseif dd.state == "hold" then
				dd.tHold += dt
				if dd.tHold >= DROP_HOLD then dd.state = "dropping" :: DropPhase end

			elseif dd.state == "dropping" then
				if dd.y > DROP_BRAKE_Y then
					dd.y = math.max(dd.y - DROP_FALL * dt, DROP_BRAKE_Y)
				else
					dd.y = math.max(dd.y - DROP_BRAKE * dt, DROP_Y_MIN)
					if dd.y <= DROP_Y_MIN then
						dd.state = "idle" :: DropPhase; dd.prompt.Enabled = true
						for _, s in dd.seatParts do
							if s.Occupant then s.Occupant.Sit = false end
						end
					end
				end
			end

			-- Move gondola and welded seats
			local gondCF = CFrame.new(DROP_CX, dd.y, DROP_CZ)
			dd.gondola.CFrame = gondCF
			for i, seat in dd.seatParts do
				seat.CFrame = gondCF * dd.seatOffsets[i]
			end
		end
	end)
end

return RideController
