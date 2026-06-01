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
	-- BURGER BOULEVARD V2 (base X = 2800) — 50s Americana / drive-in
	-- ============================================================
	-- Layout: buildings along Z=+100 ramp, foods Z=0 sample row, props Z=+60..+100 grid,
	-- decor Z=+80..+100 grid (raised Y=12), landmarks Z=+130, NPCs Z=+30 named + Z=+45 pedestrians.

	-- Foods (kept from v1)
	{ module = "Assets.Districts.BurgerBoulevard.Foods.Smashburger",          position = Vector3.new(2810, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.DoubleStack",          position = Vector3.new(2820, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.SliderCombo",          position = Vector3.new(2830, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.FriedChickenSandwich", position = Vector3.new(2840, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.Milkshake",            position = Vector3.new(2850, 6, 0) },

	-- Hero buildings (i=1..5 → x = 2800 + 50i along Z=100)
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.SmashvilleDriveIn", position = Vector3.new(2850, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.BigBeefDiner",      position = Vector3.new(2900, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.SliderStop",        position = Vector3.new(2950, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.ChickenwichExpress", position = Vector3.new(3000, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.CoolShakeMixer",    position = Vector3.new(3050, 0, 100), yaw = 0 },

	-- Backdrop buildings (i=6..10 → x = 2800 + 50i along Z=160, set back behind heroes)
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.DriveInMovieWall",  position = Vector3.new(3100, 0, 160), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.VintageGasStation", position = Vector3.new(2825, 0, 160), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.NeonMotel",         position = Vector3.new(2925, 0, 200), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.AutoGarage",        position = Vector3.new(3050, 0, 200), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.SuburbanHouses",    position = Vector3.new(2850, 0, 240), yaw = 0 },

	-- Landmarks (i=1..4 → x = 2800 + 25 + (i-1)*70 along Z=130)
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.GiantBurgerTower",  position = Vector3.new(2825, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.FiftiesNeonArch",   position = Vector3.new(2780, 0,  40), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.DriveInMarquee",    position = Vector3.new(3120, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.MilkshakeWaterTower", position = Vector3.new(3000, 0, 280), yaw = 0 },

	-- Props (mostly along curbs at Z=70..90, grid)
	{ module = "Assets.Districts.BurgerBoulevard.Props.VintageCadillacRed",   position = Vector3.new(2860, 1, 70), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.VintageCadillacTeal",  position = Vector3.new(2920, 1, 70), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.VintageCadillacCream", position = Vector3.new(2980, 1, 70), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Jukebox",              position = Vector3.new(2870, 1, 90), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Jukebox",              position = Vector3.new(3030, 1, 90), yaw = 180 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.DriveInSpeakers",      position = Vector3.new(2900, 1, 80), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.DriveInSpeakers",      position = Vector3.new(2960, 1, 80), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.RollerSkaterRack",     position = Vector3.new(2890, 1, 88), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.CondimentCaddy",       position = Vector3.new(2940, 4, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.FryerVat",             position = Vector3.new(3010, 1, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.MilkshakeMixer",       position = Vector3.new(3060, 1, 88), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(2855, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(2860, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(2865, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(3055, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(3060, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(3065, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.TrashCanChrome",       position = Vector3.new(2845, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.TrashCanChrome",       position = Vector3.new(2995, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.TrashCanChrome",       position = Vector3.new(3070, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(2855, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(2905, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(2955, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(3005, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Lamppost50s",          position = Vector3.new(2825, 0, 60), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Lamppost50s",          position = Vector3.new(2925, 0, 60), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Lamppost50s",          position = Vector3.new(3025, 0, 60), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.NewspaperBox",         position = Vector3.new(2880, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.PhoneBoothBubble",     position = Vector3.new(2980, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.PicnicBench",          position = Vector3.new(2870, 1, 78), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.PicnicBench",          position = Vector3.new(3020, 1, 78), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BicycleCruiser",       position = Vector3.new(2935, 1, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.CarhopTrayStand",      position = Vector3.new(2945, 0, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.CarhopTrayStand",      position = Vector3.new(3015, 0, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.IceCreamCart",         position = Vector3.new(2990, 1, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.SignpostArrows",       position = Vector3.new(2810, 0, 50), yaw = 0 },

	-- Decor (Y=12 mounted high on building facades, or low Y=2 for ground decor)
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(2855, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(2905, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(2955, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(3005, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.RedWhiteCheckeredBanner", position = Vector3.new(2860, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.RedWhiteCheckeredBanner", position = Vector3.new(3010, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.NeonArrowSign",         position = Vector3.new(2820, 0, 50), yaw = 90 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.NeonArrowSign",         position = Vector3.new(3080, 0, 50), yaw = -90 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.VinylRecordsHung",      position = Vector3.new(2870, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.VinylRecordsHung",      position = Vector3.new(3030, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.AmericanaFlagBunting",  position = Vector3.new(2880, 6, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.AmericanaFlagBunting",  position = Vector3.new(2960, 6, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.AmericanaFlagBunting",  position = Vector3.new(3040, 6, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PennantTriangleFlags",  position = Vector3.new(2880, 10, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PennantTriangleFlags",  position = Vector3.new(2940, 10, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PennantTriangleFlags",  position = Vector3.new(3000, 10, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StringLights",          position = Vector3.new(2890, 9, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StringLights",          position = Vector3.new(2970, 9, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StringLights",          position = Vector3.new(3050, 9, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StanchionRope",         position = Vector3.new(2855, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StanchionRope",         position = Vector3.new(3045, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(2860, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(2920, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(2980, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(3040, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StarBurstSign",         position = Vector3.new(2855, 18, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StarBurstSign",         position = Vector3.new(2945, 18, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StarBurstSign",         position = Vector3.new(3055, 18, 92), yaw = 0 },

	-- NPCs — named at Z=30, pedestrians at Z=45..50 ambient
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.SmashRiley",  position = Vector3.new(2820, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.PattyBonez",  position = Vector3.new(2840, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.SliderSteve", position = Vector3.new(2860, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.Cookie",      position = Vector3.new(2880, 6, 30) },
	-- Pedestrians (i=5..10)
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.RollerSkatingWaitress", position = Vector3.new(2900, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.GreaserWithComb",       position = Vector3.new(2920, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.JukeboxDancer",         position = Vector3.new(2940, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.BeatnikWithShake",      position = Vector3.new(2960, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.VarsityLetterman",      position = Vector3.new(2980, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.ClassicCarOwner",       position = Vector3.new(3000, 6, 45) },

	-- ============================================================
	-- BBQ HOLLER (base X = 2600) — American BBQ
	-- ============================================================

	{ module = "Assets.Districts.BbqHoller.Foods.Brisket",      position = Vector3.new(2610, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.PulledPork",   position = Vector3.new(2620, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.Ribs",         position = Vector3.new(2630, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.HotLink",      position = Vector3.new(2640, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.MacAndCheese", position = Vector3.new(2650, 6, 0) },

	{ module = "Assets.Districts.BbqHoller.Buildings.SmokehouseShack", position = Vector3.new(2600, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.PicnicPavilion",  position = Vector3.new(2650, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.ChuckwagonStand", position = Vector3.new(2700, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.BarnLandmark",    position = Vector3.new(2750, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.FirepitCircle",   position = Vector3.new(2580, 0,  60), yaw = 0 },

	{ module = "Assets.Districts.BbqHoller.Npcs.BigEarl",    position = Vector3.new(2620, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.MamaHattie", position = Vector3.new(2640, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.TexDiggs",   position = Vector3.new(2660, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.SkinnyJoe",  position = Vector3.new(2680, 6, 30) },

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
