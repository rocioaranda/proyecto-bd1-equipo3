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
