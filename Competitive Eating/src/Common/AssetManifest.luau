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
	-- MERCADO DEL SOL — V2 EXPANSION (base X = 4200)
	-- Real-neighborhood density: 10 buildings, 22 props, 30 decor,
	-- 4 landmarks, 11 NPCs = 77 placements for a walkable street feel.
	-- ============================================================

	-- ── V2 Buildings (4200 + 50*i, 0, 100) ──
	{ module = "Assets.Districts.MercadoDelSol.Buildings.TaqueriaElSol",        position = Vector3.new(4250, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.BurritoCasa",          position = Vector3.new(4300, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.QuesadillaStand",      position = Vector3.new(4350, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.TamaleTia",            position = Vector3.new(4400, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.EloteTruck",           position = Vector3.new(4450, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.TerracottaHacienda",   position = Vector3.new(4500, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.CantinaStainedGlass",  position = Vector3.new(4550, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.PinkGreenStuccoShops", position = Vector3.new(4600, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.FountainCourtyard",    position = Vector3.new(4650, 0, 100), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.BellTower",            position = Vector3.new(4700, 0, 100), yaw = 0 },

	-- ── V2 Props row 1 (4200 + 15*i, 0, 60) ──
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(4215, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(4230, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(4245, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(4260, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(4275, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.PapelPicadoBanner",  position = Vector3.new(4290, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.SombreroRack",       position = Vector3.new(4305, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.DonkeyCart",         position = Vector3.new(4320, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.MariachiGearPile",   position = Vector3.new(4335, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.SucculentPlanter",   position = Vector3.new(4350, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CalaveraSugarSkull", position = Vector3.new(4365, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.WovenBasket",        position = Vector3.new(4380, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.DanceRibbon",        position = Vector3.new(4395, 0, 60) },
	{ module = "Assets.Districts.MercadoDelSol.Props.ChiliRistraPole",    position = Vector3.new(4410, 0, 60) },

	-- ── V2 Props row 2 (4200 + 15*i, 0, 80) — ceramic pot collection ──
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4215, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4230, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4245, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4260, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4275, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4290, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4305, 0, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Props.CeramicPot", position = Vector3.new(4320, 0, 80) },

	-- ── V2 Decor grid (4200 + 10*i, 12, 80 + 5*j), cycling 5 types ──
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(4210, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(4220, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(4230, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(4240, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(4250, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(4260, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(4270, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(4280, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(4290, 12, 80) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(4300, 12, 80) },

	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(4210, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(4220, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(4230, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(4240, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(4250, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(4260, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(4270, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(4280, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(4290, 12, 85) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(4300, 12, 85) },

	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(4210, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(4220, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(4230, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(4240, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(4250, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.CandleAltar",        position = Vector3.new(4260, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.WovenHammock",       position = Vector3.new(4270, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PapelPicadoString",  position = Vector3.new(4280, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.MarigoldFlowerArch", position = Vector3.new(4290, 12, 90) },
	{ module = "Assets.Districts.MercadoDelSol.Decor.PaintedTileWall",    position = Vector3.new(4300, 12, 90) },

	-- ── V2 Landmarks (4200 + 100*i, 0, 130) ──
	{ module = "Assets.Districts.MercadoDelSol.Buildings.PinataTower",         position = Vector3.new(4300, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Buildings.CathedralArchEntry",  position = Vector3.new(4400, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Landmarks.MariachiBandstand",   position = Vector3.new(4500, 0, 130), yaw = 0 },
	{ module = "Assets.Districts.MercadoDelSol.Landmarks.GiantCactusSculpture", position = Vector3.new(4600, 0, 130), yaw = 0 },

	-- ── V2 NPCs (4200 + 20*i, 6, 30) — 11 figures: 4 named + 7 pedestrians ──
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonPepe",            position = Vector3.new(4220, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Lucia",              position = Vector3.new(4240, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.Memo",               position = Vector3.new(4260, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DonaRosa",           position = Vector3.new(4280, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.MariachiMusician",   position = Vector3.new(4300, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.AbuelaTortillaCart", position = Vector3.new(4320, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.KidWithElote",       position = Vector3.new(4340, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.MaskedLuchador",     position = Vector3.new(4360, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.DancingCouple",      position = Vector3.new(4380, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.ChurroVendor",       position = Vector3.new(4400, 6, 30) },
	{ module = "Assets.Districts.MercadoDelSol.Npcs.KidsKickingBall",    position = Vector3.new(4420, 6, 30) },
}
