--[[
  create_myco_npc.luau
  Run once in Studio (Command Bar or Script > Run) to place Myco the Merchant NPC.
  The NPC lives in workspace.Hub and is referenced at runtime by NPCShopClient.

  Geometry:
    MycoNPC (Model, PrimaryPart = Cap)
      Cap   (Part, sphere, bioluminescent purple cap)
      Stem  (Part, cylinder, cream/white)
      EyeL  (Part, small sphere, glowing amber)
      EyeR  (Part, small sphere, glowing amber)
      ShopPrompt (ProximityPrompt, parent = Cap)
      SpeechBillboard (BillboardGui, parent = Cap)
        Bubble (Frame)
          Text (TextLabel)

  Position: centre of Hub platform, offset slightly from spawn (0, 0, -12).
  Adjust HUB_OFFSET if your Hub Part is at a different CFrame.
--]]

local HUB_OFFSET = CFrame.new(0, 5, -12)   -- relative to Hub.CFrame origin

-- ── helpers ──────────────────────────────────────────────────────────────────

local function part(name, shape, size, color, material, parent)
	local p = Instance.new("Part")
	p.Name     = name
	p.Shape    = shape
	p.Size     = size
	p.Color    = color
	p.Material = material
	p.Anchored = true
	p.CanCollide = false
	p.CastShadow = false
	p.Parent   = parent
	return p
end

local function glow(p, color3, range, brightness)
	local light = Instance.new("PointLight")
	light.Color      = color3
	light.Range      = range
	light.Brightness = brightness
	light.Parent     = p
end

-- ── build ─────────────────────────────────────────────────────────────────────

local hub = workspace:FindFirstChild("Hub")
assert(hub, "Hub not found in workspace — make sure the Hub model exists first")

-- Remove old copy so script is re-runnable
local old = hub:FindFirstChild("MycoNPC")
if old then old:Destroy() end

local model = Instance.new("Model")
model.Name = "MycoNPC"
model.Parent = hub

-- Hub base CFrame (use PrimaryPart if set, else identity)
local hubCF = (hub:IsA("Model") and hub.PrimaryPart)
	and hub.PrimaryPart.CFrame
	or CFrame.new()

local base = hubCF * HUB_OFFSET   -- world CFrame for NPC root

-- Stem
local stem = part("Stem",
	Enum.PartType.Cylinder,
	Vector3.new(0.6, 2.4, 0.6),
	Color3.fromRGB(240, 230, 210),
	Enum.Material.SmoothPlastic,
	model)
stem.CFrame = base * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))

-- Cap (primary part)
local cap = part("Cap",
	Enum.PartType.Ball,
	Vector3.new(2.6, 2.0, 2.6),
	Color3.fromRGB(100, 40, 160),   -- deep violet
	Enum.Material.Neon,
	model)
cap.CFrame = base * CFrame.new(0, 1.8, 0)
glow(cap, Color3.fromRGB(140, 60, 220), 12, 1.2)
model.PrimaryPart = cap

-- Eyes
local eyeL = part("EyeL",
	Enum.PartType.Ball,
	Vector3.new(0.35, 0.35, 0.35),
	Color3.fromRGB(255, 190, 30),
	Enum.Material.Neon,
	model)
eyeL.CFrame = base * CFrame.new(-0.45, 1.4, -1.1)
glow(eyeL, Color3.fromRGB(255, 200, 50), 4, 0.8)

local eyeR = part("EyeR",
	Enum.PartType.Ball,
	Vector3.new(0.35, 0.35, 0.35),
	Color3.fromRGB(255, 190, 30),
	Enum.Material.Neon,
	model)
eyeR.CFrame = base * CFrame.new(0.45, 1.4, -1.1)
glow(eyeR, Color3.fromRGB(255, 200, 50), 4, 0.8)

-- ProximityPrompt
local prompt = Instance.new("ProximityPrompt")
prompt.Name            = "ShopPrompt"
prompt.ActionText      = "Browse"
prompt.ObjectText      = "Myco the Merchant"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.MaxActivationDistance = 10
prompt.HoldDuration    = 0
prompt.Parent          = cap

-- BillboardGui (speech bubble above cap)
local billboard = Instance.new("BillboardGui")
billboard.Name          = "SpeechBillboard"
billboard.Adornee       = cap
billboard.Size          = UDim2.new(0, 240, 0, 60)
billboard.StudsOffset   = Vector3.new(0, 2.2, 0)
billboard.AlwaysOnTop   = false
billboard.LightInfluence = 0
billboard.Enabled       = false      -- NPCShopClient enables it on proximity
billboard.Parent        = cap

local bubble = Instance.new("Frame")
bubble.Name            = "Bubble"
bubble.Size            = UDim2.fromScale(1, 1)
bubble.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
bubble.BackgroundTransparency = 0.2
bubble.BorderSizePixel = 0
bubble.Parent          = billboard

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = bubble

local textLabel = Instance.new("TextLabel")
textLabel.Name            = "Text"
textLabel.Size            = UDim2.fromScale(1, 1)
textLabel.BackgroundTransparency = 1
textLabel.Font            = Enum.Font.GothamMedium
textLabel.TextSize        = 13
textLabel.TextColor3      = Color3.fromRGB(220, 200, 255)
textLabel.TextWrapped     = true
textLabel.Text            = "..."
textLabel.Parent          = bubble

print("✓ MycoNPC created at", cap.CFrame)
