-- Suppress Roblox built-in CoreGui topbar elements that clutter our HUD
-- (Captures icon, voice chat indicator, mobile-app/phone icon, etc).

local Players    = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local _ = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

local function suppress()
	-- Hide every CoreGui type except chat
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end)
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
	-- Legacy topbar disable
	pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)
	-- Newer unibar items
	for _, key in {"PhoneIcon", "MobileLinkIcon", "OpenInAppIcon", "RobloxAppCTA", "ContextMenuButton", "ChromeMenuButton"} do
		pcall(function() StarterGui:SetCore(key, false) end)
	end
end

suppress()
for i = 1, 10 do
	task.wait(0.5)
	suppress()
end
