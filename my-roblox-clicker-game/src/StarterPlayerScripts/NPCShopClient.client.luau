-- NPCShopClient.client.luau
-- Myco the Merchant: proximity speech bubble + ProximityPrompt → opens shop.

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local OpenShop    = ReplicatedStorage:WaitForChild("Bindables"):WaitForChild("OpenShop")

local DIALOGUE_RADIUS = 20

local IDLE_LINES = {
	"The mycelium whispers of rare finds today...",
	"Ah, the cave provides for those who tend it well.",
	"I've seen a thousand species. Each one worth the wait.",
	"A fresh Bleeding Tooth came in just this morning.",
	"Did you know? Mutations multiply. Patience compounds.",
	"The Deep holds secrets even I haven't catalogued yet.",
	"Your spores smell particularly fine today, if I may say so.",
	"Rare species aren't bought — they're earned. Then bought.",
}

local GREETING_LINES = {
	"Welcome, cultivator. What'll it be?",
	"Ah, just the farmer I wanted to see!",
	"Come in, come in. My finest stock awaits.",
	"The spores have led you to the right place.",
}

-- ─── WAIT FOR NPC ────────────────────────────────────────────────────────────
-- MycoNPC is placed in Hub by scripts/create_myco_npc.luau (run once in Studio)

local hub = workspace:WaitForChild("Hub")
local npc = hub:WaitForChild("MycoNPC")
local prompt    = npc:WaitForChild("ShopPrompt")
local billboard = npc:WaitForChild("SpeechBillboard")  -- BillboardGui on cap
local speechText = billboard:WaitForChild("Bubble"):WaitForChild("Text")

-- ─── PROXIMITY DIALOGUE ───────────────────────────────────────────────────────

local lineIdx   = 1
local lineTimer = 0
local LINE_INTERVAL = 9  -- seconds between idle line rotations

speechText.Text = IDLE_LINES[lineIdx]

RunService.Heartbeat:Connect(function(dt)
	local char = LocalPlayer.Character
	if not char then billboard.Enabled = false; return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then billboard.Enabled = false; return end

	local dist = (npc.PrimaryPart.Position - hrp.Position).Magnitude
	billboard.Enabled = dist <= DIALOGUE_RADIUS

	if dist <= DIALOGUE_RADIUS then
		lineTimer += dt
		if lineTimer >= LINE_INTERVAL then
			lineTimer = 0
			lineIdx = (lineIdx % #IDLE_LINES) + 1
			speechText.Text = IDLE_LINES[lineIdx]
		end
	else
		lineTimer = 0
	end
end)

-- ─── SHOP TRIGGER ────────────────────────────────────────────────────────────

prompt.Triggered:Connect(function()
	speechText.Text = GREETING_LINES[math.random(#GREETING_LINES)]
	lineTimer = -4  -- hold greeting for 4 extra seconds before idle resumes
	OpenShop:Fire()
end)
