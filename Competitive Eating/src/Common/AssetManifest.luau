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
	{ module = "Assets.Districts.PizzaPlaza.Foods.PizzaSlice",                position = Vector3.new(-1090, 6,   0) },

	-- Buildings (10 modules along the main street at z=100) ---------------
	{ module = "Assets.Districts.PizzaPlaza.Buildings.TonysPizzeria",         position = Vector3.new(-1050, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.MammaCarmelasTrattoria",position = Vector3.new(-1000, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.VinnysSliceShop",       position = Vector3.new(-950, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.RomeosGelatoStand",     position = Vector3.new(-900, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.SalsCalzoneCart",       position = Vector3.new(-850, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.TenementWalkup",        position = Vector3.new(-800, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.BrickAlleyWall",        position = Vector3.new(-750, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.LaundryLineBuildings",  position = Vector3.new(-700, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.BocceCourt",            position = Vector3.new(-650, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Buildings.RistoranteSignWall",    position = Vector3.new(-600, 0, 100), yaw = 0 },

	-- Props (24 entries on the sidewalk at z=60-80) ------------------------
	-- Row j=0 (z=60)
	{ module = "Assets.Districts.PizzaPlaza.Props.CheckeredUmbrellaTable",    position = Vector3.new(-1085, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.EspressoCart",              position = Vector3.new(-1070, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.MiniVespa",                 position = Vector3.new(-1055, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.WineBarrelStack",           position = Vector3.new(-1040, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.FruitMarketCrate",          position = Vector3.new(-1025, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.TrashCan",                  position = Vector3.new(-1010, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(-995, 0, 60) },
	{ module = "Assets.Districts.PizzaPlaza.Props.StreetSign",                position = Vector3.new(-980, 0, 60) },
	-- Row j=1 (z=70)
	{ module = "Assets.Districts.PizzaPlaza.Props.FoodCrates",                position = Vector3.new(-1085, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.BuskerAccordionStand",      position = Vector3.new(-1070, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.SandwichBoardChalkMenu",    position = Vector3.new(-1055, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PigeonPerches",             position = Vector3.new(-1040, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PlanterBox",                position = Vector3.new(-1025, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.NewspaperStand",            position = Vector3.new(-1010, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.BikeRack",                  position = Vector3.new(-995, 0, 70) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(-980, 0, 70) },
	-- Row j=2 (z=80) — repeats + remaining variants
	{ module = "Assets.Districts.PizzaPlaza.Props.WineRack",                  position = Vector3.new(-1085, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PizzaBoxStack",             position = Vector3.new(-1070, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PastaCart",                 position = Vector3.new(-1055, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.ChalkboardEasel",           position = Vector3.new(-1040, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.CoffeeUrn",                 position = Vector3.new(-1025, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.PicnicBench",               position = Vector3.new(-1010, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(-995, 0, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Props.Lamppost",                  position = Vector3.new(-980, 0, 80) },

	-- Decor (32 small entries on the high shelf at y=12, z=80-90) ---------
	-- Flag bunting strung across at 5 positions
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(-1090, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(-1030, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(-970, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(-910, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagBunting",        position = Vector3.new(-850, 12, 80) },
	-- Other decor modules, one entry each, laid along the strip
	{ module = "Assets.Districts.PizzaPlaza.Decor.OpenNeonSign",              position = Vector3.new(-1080, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.DryingPastaRack",           position = Vector3.new(-1060, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.LemonGarlandString",        position = Vector3.new(-1040, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CafeChairRow",              position = Vector3.new(-1020, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.VinePlanter",               position = Vector3.new(-1000, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CiaoMural",                 position = Vector3.new(-980, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.WindowFlowerBox",           position = Vector3.new(-960, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.AwningStripeBanner",        position = Vector3.new(-940, 12, 80) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.PizzaBoxTower",             position = Vector3.new(-920, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.RedCheckTableCloth",        position = Vector3.new(-900, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.EspressoCupStack",          position = Vector3.new(-880, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.WineGlassDisplay",          position = Vector3.new(-860, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.OliveOilJugs",              position = Vector3.new(-840, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.GarlicBraidString",         position = Vector3.new(-820, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CheeseWheelDisplay",        position = Vector3.new(-800, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.BreadBasket",               position = Vector3.new(-780, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ChiantiBottleStack",        position = Vector3.new(-760, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.TomatoCrate",               position = Vector3.new(-740, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CafeUmbrellaSmall",         position = Vector3.new(-720, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.RedRoseVase",               position = Vector3.new(-700, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.NeonHeartSign",             position = Vector3.new(-680, 12, 85) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.SidewalkChalkArt",          position = Vector3.new(-660, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ItalianFlagPole",           position = Vector3.new(-640, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.WoodWineBarrel",            position = Vector3.new(-620, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.GrapevineHanger",           position = Vector3.new(-600, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.BasilPotRow",               position = Vector3.new(-580, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CherryTomatoPlant",         position = Vector3.new(-560, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.ParmesanShakerSet",         position = Vector3.new(-540, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.PepperGrinderStack",        position = Vector3.new(-520, 0, 90) },
	{ module = "Assets.Districts.PizzaPlaza.Decor.CandleHolderRow",           position = Vector3.new(-500, 0, 90) },

	-- Landmarks (3 monumental anchors at z=130) ----------------------------
	{ module = "Assets.Districts.PizzaPlaza.Landmarks.BaroqueArchEntry",      position = Vector3.new(-1000, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Landmarks.TreviFountain",         position = Vector3.new(-900, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.PizzaPlaza.Landmarks.GiantPizzaOven",        position = Vector3.new(-800, 0, 130), yaw = 0 },

	-- NPCs (12 pedestrians at z=30, 6 above ground) ------------------------
	-- Named storefront owners
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Tony",                       position = Vector3.new(-1080, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Vinny",                      position = Vector3.new(-1060, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Carmela",                    position = Vector3.new(-1040, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.Sal",                        position = Vector3.new(-1020, 6, 30) },
	-- Pedestrians
	{ module = "Assets.Districts.PizzaPlaza.Npcs.OldManBenchReader",          position = Vector3.new(-1000, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.KidWithGelato",              position = Vector3.new(-980, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.NonnaShoppingBag",           position = Vector3.new(-960, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.AccordionBusker",            position = Vector3.new(-940, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.FashionWoman",               position = Vector3.new(-920, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.FashionMan",                 position = Vector3.new(-900, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.StreetSweeper",              position = Vector3.new(-880, 6, 30) },
	{ module = "Assets.Districts.PizzaPlaza.Npcs.DeliveryBoyOnBike",          position = Vector3.new(-860, 6, 30) },

	-- ============================================================
	-- TOKYO TOWN V3 (Session D layout reorg)
	-- Footprint: X 785..1030, Z 55..150 (per Session D spec).
	-- Winding street + central plaza around the Maneki-neko + side alleys.
	-- ContestStage_T1 (X=72, Z=-221) and Pizza Plaza (X=-1100..-450) untouched.
	-- ============================================================

	-- Foods (kept from v1, food row away from district at z=0)
	{ module = "Assets.Districts.TokyoTown.Foods.RamenBowl",  position = Vector3.new(810, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.GyozaTray",  position = Vector3.new(820, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.Takoyaki",   position = Vector3.new(830, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.SushiRoll",  position = Vector3.new(840, 6, 0) },
	{ module = "Assets.Districts.TokyoTown.Foods.Mochi",      position = Vector3.new(850, 6, 0) },

	-- ─── Winding hero street ────────────────────────────────────────────
	-- DaikonRamen → SushiDaiko → IzakayaLantern, staggered in Z and canted
	-- so the row reads as a winding alley rather than a straight strip.
	-- TakoyakiCart and SakeBar tucked into side alleys, bad faces away.
	{ module = "Assets.Districts.TokyoTown.Buildings.DaikonRamen",     position = Vector3.new(800, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.SushiDaiko",      position = Vector3.new(845, 0, 100), yaw =   0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.IzakayaLantern",  position = Vector3.new(895, 0, 100), yaw =  0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.SakeBar",         position = Vector3.new(948, 0, 132), yaw = -30 },  -- north-east alley
	{ module = "Assets.Districts.TokyoTown.Buildings.TakoyakiCart",    position = Vector3.new(960, 0, 100), yaw = 0 },  -- south alley vendor

	-- ─── Backdrop row (Z=140..150, masks the back of the heroes) ───────
	{ module = "Assets.Districts.TokyoTown.Buildings.CapsuleHotel",        position = Vector3.new(815, 0, 148), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.VendingMachineWall",  position = Vector3.new(872, 0, 145), yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Buildings.NarrowAlleyShops",    position = Vector3.new(920, 0, 150), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.SalarymanApartments", position = Vector3.new(985, 0, 145), yaw = 0 },
	{ module = "Assets.Districts.TokyoTown.Buildings.LanternNoodleRow",    position = Vector3.new(998, 0, 122), yaw =  10 },

	-- ─── Landmarks ─────────────────────────────────────────────────────
	-- Torii is the WEST entry gate; Maneki-neko anchors the PLAZA at Z=85;
	-- Pagoda is the EAST landmark visible down the winding street.
	{ module = "Assets.Districts.TokyoTown.Landmarks.ShintoTorii",     position = Vector3.new(790, 0,  82), yaw = 90 },
	{ module = "Assets.Districts.TokyoTown.Landmarks.GiantManekiNeko", position = Vector3.new(875, 0,  85), yaw =  0 },
	{ module = "Assets.Districts.TokyoTown.Landmarks.MiniPagodaTower", position = Vector3.new(1018, 0,  95), yaw =  0 },

	-- ─── NPCs ──────────────────────────────────────────────────────────
	-- Named locals: 4 along the winding street (Z 95..115)
	{ module = "Assets.Districts.TokyoTown.Npcs.Akemi", position = Vector3.new(820, 6, 95),  yaw = -90 },
	{ module = "Assets.Districts.TokyoTown.Npcs.Kenji", position = Vector3.new(852, 6, 108), yaw = -45 },
	{ module = "Assets.Districts.TokyoTown.Npcs.Yumi",  position = Vector3.new(895, 6, 102), yaw =  45 },
	{ module = "Assets.Districts.TokyoTown.Npcs.Riku",  position = Vector3.new(970, 6, 105), yaw = 180 },
	-- Plaza ambient: 4 facing the Maneki-neko
	{ module = "Assets.Districts.TokyoTown.Npcs.SushiChef",        position = Vector3.new(855, 6, 75), yaw =  20 },
	{ module = "Assets.Districts.TokyoTown.Npcs.RamenSlurper",     position = Vector3.new(885, 6, 78), yaw =  -25 },
	{ module = "Assets.Districts.TokyoTown.Npcs.SchoolgirlBento",  position = Vector3.new(872, 6, 95), yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Npcs.BowingShopkeeper", position = Vector3.new(895, 6, 92), yaw = -90 },
	-- Side-alley figures
	{ module = "Assets.Districts.TokyoTown.Npcs.SalarymanSuited", position = Vector3.new(945, 6, 118), yaw = -50 },
	{ module = "Assets.Districts.TokyoTown.Npcs.PachinkoPlayer",  position = Vector3.new(948, 6, 138), yaw = 180 },
	-- Hotel guest + east-side cyclist
	{ module = "Assets.Districts.TokyoTown.Npcs.CapsuleHotelGuest", position = Vector3.new(820, 6, 138), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Npcs.BicycleSchoolgirl", position = Vector3.new(1000, 6,  78), yaw =  90 },

	-- ─── Props ─────────────────────────────────────────────────────────
	{ module = "Assets.Districts.TokyoTown.Props.DaikonRamenSignboard", position = Vector3.new(815, 4, 113), yaw = 0 },

	-- Real kanji signs in front of each Cube 3D shop (Session D 7c)
	{ module = "Assets.Districts.TokyoTown.Props.KanjiSign_Ramen",    position = Vector3.new(815, 0,  96), yaw = -12 },
	{ module = "Assets.Districts.TokyoTown.Props.KanjiSign_Daikon",   position = Vector3.new(823, 0,  93), yaw = -12 },
	{ module = "Assets.Districts.TokyoTown.Props.KanjiSign_Sushi",    position = Vector3.new(852, 0, 110), yaw =   4 },
	{ module = "Assets.Districts.TokyoTown.Props.KanjiSign_Izakaya",  position = Vector3.new(895, 0, 104), yaw =  18 },
	{ module = "Assets.Districts.TokyoTown.Props.KanjiSign_Takoyaki", position = Vector3.new(872, 0,  72), yaw = 180 },

	-- Back-alley decor clusters behind each Cube 3D building (Session D 7b)
	{ module = "Assets.Districts.TokyoTown.Decor.BackAlleyCluster", position = Vector3.new(815, 0, 122), yaw = -12 + 180 },
	{ module = "Assets.Districts.TokyoTown.Decor.BackAlleyCluster", position = Vector3.new(852, 0, 138), yaw =   4 + 180 },
	{ module = "Assets.Districts.TokyoTown.Decor.BackAlleyCluster", position = Vector3.new(895, 0, 130), yaw =  18 + 180 },
	{ module = "Assets.Districts.TokyoTown.Decor.BackAlleyCluster", position = Vector3.new(948, 0, 118), yaw = -30 + 180 },
	{ module = "Assets.Districts.TokyoTown.Decor.BackAlleyCluster", position = Vector3.new(872, 0,  55), yaw =   0 },  -- TakoyakiCart "back" is south

	-- Lantern strings spaced along the winding street
	{ module = "Assets.Districts.TokyoTown.Props.RedPaperLanternString", position = Vector3.new(820, 0,  88), yaw = -12 },
	{ module = "Assets.Districts.TokyoTown.Props.RedPaperLanternString", position = Vector3.new(870, 0,  90), yaw =   0 },
	{ module = "Assets.Districts.TokyoTown.Props.RedPaperLanternString", position = Vector3.new(940, 0,  95), yaw =  18 },

	-- Vending machine clusters in side alleys (away from main walking line)
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(940, 0, 105), yaw = -90 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(940, 0, 110), yaw = -90 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(940, 0, 115), yaw = -90 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(805, 0,  70), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(805, 0,  75), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(805, 0,  80), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1010, 0, 110), yaw = -90 },
	{ module = "Assets.Districts.TokyoTown.Props.VendingMachineSingle", position = Vector3.new(1010, 0, 115), yaw = -90 },

	-- Plaza & street props
	{ module = "Assets.Districts.TokyoTown.Props.SakeBarrel",           position = Vector3.new(932, 0, 122), yaw = -30 },
	{ module = "Assets.Districts.TokyoTown.Props.PachinkoMachine",      position = Vector3.new(950, 0, 142), yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.BicycleRack",          position = Vector3.new(800, 0,  92), yaw =   0 },
	{ module = "Assets.Districts.TokyoTown.Props.ManholeCovers",        position = Vector3.new(870, 0,  88), yaw =   0 },  -- in plaza
	{ module = "Assets.Districts.TokyoTown.Props.BroomAndDustpan",      position = Vector3.new(900, 0,  88), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Props.KindergartenPullCart", position = Vector3.new(880, 0,  62), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Props.DarumaDoll",           position = Vector3.new(862, 0,  88), yaw = 180 },
	{ module = "Assets.Districts.TokyoTown.Props.OmikujiRack",          position = Vector3.new(792, 0,  88), yaw =  90 },  -- at torii
	{ module = "Assets.Districts.TokyoTown.Props.KoiPondStones",        position = Vector3.new(880, 0,  78), yaw =   0 },  -- plaza pond

	-- Decor
	{ module = "Assets.Districts.TokyoTown.Decor.KatakanaNeon",          position = Vector3.new(895, 6, 105), yaw =  18 },
	{ module = "Assets.Districts.TokyoTown.Decor.CherryBlossomStrings",  position = Vector3.new(870, 0,  72), yaw =   0 },
	{ module = "Assets.Districts.TokyoTown.Decor.WashiPaperBanner",      position = Vector3.new(792, 0,  76), yaw =  90 },
	{ module = "Assets.Districts.TokyoTown.Decor.JapaneseFlagBunting",   position = Vector3.new(870, 0,  82), yaw =   0 },
	{ module = "Assets.Districts.TokyoTown.Decor.WhiteTileAlleyMarking", position = Vector3.new(880, 0,  88), yaw =   0 },
	{ module = "Assets.Districts.TokyoTown.Decor.SakuraPetalScatter",    position = Vector3.new(875, 0,  85), yaw =   0 },

	-- ============================================================
	-- DONUT DYNASTY (base X = 1600) — Sweets / Pastries genre
	-- ============================================================

	{ module = "Assets.Districts.DonutDynasty.Foods.Donut",        position = Vector3.new(710, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.Eclair",       position = Vector3.new(720, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.Churro",       position = Vector3.new(730, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.Beignet",      position = Vector3.new(740, 6, 0) },
	{ module = "Assets.Districts.DonutDynasty.Foods.CinnamonRoll", position = Vector3.new(750, 6, 0) },

	{ module = "Assets.Districts.DonutDynasty.Buildings.DonutShop",        position = Vector3.new(700, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.GlazeFountain",    position = Vector3.new(750, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.CoffeeKiosk",      position = Vector3.new(800, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.BakeryArchEntry",  position = Vector3.new(680, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.Buildings.SugarSiloTower",   position = Vector3.new(850, 0, 100), yaw = 0 },

	{ module = "Assets.Districts.DonutDynasty.Npcs.Marie",    position = Vector3.new(720, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Bernard",  position = Vector3.new(740, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Lulu",     position = Vector3.new(760, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Stephane", position = Vector3.new(780, 6, 30) },

	-- ============================================================
	-- BURGER BOULEVARD V2 (base X = 2800) — 50s Americana / drive-in
	-- ============================================================
	-- Layout: buildings along Z=+100 ramp, foods Z=0 sample row, props Z=+60..+100 grid,
	-- decor Z=+80..+100 grid (raised Y=12), landmarks Z=+130, NPCs Z=+30 named + Z=+45 pedestrians.

	-- Foods (kept from v1)
	{ module = "Assets.Districts.BurgerBoulevard.Foods.Smashburger",          position = Vector3.new(1610, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.DoubleStack",          position = Vector3.new(1620, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.SliderCombo",          position = Vector3.new(1630, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.FriedChickenSandwich", position = Vector3.new(1640, 6, 0) },
	{ module = "Assets.Districts.BurgerBoulevard.Foods.Milkshake",            position = Vector3.new(1650, 6, 0) },

	-- Hero buildings (i=1..5 → x = 2800 + 50i along Z=100)
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.SmashvilleDriveIn", position = Vector3.new(1650, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.BigBeefDiner",      position = Vector3.new(1700, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.SliderStop",        position = Vector3.new(1750, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.ChickenwichExpress", position = Vector3.new(1800, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.CoolShakeMixer",    position = Vector3.new(1850, 0, 100), yaw = 0 },

	-- Backdrop buildings (i=6..10 → x = 2800 + 50i along Z=160, set back behind heroes)
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.DriveInMovieWall",  position = Vector3.new(1900, 0, 160), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.VintageGasStation", position = Vector3.new(1625, 0, 160), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.NeonMotel",         position = Vector3.new(1725, 0, 200), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.AutoGarage",        position = Vector3.new(1850, 0, 200), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Buildings.SuburbanHouses",    position = Vector3.new(1650, 0, 240), yaw = 0 },

	-- Landmarks (i=1..4 → x = 2800 + 25 + (i-1)*70 along Z=130)
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.GiantBurgerTower",  position = Vector3.new(1625, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.FiftiesNeonArch",   position = Vector3.new(1580, 0,  40), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.DriveInMarquee",    position = Vector3.new(1920, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Landmarks.MilkshakeWaterTower", position = Vector3.new(1800, 0, 280), yaw = 0 },

	-- Props (mostly along curbs at Z=70..90, grid)
	{ module = "Assets.Districts.BurgerBoulevard.Props.VintageCadillacRed",   position = Vector3.new(1660, 1, 70), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.VintageCadillacTeal",  position = Vector3.new(1720, 1, 70), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.VintageCadillacCream", position = Vector3.new(1780, 1, 70), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Jukebox",              position = Vector3.new(1670, 1, 90), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Jukebox",              position = Vector3.new(1830, 1, 90), yaw = 180 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.DriveInSpeakers",      position = Vector3.new(1700, 1, 80), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.DriveInSpeakers",      position = Vector3.new(1760, 1, 80), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.RollerSkaterRack",     position = Vector3.new(1690, 1, 88), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.CondimentCaddy",       position = Vector3.new(1740, 4, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.FryerVat",             position = Vector3.new(1810, 1, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.MilkshakeMixer",       position = Vector3.new(1860, 1, 88), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(1655, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(1660, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(1665, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(1855, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(1860, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BarStool",             position = Vector3.new(1865, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.TrashCanChrome",       position = Vector3.new(1645, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.TrashCanChrome",       position = Vector3.new(1795, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.TrashCanChrome",       position = Vector3.new(1870, 1, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(1655, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(1705, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(1755, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.ParkingMeter",         position = Vector3.new(1805, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Lamppost50s",          position = Vector3.new(1625, 0, 60), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Lamppost50s",          position = Vector3.new(1725, 0, 60), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.Lamppost50s",          position = Vector3.new(1825, 0, 60), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.NewspaperBox",         position = Vector3.new(1680, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.PhoneBoothBubble",     position = Vector3.new(1780, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.PicnicBench",          position = Vector3.new(1670, 1, 78), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.PicnicBench",          position = Vector3.new(1820, 1, 78), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.BicycleCruiser",       position = Vector3.new(1735, 1, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.CarhopTrayStand",      position = Vector3.new(1745, 0, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.CarhopTrayStand",      position = Vector3.new(1815, 0, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.IceCreamCart",         position = Vector3.new(1790, 1, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Props.SignpostArrows",       position = Vector3.new(1610, 0, 50), yaw = 0 },

	-- Decor (Y=12 mounted high on building facades, or low Y=2 for ground decor)
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(1655, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(1705, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(1755, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.ChromeTrimStrip",       position = Vector3.new(1805, 12, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.RedWhiteCheckeredBanner", position = Vector3.new(1660, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.RedWhiteCheckeredBanner", position = Vector3.new(1810, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.NeonArrowSign",         position = Vector3.new(1620, 0, 50), yaw = 90 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.NeonArrowSign",         position = Vector3.new(1880, 0, 50), yaw = -90 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.VinylRecordsHung",      position = Vector3.new(1670, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.VinylRecordsHung",      position = Vector3.new(1830, 8, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.AmericanaFlagBunting",  position = Vector3.new(1680, 6, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.AmericanaFlagBunting",  position = Vector3.new(1760, 6, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.AmericanaFlagBunting",  position = Vector3.new(1840, 6, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PennantTriangleFlags",  position = Vector3.new(1680, 10, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PennantTriangleFlags",  position = Vector3.new(1740, 10, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PennantTriangleFlags",  position = Vector3.new(1800, 10, 75), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StringLights",          position = Vector3.new(1690, 9, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StringLights",          position = Vector3.new(1770, 9, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StringLights",          position = Vector3.new(1850, 9, 85), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StanchionRope",         position = Vector3.new(1655, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StanchionRope",         position = Vector3.new(1845, 0, 65), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(1660, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(1720, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(1780, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.PaintedCurbStripes",    position = Vector3.new(1840, 0, 55), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StarBurstSign",         position = Vector3.new(1655, 18, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StarBurstSign",         position = Vector3.new(1745, 18, 92), yaw = 0 },
	{ module = "Assets.Districts.BurgerBoulevard.Decor.StarBurstSign",         position = Vector3.new(1855, 18, 92), yaw = 0 },

	-- NPCs — named at Z=30, pedestrians at Z=45..50 ambient
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.SmashRiley",  position = Vector3.new(1620, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.PattyBonez",  position = Vector3.new(1640, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.SliderSteve", position = Vector3.new(1660, 6, 30) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.Cookie",      position = Vector3.new(1680, 6, 30) },
	-- Pedestrians (i=5..10)
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.RollerSkatingWaitress", position = Vector3.new(1700, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.GreaserWithComb",       position = Vector3.new(1720, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.JukeboxDancer",         position = Vector3.new(1740, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.BeatnikWithShake",      position = Vector3.new(1760, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.VarsityLetterman",      position = Vector3.new(1780, 6, 45) },
	{ module = "Assets.Districts.BurgerBoulevard.Npcs.ClassicCarOwner",       position = Vector3.new(1800, 6, 45) },

	-- ============================================================
	-- BBQ HOLLER V2 (base X = 3500) — American BBQ / rural smokehouse
	-- ============================================================

	-- Foods (kept from V1)
	{ module = "Assets.Districts.BbqHoller.Foods.Brisket",      position = Vector3.new(2010, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.PulledPork",   position = Vector3.new(2020, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.Ribs",         position = Vector3.new(2030, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.HotLink",      position = Vector3.new(2040, 6, 0) },
	{ module = "Assets.Districts.BbqHoller.Foods.MacAndCheese", position = Vector3.new(2050, 6, 0) },

	-- Hero buildings (main street, Z=100)
	{ module = "Assets.Districts.BbqHoller.Buildings.SmokehouseSmokyJoes", position = Vector3.new(2000, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.RibShack",            position = Vector3.new(2060, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.PulledPorkPit",       position = Vector3.new(2120, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.BrisketBarn",         position = Vector3.new(2180, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.PitBossBBQTruck",     position = Vector3.new(2240, 0,  95), yaw = 15 },

	-- Backdrop buildings (back row, Z=175)
	{ module = "Assets.Districts.BbqHoller.Buildings.WeatheredFarmhouse", position = Vector3.new(1990, 0, 175), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.RustedShed",        position = Vector3.new(2050, 0, 175), yaw = -10 },
	{ module = "Assets.Districts.BbqHoller.Buildings.HayBarn",           position = Vector3.new(2120, 0, 185), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Buildings.LogCabin",          position = Vector3.new(2200, 0, 170), yaw = 8 },
	{ module = "Assets.Districts.BbqHoller.Buildings.WaterTower",        position = Vector3.new(2270, 0, 195), yaw = 0 },

	-- Landmarks (anchor points around the district)
	{ module = "Assets.Districts.BbqHoller.Landmarks.BarnLandmark",       position = Vector3.new(1950, 0, 160), yaw = 25 },
	{ module = "Assets.Districts.BbqHoller.Landmarks.GiantPigStatue",     position = Vector3.new(2100, 0,  70), yaw = -20 },
	{ module = "Assets.Districts.BbqHoller.Landmarks.SmokerChimneyTower", position = Vector3.new(2280, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Landmarks.HayBalePyramid",     position = Vector3.new(1970, 0, 120), yaw = 0 },

	-- Props (scattered around buildings)
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(2005, 0,  78), yaw = 10 },
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(2030, 0,  82), yaw = -20 },
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(2065, 0,  78), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.SmokerBarrel", position = Vector3.new(2095, 0,  82), yaw = 30 },
	{ module = "Assets.Districts.BbqHoller.Props.BBQGrill",     position = Vector3.new(2025, 0,  85), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.BBQGrill",     position = Vector3.new(2125, 0,  85), yaw = 20 },
	{ module = "Assets.Districts.BbqHoller.Props.BBQGrill",     position = Vector3.new(2225, 0,  88), yaw = -15 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(1990, 0,  55), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(2055, 0,  55), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(2150, 0,  55), yaw = 90 },
	{ module = "Assets.Districts.BbqHoller.Props.PicnicTable",  position = Vector3.new(2220, 0,  55), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.WoodenCrate",  position = Vector3.new(2040, 0,  75), yaw = 25 },
	{ module = "Assets.Districts.BbqHoller.Props.BeerKeg",      position = Vector3.new(2075, 0,  90), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.CharcoalPile", position = Vector3.new(2010, 0,  68), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Props.AxeAndStump",  position = Vector3.new(1960, 0, 110), yaw = 35 },
	{ module = "Assets.Districts.BbqHoller.Props.RockingChair", position = Vector3.new(2180, 0,  80), yaw = 180 },
	{ module = "Assets.Districts.BbqHoller.Props.Lantern",      position = Vector3.new(2140, 0,  95), yaw = 0 },

	-- Decor (small flourishes)
	{ module = "Assets.Districts.BbqHoller.Decor.StringLight",          position = Vector3.new(2055, 0, 108), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.AmericanFlagBunting",  position = Vector3.new(2020, 0, 109), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.SunBleachedPennant",   position = Vector3.new(2140, 0, 109), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.WagonWheel",           position = Vector3.new(1950, 0,  70), yaw = 60 },
	{ module = "Assets.Districts.BbqHoller.Decor.RanchFence",           position = Vector3.new(2280, 0,  70), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Decor.HayBaleStack",         position = Vector3.new(2260, 0, 110), yaw = 15 },
	{ module = "Assets.Districts.BbqHoller.Decor.DriedCornHusk",        position = Vector3.new(2190, 0,  68), yaw = 0 },

	-- Named NPCs (kept from V1)
	{ module = "Assets.Districts.BbqHoller.Npcs.BigEarl",    position = Vector3.new(2020, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.MamaHattie", position = Vector3.new(2040, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.TexDiggs",   position = Vector3.new(2060, 6, 30) },
	{ module = "Assets.Districts.BbqHoller.Npcs.SkinnyJoe",  position = Vector3.new(2080, 6, 30) },

	-- Pedestrian NPCs (V2 additions, scattered)
	{ module = "Assets.Districts.BbqHoller.Npcs.PitMasterApron",      position = Vector3.new(1970, 6,  50), yaw = 180 },
	{ module = "Assets.Districts.BbqHoller.Npcs.CowboyWithHat",       position = Vector3.new(2000, 6,  45), yaw = 0 },
	{ module = "Assets.Districts.BbqHoller.Npcs.FarmgirlIcedTea",     position = Vector3.new(2100, 6,  45), yaw = 180 },
	{ module = "Assets.Districts.BbqHoller.Npcs.BBQJudge",            position = Vector3.new(2130, 6,  20), yaw = 90 },
	{ module = "Assets.Districts.BbqHoller.Npcs.KidEatingRibs",       position = Vector3.new(1950, 6,  50), yaw = 270 },
	{ module = "Assets.Districts.BbqHoller.Npcs.FarmerWithPitchfork", position = Vector3.new(2205, 6,  50), yaw = 200 },
	{ module = "Assets.Districts.BbqHoller.Npcs.GuitarPlayerPorch",   position = Vector3.new(2180, 6,  85), yaw = 180 },

	-- ============================================================
	-- MERCADO DEL SOL (base X = 3100) — Mexican Street genre
	-- ============================================================

	{ module = "Assets.Districts.MercadoDelSol.Foods.Taco",       position = Vector3.new(1310, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Burrito",    position = Vector3.new(1320, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Quesadilla", position = Vector3.new(1330, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Tamale",     position = Vector3.new(1340, 6, 0) },
	{ module = "Assets.Districts.MercadoDelSol.Foods.Elote",      position = Vector3.new(1350, 6, 0) },

	{ module = "Assets.Districts.MercadoDelSol.Buildings.TaqueriaStall",      position = Vector3.new(1300, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.MercadoCanopy",      position = Vector3.new(1350, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.SalsaCart",          position = Vector3.new(1400, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.CathedralArchEntry", position = Vector3.new(1280, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.PinataTower",        position = Vector3.new(1450, 0, 100), yaw = 0 },

	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonPepe",  position = Vector3.new(1320, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Lucia",    position = Vector3.new(1340, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Memo",     position = Vector3.new(1360, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonaRosa", position = Vector3.new(1380, 6, 30) },

	-- ============================================================
	-- DONUT DYNASTY V2 (base X = 2100) — Sweets/Pastries, fairy-tale
	-- Robloxy primitives. ~80 placements across hero buildings,
	-- backdrops, props, decor, landmarks, and pedestrian NPCs.
	-- ============================================================

	-- Hero buildings — main street row at Z = 100, spaced 50 studs
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.LeGlacePastry",       position = Vector3.new(1180, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.SweetheartDonuts",    position = Vector3.new(1230, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.BeignetBayou",        position = Vector3.new(1280, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.CinnamonSpiralRollCo",position = Vector3.new(1330, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.CocoaAndCake",        position = Vector3.new(1380, 0, 100), yaw = 0 },

	-- Backdrop buildings — further back, Z = 160-200
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.PinkTownhouses",       position = Vector3.new(1200, 0, 180), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.SugarCrustedApartments", position = Vector3.new(1300, 0, 200), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.GingerbreadStorefronts", position = Vector3.new(1370, 0, 180), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Buildings.CandyCaneLampRow",     position = Vector3.new(1280, 0,  75), yaw = 0 },

	-- Landmarks
	{ module = "Assets.Districts.DonutDynasty.V2.Landmarks.GiantDonutTower",      position = Vector3.new(1280, 0,  20), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Landmarks.CandyCaneArchway",     position = Vector3.new(1180, 0,  60), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Landmarks.SugarSpireCastle",     position = Vector3.new(1430, 0, 220), yaw = 0 },
	-- Keep v1 GlazeFountain (per spec) — reference v1 module at v2 position
	{ module = "Assets.Districts.DonutDynasty.Buildings.GlazeFountain",            position = Vector3.new(1250, 0,  45), yaw = 0 },

	-- Props: CandyCoatedBench (x4) — flanking sidewalks
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(1195, 2, 85),  yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(1255, 2, 85),  yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(1315, 2, 85),  yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CandyCoatedBench", position = Vector3.new(1375, 2, 85),  yaw = 0 },

	-- Props: LollipopSignpost (x6) — along sidewalk at regular intervals
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(1190, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(1230, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(1270, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(1310, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(1350, 0, 75) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.LollipopSignpost", position = Vector3.new(1390, 0, 75) },

	-- Props: SugarCubePlanter (x8) — bracketing the buildings
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1168, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1192, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1218, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1268, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1318, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1368, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1400, 0, 90) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.SugarCubePlanter", position = Vector3.new(1280, 0,  35) },

	-- Other single-instance props
	{ module = "Assets.Districts.DonutDynasty.V2.Props.MarshmallowOttoman", position = Vector3.new(1240, 0, 80) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.MarshmallowOttoman", position = Vector3.new(1320, 0, 80) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.GumdropPebble",      position = Vector3.new(1205, 0, 82) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.GumdropPebble",      position = Vector3.new(1345, 0, 82) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.GumdropPebble",      position = Vector3.new(1285, 0, 50) },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.HotChocolateStand",  position = Vector3.new(1210, 0, 60), yaw = 180 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.IceCreamPushcart",   position = Vector3.new(1350, 0, 60), yaw = 180 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.DonutDisplayRack",   position = Vector3.new(1230, 0, 85), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.DonutDisplayRack",   position = Vector3.new(1370, 0, 85), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Props.CakeStandTable",     position = Vector3.new(1300, 0, 70), yaw = 0 },

	-- Decor: PinkBalloonBunch (x5)
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(1185, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(1235, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(1285, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(1335, 0, 78) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.PinkBalloonBunch", position = Vector3.new(1385, 0, 78) },

	-- Decor: other single placements
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.RibbonStreamer",    position = Vector3.new(1280, 0, 110), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.GumdropFence",      position = Vector3.new(1180, 0, 50), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.GumdropFence",      position = Vector3.new(1360, 0, 50), yaw = 0 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.CottonCandyBush",   position = Vector3.new(1215, 0, 70) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.CottonCandyBush",   position = Vector3.new(1295, 0, 70) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.CottonCandyBush",   position = Vector3.new(1375, 0, 70) },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.RainbowSprinklePath", position = Vector3.new(1220, 0, 45), yaw = 90 },
	{ module = "Assets.Districts.DonutDynasty.V2.Decor.RainbowSprinklePath", position = Vector3.new(1340, 0, 45), yaw = 90 },

	-- Named NPCs (reuse v1 visuals at v2 positions)
	{ module = "Assets.Districts.DonutDynasty.Npcs.Marie",    position = Vector3.new(1220, 6, 40) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Bernard",  position = Vector3.new(1260, 6, 40) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Lulu",     position = Vector3.new(1300, 6, 40) },
	{ module = "Assets.Districts.DonutDynasty.Npcs.Stephane", position = Vector3.new(1340, 6, 40) },

	-- Pedestrian NPCs (V2-only)
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.PastryChef",         position = Vector3.new(1195, 6, 65) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.FairyGodmother",     position = Vector3.new(1250, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.DonutDeliveryKid",   position = Vector3.new(1280, 6, 65) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.KidCottonCandy",     position = Vector3.new(1315, 6, 30) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.WeddingPhotoCouple", position = Vector3.new(1365, 6, 25), yaw = 180 },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.BalletDancerKid",    position = Vector3.new(1345, 6, 65) },
	{ module = "Assets.Districts.DonutDynasty.V2.Npcs.BakerWithApron",     position = Vector3.new(1225, 6, 110) },

	-- ============================================================
	-- MERCADO DEL SOL — V2 EXPANSION (base X = 4200)
	-- Real-neighborhood density: 10 buildings, 22 props, 30 decor,
	-- 4 landmarks, 11 NPCs = 77 placements for a walkable street feel.
	-- ============================================================

	-- ── V2 Buildings (4200 + 50*i, 0, 100) ──
	{ module = "Assets.Districts.MercadoDelSol.Buildings.TaqueriaElSol",        position = Vector3.new(2450, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.BurritoCasa",          position = Vector3.new(2500, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.QuesadillaStand",      position = Vector3.new(2550, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.TamaleTia",            position = Vector3.new(2600, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.EloteTruck",           position = Vector3.new(2650, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.TerracottaHacienda",   position = Vector3.new(2700, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.CantinaStainedGlass",  position = Vector3.new(2750, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.PinkGreenStuccoShops", position = Vector3.new(2800, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.FountainCourtyard",    position = Vector3.new(2850, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.BellTower",            position = Vector3.new(2900, 0, 100), yaw = 0 },

	-- ── V2 Props row 1 (4200 + 15*i, 0, 60) ──
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(2415, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(2430, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(2445, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(2460, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(2475, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(2490, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.SombreroRack",       position = Vector3.new(2505, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.DonkeyCart",         position = Vector3.new(2520, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.MariachiGearPile",   position = Vector3.new(2535, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.SucculentPlanter",   position = Vector3.new(2550, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CalaveraSugarSkull", position = Vector3.new(2565, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.WovenBasket",        position = Vector3.new(2580, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.DanceRibbon",        position = Vector3.new(2595, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.ChiliRistraPole",    position = Vector3.new(2610, 0, 60) },

	-- ── V2 Props row 2 (4200 + 15*i, 0, 80) — ceramic pot collection ──
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2415, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2430, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2445, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2460, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2475, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2490, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2505, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(2520, 0, 80) },

	-- ── V2 Decor grid (4200 + 10*i, 12, 80 + 5*j), cycling 5 types ──
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(2410, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(2420, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(2430, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(2440, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(2450, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(2460, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(2470, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(2480, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(2490, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(2500, 12, 80) },

	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(2410, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(2420, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(2430, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(2440, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(2450, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(2460, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(2470, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(2480, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(2490, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(2500, 12, 85) },

	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(2410, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(2420, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(2430, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(2440, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(2450, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(2460, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(2470, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(2480, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(2490, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(2500, 12, 90) },

	-- ── V2 Landmarks (4200 + 100*i, 0, 130) ──
	{ module = "Assets.Districts.MercadoDelSol.Buildings.PinataTower",         position = Vector3.new(2500, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.CathedralArchEntry",  position = Vector3.new(2600, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Landmarks.MariachiBandstand",   position = Vector3.new(2700, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Landmarks.GiantCactusSculpture", position = Vector3.new(2800, 0, 130), yaw = 0 },

	-- ── V2 NPCs (4200 + 20*i, 6, 30) — 11 figures: 4 named + 7 pedestrians ──
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonPepe",            position = Vector3.new(2420, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Lucia",              position = Vector3.new(2440, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Memo",               position = Vector3.new(2460, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonaRosa",           position = Vector3.new(2480, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.MariachiMusician",   position = Vector3.new(2500, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.AbuelaTortillaCart", position = Vector3.new(2520, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.KidWithElote",       position = Vector3.new(2540, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.MaskedLuchador",     position = Vector3.new(2560, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DancingCouple",      position = Vector3.new(2580, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.ChurroVendor",       position = Vector3.new(2600, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.KidsKickingBall",    position = Vector3.new(2620, 6, 30) },
}
