-- MyceliumPulseLoop: starts the cooperative pulse system and wires
-- SporeOrbManager's onOrbCollected callback to record player activity.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MyceliumPulse   = require(script.Parent.MyceliumPulse)
local SporeOrbManager = require(script.Parent.SporeOrbManager)

local Remotes            = ReplicatedStorage:WaitForChild("Remotes")
local MyceliumPulseEvent = Remotes:WaitForChild("MyceliumPulse")

-- Register the activity callback on SporeOrbManager
SporeOrbManager.onOrbCollected = function(player: Player)
	MyceliumPulse.recordActivity(player)
end

-- Start the pulse check loop
MyceliumPulse.startLoop(MyceliumPulseEvent)
