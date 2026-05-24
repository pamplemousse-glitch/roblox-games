-- MutationHook.luau
-- Lightweight pub-sub for server-side mutation events.
-- SporeLoop calls MutationHook.fire(player) after a mutation occurs.
-- Any other server module can subscribe via MutationHook.onMutation(fn).

local MutationHook = {}

local listeners: { (Player) -> () } = {}

function MutationHook.onMutation(fn: (Player) -> ())
	table.insert(listeners, fn)
end

function MutationHook.fire(player: Player)
	for _, fn in ipairs(listeners) do
		task.spawn(fn, player)
	end
end

return MutationHook
