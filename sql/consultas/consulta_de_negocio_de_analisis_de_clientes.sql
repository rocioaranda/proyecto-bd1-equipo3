- CONSULTA DE NEGOCIO 
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
