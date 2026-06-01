-- Picks an NPC dialog line that reflects the player's history with that NPC.
-- 1st-2nd encounter → catchphrase. 3rd+ → familiar. 10th+ → rival.
-- Reads from DataManager (per-player npcEncounters), never mutates.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common      = ReplicatedStorage.Common
local Constants   = require(Common.Constants)
local DataManager = require(script.Parent.DataManager)

local NpcMemoryService = {}

local function pickFrom(list: { string }?): string?
	if not list or #list == 0 then return nil end
	return list[math.random(#list)]
end

-- situation:
--   "intro"   → countdown catchphrase, escalates with familiarity
--   "npcWin"  → NPC's line after beating the player
--   "npcLose" → NPC's line after losing to the player
function NpcMemoryService.pickDialogLine(player: Player, npcName: string, situation: string): string?
	local char = Constants.NPC_CHARACTERS[npcName]
	if not char then return nil end

	local rec = DataManager.getNpcEncounter(player, npcName)
	local priorCount = (rec and rec.count) or 0

	if situation == "intro" then
		if priorCount >= Constants.NPC_RIVAL_THRESHOLD then
			return pickFrom(char.rivalLines)
				or pickFrom(char.familiarLines)
				or char.catchphrase
		elseif priorCount >= Constants.NPC_FAMILIAR_THRESHOLD then
			return pickFrom(char.familiarLines)
				or char.catchphrase
		else
			return char.catchphrase
		end
	elseif situation == "npcWin" then
		return char.winLine
	elseif situation == "npcLose" then
		return char.loseLine
	end

	return char.catchphrase
end

return NpcMemoryService
