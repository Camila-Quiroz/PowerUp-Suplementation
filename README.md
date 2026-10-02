# PowerUp Supplementation + SQL Server

Proyecto generado a partir del catálogo HTML suministrado.

Incluye los 128 productos originales, con sus precios, presentaciones e imágenes.

## Arquitectura
Navegador -> Node.js/Express -> SQL Server

## Instalación

1. Ejecuta `database.sql` en SQL Server.
2. Abre la carpeta en VS Code.
3. Ejecuta:
   `npm install`
4. Copia `.env.example` como `.env`.
5. Coloca las credenciales de tu SQL Server.
6. Ejecuta:
   `npm start`
7. Abre `http://localhost:3000`.

## Tablas

- Categories
- Brands
- Products
- Orders
- OrderItems

El catálogo consulta `GET /api/products`.
Al pulsar PEDIR POR INSTAGRAM, primero se registra el pedido en SQL Server y luego se abre el chat de Instagram.

No publiques `.env` ni sus credenciales.
