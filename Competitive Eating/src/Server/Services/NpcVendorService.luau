-- Creates ProximityPrompt-driven vendor NPCs at fixed world positions.
-- Each vendor fires a relevant RemoteEvent to the triggering player.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NpcVendorService = {}

local remotes: { [string]: RemoteEvent } = {}

-- ── NPC definition table ──────────────────────────────────────────────────────

type VendorDef = {
	modelName    : string,
	displayName  : string,
	dialog       : string,
	position     : Vector3,
	bodyColor    : Color3,
	actionText   : string,
	remoteName   : string,
}

local VENDORS: { VendorDef } = {
	{
		modelName   = "NPC_Frank",
		displayName = "Frank",
		dialog      = "Best dogs on the fairground!",
		position    = Vector3.new(0, 3, 17),
		bodyColor   = Color3.fromRGB(220, 140, 80),
		actionText  = "Talk to Frank",
		remoteName  = "OpenShop",     -- placeholder; reuses OpenShop for now
	},
	{
		modelName   = "NPC_Doc",
		displayName = "Doc",
		dialog      = "I can make you stronger...",
		position    = Vector3.new(250, 3, -450),
		bodyColor   = Color3.fromRGB(100, 160, 220),
		actionText  = "Open Upgrades",
		remoteName  = "OpenShop",
	},
	{
		modelName   = "NPC_Rosie",
		displayName = "Rosie",
		dialog      = "Coins for prizes — that's my deal!",
		position    = Vector3.new(-200, 3, -450),
		bodyColor   = Color3.fromRGB(220, 120, 180),
		actionText  = "Prize Booth",
		remoteName  = "OpenPrizeBooth",
	},
}

-- ── Build a single NPC model ──────────────────────────────────────────────────

local function buildVendor(def: VendorDef)
	local model = Instance.new("Model")
	model.Name  = def.modelName

	-- Body block
	local body = Instance.new("Part")
	body.Name          = "Body"
	body.Size          = Vector3.new(2, 3, 1)
	body.Position      = def.position
	body.Anchored      = true
	body.CanCollide    = true
	body.BrickColor    = BrickColor.new(def.bodyColor)
	body.Material      = Enum.Material.SmoothPlastic
	body.Parent        = model

	-- HumanoidRootPart (required for ProximityPrompt detection conventions)
	local hrp = Instance.new("Part")
	hrp.Name           = "HumanoidRootPart"
	hrp.Size           = Vector3.new(2, 2, 1)
	hrp.Position       = def.position
	hrp.Anchored       = true
	hrp.CanCollide     = false
	hrp.Transparency   = 1
	hrp.Parent         = model

	-- Head (sphere)
	local head = Instance.new("Part")
	head.Name          = "Head"
	head.Shape         = Enum.PartType.Ball
	head.Size          = Vector3.new(2, 2, 2)
	head.Position      = def.position + Vector3.new(0, 2.5, 0)
	head.Anchored      = true
	head.CanCollide    = false
	head.BrickColor    = BrickColor.new(Color3.fromRGB(255, 210, 155))
	head.Material      = Enum.Material.SmoothPlastic
	head.Parent        = model

	-- Eyes (cosmetic, two small black spheres)
	for _, xOff in { -0.45, 0.45 } do
		local eye = Instance.new("Part")
		eye.Shape         = Enum.PartType.Ball
		eye.Size          = Vector3.new(0.3, 0.3, 0.3)
		eye.Position      = def.position + Vector3.new(xOff, 2.55, -0.9)
		eye.Anchored      = true
		eye.CanCollide    = false
		eye.BrickColor    = BrickColor.Black()
		eye.Material      = Enum.Material.SmoothPlastic
		eye.Parent        = model
	end

	-- BillboardGui above head
	local billboard = Instance.new("BillboardGui")
	billboard.Size            = UDim2.fromOffset(200, 72)
	billboard.StudsOffset     = Vector3.new(0, 3.2, 0)
	billboard.AlwaysOnTop     = false
	billboard.MaxDistance     = 30
	billboard.Parent          = head

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size              = UDim2.new(1, 0, 0.5, 0)
	nameLbl.BackgroundTransparency = 1
	nameLbl.TextColor3        = Color3.fromRGB(255, 220, 60)
	nameLbl.TextScaled        = true
	nameLbl.Font              = Enum.Font.GothamBold
	nameLbl.Text              = def.displayName
	nameLbl.Parent            = billboard

	local dialogLbl = Instance.new("TextLabel")
	dialogLbl.Size              = UDim2.new(1, 0, 0.5, 0)
	dialogLbl.Position          = UDim2.new(0, 0, 0.5, 0)
	dialogLbl.BackgroundTransparency = 1
	dialogLbl.TextColor3        = Color3.new(1, 1, 1)
	dialogLbl.TextScaled        = true
	dialogLbl.Font              = Enum.Font.Gotham
	dialogLbl.TextWrapped       = true
	dialogLbl.Text              = '"' .. def.dialog .. '"'
	dialogLbl.Parent            = billboard

	-- ProximityPrompt on HumanoidRootPart
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText           = def.actionText
	prompt.ObjectText           = def.displayName
	prompt.MaxActivationDistance = 8
	prompt.HoldDuration         = 0
	prompt.RequiresLineOfSight  = false
	prompt.Parent               = hrp

	-- Fire event when triggered
	local targetRemoteName = def.remoteName
	prompt.Triggered:Connect(function(player: Player)
		local remote = remotes[targetRemoteName]
		if remote then
			remote:FireClient(player)
		end
	end)

	model.PrimaryPart = hrp
	model.Parent      = workspace
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function NpcVendorService.init(remotesFolder: Folder)
	remotes.OpenShop      = remotesFolder:WaitForChild("OpenShop")      :: RemoteEvent
	remotes.OpenPrizeBooth = remotesFolder:WaitForChild("OpenPrizeBooth") :: RemoteEvent

	for _, def in VENDORS do
		buildVendor(def)
	end
end

return NpcVendorService
