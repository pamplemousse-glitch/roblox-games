-- AssetManifest: registry of every asset the AssetSpawner instantiates at
-- server start. Add an entry per asset to make it appear in the world.
--
-- Layout: districts arranged along the +X axis as a walkable "main street"
-- east of Frank's Fairground. ~500 studs between district centers.
--
-- Entry format:
--   { module = "Assets.Districts.<District>.<Category>.<AssetName>",
--     position = Vector3.new(x, y, z),
--     yaw = 0 }

return {
	-- ============================================================
	-- PIZZA PLAZA (base X = 600) — Italian-American genre
	-- ============================================================

	{ module = "Assets.Districts.PizzaPlaza.Foods.PizzaSlice",      position = Vector3.new(600, 6,    0) },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.PizzaParlor", position = Vector3.new(600, 0,  100), yaw = 0 },

	-- ============================================================
	-- TOKYO TOWN (base X = 1100) — Japanese Street genre
	-- ============================================================

	{ module = "Assets.Districts.TokyoTown.Foods.RamenBowl",  position = Vector3.new(1110, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.GyozaTray",  position = Vector3.new(1120, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.Takoyaki",   position = Vector3.new(1130, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.SushiRoll",  position = Vector3.new(1140, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.Mochi",      position = Vector3.new(1150, 6, 0) },

	{ module = "Assets.Districts.TokyoTown.Buildings.RamenShop",          position = Vector3.new(1100, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.SushiBar",           position = Vector3.new(1150, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.IzakayaPub",         position = Vector3.new(1200, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.ShintoArchEntry",    position = Vector3.new(1080, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.StreetCartTakoyaki", position = Vector3.new(1250, 0, 100), yaw = 0 },

	{ module = "Assets.Districts.TokyoTown.Npcs.Kenji", position = Vector3.new(1120, 6, 30) },
	{ module = "Assets.Districts.TokyoTown.Npcs.Yumi",  position = Vector3.new(1140, 6, 30) },
	{ module = "Assets.Districts.TokyoTown.Npcs.Riku",  position = Vector3.new(1160, 6, 30) },
	{ module = "Assets.Districts.TokyoTown.Npcs.Akemi", position = Vector3.new(1180, 6, 30) },

	-- ============================================================
	-- DONUT DYNASTY (base X = 1600) — Sweets / Pastries genre
	-- ============================================================

	{ module = "Assets.Districts.DonutDynasty.Foods.Donut",        position = Vector3.new(1610, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.Eclair",       position = Vector3.new(1620, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.Churro",       position = Vector3.new(1630, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.Beignet",      position = Vector3.new(1640, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.CinnamonRoll", position = Vector3.new(1650, 6, 0) },

	{ module = "Assets.Districts.DonutDynasty.Buildings.DonutShop",        position = Vector3.new(1600, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.GlazeFountain",    position = Vector3.new(1650, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.CoffeeKiosk",      position = Vector3.new(1700, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.BakeryArchEntry",  position = Vector3.new(1580, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.SugarSiloTower",   position = Vector3.new(1750, 0, 100), yaw = 0 },

	{ module = "Assets.Districts.DonutDynasty.Npcs.Marie",    position = Vector3.new(1620, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Bernard",  position = Vector3.new(1640, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Lulu",     position = Vector3.new(1660, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Stephane", position = Vector3.new(1680, 6, 30) },

	-- ============================================================
	-- BURGER BOULEVARD (base X = 2100) — 50s diner / burger variants
	-- ============================================================

	{ module = "Assets.Districts.BurgerBoulevard.Foods.Smashburger",          position = Vector3.new(2110, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.DoubleStack",          position = Vector3.new(2120, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.SliderCombo",          position = Vector3.new(2130, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.FriedChickenSandwich", position = Vector3.new(2140, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.Milkshake",            position = Vector3.new(2150, 6, 0) },

	{ module = "Assets.Districts.BurgerBoulevard.Buildings.DriveThruDiner",      position = Vector3.new(2100, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.BurgerJoint",         position = Vector3.new(2150, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.ShakeStand",          position = Vector3.new(2200, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.BurgerTowerLandmark", position = Vector3.new(2080, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.RetroGasStation",     position = Vector3.new(2250, 0, 100), yaw = 0 },

	{ module = "Assets.Districts.BurgerBoulevard.Npcs.SmashRiley",  position = Vector3.new(2120, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.PattyBonez",  position = Vector3.new(2140, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.SliderSteve", position = Vector3.new(2160, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.Cookie",      position = Vector3.new(2180, 6, 30) },

	-- ============================================================
	-- BBQ HOLLER V2 (base X = 3500) — American BBQ / rural smokehouse
	-- ============================================================

	-- Foods (kept from V1)
	{ module = "Assets.Districts.BbqHoller.Foods.Brisket",      position = Vector3.new(3510, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.PulledPork",   position = Vector3.new(3520, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.Ribs",         position = Vector3.new(3530, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.HotLink",      position = Vector3.new(3540, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.MacAndCheese", position = Vector3.new(3550, 6, 0) },

	-- Hero buildings (main street, Z=100)
	{ module = "Assets.Districts.BbqHoller.Buildings.SmokehouseSmokyJoes", position = Vector3.new(3500, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.RibShack",            position = Vector3.new(3560, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.PulledPorkPit",       position = Vector3.new(3620, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.BrisketBarn",         position = Vector3.new(3680, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.PitBossBBQTruck",     position = Vector3.new(3740, 0,  95), yaw = 15 },

	-- Backdrop buildings (back row, Z=175)
	{ module = "Assets.Districts.BbqHoller.Buildings.WeatheredFarmhouse", position = Vector3.new(3490, 0, 175), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.RustedShed",        position = Vector3.new(3550, 0, 175), yaw = -10 },
	{ module = "Assets.Districts.BbqHoller.Buildings.HayBarn",           position = Vector3.new(3620, 0, 185), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.LogCabin",          position = Vector3.new(3700, 0, 170), yaw = 8 },
	{ module = "Assets.Districts.BbqHoller.Buildings.WaterTower",        position = Vector3.new(3770, 0, 195), yaw = 0 },

	-- Landmarks (anchor points around the district)
	{ module = "Assets.Districts.BbqHoller.Landmarks.BarnLandmark",       position = Vector3.new(3450, 0, 160), yaw = 25 },
	{ module = "Assets.Districts.BbqHoller.Landmarks.GiantPigStatue",     position = Vector3.new(3600, 0,  70), yaw = -20 },
	{ module = "Assets.Districts.BbqHoller.Landmarks.SmokerChimneyTower", position = Vector3.new(3780, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Landmarks.HayBalePyramid",     position = Vector3.new(3470, 0, 120), yaw = 0 },

	-- Props (scattered around buildings)
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(3505, 0,  78), yaw = 10 },
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(3530, 0,  82), yaw = -20 },
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(3565, 0,  78), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(3595, 0,  82), yaw = 30 },
	{ module = "Assets.Districts.BbqHoller.Props.BBQGrill",     position = Vector3.new(3525, 0,  85), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.BBQGrill",     position = Vector3.new(3625, 0,  85), yaw = 20 },
	{ module = "Assets.Districts.BbqHoller.Props.BBQGrill",     position = Vector3.new(3725, 0,  88), yaw = -15 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(3490, 0,  55), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(3555, 0,  55), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(3650, 0,  55), yaw = 90 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(3720, 0,  55), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.WoodenCrate",  position = Vector3.new(3540, 0,  75), yaw = 25 },
	{ module = "Assets.Districts.BbqHoller.Props.BeerKeg",      position = Vector3.new(3575, 0,  90), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.CharcoalPile", position = Vector3.new(3510, 0,  68), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.AxeAndStump",  position = Vector3.new(3460, 0, 110), yaw = 35 },
	{ module = "Assets.Districts.BbqHoller.Props.RockingChair", position = Vector3.new(3680, 0,  80), yaw = 180 },
	{ module = "Assets.Districts.BbqHoller.Props.Lantern",      position = Vector3.new(3640, 0,  95), yaw = 0 },

	-- Decor (small flourishes)
	{ module = "Assets.Districts.BbqHoller.Decor.StringLight",          position = Vector3.new(3555, 0, 108), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.AmericanFlagBunting",  position = Vector3.new(3520, 0, 109), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.SunBleachedPennant",   position = Vector3.new(3640, 0, 109), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.WagonWheel",           position = Vector3.new(3450, 0,  70), yaw = 60 },
	{ module = "Assets.Districts.BbqHoller.Decor.RanchFence",           position = Vector3.new(3780, 0,  70), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.HayBaleStack",         position = Vector3.new(3760, 0, 110), yaw = 15 },
	{ module = "Assets.Districts.BbqHoller.Decor.DriedCornHusk",        position = Vector3.new(3690, 0,  68), yaw = 0 },

	-- Named NPCs (kept from V1)
	{ module = "Assets.Districts.BbqHoller.Npcs.BigEarl",    position = Vector3.new(3520, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.MamaHattie", position = Vector3.new(3540, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.TexDiggs",   position = Vector3.new(3560, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.SkinnyJoe",  position = Vector3.new(3580, 6, 30) },

	-- Pedestrian NPCs (V2 additions, scattered)
	{ module = "Assets.Districts.BbqHoller.Npcs.PitMasterApron",      position = Vector3.new(3470, 6,  50), yaw = 180 },
	{ module = "Assets.Districts.BbqHoller.Npcs.CowboyWithHat",       position = Vector3.new(3500, 6,  45), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Npcs.FarmgirlIcedTea",     position = Vector3.new(3600, 6,  45), yaw = 180 },
	{ module = "Assets.Districts.BbqHoller.Npcs.BBQJudge",            position = Vector3.new(3630, 6,  20), yaw = 90 },
	{ module = "Assets.Districts.BbqHoller.Npcs.KidEatingRibs",       position = Vector3.new(3450, 6,  50), yaw = 270 },
	{ module = "Assets.Districts.BbqHoller.Npcs.FarmerWithPitchfork", position = Vector3.new(3705, 6,  50), yaw = 200 },
	{ module = "Assets.Districts.BbqHoller.Npcs.GuitarPlayerPorch",   position = Vector3.new(3680, 6,  85), yaw = 180 },

	-- ============================================================
	-- MERCADO DEL SOL (base X = 3100) — Mexican Street genre
	-- ============================================================

	{ module = "Assets.Districts.MercadoDelSol.Foods.Taco",       position = Vector3.new(3110, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Burrito",    position = Vector3.new(3120, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Quesadilla", position = Vector3.new(3130, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Tamale",     position = Vector3.new(3140, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Elote",      position = Vector3.new(3150, 6, 0) },

	{ module = "Assets.Districts.MercadoDelSol.Buildings.TaqueriaStall",      position = Vector3.new(3100, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.MercadoCanopy",      position = Vector3.new(3150, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.SalsaCart",          position = Vector3.new(3200, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.CathedralArchEntry", position = Vector3.new(3080, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.PinataTower",        position = Vector3.new(3250, 0, 100), yaw = 0 },

	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonPepe",  position = Vector3.new(3120, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Lucia",    position = Vector3.new(3140, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Memo",     position = Vector3.new(3160, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonaRosa", position = Vector3.new(3180, 6, 30) },
}
