-- Shared coin pool a player and their Roblox friends can deposit into.
-- Only the vault owner can withdraw. Max balance 10,000 coins.
-- Server-authoritative: all amounts validated, friendship verified via GetFriendsAsync.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManager = require(script.Parent.DataManager)

local FriendVaultService = {}

local VAULT_MAX        = 10000
local FRIEND_CACHE_TTL = 60  -- seconds; GetFriendsAsync is rate-limited and slow

local remotes: { [string]: RemoteEvent } = {}

-- friendCache[userIdA][userIdB] = true means A confirmed B is on A's friends list.
local friendCache: { [number]: { friends: { [number]: boolean }, expiresAt: number } } = {}

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function getBalance(player: Player): number
	local data = DataManager.get(player)
	if not data then return 0 end
	return data.friendVaultBalance or 0
end

local function getCoins(player: Player): number
	local data = DataManager.get(player)
	if not data then return 0 end
	return data.coins or 0
end

-- Refreshes the friend list for `viewer` and returns whether `otherId` is on it.
-- Result is cached for FRIEND_CACHE_TTL to limit GetFriendsAsync calls.
local function isFriend(viewer: Player, otherId: number): boolean
	if viewer.UserId == otherId then return true end

	local entry = friendCache[viewer.UserId]
	if entry and entry.expiresAt > os.clock() then
		return entry.friends[otherId] == true
	end

	local friends: { [number]: boolean } = {}
	local ok, pages = pcall(function()
		return Players:GetFriendsAsync(viewer.UserId)
	end)

	if ok and pages then
		local done = false
		while not done do
			local pageOk, pageItems = pcall(function() return pages:GetCurrentPage() end)
			if pageOk and pageItems then
				for _, info in pageItems do
					if typeof(info) == "table" and info.Id then
						friends[info.Id] = true
					end
				end
			end
			if pages.IsFinished then
				done = true
			else
				local advOk = pcall(function() pages:AdvanceToNextPageAsync() end)
				if not advOk then done = true end
			end
		end
	else
		warn("[FriendVaultService] GetFriendsAsync failed for", viewer.Name, ":", tostring(pages))
	end

	friendCache[viewer.UserId] = { friends = friends, expiresAt = os.clock() + FRIEND_CACHE_TTL }
	return friends[otherId] == true
end

-- Fire vault state back to a client.
local function sync(player: Player, remote: RemoteEvent, success: boolean)
	remote:FireClient(player, success, getBalance(player), getCoins(player))
end

-- ── Deposit ───────────────────────────────────────────────────────────────────
-- Client payload: (amount, targetUserId?)
-- If targetUserId is nil or self → deposit into own vault.
-- Otherwise → must be a Roblox friend of the local player (and online here, since
-- we need to mutate their cached data). Coins come from the depositor.

local function onDeposit(player: Player, amount: any, targetUserId: any)
	if typeof(amount) ~= "number" then return end
	amount = math.floor(amount)
	if amount <= 0 then return end

	local target: Player = player
	if typeof(targetUserId) == "number" and targetUserId ~= player.UserId then
		local found = Players:GetPlayerByUserId(targetUserId)
		if not found then
			sync(player, remotes.DepositToVault, false)
			return
		end
		if not isFriend(player, targetUserId) then
			sync(player, remotes.DepositToVault, false)
			return
		end
		target = found
	end

	local targetData = DataManager.get(target)
	if not targetData then
		sync(player, remotes.DepositToVault, false)
		return
	end

	local currentBalance = targetData.friendVaultBalance or 0
	local headroom = VAULT_MAX - currentBalance
	if headroom <= 0 then
		sync(player, remotes.DepositToVault, false)
		return
	end

	local depositAmount = math.min(amount, headroom)
	if not DataManager.spendCoins(player, depositAmount) then
		sync(player, remotes.DepositToVault, false)
		return
	end

	if not DataManager.addToFriendVault(target, depositAmount) then
		-- Should not fail since we just validated, but refund to keep coins consistent.
		DataManager.addCoins(player, depositAmount)
		sync(player, remotes.DepositToVault, false)
		return
	end

	sync(player, remotes.DepositToVault, true)
	if target ~= player then
		sync(target, remotes.DepositToVault, true)  -- notify recipient if online
	end
end

-- ── Withdraw ──────────────────────────────────────────────────────────────────
-- Only the vault owner can withdraw from their own vault. No targetUserId.

local function onWithdraw(player: Player, amount: any)
	if typeof(amount) ~= "number" then return end
	amount = math.floor(amount)
	if amount <= 0 then return end

	if not DataManager.withdrawFromFriendVault(player, amount) then
		sync(player, remotes.WithdrawFromVault, false)
		return
	end

	DataManager.addCoins(player, amount)
	sync(player, remotes.WithdrawFromVault, true)
end

-- ── Init ──────────────────────────────────────────────────────────────────────

function FriendVaultService.init(remotesFolder: Folder)
	remotes.DepositToVault    = remotesFolder:WaitForChild("DepositToVault")    :: RemoteEvent
	remotes.WithdrawFromVault = remotesFolder:WaitForChild("WithdrawFromVault") :: RemoteEvent

	remotes.DepositToVault.OnServerEvent:Connect(onDeposit)
	remotes.WithdrawFromVault.OnServerEvent:Connect(onWithdraw)

	Players.PlayerRemoving:Connect(function(player)
		friendCache[player.UserId] = nil
	end)

	-- Initial sync on join: tell each client their current vault balance.
	local function syncOnJoin(player: Player)
		-- Defer until DataManager has loaded the player.
		task.spawn(function()
			for _ = 1, 50 do
				if DataManager.get(player) then break end
				task.wait(0.1)
			end
			if DataManager.get(player) then
				sync(player, remotes.WithdrawFromVault, true)
			end
		end)
	end
	Players.PlayerAdded:Connect(syncOnJoin)
	for _, p in Players:GetPlayers() do
		syncOnJoin(p)
	end
end

return FriendVaultService
