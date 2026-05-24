-- ArrangeMode: lets players rearrange mushrooms across pedestals
-- Usage: ArrangeMode.init(arrangeBtn, hintLabel, ArrangeSwapRemote)
--        ArrangeMode.toggle()   -- called by the ARRANGE button
--        ArrangeMode.deactivate() -- called when switching tabs

local UserInputService = game:GetService("UserInputService")

local ArrangeMode = {}

local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_PANEL = Color3.fromRGB(22, 18, 40)

local active        = false
local selectedModel = nil
local selectionBox  = nil
local arrangeBtn    = nil
local hintLabel     = nil
local swapRemote    = nil

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function clearSelection()
	if selectionBox then selectionBox:Destroy() selectionBox = nil end
	selectedModel = nil
end

local function setButtonState(on: boolean)
	if not arrangeBtn then return end
	arrangeBtn.BackgroundColor3 = on and C_CYAN or C_PANEL
	arrangeBtn.TextColor3       = on and Color3.fromRGB(12, 10, 22) or Color3.new(1, 1, 1)
end

-- Walk up the hierarchy to find a Model with a SpeciesId attribute
local function mushroomModelFromPart(part: Instance): Model?
	local cur = part
	while cur and cur ~= workspace do
		if cur:IsA("Model") and cur:GetAttribute("SpeciesId") then
			return cur :: Model
		end
		cur = cur.Parent
	end
	return nil
end

-- ─── INPUT ───────────────────────────────────────────────────────────────────

local function onInput(input, processed)
	if processed or not active then return end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end

	local camera = workspace.CurrentCamera
	local ray    = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
	local result = workspace:Raycast(ray.Origin, ray.Direction * 600)
	if not result then clearSelection() return end

	local hitPart  = result.Instance
	local hitModel = mushroomModelFromPart(hitPart)

	if hitModel then
		-- ── Clicked a mushroom ────────────────────────────────────────────
		if selectedModel == nil then
			-- Select it
			selectedModel = hitModel
			selectionBox             = Instance.new("SelectionBox")
			selectionBox.Adornee     = hitModel
			selectionBox.Color3      = C_CYAN
			selectionBox.LineThickness    = 0.08
			selectionBox.SurfaceTransparency = 0.7
			selectionBox.SurfaceColor3    = C_CYAN
			selectionBox.Parent      = workspace

		elseif selectedModel == hitModel then
			clearSelection()   -- tap same → deselect

		else
			-- Swap with another mushroom
			local target = hitModel:GetAttribute("RootSpotName")
			if target and swapRemote then
				swapRemote:FireServer(selectedModel:GetAttribute("SpeciesId"), target)
			end
			clearSelection()
		end
		return
	end

	-- ── Clicked an empty pedestal ─────────────────────────────────────────
	if hitPart.Name:match("^RootSpot_") and selectedModel then
		if swapRemote then
			swapRemote:FireServer(selectedModel:GetAttribute("SpeciesId"), hitPart.Name)
		end
		clearSelection()
		return
	end

	clearSelection()
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

function ArrangeMode.init(btn, hint, remote)
	arrangeBtn = btn
	hintLabel  = hint
	swapRemote = remote
	UserInputService.InputBegan:Connect(onInput)
end

function ArrangeMode.toggle()
	active = not active
	clearSelection()
	setButtonState(active)
	if hintLabel then hintLabel.Visible = active end
end

function ArrangeMode.deactivate()
	if not active then return end
	active = false
	clearSelection()
	setButtonState(false)
	if hintLabel then hintLabel.Visible = false end
end

function ArrangeMode.isActive(): boolean
	return active
end

return ArrangeMode
