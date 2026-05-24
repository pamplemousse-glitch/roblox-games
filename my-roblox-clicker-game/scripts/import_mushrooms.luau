-- Run this in Studio's Command Bar (View → Command Bar) to import all mushroom models into ServerStorage
local InsertService = game:GetService("InsertService")
local ServerStorage = game:GetService("ServerStorage")

local assetIds = {
	amethyst      = 139473382103744,
	azuredragon   = 113995408522971,
	biolumpanellus= 132681226942397,
	blacktrumpet  = 103278342330505,
	bleedingtooth = 140092672616120,
	button        = 93039236166593,
	caesars       = 114125109313562,
	cauliflower   = 77592490009629,
	chanterelle   = 83898985280339,
	chestnut      = 128986963031576,
	chickenwoods  = 138113171926820,
	coralfungus   = 127372732473320,
	cremini       = 84061800816540,
	enoki         = 133351557304902,
	flyagaric     = 90703977415939,
	ghostfungus   = 81774241112057,
	giantpuffball = 111574297153306,
	goldenteacher = 93609899444021,
	hedgehog      = 108913828330223,
	henofwoods    = 75238217188611,
	indigomilk    = 76296745347419,
	kingtrumpet   = 97612475728104,
	lionsmane     = 135520165681800,
	lobster       = 120069917951443,
	maitake       = 86437343699928,
	matsutake     = 87098358819888,
	morel         = 79046508488556,
	nameko        = 86347531890771,
	oyster        = 73107611498681,
	porcini       = 102152026439484,
	portobello    = 93930084130854,
	rootspot      = 114552833015796,
	saffronmilk   = 133686819305432,
	shiitake      = 108760418121153,
	starfire      = 98720860623659,
	velvetpiop    = 137148235024143,
	violetweb     = 81885817136982,
}

local folder = Instance.new("Folder")
folder.Name = "Mushrooms"
folder.Parent = ServerStorage

local ok, fail = 0, 0
for name, id in pairs(assetIds) do
	local success, result = pcall(function()
		return InsertService:LoadAsset(id)
	end)
	if success then
		result.Name = name
		result.Parent = folder
		ok += 1
		print("✓ " .. name)
	else
		fail += 1
		warn("✗ " .. name .. ": " .. tostring(result))
	end
end

print(string.format("\nDone: %d imported, %d failed", ok, fail))
