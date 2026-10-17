
USE Byte_Motors;
GO


--  FACTURA / COMPROBANTE
-- encabezado + renglones con subtotal y acumulado
DECLARE @cod_transaccion INT = 1;

SELECT
    t.Cod_Transaccion                                   AS Nro_Comprobante,
    t.Fecha,
    c.nombre + ' ' + c.apellido                         AS Cliente,
    c.Nro_Dni                                           AS DNI,
    ISNULL(c.Razon_Social, '-')                         AS Razon_Social,
    v.nombre + ' ' + v.apellido                         AS Vendedor,
    mp.descripcion                                      AS Metodo_De_Pago,
    p.categoria + ' ' + p.marca                         AS Producto,
    d.Cantidad,
    d.Precio_unitario,
    d.Cantidad * d.Precio_unitario                      AS Subtotal_Renglon,
    SUM(d.Cantidad * d.Precio_unitario) OVER (
        ORDER BY d.cod_producto
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                   AS Total_Acumulado
FROM Transacciones t
INNER JOIN Clientes       c  ON c.Cod_Cliente      = t.Cod_Cliente
INNER JOIN Vendedores     v  ON v.Cod_Vendedor     = t.Cod_Vendedor
INNER JOIN Metodo_De_Pago mp ON mp.Cod_Metodo_Pago = t.Cod_Metodo_Pago
INNER JOIN Detalle        d  ON d.cod_transaccion  = t.Cod_Transaccion
INNER JOIN Productos      p  ON p.Cod_Producto     = d.cod_producto
WHERE t.Cod_Transaccion = @cod_transaccion
ORDER BY d.cod_producto;
GO

-- total final del comprobante
DECLARE @cod_transaccion INT = 1;

SELECT
    d.cod_transaccion                                   AS Nro_Comprobante,
    COUNT(*)                                            AS Cant_Renglones,
    SUM(d.Cantidad)                                     AS Unidades_Totales,
    SUM(d.Cantidad * d.Precio_unitario)                 AS TOTAL_A_PAGAR
FROM Detalle d
WHERE d.cod_transaccion = @cod_transaccion
GROUP BY d.cod_transaccion;
GO


--  REPORTE AGREGADO (GROUP BY, SUM, COUNT) EN UN RANGO DE FECHAS

-- total de ventas por VENDEDOR
DECLARE @desde DATE = '2026-08-01';
DECLARE @hasta DATE = '2026-09-30';

SELECT
    v.Cod_Vendedor,
    v.nombre + ' ' + v.apellido                         AS Vendedor,
    COUNT(DISTINCT t.Cod_Transaccion)                   AS Cant_Ventas,
    SUM(d.Cantidad)                                     AS Unidades_Vendidas,
    SUM(d.Cantidad * d.Precio_unitario)                 AS Total_Vendido
FROM Vendedores v
INNER JOIN Transacciones t ON t.Cod_Vendedor    = v.Cod_Vendedor
INNER JOIN Detalle       d ON d.cod_transaccion = t.Cod_Transaccion
WHERE t.Fecha BETWEEN @desde AND @hasta
GROUP BY v.Cod_Vendedor, v.nombre, v.apellido
ORDER BY Total_Vendido DESC;
GO

-- total de ventas por CATEGORIA de producto
DECLARE @desde DATE = '2026-08-01';
DECLARE @hasta DATE = '2026-09-30';

SELECT
    p.categoria,
    COUNT(DISTINCT t.Cod_Transaccion)                   AS Cant_Ventas,
    SUM(d.Cantidad)                                     AS Unidades_Vendidas,
    SUM(d.Cantidad * d.Precio_unitario)                 AS Total_Vendido
FROM Productos p
INNER JOIN Detalle       d ON d.cod_producto    = p.Cod_Producto
INNER JOIN Transacciones t ON t.Cod_Transaccion = d.cod_transaccion
WHERE t.Fecha BETWEEN @desde AND @hasta
GROUP BY p.categoria
ORDER BY Total_Vendido DESC;
GO



-- CONSULTA DE NEGOCIO 
--  Clientes "premium": aquellos cuyo gasto total supera el gasto promedio por cliente. Une 5 tablas y filtra con HAVING comparando contra una subconsulta.
SELECT
    c.Cod_Cliente,
    c.nombre + ' ' + c.apellido                         AS Cliente,
    COUNT(DISTINCT t.Cod_Transaccion)                   AS Cant_Compras,
    COUNT(DISTINCT p.categoria)                         AS Categorias_Distintas,
    SUM(d.Cantidad * d.Precio_unitario)                 AS Gasto_Total
FROM Clientes c
INNER JOIN Transacciones t ON t.Cod_Cliente     = c.Cod_Cliente
INNER JOIN Detalle       d ON d.cod_transaccion = t.Cod_Transaccion
INNER JOIN Productos     p ON p.Cod_Producto    = d.cod_producto
GROUP BY c.Cod_Cliente, c.nombre, c.apellido
HAVING SUM(d.Cantidad * d.Precio_unitario) > (
        -- promedio del gasto total por cliente
        SELECT AVG(gasto)
        FROM (
            SELECT SUM(d2.Cantidad * d2.Precio_unitario) AS gasto
            FROM Transacciones t2
            INNER JOIN Detalle d2 ON d2.cod_transaccion = t2.Cod_Transaccion
            GROUP BY t2.Cod_Cliente
        ) AS gasto_por_cliente
)
ORDER BY Gasto_Total DESC;
GO

--  productos con ingresos superiores al promedio, indicando su proveedor (persona o empresa). Une productos, detalle,proveedores y las dos subtablas del proveedor.
SELECT
    p.Cod_Producto,
    p.categoria + ' ' + p.marca                         AS Producto,
    COALESCE(pe.Razon_Social, pp.Nombre + ' ' + pp.Apellido) AS Proveedor,
    CASE WHEN pe.Cod_Proveedor IS NOT NULL THEN 'Empresa' ELSE 'Persona' END AS Tipo_Proveedor,
    SUM(d.Cantidad)                                     AS Unidades_Vendidas,
    SUM(d.Cantidad * d.Precio_unitario)                 AS Ingresos
FROM Productos p
INNER JOIN Detalle             d  ON d.cod_producto  = p.Cod_Producto
INNER JOIN Proveedores         pr ON pr.Cod_Proveedor = p.cod_Proveedor
LEFT  JOIN Proveedor_Empresa   pe ON pe.Cod_Proveedor = pr.Cod_Proveedor
LEFT  JOIN Proveedor_Persona   pp ON pp.Cod_Proveedor = pr.Cod_Proveedor
GROUP BY p.Cod_Producto, p.categoria, p.marca,
         pe.Razon_Social, pe.Cod_Proveedor, pp.Nombre, pp.Apellido
HAVING SUM(d.Cantidad * d.Precio_unitario) > (
        SELECT AVG(ingreso)
        FROM (
            SELECT SUM(Cantidad * Precio_unitario) AS ingreso
            FROM Detalle
            GROUP BY cod_producto
        ) AS ingreso_por_producto
)
ORDER BY Ingresos DESC;
GO