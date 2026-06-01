-- Client entry point. Waits for Remotes folder, then inits all controllers.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", 15) :: Folder
if not remotesFolder then
	warn("[Client] Remotes folder not found — server may not have started yet.")
	return
end

local Controllers = script.Parent.Controllers

local ContestController    = require(Controllers.ContestController)
local HudController        = require(Controllers.HudController)
local ShopController        = require(Controllers.ShopController)
local OnboardingController  = require(Controllers.OnboardingController)
local GloryReelController   = require(Controllers.GloryReelController)
local FriendVaultController = require(Controllers.FriendVaultController)

ContestController.init(remotesFolder)
HudController.init(remotesFolder)
ShopController.init(remotesFolder)
OnboardingController.init(remotesFolder)
GloryReelController.init(remotesFolder)
FriendVaultController.init(remotesFolder)
