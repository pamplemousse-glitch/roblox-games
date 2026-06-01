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
	-- PIZZA PLAZA V2 (base X = 700) — Italian-American street neighborhood
	-- 10 buildings · 1 food · 24 props · 32 decor · 3 landmarks · 12 NPCs ≈ 82 entries
	-- ============================================================

	-- Foods (kept from v1, shifted into V2 base) ---------------------------
	{ module = "Assets.Districts.PizzaPlaza.Foods.PizzaSlice",                position = Vector3.new(710, 6,   0) },

	-- Buildings (10 modules along the main street at z=100) ---------------
	{ module = "Assets.Districts.PizzaPlaza.Buildings.TonysPizzeria",         position = Vector3.new(750, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.MammaCarmelasTrattoria",position = Vector3.new(800, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.VinnysSliceShop",       position = Vector3.new(850, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.RomeosGelatoStand",     position = Vector3.new(900, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.SalsCalzoneCart",       position = Vector3.new(950, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.TenementWalkup",        position = Vector3.new(1000, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.BrickAlleyWall",        position = Vector3.new(1050, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.LaundryLineBuildings",  position = Vector3.new(1100, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.BocceCourt",            position = Vector3.new(1150, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.RistoranteSignWall",    position = Vector3.new(1200, 0, 100), yaw = 0 },

	-- Props (24 entries on the sidewalk at z=60-80) ------------------------
	-- Row j=0 (z=60)
	{ module = "Assets.Districts.PizzaPlaza.Props.CheckeredUmbrellaTable",    position = Vector3.new(715, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.EspressoCart",              position = Vector3.new(730, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.MiniVespa",                 position = Vector3.new(745, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.WineBarrelStack",           position = Vector3.new(760, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.FruitMarketCrate",          position = Vector3.new(775, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.TrashCan",                  position = Vector3.new(790, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(805, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.StreetSign",                position = Vector3.new(820, 0, 60) },
	-- Row j=1 (z=70)
	{ module = "Assets.Districts.PizzaPlaza.Props.FoodCrates",                position = Vector3.new(715, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.BuskerAccordionStand",      position = Vector3.new(730, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.SandwichBoardChalkMenu",    position = Vector3.new(745, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PigeonPerches",             position = Vector3.new(760, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PlanterBox",                position = Vector3.new(775, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.NewspaperStand",            position = Vector3.new(790, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.BikeRack",                  position = Vector3.new(805, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(820, 0, 70) },
	-- Row j=2 (z=80) — repeats + remaining variants
	{ module = "Assets.Districts.PizzaPlaza.Props.WineRack",                  position = Vector3.new(715, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PizzaBoxStack",             position = Vector3.new(730, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PastaCart",                 position = Vector3.new(745, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.ChalkboardEasel",           position = Vector3.new(760, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.CoffeeUrn",                 position = Vector3.new(775, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PicnicBench",               position = Vector3.new(790, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(805, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(820, 0, 80) },

	-- Decor (32 small entries on the high shelf at y=12, z=80-90) ---------
	-- Flag bunting strung across at 5 positions
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(710, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(770, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(830, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(890, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(950, 12, 80) },
	-- Other decor modules, one entry each, laid along the strip
	{ module = "Assets.Districts.PizzaPlaza.Decor.OpenNeonSign",              position = Vector3.new(720, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.DryingPastaRack",           position = Vector3.new(740, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.LemonGarlandString",        position = Vector3.new(760, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CafeChairRow",              position = Vector3.new(780, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.VinePlanter",               position = Vector3.new(800, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CiaoMural",                 position = Vector3.new(820, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.WindowFlowerBox",           position = Vector3.new(840, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.AwningStripeBanner",        position = Vector3.new(860, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.PizzaBoxTower",             position = Vector3.new(880, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.RedCheckTableCloth",        position = Vector3.new(900, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.EspressoCupStack",          position = Vector3.new(920, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.WineGlassDisplay",          position = Vector3.new(940, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.OliveOilJugs",              position = Vector3.new(960, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.GarlicBraidString",         position = Vector3.new(980, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CheeseWheelDisplay",        position = Vector3.new(1000, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.BreadBasket",               position = Vector3.new(1020, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ChiantiBottleStack",        position = Vector3.new(1040, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.TomatoCrate",               position = Vector3.new(1060, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CafeUmbrellaSmall",         position = Vector3.new(1080, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.RedRoseVase",               position = Vector3.new(1100, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.NeonHeartSign",             position = Vector3.new(1120, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.SidewalkChalkArt",          position = Vector3.new(1140, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagPole",           position = Vector3.new(1160, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.WoodWineBarrel",            position = Vector3.new(1180, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.GrapevineHanger",           position = Vector3.new(1200, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.BasilPotRow",               position = Vector3.new(1220, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CherryTomatoPlant",         position = Vector3.new(1240, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ParmesanShakerSet",         position = Vector3.new(1260, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.PepperGrinderStack",        position = Vector3.new(1280, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CandleHolderRow",           position = Vector3.new(1300, 0, 90) },

	-- Landmarks (3 monumental anchors at z=130) ----------------------------
	{ module = "Assets.Districts.PizzaPlaza.Landmarks.BaroqueArchEntry",      position = Vector3.new(800, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Landmarks.TreviFountain",         position = Vector3.new(900, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Landmarks.GiantPizzaOven",        position = Vector3.new(1000, 0, 130), yaw = 0 },

	-- NPCs (12 pedestrians at z=30, 6 above ground) ------------------------
	-- Named storefront owners
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Tony",                       position = Vector3.new(720, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Vinny",                      position = Vector3.new(740, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Carmela",                    position = Vector3.new(760, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Sal",                        position = Vector3.new(780, 6, 30) },
	-- Pedestrians
	{ module = "Assets.Districts.PizzaPlaza.Npcs.OldManBenchReader",          position = Vector3.new(800, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.KidWithGelato",              position = Vector3.new(820, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.NonnaShoppingBag",           position = Vector3.new(840, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.AccordionBusker",            position = Vector3.new(860, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.FashionWoman",               position = Vector3.new(880, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.FashionMan",                 position = Vector3.new(900, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.StreetSweeper",              position = Vector3.new(920, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.DeliveryBoyOnBike",          position = Vector3.new(940, 6, 30) },

	-- ============================================================
	-- TOKYO TOWN V2 (base X = 1400) — Japanese Street genre
	-- ============================================================

	-- Foods (kept from v1, base shifted to 1400)
	{ module = "Assets.Districts.TokyoTown.Foods.RamenBowl",  position = Vector3.new(1410, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.GyozaTray",  position = Vector3.new(1420, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.Takoyaki",   position = Vector3.new(1430, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.SushiRoll",  position = Vector3.new(1440, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.Mochi",      position = Vector3.new(1450, 6, 0) },

	-- V2 Hero buildings (main street, z=100)
	{ module = "Assets.Districts.TokyoTown.Buildings.DaikonRamen",      position = Vector3.new(1400, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.SushiDaiko",       position = Vector3.new(1445, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.IzakayaLantern",   position = Vector3.new(1495, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.SakeBar",          position = Vector3.new(1525, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.TakoyakiCart",     position = Vector3.new(1560, 0, 105), yaw = 0 },

	-- V2 Backdrop buildings (further back, z=140-170)
	{ module = "Assets.Districts.TokyoTown.Buildings.CapsuleHotel",         position = Vector3.new(1395, 0, 170), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.VendingMachineWall",   position = Vector3.new(1465, 0, 145), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.NarrowAlleyShops",     position = Vector3.new(1510, 0, 155), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.SalarymanApartments",  position = Vector3.new(1560, 0, 175), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.LanternNoodleRow",     position = Vector3.new(1605, 0, 105), yaw = 0 },

	-- V2 Landmarks
	{ module = "Assets.Districts.TokyoTown.Landmarks.ShintoTorii",      position = Vector3.new(1375, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Landmarks.GiantManekiNeko",  position = Vector3.new(1455, 0,  45), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Landmarks.MiniPagodaTower",  position = Vector3.new(1625, 0, 150), yaw = 0 },

	-- V2 Named NPCs (kept from v1, shifted)
	{ module = "Assets.Districts.TokyoTown.Npcs.Kenji", position = Vector3.new(1420, 6, 30) },
	{ module = "Assets.Districts.TokyoTown.Npcs.Yumi",  position = Vector3.new(1440, 6, 30) },
	{ module = "Assets.Districts.TokyoTown.Npcs.Riku",  position = Vector3.new(1460, 6, 30) },
	{ module = "Assets.Districts.TokyoTown.Npcs.Akemi", position = Vector3.new(1480, 6, 30) },

	-- V2 Pedestrian NPCs (scattered, z=15-80)
	{ module = "Assets.Districts.TokyoTown.Npcs.SalarymanSuited",   position = Vector3.new(1410, 6, 25),  yaw =  20 },
	{ module = "Assets.Districts.TokyoTown.Npcs.SchoolgirlBento",   position = Vector3.new(1432, 6, 70),  yaw = -30 },
	{ module = "Assets.Districts.TokyoTown.Npcs.SushiChef",         position = Vector3.new(1450, 6, 80),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Npcs.RamenSlurper",      position = Vector3.new(1475, 6, 78),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Npcs.BowingShopkeeper",  position = Vector3.new(1500, 6, 80),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Npcs.CapsuleHotelGuest", position = Vector3.new(1395, 6, 130), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Npcs.BicycleSchoolgirl", position = Vector3.new(1540, 6, 50),  yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Npcs.PachinkoPlayer",    position = Vector3.new(1570, 6, 75),  yaw = 180 },

	-- V2 Props
	{ module = "Assets.Districts.TokyoTown.Props.RedPaperLanternString", position = Vector3.new(1415, 0, 50),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Props.RedPaperLanternString", position = Vector3.new(1500, 0, 50),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Props.RedPaperLanternString", position = Vector3.new(1585, 0, 50),  yaw = 0 },

	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1408, 0, 35),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1416, 0, 35),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1424, 0, 35),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1462, 0, 35),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1470, 0, 35),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1545, 0, 35),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1553, 0, 35),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1615, 0, 35),  yaw = 180 },

	{ module = "Assets.Districts.TokyoTown.Props.SakeBarrel",            position = Vector3.new(1488, 0, 70),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Props.PachinkoMachine",       position = Vector3.new(1572, 0, 80),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.BicycleRack",           position = Vector3.new(1432, 0, 25),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Props.ManholeCovers",         position = Vector3.new(1500, 0, 22),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Props.BroomAndDustpan",       position = Vector3.new(1525, 0, 80),  yaw = 90 },
	{ module = "Assets.Districts.TokyoTown.Props.KindergartenPullCart",  position = Vector3.new(1470, 0, 20),  yaw = 90 },
	{ module = "Assets.Districts.TokyoTown.Props.DarumaDoll",            position = Vector3.new(1430, 0, 65),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.OmikujiRack",           position = Vector3.new(1380, 0, 75),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Props.KoiPondStones",         position = Vector3.new(1630, 0, 90),  yaw = 0 },

	-- V2 Decor
	{ module = "Assets.Districts.TokyoTown.Decor.KatakanaNeon",          position = Vector3.new(1525, 6, 95),  yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Decor.CherryBlossomStrings",  position = Vector3.new(1465, 0, 55),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Decor.WashiPaperBanner",      position = Vector3.new(1400, 0, 40),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Decor.JapaneseFlagBunting",   position = Vector3.new(1500, 0, 60),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Decor.WhiteTileAlleyMarking", position = Vector3.new(1485, 0, 25),  yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Decor.SakuraPetalScatter",    position = Vector3.new(1440, 0, 55),  yaw = 0 },

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
