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
