-- Road to The Bear — 4-stage tournament storyline.
--
-- Players progress through 4 stages defined in Constants.TOURNAMENT_STAGES.
-- ContestService calls onContestResult(player, didWin, sortedResults, playerPlace, tier)
-- at the end of every contest. We:
--   1. Increment objective counters for the player's currentStage.
--   2. If every objective for currentStage is satisfied, grant the reward
--      (cosmetic ownership flag + title) and advance currentStage.
--   3. Stage 4 completion sets arcComplete=true and fires bearPreview=true,
--      which the client treats as the placeholder "BEAR PREVIEW (coming soon)"
--      cutscene cue. The real Bear boss fight is deferred.
--
-- Fires TournamentProgressUpdate (server -> client) on every credited contest,
-- so the HUD/journal can re-render objective counters and stage cards.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common      = ReplicatedStorage:WaitForChild("Common")
local Constants   = require(Common.Constants)
local DataManager = require(script.Parent.DataManager)

local TournamentService = {}

local progressRemote: RemoteEvent

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function getStageDef(stageId: number)
	for _, stage in Constants.TOURNAMENT_STAGES do
		if stage.id == stageId then return stage end
	end
	return nil
end

local function ensureProgress(data: any)
	if data.tournamentProgress == nil then
		data.tournamentProgress = { currentStage = 1, objectives = {}, arcComplete = false }
	end
	if data.tournamentProgress.currentStage == nil then data.tournamentProgress.currentStage = 1 end
	if data.tournamentProgress.objectives   == nil then data.tournamentProgress.objectives   = {} end
	if data.tournamentProgress.arcComplete  == nil then data.tournamentProgress.arcComplete  = false end
	return data.tournamentProgress
end

-- Build the client-facing snapshot of a stage: every objective with its
-- current/target counts and a `complete` flag.
local function snapshotStage(progress: any, stageDef)
	local objectives = {}
	for _, o in stageDef.objectives do
		local current = math.min(progress.objectives[o.key] or 0, o.target)
		table.insert(objectives, {
			key      = o.key,
			label    = o.label,
			target   = o.target,
			current  = current,
			complete = current >= o.target,
		})
	end
	return {
		id          = stageDef.id,
		name        = stageDef.name,
		description = stageDef.description,
		objectives  = objectives,
	}
end

local function buildPayload(progress: any, justCompletedStage, bearPreview: boolean?)
	local stageDef = getStageDef(progress.currentStage) or Constants.TOURNAMENT_STAGES[#Constants.TOURNAMENT_STAGES]
	return {
		arcName        = Constants.TOURNAMENT_ARC_NAME,
		currentStage   = progress.currentStage,
		stage          = snapshotStage(progress, stageDef),
		stageCompleted = justCompletedStage,             -- stage def (with reward) or nil
		bearPreview    = bearPreview == true,            -- triggers placeholder cutscene
		arcComplete    = progress.arcComplete == true,
	}
end

local function fireProgress(player: Player, progress: any, justCompletedStage, bearPreview: boolean?)
	if not progressRemote then return end
	progressRemote:FireClient(player, buildPayload(progress, justCompletedStage, bearPreview))
end

-- Try to evaluate the current stage; if all objectives satisfied, grant reward
-- and advance. Returns the completed-stage def (or nil), and whether the arc
-- itself just completed (stage 4 finished).
local function tryCompleteStage(player: Player, data: any, progress: any): (any?, boolean)
	local stageDef = getStageDef(progress.currentStage)
	if stageDef == nil then return nil, false end

	for _, o in stageDef.objectives do
		if (progress.objectives[o.key] or 0) < o.target then
			return nil, false
		end
	end

	-- Grant reward
	local reward = stageDef.reward or {}
	if reward.cosmeticId then
		data.ownedCosmetics = data.ownedCosmetics or {}
		data.ownedCosmetics[reward.cosmeticId] = true
	end
	if reward.title then
		data.titles = data.titles or {}
		if not table.find(data.titles, reward.title) then
			table.insert(data.titles, reward.title)
		end
		data.activeTitle = reward.title
	end

	-- Advance
	local arcJustCompleted = false
	local nextStageId = progress.currentStage + 1
	if getStageDef(nextStageId) then
		progress.currentStage = nextStageId
	else
		progress.arcComplete = true
		arcJustCompleted = true
	end

	DataManager.markDirty(player)
	return stageDef, arcJustCompleted
end

-- ── Public API ────────────────────────────────────────────────────────────────

function TournamentService.init(remotesFolder: Folder)
	progressRemote = remotesFolder:WaitForChild("TournamentProgressUpdate") :: RemoteEvent

	-- Send initial snapshot to players already in (and any future joiners) so
	-- the journal/HUD has data on session start.
	local function pushInitial(player: Player)
		task.spawn(function()
			local data
			for _ = 1, 40 do
				data = DataManager.get(player)
				if data then break end
				task.wait(0.1)
			end
			if not data then return end
			local progress = ensureProgress(data)
			fireProgress(player, progress, nil, false)
		end)
	end

	Players.PlayerAdded:Connect(pushInitial)
	for _, p in Players:GetPlayers() do pushInitial(p) end
end

-- Returns the live progress snapshot for a player (for other services /
-- read-only callers). Returns nil if data isn't loaded yet.
function TournamentService.getProgress(player: Player): any?
	local data = DataManager.get(player)
	if not data then return nil end
	local progress = ensureProgress(data)
	local stageDef = getStageDef(progress.currentStage)
	if not stageDef then return nil end
	return {
		currentStage = progress.currentStage,
		arcComplete  = progress.arcComplete,
		stage        = snapshotStage(progress, stageDef),
	}
end

-- Called by ContestService after every contest result.
-- sortedResults: the contestants in finishing order (place-1 first).
-- playerPlace:   the human player's place (1..SEATS_PER_ARENA).
-- tier:          arena tier at time of contest.
function TournamentService.onContestResult(
	player: Player,
	didWin: boolean,
	sortedResults: { any },
	playerPlace: number,
	tier: number
)
	local data = DataManager.get(player)
	if not data then return end
	local progress = ensureProgress(data)

	if progress.arcComplete then
		fireProgress(player, progress, nil, false)
		return
	end

	local stageDef = getStageDef(progress.currentStage)
	if not stageDef then return end

	-- Figure out which NPCs the player finished ahead of.
	local npcsBeaten: { [string]: boolean } = {}
	if type(sortedResults) == "table" then
		for place, c in sortedResults do
			if place > playerPlace and c and c.isNpc and c.npcName then
				npcsBeaten[c.npcName] = true
			end
		end
	end

	-- Apply increments for objectives in the active stage only.
	local progressed = false
	for _, o in stageDef.objectives do
		local cur = progress.objectives[o.key] or 0
		if cur >= o.target then continue end  -- already satisfied

		if o.kind == "tierWin" then
			if didWin and tier == o.tier then
				progress.objectives[o.key] = cur + 1
				progressed = true
			end
		elseif o.kind == "beatNpc" then
			if npcsBeaten[o.npc] then
				progress.objectives[o.key] = cur + 1
				progressed = true
			end
		end
	end

	if progressed then
		DataManager.markDirty(player)
	end

	-- Try to complete the current stage. May cascade if a stage's bar was
	-- already met before this contest (defensive — normally not needed).
	local completedStage, arcJustDone = tryCompleteStage(player, data, progress)
	local bearPreview = arcJustDone  -- stage 4 completion triggers placeholder

	fireProgress(player, progress, completedStage, bearPreview)
end

return TournamentService
