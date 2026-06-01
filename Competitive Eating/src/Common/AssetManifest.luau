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

	-- ============================================================
	-- DONUT DYNASTY V2 (base X = 2100) — Sweets/Pastries, fairy-tale
	-- Robloxy primitives. ~80 placements across hero buildings,
	-- backdrops, props, decor, landmarks, and pedestrian NPCs.
	-- ============================================================

	-- Hero buildings — main street row at Z = 100, spaced 50 studs
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.LeGlacePastry",       position = Vector3.new(2080, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.SweetheartDonuts",    position = Vector3.new(2130, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.BeignetBayou",        position = Vector3.new(2180, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.CinnamonSpiralRollCo",position = Vector3.new(2230, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.CocoaAndCake",        position = Vector3.new(2280, 0, 100), yaw = 0 },

	-- Backdrop buildings — further back, Z = 160-200
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.PinkTownhouses",       position = Vector3.new(2100, 0, 180), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.SugarCrustedApartments", position = Vector3.new(2200, 0, 200), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.GingerbreadStorefronts", position = Vector3.new(2270, 0, 180), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.CandyCaneLampRow",     position = Vector3.new(2180, 0,  75), yaw = 0 },

	-- Landmarks
	{ module = "Assets.Districts.DonutDynasty.V2.Landmarks.GiantDonutTower",      position = Vector3.new(2180, 0,  20), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Landmarks.CandyCaneArchway",     position = Vector3.new(2080, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Landmarks.SugarSpireCastle",     position = Vector3.new(2330, 0, 220), yaw = 0 },
	-- Keep v1 GlazeFountain (per spec) — reference v1 module at v2 position
	{ module = "Assets.Districts.DonutDynasty.Buildings.GlazeFountain",            position = Vector3.new(2150, 0,  45), yaw = 0 },

	-- Props: CandyCoatedBench (x4) — flanking sidewalks
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(2095, 2, 85),  yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(2155, 2, 85),  yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(2215, 2, 85),  yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(2275, 2, 85),  yaw = 0 },

	-- Props: LollipopSignpost (x6) — along sidewalk at regular intervals
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(2090, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(2130, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(2170, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(2210, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(2250, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(2290, 0, 75) },

	-- Props: SugarCubePlanter (x8) — bracketing the buildings
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2068, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2092, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2118, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2168, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2218, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2268, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2300, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(2180, 0,  35) },

	-- Other single-instance props
	{ module = "Assets.Districts.DonutDynasty.V2.Props.MarshmallowOttoman", position = Vector3.new(2140, 0, 80) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.MarshmallowOttoman", position = Vector3.new(2220, 0, 80) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.GumdropPebble",      position = Vector3.new(2105, 0, 82) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.GumdropPebble",      position = Vector3.new(2245, 0, 82) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.GumdropPebble",      position = Vector3.new(2185, 0, 50) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.HotChocolateStand",  position = Vector3.new(2110, 0, 60), yaw = 180 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.IceCreamPushcart",   position = Vector3.new(2250, 0, 60), yaw = 180 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.DonutDisplayRack",   position = Vector3.new(2130, 0, 85), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.DonutDisplayRack",   position = Vector3.new(2270, 0, 85), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CakeStandTable",     position = Vector3.new(2200, 0, 70), yaw = 0 },

	-- Decor: PinkBalloonBunch (x5)
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(2085, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(2135, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(2185, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(2235, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(2285, 0, 78) },

	-- Decor: other single placements
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.RibbonStreamer",    position = Vector3.new(2180, 0, 110), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.GumdropFence",      position = Vector3.new(2080, 0, 50), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.GumdropFence",      position = Vector3.new(2260, 0, 50), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.CottonCandyBush",   position = Vector3.new(2115, 0, 70) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.CottonCandyBush",   position = Vector3.new(2195, 0, 70) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.CottonCandyBush",   position = Vector3.new(2275, 0, 70) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.RainbowSprinklePath", position = Vector3.new(2120, 0, 45), yaw = 90 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.RainbowSprinklePath", position = Vector3.new(2240, 0, 45), yaw = 90 },

	-- Named NPCs (reuse v1 visuals at v2 positions)
	{ module = "Assets.Districts.DonutDynasty.Npcs.Marie",    position = Vector3.new(2120, 6, 40) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Bernard",  position = Vector3.new(2160, 6, 40) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Lulu",     position = Vector3.new(2200, 6, 40) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Stephane", position = Vector3.new(2240, 6, 40) },

	-- Pedestrian NPCs (V2-only)
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.PastryChef",         position = Vector3.new(2095, 6, 65) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.FairyGodmother",     position = Vector3.new(2150, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.DonutDeliveryKid",   position = Vector3.new(2180, 6, 65) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.KidCottonCandy",     position = Vector3.new(2215, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.WeddingPhotoCouple", position = Vector3.new(2265, 6, 25), yaw = 180 },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.BalletDancerKid",    position = Vector3.new(2245, 6, 65) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.BakerWithApron",     position = Vector3.new(2125, 6, 110) },
}
