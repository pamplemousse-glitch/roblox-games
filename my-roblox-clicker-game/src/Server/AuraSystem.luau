local PlotManager = require(script.Parent.PlotManager)

local AuraSystem = {}

-- { [userId] = { [speciesId] = totalBoostMultiplier } }
local cache = {}

local AURA = {
	[1] = { radius = 10, bonus = 0.10 },
	[2] = { radius = 18, bonus = 0.25 },
	[3] = { radius = 28, bonus = 0.50 },
}

local function calcBoosts(plot: Folder, data: table): { [string]: number }
	-- Collect positions of all spawned mushroom models
	local models = {}
	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Model") then
			local sid = child:GetAttribute("SpeciesId")
			local root = child.PrimaryPart or child:FindFirstChild("Root")
			if sid and root then
				table.insert(models, {
					id       = sid,
					pos      = root.Position,
					mutCount = data.mutations[sid] or 0,
				})
			end
		end
	end

	local boosts = {}
	for _, target in ipairs(models) do
		local total = 1
		for _, source in ipairs(models) do
			if source.id == target.id then continue end
			local mut = source.mutCount
			if mut == 0 then continue end
			local aura = AURA[mut]
			if aura and (source.pos - target.pos).Magnitude <= aura.radius then
				total += aura.bonus
			end
		end
		boosts[target.id] = total
	end
	return boosts
end

function AuraSystem.update(player: Player, data: table)
	local plot = PlotManager.getPlot(player)
	if not plot then
		cache[player.UserId] = {}
		return
	end
	cache[player.UserId] = calcBoosts(plot, data)
end

function AuraSystem.getBoosts(player: Player): { [string]: number }
	return cache[player.UserId] or {}
end

function AuraSystem.remove(player: Player)
	cache[player.UserId] = nil
end

return AuraSystem
