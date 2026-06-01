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
}
