require("dotenv").config();
const path = require("path");
const express = require("express");
const { sql, poolPromise } = require("./db");

(async () => {
  const app = express();
  const PORT = Number(process.env.PORT || 3000);

  app.use(express.json({ limit: "100kb" }));
  app.use(express.static(path.join(__dirname, "public")));

  // ============================================================
  //   HEALTH CHECK
  // ============================================================
  app.get("/api/health", async (_req, res) => {
    try {
      const pool = await poolPromise;
      await pool.request().query("SELECT 1 AS ok");
      res.json({ ok: true, database: process.env.DB_DATABASE });
    } catch (error) {
      console.error(error);
      res.status(500).json({ ok: false, error: "SQL Server no disponible." });
    }
  });

  // ============================================================
  //   LISTAR PRODUCTOS (con stock)
  // ============================================================
  app.get("/api/products", async (_req, res) => {
    try {
      const pool = await poolPromise;
      const result = await pool.request().query(`
        SELECT
          p.ProductId AS id,
          c.Name AS categoria,
          b.Name AS marca,
          p.Name AS nombre,
          p.Presentation AS formato,
          p.Price AS precio,
          p.ImagePath AS imagen,
          p.Stock AS stock
        FROM dbo.Products p
        INNER JOIN dbo.Categories c ON c.CategoryId = p.CategoryId
        INNER JOIN dbo.Brands b ON b.BrandId = p.BrandId
        WHERE p.IsActive = 1 AND c.IsActive = 1 AND b.IsActive = 1
        ORDER BY p.ProductId;
      `);
      res.json(result.recordset);
    } catch (error) {
      console.error("GET /api/products:", error);
      res.status(500).json({ error: "No se pudieron cargar los productos." });
    }
  });

  // ============================================================
  //   CREAR PEDIDO (valida y descuenta stock)
  // ============================================================
  app.post("/api/orders", async (req, res) => {
    const items = Array.isArray(req.body?.items) ? req.body.items : [];
    if (!items.length) {
      return res.status(400).json({ error: "El pedido está vacío." });
    }

    const normalized = items.map(item => ({
      productId: Number(item.productId),
      quantity: Number(item.quantity)
    }));

    if (normalized.some(i =>
      !Number.isInteger(i.productId) ||
      !Number.isInteger(i.quantity) ||
      i.quantity <= 0
    )) {
      return res.status(400).json({ error: "Productos o cantidades inválidos." });
    }

    const pool = await poolPromise;
    const transaction = new sql.Transaction(pool);

    try {
      await transaction.begin();

      const productIds = [...new Set(normalized.map(i => i.productId))];
      const request = new sql.Request(transaction);

      const placeholders = productIds.map((id, index) => {
        request.input(`id${index}`, sql.Int, id);
        return `@id${index}`;
      }).join(",");

      // Traemos precio Y stock actual de cada producto
      const result = await request.query(`
        SELECT ProductId, Price, Stock
        FROM dbo.Products
        WHERE IsActive = 1 AND ProductId IN (${placeholders});
      `);

      const productMap = new Map(
        result.recordset.map(p => [
          p.ProductId,
          { price: Number(p.Price), stock: Number(p.Stock) }
        ])
      );

      // Validar que todos los productos existen
      if (normalized.some(i => !productMap.has(i.productId))) {
        await transaction.rollback();
        return res.status(400).json({ error: "Un producto ya no está disponible." });
      }

      // Validar stock suficiente
      for (const item of normalized) {
        const p = productMap.get(item.productId);
        if (p.stock < item.quantity) {
          await transaction.rollback();
          return res.status(400).json({
            error: `Stock insuficiente. Solo quedan ${p.stock} unidades del producto #${item.productId}.`
          });
        }
      }

      const total = normalized.reduce(
        (sum, i) => sum + productMap.get(i.productId).price * i.quantity, 0
      );

      const orderRequest = new sql.Request(transaction);
      orderRequest.input("status", sql.NVarChar(40), "PENDIENTE_INSTAGRAM");
      orderRequest.input("total", sql.Decimal(18, 2), total);

      const orderResult = await orderRequest.query(`
        INSERT INTO dbo.Orders (Status, Total)
        OUTPUT INSERTED.OrderId
        VALUES (@status, @total);
      `);

      const orderId = orderResult.recordset[0].OrderId;

      for (const item of normalized) {
        const itemRequest = new sql.Request(transaction);
        itemRequest.input("orderId", sql.BigInt, orderId);
        itemRequest.input("productId", sql.Int, item.productId);
        itemRequest.input("quantity", sql.Int, item.quantity);
        itemRequest.input("unitPrice", sql.Decimal(18, 2), productMap.get(item.productId).price);

        await itemRequest.query(`
          INSERT INTO dbo.OrderItems (OrderId, ProductId, Quantity, UnitPrice)
          VALUES (@orderId, @productId, @quantity, @unitPrice);
        `);

        // Descontar stock del producto
        const stockRequest = new sql.Request(transaction);
        stockRequest.input("productId", sql.Int, item.productId);
        stockRequest.input("quantity", sql.Int, item.quantity);

        await stockRequest.query(`
          UPDATE dbo.Products
          SET Stock = Stock - @quantity
          WHERE ProductId = @productId;
        `);
      }

      await transaction.commit();
      res.status(201).json({ ok: true, orderId, total });
    } catch (error) {
      try { await transaction.rollback(); } catch (_) {}
      console.error("POST /api/orders:", error);
      res.status(500).json({ error: "No se pudo registrar el pedido." });
    }
  });

  // ============================================================
  //   ARRANCAR SERVIDOR
  // ============================================================
  app.listen(PORT, () => {
    console.log(`PowerUp funcionando en http://localhost:${PORT}`);
  });
})();