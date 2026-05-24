-- GameEventsBroadcast.luau
-- Cross-server pub/sub via MessagingService.
-- Publish game events (multiplier_start, multiplier_end, season_reset, etc.)
-- to all live servers, and let local code subscribe to those events.
--
-- Usage:
--   GameEventsBroadcast.publish("multiplier_start", { type="weekend", mult=2, expiresAt=os.time()+3600 })
--   GameEventsBroadcast.on("multiplier_start", function(data) ... end)
--   local mult = GameEventsBroadcast.getSporeMultiplier()

local MessagingService = game:GetService("MessagingService")
local HttpService      = game:GetService("HttpService")

local TOPIC = "FunGuyEvents_v1"

-- ─── ACTIVE MODIFIERS TABLE ──────────────────────────────────────────────────
-- { [modifierType] = { multiplier: number, expiresAt: number } }
local activeModifiers: { [string]: { multiplier: number, expiresAt: number } } = {}

-- ─── SUBSCRIBER REGISTRY ────────────────────────────────────────────────────
local handlers: { [string]: { (table) -> () } } = {}

local GameEventsBroadcast = {}

-- ─── SUBSCRIBE TO AN EVENT TYPE ─────────────────────────────────────────────

function GameEventsBroadcast.on(eventType: string, fn: (table) -> ())
	if not handlers[eventType] then handlers[eventType] = {} end
	table.insert(handlers[eventType], fn)
end

-- ─── PUBLISH AN EVENT TO ALL SERVERS ────────────────────────────────────────

function GameEventsBroadcast.publish(eventType: string, data: table)
	local payload = HttpService:JSONEncode({ eventType = eventType, data = data })
	-- MessagingService cap: 1 KB per message
	if #payload > 900 then
		warn("[GameEventsBroadcast] Payload too large for eventType:", eventType)
		return
	end
	task.spawn(function()
		local ok, err = pcall(function()
			MessagingService:PublishAsync(TOPIC, payload)
		end)
		if not ok then
			warn("[GameEventsBroadcast] PublishAsync failed:", err)
		end
	end)
end

-- ─── GET COMBINED SPORE MULTIPLIER ──────────────────────────────────────────
-- Returns the product of all active (non-expired) spore multipliers.

function GameEventsBroadcast.getSporeMultiplier(): number
	local now     = os.time()
	local total   = 1
	local expired = {}
	for modType, mod in pairs(activeModifiers) do
		if now < mod.expiresAt then
			total *= mod.multiplier
		else
			table.insert(expired, modType)
		end
	end
	for _, modType in ipairs(expired) do
		activeModifiers[modType] = nil
	end
	return total
end

-- ─── BUILT-IN HANDLERS ───────────────────────────────────────────────────────

-- multiplier_start: { type, multiplier, expiresAt }
GameEventsBroadcast.on("multiplier_start", function(data: table)
	activeModifiers[data.type] = {
		multiplier = data.multiplier,
		expiresAt  = data.expiresAt,
	}
	-- Auto-remove after expiry so getSporeMultiplier() stays clean
	local ttl = data.expiresAt - os.time()
	if ttl > 0 then
		task.delay(ttl, function()
			activeModifiers[data.type] = nil
		end)
	end
end)

-- multiplier_end: { type }
GameEventsBroadcast.on("multiplier_end", function(data: table)
	activeModifiers[data.type] = nil
end)

-- ─── INCOMING MESSAGE DISPATCHER ─────────────────────────────────────────────

task.spawn(function()
	local ok, err = pcall(function()
		MessagingService:SubscribeAsync(TOPIC, function(message)
			local payload = message.Data
			local decoded
			local decOk, decErr = pcall(function()
				decoded = HttpService:JSONDecode(payload)
			end)
			if not decOk or not decoded then
				warn("[GameEventsBroadcast] Bad payload:", decErr)
				return
			end

			local eventType = decoded.eventType
			local data      = decoded.data or {}

			local fns = handlers[eventType]
			if fns then
				for _, fn in ipairs(fns) do
					task.spawn(fn, data)
				end
			end
		end)
	end)
	if not ok then
		warn("[GameEventsBroadcast] SubscribeAsync failed:", err)
	end
end)

return GameEventsBroadcast
