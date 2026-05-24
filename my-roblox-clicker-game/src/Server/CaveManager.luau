local Config = require(game.ReplicatedStorage.Common.Config)

local CaveManager = {}

-- { [userId] = { displayName, species[3], prestigeLevel } }
local showcases = {}

local TIER_RANK = { Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Mythic = 5 }

local function topThree(data: table): { { name: string, tier: string } }
	local list = {}
	for _, id in ipairs(data.ownedSpecies) do
		local sp = Config.SPECIES_BY_ID[id]
		if sp then table.insert(list, sp) end
	end
	table.sort(list, function(a, b)
		local ra = TIER_RANK[a.tier] or 0
		local rb = TIER_RANK[b.tier] or 0
		if ra ~= rb then return ra > rb end
		return a.sporesPerSec > b.sporesPerSec
	end)
	local result = {}
	for i = 1, math.min(3, #list) do
		table.insert(result, { name = list[i].name, tier = list[i].tier })
	end
	return result
end

function CaveManager.update(player: Player, data: table)
	showcases[player.UserId] = {
		userId       = player.UserId,
		displayName  = player.DisplayName,
		species      = topThree(data),
		prestigeLevel = data.prestigeLevel,
	}
end

function CaveManager.remove(player: Player)
	showcases[player.UserId] = nil
end

-- Returns array safe for RemoteEvent serialization
function CaveManager.getAll(): { any }
	local result = {}
	for _, showcase in pairs(showcases) do
		table.insert(result, showcase)
	end
	return result
end

return CaveManager
