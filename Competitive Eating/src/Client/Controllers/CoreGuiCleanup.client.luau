-- Disable Roblox's built-in topbar elements (mobile-app icon, etc).
-- AAA_ prefix so it runs first.

local StarterGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts") and game:GetService("StarterGui")

local function kill()
	-- Modern API
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
	end)
	-- Re-enable only what we actually want
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	end)
	-- Legacy fallback
	pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)
end

-- Run immediately + retry a few times (some CoreGui items load lazily)
kill()
for i = 1, 5 do
	task.wait(0.5)
	kill()
end
