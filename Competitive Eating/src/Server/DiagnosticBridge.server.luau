-- Diagnostic bridge: capture all server prints + warnings into a StringValue in
-- Workspace so that after Stop, Edit-mode tools (execute_luau, etc.) can read
-- what happened during play. LogService is per-VM, so this is the only way.
--
-- Capture limit: last 4000 chars. Older entries get truncated.

local LogService = game:GetService("LogService")
local Workspace  = game:GetService("Workspace")

local CAP = 4000

local bridge = Workspace:FindFirstChild("__DiagBridge") or Instance.new("StringValue")
bridge.Name   = "__DiagBridge"
bridge.Value  = ""
bridge.Parent = Workspace

LogService.MessageOut:Connect(function(msg, msgType)
	local prefix = ""
	if msgType == Enum.MessageType.MessageError   then prefix = "[ERR] "
	elseif msgType == Enum.MessageType.MessageWarning then prefix = "[WRN] "
	end
	local line = prefix .. msg .. "\n"
	local combined = bridge.Value .. line
	if #combined > CAP then
		combined = combined:sub(-CAP)
	end
	bridge.Value = combined
end)

print("[DiagBridge] online")
