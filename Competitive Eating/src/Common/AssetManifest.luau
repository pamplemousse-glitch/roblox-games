-- AssetManifest: registry of every asset the AssetSpawner will instantiate at
-- server start. Add an entry per asset to make it appear in the world.
--
-- Entry format:
--   { module = "Assets.Districts.<District>.<Category>.<AssetName>",
--     position = Vector3.new(x, y, z),
--     yaw = 0 }
--
-- Each district occupies a unique X-band. ~2000 stud spacing.
-- Frank's Fairground is the only district pre-built without using AssetSpawner;
-- everything else routes through here.

return {
	-- ============================================================
	-- PIZZA PLAZA (X = 2000) — Italian-American genre — WORKED EXAMPLE
	-- ============================================================

	-- Tier 1 foods (5 dish piles per contestant — for now they spawn as standalone displays)
	{ module = "Assets.Districts.PizzaPlaza.Foods.PizzaSlice",   position = Vector3.new(2000, 6,    0) },
	{ module = "Assets.Districts.PizzaPlaza.Foods.Calzone",      position = Vector3.new(2010, 6,    0) },
	{ module = "Assets.Districts.PizzaPlaza.Foods.MeatballSub",  position = Vector3.new(2020, 6,    0) },
	{ module = "Assets.Districts.PizzaPlaza.Foods.GarlicBread",  position = Vector3.new(2030, 6,    0) },
	{ module = "Assets.Districts.PizzaPlaza.Foods.PastaBowl",    position = Vector3.new(2040, 6,    0) },

	-- Buildings (5 hero structures)
	{ module = "Assets.Districts.PizzaPlaza.Buildings.PizzaParlor",      position = Vector3.new(2000, 0,  100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.GelatoStand",      position = Vector3.new(2050, 0,  100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.OperaArchEntry",   position = Vector3.new(2000, 0, -100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.WoodFiredOven",    position = Vector3.new(2100, 0,    0), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.PiazzaFountain",   position = Vector3.new(1950, 0,    0), yaw = 0 },

	-- NPC vendor stands (4 - same NPC name as in Constants.NPC_NAMES style)
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Vinny",    position = Vector3.new(2000, 6,   30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Tony",     position = Vector3.new(2020, 6,   30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Carmela",  position = Vector3.new(2040, 6,   30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Sal",      position = Vector3.new(2060, 6,   30) },

	-- ============================================================
	-- MERCADO DEL SOL (X = 12000) — Mexican Street genre
	-- ============================================================

	-- Foods (5)
	{ module = "Assets.Districts.MercadoDelSol.Foods.Taco",       position = Vector3.new(12010, 6,    0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Burrito",    position = Vector3.new(12020, 6,    0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Quesadilla", position = Vector3.new(12030, 6,    0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Tamale",     position = Vector3.new(12040, 6,    0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Elote",      position = Vector3.new(12050, 6,    0) },

	-- Buildings (5)
	{ module = "Assets.Districts.MercadoDelSol.Buildings.TaqueriaStall",       position = Vector3.new(12050, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.MercadoCanopy",       position = Vector3.new(12100, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.SalsaCart",           position = Vector3.new(12150, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.CathedralArchEntry", position = Vector3.new(12200, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.PinataTower",         position = Vector3.new(12250, 0, 100), yaw = 0 },

	-- NPCs (4)
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonPepe",  position = Vector3.new(12020, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Lucia",    position = Vector3.new(12040, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Memo",     position = Vector3.new(12060, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonaRosa", position = Vector3.new(12080, 6, 30) },

	-- ============================================================
	-- Other districts go here as parallel sessions complete:
	-- TOKYO TOWN              (X = 4000)
	-- DONUT DYNASTY           (X = 6000)
	-- BURGER BOULEVARD        (X = 8000)
	-- BBQ HOLLER              (X = 10000)
	-- ============================================================
}
