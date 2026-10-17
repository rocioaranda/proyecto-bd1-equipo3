# Informe de ventas

La gerencia necesita saber cuánto se vendió en un período, y quién y qué lo generó. El informe responde dos preguntas:

- ¿Qué vendedores generaron más ventas entre dos fechas?
- ¿Qué categorías de productos se vendieron más en ese mismo período?

## Técnicas utilizadas en ambas consultas

- **`GROUP BY`:** agrupa por vendedor o por categoría.
- **Funciones de agregación:**
  - `COUNT(DISTINCT Cod_Transaccion)` cuenta las ventas reales. Se usa `DISTINCT` porque una venta con varios renglones aparecería repetida.
  - `SUM(Cantidad)` suma las unidades vendidas.
  - `SUM(Cantidad * Precio_unitario)` suma el monto total.
- **Filtro de fechas:** `WHERE Fecha BETWEEN desde AND hasta`, con variables para poder cambiar el rango sin tocar la consulta. El filtro va en `WHERE` y no en `HAVING` porque se aplica a filas individuales antes de agrupar.
- **`ORDER BY Total_Vendido DESC`:** obtiene un ranking.

## Tablas

- **Por vendedor:** `Vendedores` - `Transacciones` - `Detalle`.
- **Por categoría:** `Productos` - `Detalle` - `Transacciones`.

## Resultado esperado

Rango de prueba: `@desde = '2026-08-01'` y `@hasta = '2026-09-30'` (incluye las 10 ventas).
