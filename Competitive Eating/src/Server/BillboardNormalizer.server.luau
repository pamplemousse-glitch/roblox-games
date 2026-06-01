-- BillboardNormalizer: walks Workspace.Districts on server start and shrinks
-- every BillboardGui to readable size. Without this, NPC name tags render as
-- giant overlapping text obscuring the whole map.

local function normalizeBillboards(root: Instance)
	for _, d in root:GetDescendants() do
		if d:IsA("BillboardGui") then
			d.Size = UDim2.fromOffset(80, 16)
			d.StudsOffset = Vector3.new(0, 2.5, 0)
			d.AlwaysOnTop = false
			d.MaxDistance = 50
			for _, lbl in d:GetDescendants() do
				if lbl:IsA("TextLabel") then
					lbl.TextScaled = false
					lbl.TextSize = 12
					lbl.Font = Enum.Font.GothamBold
				end
			end
		end
	end
end

-- Run once on startup + on new district additions
task.spawn(function()
	local districts = workspace:WaitForChild("Districts", 30)
	if not districts then return end
	normalizeBillboards(districts)
	districts.DescendantAdded:Connect(function(d)
		if d:IsA("BillboardGui") then
			task.defer(normalizeBillboards, districts)
		end
	end)
end)
