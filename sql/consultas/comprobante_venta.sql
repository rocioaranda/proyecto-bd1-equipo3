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
    p.descripcion,
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
