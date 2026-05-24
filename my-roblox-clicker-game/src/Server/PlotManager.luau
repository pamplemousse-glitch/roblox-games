local Workspace = game:GetService("Workspace")

local PlotManager = {}

local assignedPlot  = {} -- { [userId] = plotName }
local plotOccupant  = {} -- { [plotName] = userId }

local function plotsFolder(): Folder?
	return Workspace:FindFirstChild("Plots") :: Folder?
end

local function allPlots(): { Folder }
	local folder = plotsFolder()
	if not folder then return {} end
	local result = {}
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Folder") or child:IsA("Model") then
			table.insert(result, child)
		end
	end
	table.sort(result, function(a, b) return a.Name < b.Name end)
	return result
end

function PlotManager.assign(player: Player): Folder?
	for _, plot in ipairs(allPlots()) do
		if not plotOccupant[plot.Name] then
			assignedPlot[player.UserId] = plot.Name
			plotOccupant[plot.Name]     = player.UserId
			return plot
		end
	end
	return nil -- server full
end

function PlotManager.release(player: Player)
	local name = assignedPlot[player.UserId]
	if name then
		plotOccupant[name]          = nil
		assignedPlot[player.UserId] = nil
	end
end

function PlotManager.getPlot(player: Player): Folder?
	local name   = assignedPlot[player.UserId]
	local folder = plotsFolder()
	if not name or not folder then return nil end
	return folder:FindFirstChild(name) :: Folder?
end

-- Returns root spots sorted by trailing number (RootSpot_1 … RootSpot_N)
function PlotManager.getRootSpots(plot: Folder): { BasePart }
	local list = {}
	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("BasePart") and child.Name:match("^RootSpot_") then
			table.insert(list, child)
		end
	end
	table.sort(list, function(a, b)
		local na = tonumber(a.Name:match("%d+$")) or 0
		local nb = tonumber(b.Name:match("%d+$")) or 0
		return na < nb
	end)
	return list
end

return PlotManager
