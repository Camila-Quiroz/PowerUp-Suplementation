require("dotenv").config();

// Usa el driver nativo ODBC en lugar de tedious
const sql = require("mssql/msnodesqlv8");

// ===== Validación temprana de variables de entorno =====
if (!process.env.DB_SERVER || !process.env.DB_DATABASE) {
  throw new Error("Faltan DB_SERVER y/o DB_DATABASE en el archivo .env");
}
if (!process.env.DB_USER || !process.env.DB_PASSWORD) {
  throw new Error("Faltan DB_USER y/o DB_PASSWORD en el archivo .env");
}

// ===== Diagnóstico (puedes borrar estas líneas cuando ya funcione) =====
console.log("DB_SERVER =", JSON.stringify(process.env.DB_SERVER));
console.log("DB_USER   =", JSON.stringify(process.env.DB_USER));
console.log("DB_PASSWORD length =", process.env.DB_PASSWORD.length);
console.log("DB_DATABASE =", JSON.stringify(process.env.DB_DATABASE));

// ===== Cadena de conexión ODBC =====
// OJO: aquí el servidor va con UNA sola barra invertida
const connectionString =
  `Driver={ODBC Driver 18 for SQL Server};` +
  `Server=${process.env.DB_SERVER};` +
  `Database=${process.env.DB_DATABASE};` +
  `Uid=${process.env.DB_USER};` +
  `Pwd=${process.env.DB_PASSWORD};` +
  `Encrypt=optional;` +
  `TrustServerCertificate=yes;`;

const config = {
  connectionString,
  pool: { max: 10, min: 0, idleTimeoutMillis: 30000 },
  connectionTimeout: 30000,
  requestTimeout: 30000
};

// ===== Pool de conexión =====
const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log("SQL Server conectado correctamente (via ODBC).");
    return pool;
  })
  .catch(error => {
    console.error("Error conectando a SQL Server:", error.message);
    throw error;
  });

module.exports = { sql, poolPromise };