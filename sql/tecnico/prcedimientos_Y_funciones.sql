--## 5. Script de Demostración y Resultados Obtenidos

--*(Nota: Este script debe ejecutarse en el motor de base de datos SQL Server)*

USE Byte_Motors;
GO

-- =========================================================
-- FUNCIÓN: Calcular descuento para clientes frecuentes
-- =========================================================
CREATE OR ALTER FUNCTION dbo.fn_CalcularDescuentoCliente (@cliente_id INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total_acumulado DECIMAL(12,2);
    
    -- Sumar el monto total de compras del cliente
    SELECT @total_acumulado = ISNULL(SUM(d.Cantidad * d.Precio_unitario), 0)
    FROM Transacciones t
    JOIN detalle d ON t.Cod_Transaccion = d.cod_transaccion
    WHERE t.Cod_Cliente = @cliente_id;

    -- Aplicar lógica de descuentos mediante CASE (más limpio y corto)
    RETURN CASE 
        WHEN @total_acumulado > 500000 THEN 10.00
        WHEN @total_acumulado > 200000 THEN 5.00
        ELSE 0.00
    END;
END;
GO

-- =========================================================
-- PROCEDIMIENTO: Registrar una venta completa
-- =========================================================
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaCompleta
    @cod_cliente INT,
    @cod_vendedor INT,
    @cod_metodo_pago INT,
    @cod_producto INT,
    @cantidad INT,
    @precio_unitario DECIMAL(10,2)
AS
BEGIN
    -- 1. Registrar encabezado de venta
    INSERT INTO Transacciones (Fecha, Cod_Cliente, Cod_Vendedor, Cod_Metodo_Pago)
    VALUES (GETDATE(), @cod_cliente, @cod_vendedor, @cod_metodo_pago);

    -- Obtener el ID de la venta recién creada
    DECLARE @id_venta INT = SCOPE_IDENTITY();

    -- 2. Insertar detalle de venta (con precio histórico)
    INSERT INTO detalle (cod_transaccion, cod_producto, Cantidad, Precio_unitario)
    VALUES (@id_venta, @cod_producto, @cantidad, @precio_unitario);

    -- 3. Actualizar stock del producto
    UPDATE Productos
    SET Stock_Disponible = Stock_Disponible - @cantidad
    WHERE Cod_Producto = @cod_producto;
END;
GO
```
