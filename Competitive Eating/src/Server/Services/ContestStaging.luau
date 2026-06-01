-- ContestStaging: visible NPCs at chairs + food piles + per-bite shrink/bob.
--
-- Hooks into ContestService phase transitions:
--   spawnArena(arena)  — on Active phase: NPC rigs at chairs, food piles on table
--   onConsume(arena, contestant) — each successful skill check: shrink that
--     contestant's pile, bob their rig
--   cleanupArena(arena) — on Results phase: destroy everything spawned
--
-- Geometry (from ContestStage_T1):
--   Table top Y = 6, chairs Y = 4.5
--   Chair X offsets per index (1..8): -42, -30, -18, -6, 6, 18, 30, 42
--   Chairs at Z = -193.5, table at Z = -205
--   Pile sits between chair and table center: Z ~ -201
--
-- Multi-arena offset: arena 1 uses chairs 1..SEATS_PER_ARENA, arena 2 uses the
-- next block. Arena 3 with more than 8 total chairs would overflow — handled
-- by wrap, but visuals will overlap.

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Common    = game:GetService("ReplicatedStorage").Common
local Constants = require(Common.Constants)
local Types     = require(Common.Types)

local ContestStaging = {}

-- Per-arena state: { rigs = { [seatIdx]=Model }, piles = { [seatIdx]=Part },
--                    initialCount = { [seatIdx]=number }, consumed = { [seatIdx]=number },
--                    folder = Folder, consumedByContestant = { [key]=count } }
local arenaState: { [number]: any } = {}

-- ── Visual config ────────────────────────────────────────────────────────────

local CHAIR_X        = { -42, -30, -18, -6, 6, 18, 30, 42 }
local CHAIR_Y        = 5.0  -- top of chair pad
local CHAIR_Z        = -193.5
local TABLE_TOP_Y    = 6.0
local PILE_Z         = -201.0
local PILE_INITIAL_H = 6.0  -- studs tall when full
local PILE_RADIUS    = 1.8

local FOOD_COLOR: { [string]: Color3 } = {
	["Hot Dog"]                 = Color3.fromRGB(180, 90, 50),
	["Hamburger"]               = Color3.fromRGB(140, 80, 40),
	["Corn Dog"]                = Color3.fromRGB(230, 180, 60),
	["Pretzel Bites"]           = Color3.fromRGB(180, 130, 70),
	["Chicken Wings"]           = Color3.fromRGB(200, 130, 70),
	["Chili Dog"]               = Color3.fromRGB(140, 60, 40),
	["Double Burger"]           = Color3.fromRGB(120, 70, 35),
	["Loaded Nachos"]           = Color3.fromRGB(230, 180, 80),
	["Funnel Cake"]             = Color3.fromRGB(240, 220, 170),
	["Wing Bucket"]             = Color3.fromRGB(200, 140, 70),
	["Footlong Hot Dog"]        = Color3.fromRGB(180, 80, 40),
	["Triple-Stack Burger"]     = Color3.fromRGB(110, 60, 30),
	["Deep-Fried Twinkie"]      = Color3.fromRGB(250, 220, 130),
	["Turkey Leg"]              = Color3.fromRGB(180, 110, 60),
	["Cheese Curd Mountain"]    = Color3.fromRGB(255, 220, 100),
	["Nathan's Famous Dog"]     = Color3.fromRGB(170, 80, 40),
	["Smash Tower"]             = Color3.fromRGB(100, 55, 30),
	["Bloomin' Onion"]          = Color3.fromRGB(220, 180, 100),
	["World's Hottest Wings"]   = Color3.fromRGB(255, 60, 40),
	["Carnival Champion Plate"] = Color3.fromRGB(240, 200, 100),
}

-- ── Helpers ──────────────────────────────────────────────────────────────────

local function seatIndexFor(arena: Types.Arena, contestantIdx: number): number
	-- arena.id 1 → seats 1..SEATS_PER_ARENA
	-- arena.id 2 → seats (SEATS+1)..(2*SEATS)
	-- mod-wrapped if exceeds 8
	local base = (arena.id - 1) * Constants.SEATS_PER_ARENA
	local seat = base + contestantIdx
	if seat > #CHAIR_X then seat = ((seat - 1) % #CHAIR_X) + 1 end
	return seat
end

local function makePile(seatIdx: number, foodName: string, parent: Instance): Part
	local color = FOOD_COLOR[foodName] or Color3.fromRGB(220, 180, 100)
	local pile = Instance.new("Part")
	pile.Shape          = Enum.PartType.Cylinder
	pile.Size           = Vector3.new(PILE_INITIAL_H, PILE_RADIUS * 2, PILE_RADIUS * 2)
	pile.CFrame         = CFrame.new(CHAIR_X[seatIdx], TABLE_TOP_Y + PILE_INITIAL_H / 2, PILE_Z) * CFrame.Angles(0, 0, math.rad(90))
	pile.Color          = color
	pile.Material       = Enum.Material.SmoothPlastic
	pile.Anchored       = true
	pile.CanCollide     = false
	pile.TopSurface     = Enum.SurfaceType.Smooth
	pile.BottomSurface  = Enum.SurfaceType.Smooth
	pile.Name           = "FoodPile_" .. seatIdx
	pile.Parent         = parent
	return pile
end

local function makeNpcRig(seatIdx: number, npcName: string, parent: Instance): Model
	local model = Instance.new("Model")
	model.Name = "NpcRig_" .. seatIdx

	local x = CHAIR_X[seatIdx]
	local sitY = CHAIR_Y + 1.5
	local baseCF = CFrame.new(x, sitY, CHAIR_Z) * CFrame.Angles(0, math.rad(180), 0) -- face -Z (table)

	-- Torso
	local torso = Instance.new("Part")
	torso.Name      = "Torso"
	torso.Size      = Vector3.new(2.6, 3, 1.2)
	torso.CFrame    = baseCF
	torso.Color     = Color3.fromRGB(60 + math.random(0, 80), 60 + math.random(0, 80), 60 + math.random(0, 80))
	torso.Material  = Enum.Material.SmoothPlastic
	torso.Anchored  = true
	torso.CanCollide = false
	torso.Parent    = model

	-- Head
	local head = Instance.new("Part")
	head.Name      = "Head"
	head.Shape     = Enum.PartType.Ball
	head.Size      = Vector3.new(1.8, 1.8, 1.8)
	head.CFrame    = baseCF * CFrame.new(0, 2.2, 0)
	head.Color     = Color3.fromRGB(255, 220, 180)
	head.Material  = Enum.Material.SmoothPlastic
	head.Anchored  = true
	head.CanCollide = false
	head.Parent    = model

	-- Arms (forward, resting on table)
	for _, side in {-1, 1} do
		local arm = Instance.new("Part")
		arm.Name      = "Arm_" .. (side == -1 and "L" or "R")
		arm.Size      = Vector3.new(0.9, 0.9, 2.4)
		arm.CFrame    = baseCF * CFrame.new(side * 1.6, 0.4, -1.2)
		arm.Color     = torso.Color
		arm.Material  = Enum.Material.SmoothPlastic
		arm.Anchored  = true
		arm.CanCollide = false
		arm.Parent    = model
	end

	-- Nametag
	local tag = Instance.new("BillboardGui")
	tag.Name           = "NameTag"
	tag.Size           = UDim2.fromOffset(180, 32)
	tag.StudsOffset    = Vector3.new(0, 2, 0)
	tag.AlwaysOnTop    = true
	tag.Parent         = head

	local label = Instance.new("TextLabel")
	label.Size              = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.TextColor3        = Color3.new(1, 1, 1)
	label.TextStrokeColor3  = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.Font              = Enum.Font.GothamBold
	label.TextScaled        = true
	label.Text              = npcName
	label.Parent            = tag

	model.Parent = parent
	return model
end

local function bobHead(model: Model)
	local head = model:FindFirstChild("Head")
	if not head then return end
	local original = head.CFrame
	TweenService:Create(head, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		CFrame = original * CFrame.new(0, -0.4, -0.5),
	}):Play()
	task.delay(0.1, function()
		TweenService:Create(head, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			CFrame = original,
		}):Play()
	end)
end

-- ── Public API ───────────────────────────────────────────────────────────────

function ContestStaging.spawnArena(arena: Types.Arena)
	-- Clean up any leftover from prior contest on same arena
	ContestStaging.cleanupArena(arena)

	local folder = Instance.new("Folder")
	folder.Name   = "ArenaStaging_" .. arena.id
	folder.Parent = workspace

	local state = {
		folder              = folder,
		rigs                = {},
		piles               = {},
		consumedPerSeat     = {},
	}

	for i, c in arena.contestants do
		local seatIdx = seatIndexFor(arena, i)
		state.piles[seatIdx] = makePile(seatIdx, arena.currentFood, folder)
		state.consumedPerSeat[seatIdx] = 0

		if c.isNpc then
			state.rigs[seatIdx] = makeNpcRig(seatIdx, c.npcName or "NPC", folder)
		else
			-- Player gets teleported to their chair, no rig needed
			local player = Players:GetPlayerByUserId(c.userId)
			if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = player.Character.HumanoidRootPart
				hrp.CFrame = CFrame.new(CHAIR_X[seatIdx], CHAIR_Y + 3, CHAIR_Z) * CFrame.Angles(0, math.rad(180), 0)
			end
		end
	end

	arenaState[arena.id] = state
end

-- Called for every successful skill check (each bite consumes 1 item from pile).
function ContestStaging.onConsume(arena: Types.Arena, contestantIdx: number)
	local state = arenaState[arena.id]
	if not state then return end

	local seatIdx = seatIndexFor(arena, contestantIdx)
	local pile = state.piles[seatIdx]
	if not pile or not pile.Parent then return end

	state.consumedPerSeat[seatIdx] += 1
	-- Shrink pile: assume pile starts able to feed 30 items. Scale Y proportionally.
	local remaining = math.max(0, 1 - (state.consumedPerSeat[seatIdx] / 30))
	local newH = math.max(0.6, PILE_INITIAL_H * remaining)
	TweenService:Create(pile, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
		Size  = Vector3.new(newH, PILE_RADIUS * 2, PILE_RADIUS * 2),
		CFrame = CFrame.new(CHAIR_X[seatIdx], TABLE_TOP_Y + newH / 2, PILE_Z) * CFrame.Angles(0, 0, math.rad(90)),
	}):Play()

	-- Bob the contestant's head
	if state.rigs[seatIdx] then
		bobHead(state.rigs[seatIdx])
	end
end

function ContestStaging.cleanupArena(arena: Types.Arena)
	local state = arenaState[arena.id]
	if not state then return end
	if state.folder then state.folder:Destroy() end
	arenaState[arena.id] = nil
end

-- Tell controllers / staging which seat a contestant is in (for client-side
-- player character bob). Returns the chair X coordinate so client can compute.
function ContestStaging.getSeatX(arena: Types.Arena, contestantIdx: number): number?
	return CHAIR_X[seatIndexFor(arena, contestantIdx)]
end

return ContestStaging
