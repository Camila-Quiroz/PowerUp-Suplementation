require("dotenv").config();
const { sql, poolPromise } = require("./db");

// ============================================================
//   LISTA COMPLETA DE PRODUCTOS
// ============================================================
const productos = [
  { categoria:"Proteina", marca:"VITANAS", nombre:"100% Whey Elite 2 lb", formato:"28 servicios", precio:179000, imagen:"whey_elite.jpg" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"100% Whey Elite 5 lb", formato:"67 servicios", precio:385000, imagen:"whey_elite.jpg" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"100% Whey Elite 8 lb", formato:"121 servicios", precio:547000, imagen:"whey_elite.jpg" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"Beef Isolate 2 lb", formato:"28 servicios", precio:175000, imagen:"Beef_Isolate.webp" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"Beef Isolate 5 lb", formato:"67 servicios", precio:360000, imagen:"Beef_Isolate.webp" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"Isolate Gourmet 2lb", formato:"28 servicios", precio:235000, imagen:"Isolate_Army.webp" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"Isolate Gourmet 5lb", formato:"67 servicios", precio:475000, imagen:"Isolate_Army.webp" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"Titan Beef Mass 2 lb", formato:"4 servicios", precio:60000, imagen:"Titan_Beef_Mass.webp" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"Titan Beef Mass 5 lb", formato:"12 servicios", precio:130000, imagen:"Titan_Beef_Mass.webp" },
  { categoria:"Proteina", marca:"VITANAS", nombre:"Titan Beef Mass 10 lb", formato:"21 servicios", precio:230000, imagen:"Titan_Beef_Mass.webp" },
  { categoria:"Proteina", marca:"GMN", nombre:"Be One 2 lb", formato:"32 servicios", precio:178000, imagen:"Be_One.webp" },
  { categoria:"Proteina", marca:"GMN", nombre:"Be One 3 lb", formato:"49 servicios", precio:249000, imagen:"Be_One.webp" },
  { categoria:"Proteina", marca:"GMN", nombre:"Mega Gainer 2 lb", formato:"5 servicios", precio:74200, imagen:"Mega_gainer_2lb.jpg" },
  { categoria:"Proteina", marca:"GMN", nombre:"Mega Gainer 5 lb", formato:"9 servicios", precio:74200, imagen:"imagenes/Mega_Gainer_5_lb.webp" },
  { categoria:"Proteina", marca:"NUTRAMERICAN PHARMA", nombre:"Megaplex Creatine Power 10 lb", formato:"17 Servicios", precio:284990, imagen:"imagenes/Megaplex_Creatine.jpg" },
  { categoria:"Proteina", marca:"NUTRAMERICAN PHARMA", nombre:"Megaplex Creatine Power 2.3 lb", formato:"4 Servicios", precio:74990, imagen:"imagenes/Megaplex_Creatine_23.webp" },
  { categoria:"Proteina", marca:"NUTRAMERICAN PHARMA", nombre:"Biprotein Classic 2 lb", formato:"35 Servicios", precio:249000, imagen:"imagenes/Biprotein_Classic.jpg" },
  { categoria:"Proteina", marca:"NUTRAMERICAN PHARMA", nombre:"Biprotein Classic 3 lb", formato:"51 Servicios", precio:329000, imagen:"imagenes/biBiprotein_Classic_3_lb.png" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Best Protein 2 lb", formato:"28 Servicios", precio:214900, imagen:"imagenes/best_protein_2lb.webp" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Best Protein 4 lb", formato:"55 Servicios", precio:399900, imagen:"imagenes/best_protein_4lb.webp" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Best Vegan 2.16 lb", formato:"28 Servicios", precio:130000, imagen:"imagenes/Best_Vegan_216.webp" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Best Whey 2 lb", formato:"28 Servicios", precio:161900, imagen:"imagenes/Best_Whey_2 lbs.webp" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Best Whey 5 lb", formato:"69 Servicios", precio:339000, imagen:"imagenes/Best_Whey_Proscience_5_LB.webp" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Smart Gainer 13lb", formato:"24 Servicios", precio:344900, imagen:"imagenes/Smart_Gainer_13lb.jpg" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Smart Gainer 3b", formato:"6 Servicios", precio:98900, imagen:"imagenes/Smart_Gainer_3lb.jpg" },
  { categoria:"Proteina", marca:"PROSCIENCE", nombre:"Smart Gainer 6lb", formato:"11 Servicios", precio:98900, imagen:"imagenes/smart-6lb.webp" },
  { categoria:"Proteina", marca:"TNT", nombre:"TNT 3lb", formato:"4 Servicios", precio:91200, imagen:"imagenes/TNT_BOLSA_3lb.webp" },
  { categoria:"Proteina", marca:"TNT", nombre:"TNT 6lb", formato:"9 Servicios", precio:175000, imagen:"imagenes/tnt_gainer_6lb.webp" },
  { categoria:"Proteina", marca:"TNT", nombre:"TNT 10lb", formato:"15 Servicios", precio:285000, imagen:"imagenes/tnt_10lb.webp" },
  { categoria:"Proteina", marca:"DYMATIZE", nombre:"Elite Whey 5 Lb", formato:"63 Servicios", precio:380000, imagen:"imagenes/Elite_Dimatize_5 Lb.webp" },
  { categoria:"Proteina", marca:"DYMATIZE", nombre:"Elite Whey Protein 2 Lb", formato:"25 Servicios", precio:207000, imagen:"imagenes/Elite_Whey_Protein_2lb.avif" },
  { categoria:"Proteina", marca:"DYMATIZE", nombre:"Iso 100 1.3 Lb", formato:"20 Servicios", precio:235500, imagen:"imagenes/Iso_100_1_3_Lb.webp" },
  { categoria:"Proteina", marca:"DYMATIZE", nombre:"Iso 100 3 Lb", formato:"45 Servicios", precio:390000, imagen:"imagenes/iso_100_2lb.webp" },
  { categoria:"Proteina", marca:"DYMATIZE", nombre:"Iso 100 5 Lb", formato:"73 Servicios", precio:550000, imagen:"imagenes/iso_100_2lb.webp" },
  { categoria:"Proteina", marca:"DYMATIZE", nombre:"Super Mass Gainer 12 Lbs", formato:"16 Servicios", precio:361000, imagen:"imagenes/super_mass_12.jpg" },
  { categoria:"Proteina", marca:"DYMATIZE", nombre:"Super Mass Gainer 6 Lbs", formato:"8 Servicios", precio:365000, imagen:"imagenes/super_mass_12.jpg" },
  { categoria:"Proteina", marca:"ISOPURE", nombre:"Isopure Zero Carb 3lb", formato:"44 Servicios", precio:395000, imagen:"imagenes/Isopure_3lb.avif" },
  { categoria:"Proteina", marca:"ISOPURE", nombre:"Isopure Zero Carb 1,98lb", formato:"36 Servicios", precio:329000, imagen:"imagenes/Isopure_Zero_Carb.jpg" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"Iso whey 5lb", formato:"75 Servicios", precio:391000, imagen:"imagenes/MUSCLETECH_whey_5lb.jpg" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"Mass Tech Elite-2lb", formato:"10 Servicios", precio:420000, imagen:"imagenes/Mass_Tech_Elite -.webp" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"extreme 2000 - 6 Lb", formato:"5 Servicios", precio:241000, imagen:"imagenes/Extreme_2000.webp" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"Nitro Tech Protein - 4 Lb", formato:"40 Servicios", precio:301000, imagen:"imagenes/Nitro_Tech_Protein_4 Lb.avif" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"Nitro Tech Whey GOLD 2LB", formato:"31 Servicios", precio:213000, imagen:"imagenes/Gold_Muscletech_5_LB.webp" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"Nitro Tech Whey GOLD 5LB", formato:"69 Servicios", precio:322900, imagen:"imagenes/Gold_Muscletech_5_LB.webp" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"Nitro Tech Protein 2LB", formato:"22 Servicios", precio:213000, imagen:"imagenes/Nitrotech_Whey_Protein.webp" },
  { categoria:"Proteina", marca:"MUSCLETECH", nombre:"Nitro Tech Protein 4LB", formato:"40 Servicios", precio:301000, imagen:"imagenes/Nitrotech_Whey_Protein.webp" },
  { categoria:"Proteina", marca:"OPTIMUM NUTRITION", nombre:"100% Whey Gold Standard 2 lb", formato:"29 Servicios", precio:225000, imagen:"imagenes/gold-standard-2-lb.jpg" },
  { categoria:"Proteina", marca:"OPTIMUM NUTRITION", nombre:"100% Whey Gold Standard 5 lb", formato:"73 Servicios", precio:440900, imagen:"imagenes/gold-standar-5lb.webp" },

  // CREATINA
  { categoria:"Creatina", marca:"VITANAS", nombre:"Creatine Time 150g", formato:"50 Servicios", precio:58000, imagen:"Creatine_Time.webp" },
  { categoria:"Creatina", marca:"IMN", nombre:"Creatine Time 300g", formato:"100 Servicios", precio:98000, imagen:"Creatine_Time_100.webp" },
  { categoria:"Creatina", marca:"GMN", nombre:"Creatine Monohidrato", formato:"100 Servicios", precio:98000, imagen:"creatina_monohidratada_GMN.webp" },
  { categoria:"Creatina", marca:"Healthy Sports", nombre:"Healthy 150g Unflavored", formato:"50 Servicios", precio:85000, imagen:"imagenes/Healthy_Unflavored.webp" },
  { categoria:"Creatina", marca:"Healthy Sports", nombre:"Healthy 300g Unflavored", formato:"100 Servicios", precio:127200, imagen:"imagenes/Healthy_Unflavored_100.webp" },
  { categoria:"Creatina", marca:"IMN", nombre:"Creatina Monohidratada (500g)", formato:"133 Servicios", precio:129000, imagen:"imagenes/Creatina_Monohidratada_imn.webp" },
  { categoria:"Creatina", marca:"IMN", nombre:"Creatina Monohidratada (300g)", formato:"50 Servicios", precio:79900, imagen:"imagenes/Creatina_Monohidratada_imn.webp" },
  { categoria:"Creatina", marca:"MACROBLENDS", nombre:"CR2 (Passion fruit)", formato:"30 Servicios", precio:69000, imagen:"imagenes/CR2_Passion_fruit.jpg" },
  { categoria:"Creatina", marca:"MACROBLENDS", nombre:"CR2 Creatine(360g)", formato:"60 Servicios", precio:99000, imagen:"imagenes/Creatina_CR2.webp" },
  { categoria:"Creatina", marca:"PROSCIENCE", nombre:"Legacy (330g)", formato:"30 Servicios", precio:85000, imagen:"imagenes/Legacy_30_Serv.jpg" },
  { categoria:"Creatina", marca:"PROSCIENCE", nombre:"Legacy (550g)", formato:"50 Servicios", precio:130000, imagen:"imagenes/Legacy_50_Serv.webp" },
  { categoria:"Creatina", marca:"FITMAFIA", nombre:"Legend (600g)", formato:"50 Servicios", precio:127000, imagen:"imagenes/Legend_50.webp" },
  { categoria:"Creatina", marca:"FITMAFIA", nombre:"Legend (360g)", formato:"30 Servicios", precio:79900, imagen:"imagenes/LEGEND_30_SERV.webp" },
  { categoria:"Creatina", marca:"SMARTMUSCLE", nombre:"Atomic Monohydrato(600g)", formato:"120 Servicios", precio:115000, imagen:"imagenes/atomic_mono.webp" },
  { categoria:"Creatina", marca:"SMARTMUSCLE", nombre:"Atomic Monohydrato(300g)", formato:"60 Servicios", precio:65000, imagen:"imagenes/atomic_mono.webp" },
  { categoria:"Creatina", marca:"SMARTMUSCLE", nombre:"Atomic HCL(300g)", formato:"60 Servicios", precio:90000, imagen:"imagenes/Atomic_Hcl.webp" },
  { categoria:"Creatina", marca:"DYMATIZE", nombre:"Creatina Dymatize (300g)", formato:"88 Servicios", precio:157000, imagen:"imagenes/Creatina_Dymatize.jpg" },
  { categoria:"Creatina", marca:"MUSCLETECH", nombre:"Cell Tech 6lb", formato:"56 Servicios", precio:249000, imagen:"imagenes/Cell-_ech_6Lb.webp" },
  { categoria:"Creatina", marca:"MUSCLETECH", nombre:"Cell Tech 3lb", formato:"27 Servicios", precio:181000, imagen:"imagenes/Cell-_ech_6Lb.webp" },
  { categoria:"Creatina", marca:"MUSCLETECH", nombre:"Cell Tech Creator - Unflavored", formato:"120 Servicios", precio:154000, imagen:"imagenes/Cell_Tech_Creator.webp" },
  { categoria:"Creatina", marca:"MUSCLETECH", nombre:"Platinum creatine - 400gr Unflavored", formato:"80 servicio", precio:177000, imagen:"imagenes/Platinum_Creatine.webp" },
  { categoria:"Creatina", marca:"MUSCLETECH", nombre:"Platinum creatine - 400gr Unflavored", formato:"60 servicio", precio:177000, imagen:"imagenes/Platinun_sabor_creatina.webp" },
  { categoria:"Creatina", marca:"OPTIMUM NUTRITION", nombre:"Creatina ON 240 serv", formato:"240 servicio", precio:257000, imagen:"imagenes/Creatina_ON_240.webp" },
  { categoria:"Creatina", marca:"OPTIMUM NUTRITION", nombre:"Creatina ON 120 serv", formato:"120 servicio", precio:192000, imagen:"imagenes/Creatina_ON_240.webp" },
  { categoria:"Creatina", marca:"OPTIMUM NUTRITION", nombre:"Creatina ON 60 serv", formato:"60 servicio", precio:132000, imagen:"imagenes/Creatine_60_servicios.jpg" },

  // PRE-ENTRENO
  { categoria:"Pre-Entreno", marca:"PROSCIENCE", nombre:"Intenze Citrus Punch", formato:"30 servicios", precio:145000, imagen:"imagenes/Intenze_30_Serv.jpg" },
  { categoria:"Pre-Entreno", marca:"FITMAFIA", nombre:"Pase (330g)", formato:"30 servicios", precio:105000, imagen:"imagenes/pase_fitmafia.webp" },
  { categoria:"Pre-Entreno", marca:"SMARTMUSCLE", nombre:"Electron (300g)", formato:"15 servicios", precio:85000, imagen:"imagenes/electron_15_s.jpg" },
  { categoria:"Pre-Entreno", marca:"SMARTMUSCLE", nombre:"Electron (600g)", formato:"30 servicios", precio:125000, imagen:"imagenes/electron_15_s.jpg" },
  { categoria:"Pre-Entreno", marca:"DRAGON PHARMA", nombre:"Venom Inferno 40 serv", formato:"40 servicios", precio:161000, imagen:"imagenes/VENOM_40.webp" },
  { categoria:"Pre-Entreno", marca:"DRAGON PHARMA", nombre:"Venom Inferno 30 serv", formato:"30 servicios", precio:120000, imagen:"imagenes/venom_30.jpg" },
  { categoria:"Pre-Entreno", marca:"INSANE LABZ", nombre:"Psychotic Black", formato:"35 servicios", precio:129500, imagen:"imagenes/Psychotic_Black_35.jpg" },
  { categoria:"Pre-Entreno", marca:"INSANE LABZ", nombre:"Psychotic Gold", formato:"60 servicios", precio:180900, imagen:"imagenes/Psychotic_GOLD_60.webp" },
  { categoria:"Pre-Entreno", marca:"INSANE LABZ", nombre:"Psychotic Red 35", formato:"35 servicios", precio:151000, imagen:"imagenes/psychotic_red.webp" },
  { categoria:"Pre-Entreno", marca:"INSANE LABZ", nombre:"Psychotic Red 60", formato:"60 servicios", precio:189000, imagen:"imagenes/psychotic_red.webp" },
  { categoria:"Pre-Entreno", marca:"INSANE LABZ", nombre:"Psychotic Saw 30", formato:"30 servicios", precio:154900, imagen:"imagenes/Psychotic_saw.jpg" },
  { categoria:"Pre-Entreno", marca:"INSANE LABZ", nombre:"Psychotic Saw 60", formato:"60 servicios", precio:195000, imagen:"imagenes/Psychotic_saw.jpg" },
  { categoria:"Pre-Entreno", marca:"INSANE LABZ", nombre:"Psychotic xtreme", formato:"30 servicios", precio:165000, imagen:"imagenes/Psychotic_xtreme.jpg" },

  // VITAMINAS
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"B-100 Complex", formato:"50 tabs", precio:86000, imagen:"imagenes/B_100_Complex.webp" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"VCal-Mag-Zinc Plus VD3", formato:"90 Cap", precio:63000, imagen:"imagenes/Cal_Mag_Zinc_Plus_VD3.jpg" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Chelated Zinc 40 mg", formato:"100 tabs", precio:69000, imagen:"imagenes/chelated_zinc.jpg" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Fibaxil", formato:"120 Cap", precio:80000, imagen:"imagenes/Fibaxil.webp" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Melatonina 3mg", formato:"120 Sft", precio:53000, imagen:"imagenes/Melatonina.jpg" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Potassium 99mg", formato:"60 cap", precio:52000, imagen:"imagenes/Potassium_99mg.webp" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Probioticos", formato:"60 Gummies", precio:60000, imagen:"imagenes/Probiotics.jpg" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Super Magnesium 400mg", formato:"100 Sft", precio:85000, imagen:"imagenes/Super_Magnesium.webp" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Vitamina C 1000mg", formato:"100 Tab", precio:67000, imagen:"imagenes/Vitamina_C.webp" },
  { categoria:"Vitamina", marca:"HEALTHY AMERICA", nombre:"Vitamina D3 2000 IU", formato:"100 Sft", precio:67000, imagen:"imagenes/Vitamina_D3.jpg" },
  { categoria:"Vitamina", marca:"IMN", nombre:"Multi (Vitamina C / Multivitamínico 600 g)", formato:"30 Servicios", precio:69900, imagen:"imagenes/Multi_MN.webp" },
  { categoria:"Vitamina", marca:"PROSCIENCE", nombre:"Ashwagandha", formato:"60 gomas", precio:75000, imagen:"imagenes/Ashwagandha.jpg" },
  { categoria:"Vitamina", marca:"PROSCIENCE", nombre:"Vitamina D3+K2", formato:"30 perlas", precio:77000, imagen:"imagenes/VITAMINA_D3_K2_PROS.webp" },
  { categoria:"Vitamina", marca:"PROSCIENCE", nombre:"The One Orange 300 g", formato:"30 servicios", precio:90000, imagen:"imagenes/The_One_Orange.jpg" },
  { categoria:"Vitamina", marca:"PROSCIENCE", nombre:"Shield Lemon 450g", formato:"30 servicios", precio:100000, imagen:"imagenes/Shield_Lemon.jpg" },
  { categoria:"Vitamina", marca:"MUSCLETECH", nombre:"Multiplatinum 90", formato:"90 cap", precio:94000, imagen:"imagenes/multiplatinum.jpg" },
  { categoria:"Vitamina", marca:"MUSCLETECH", nombre:"Multiplatinum 180", formato:"180 cap", precio:133000, imagen:"imagenes/multiplatinum.jpg" },
  { categoria:"Vitamina", marca:"OPTIMUM NUTRITION", nombre:"Multivitamin OPTI-MEN 90", formato:"90 Caps", precio:137000, imagen:"imagenes/Multivitamin_optimen.jpg" },
  { categoria:"Vitamina", marca:"OPTIMUM NUTRITION", nombre:"Multivitamin OPTI-MEN 150", formato:"150 Caps", precio:175000, imagen:"imagenes/Multivitamin_optimen.jpg" },

  // OMEGA Y COLAGENO
  { categoria:"Omega", marca:"HEALTHY AMERICA", nombre:"Fish Oil Omega 3 1200mg", formato:"100 Cap", precio:70000, imagen:"imagenes/Fish_Oil_Omega.webp" },
  { categoria:"Omega", marca:"HEALTHY AMERICA", nombre:"Triple Omega 3-6-9", formato:"120 Cap", precio:99000, imagen:"imagenes/Triple_Omega.webp" },
  { categoria:"Colágeno", marca:"IMN", nombre:"KORAGEEM (Collagen Red Fusion 480 g)", formato:"24 Servicios", precio:89900, imagen:"imagenes/KORAGEEM.jpg" },
  { categoria:"Colágeno", marca:"IMN", nombre:"KORAGEEM (Collagen Té Chai 480 g)", formato:"24 Servicios", precio:89900, imagen:"imagenes/KORAGEEM_Te.jpg" },
  { categoria:"Omega", marca:"IMN", nombre:"Omega 3", formato:"120 Caps", precio:64900, imagen:"imagenes/OMEGA_3_imn.webp" },
  { categoria:"Omega", marca:"MACROBLENDS", nombre:"Omega 3", formato:"120 Caps", precio:75000, imagen:"imagenes/Omega_Megablends.png" },
  { categoria:"Colágeno", marca:"NUTRAMERICAN PHARMA", nombre:"Collagen Stack", formato:"45 Servicios", precio:99990, imagen:"imagenes/Collagen_Stack.webp" },
  { categoria:"Omega", marca:"PROSCIENCE", nombre:"Omega 3", formato:"120 Caps", precio:77000, imagen:"imagenes/Omega_proscience.webp" },
  { categoria:"Omega", marca:"MUSCLETECH", nombre:"Omega", formato:"100 Caps", precio:100000, imagen:"imagenes/Platinum_Fish_Oil_Omega_3_Muscletech.webp" },

  // AMINOACIDOS
  { categoria:"Aminoacidos", marca:"IMN", nombre:"BCAA 2:1:1", formato:"30 Servicios", precio:119900, imagen:"imagenes/BCAA.jpg" },
  { categoria:"Aminoacidos", marca:"MACROBLENDS", nombre:"EAAS Mix Aminos", formato:"30 Servicios", precio:117900, imagen:"imagenes/Mix_Aminos_30.png" },
  { categoria:"Aminoacidos", marca:"PROSCIENCE", nombre:"Army Eaas Citrus Punch", formato:"30 Servicios", precio:115000, imagen:"imagenes/Army_Eaas.webp" },
  { categoria:"Aminoacidos", marca:"SMARTMUSCLE", nombre:"Alpha Bcaa (600g)", formato:"30 Servicios", precio:120000, imagen:"imagenes/Alpha_Bcaa.jpg" },
  { categoria:"Aminoacidos", marca:"MUSCLETECH", nombre:"100 % Eaa+ Platinum", formato:"30 Servicios", precio:177000, imagen:"imagenes/100_Platinum_EAA.webp" },
  { categoria:"Aminoacidos", marca:"MUSCLETECH", nombre:"Amino Build", formato:"40 Servicios", precio:177000, imagen:"imagenes/100_Platinum_EAA.webp" },
  { categoria:"Aminoacidos", marca:"OPTIMUM NUTRITION", nombre:"Amino Energy Fruit Punch /Citrus", formato:"30 Servicios", precio:131000, imagen:"imagenes/amino-energy.jpg" },
  { categoria:"Aminoacidos", marca:"OPTIMUM NUTRITION", nombre:"Amino Energy Fruit Fusion", formato:"65 Servicios", precio:220000, imagen:"imagenes/amino-energy.jpg" },

  // QUEMADOR
  { categoria:"Quemador", marca:"NUTRAMERICAN PHARMA", nombre:"Burner Stack 360g", formato:"60 Servicios", precio:139990, imagen:"imagenes/Burner_Stack_360g.webp" },

  // PRECURSOR
  { categoria:"Precursor", marca:"ANGRY SUPPLEMENTS", nombre:"Animal Test", formato:"120 tab", precio:101000, imagen:"imagenes/animal_test.webp" },
  { categoria:"Precursor", marca:"ANGRY SUPPLEMENTS", nombre:"Monster Test Blanco", formato:"120 tab", precio:97000, imagen:"imagenes/Monster_test.webp" },
  { categoria:"Precursor", marca:"ANGRY SUPPLEMENTS", nombre:"Monster test + Creatina", formato:"120 Cap", precio:137000, imagen:"imagenes/Monster_test_Creatina.webp" },
  { categoria:"Precursor", marca:"ANGRY SUPPLEMENTS", nombre:"Monster Test PM", formato:"60 Cap", precio:101000, imagen:"imagenes/Monster_Test_PM.webp" },
  { categoria:"Precursor", marca:"MUSCLETECH", nombre:"Alpha Test", formato:"120 Cap", precio:167000, imagen:"imagenes/amino_build.webp" }
];

// ============================================================
//   LÓGICA DE INSERCIÓN
// ============================================================
(async () => {
  try {
    const pool = await poolPromise;

    // 1. Crear categorías únicas
    const categorias = [...new Set(productos.map(p => p.categoria))];
    for (const cat of categorias) {
      const exists = await pool.request()
        .input("name", sql.NVarChar(100), cat)
        .query("SELECT 1 AS x FROM Categories WHERE Name = @name");
      if (exists.recordset.length === 0) {
        await pool.request()
          .input("name", sql.NVarChar(100), cat)
          .query("INSERT INTO Categories (Name, IsActive) VALUES (@name, 1)");
        console.log(`✅ Categoría creada: ${cat}`);
      }
    }

    // 2. Crear marcas únicas
    const marcas = [...new Set(productos.map(p => p.marca))];
    for (const m of marcas) {
      const exists = await pool.request()
        .input("name", sql.NVarChar(100), m)
        .query("SELECT 1 AS x FROM Brands WHERE Name = @name");
      if (exists.recordset.length === 0) {
        await pool.request()
          .input("name", sql.NVarChar(100), m)
          .query("INSERT INTO Brands (Name, IsActive) VALUES (@name, 1)");
        console.log(`✅ Marca creada: ${m}`);
      }
    }

    // 3. Obtener mapa de IDs
    const catsDB = await pool.request().query("SELECT CategoryId, Name FROM Categories");
    const brandsDB = await pool.request().query("SELECT BrandId, Name FROM Brands");
    const catMap = new Map(catsDB.recordset.map(r => [r.Name, r.CategoryId]));
    const brandMap = new Map(brandsDB.recordset.map(r => [r.Name, r.BrandId]));

    // 4. Insertar productos
    let insertados = 0;
    for (const p of productos) {
      const catId = catMap.get(p.categoria);
      const brandId = brandMap.get(p.marca);
      if (!catId || !brandId) {
        console.log(`⚠️  Saltando (sin cat/marca): ${p.nombre}`);
        continue;
      }
      // Evitar duplicados por nombre + marca
      const dup = await pool.request()
        .input("name", sql.NVarChar(200), p.nombre)
        .input("brandId", sql.Int, brandId)
        .query("SELECT 1 AS x FROM Products WHERE Name = @name AND BrandId = @brandId");
      if (dup.recordset.length > 0) {
        console.log(`⏭️  Ya existe: ${p.nombre}`);
        continue;
      }
      await pool.request()
        .input("catId", sql.Int, catId)
        .input("brandId", sql.Int, brandId)
        .input("name", sql.NVarChar(200), p.nombre)
        .input("presentation", sql.NVarChar(100), p.formato)
        .input("price", sql.Decimal(18, 2), p.precio)
        .input("imagePath", sql.NVarChar(500), p.imagen)
        .query(`INSERT INTO Products (CategoryId, BrandId, Name, Presentation, Price, ImagePath, IsActive)
                VALUES (@catId, @brandId, @name, @presentation, @price, @imagePath, 1)`);
      insertados++;
      console.log(`✅ Insertado: ${p.nombre}`);
    }

    console.log(`\n🎉 Total insertados: ${insertados} de ${productos.length}`);
    process.exit(0);
  } catch (err) {
    console.error("❌ Error:", err.message);
    process.exit(1);
  }
})();