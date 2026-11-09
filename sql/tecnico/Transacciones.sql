USE Byte_Motors;
GO
-- PRUEBA 1: CASO CORRECTO (Stock suficiente)
BEGIN TRANSACTION;

DECLARE @id_producto INT = 1;
DECLARE @cantidad_comprada INT = 2;
DECLARE @stock_actual INT;
DECLARE @precio_lista DECIMAL(10,2);

-- 1. Verificar stock y obtener el precio vigente del catálogo
SELECT 
    @stock_actual = Stock_Disponible,
    @precio_lista = Precio 
FROM Productos 
WHERE Cod_Producto = @id_producto;

IF @stock_actual >= @cantidad_comprada
BEGIN
    -- Registrar la transacción (Cabecera)
    INSERT INTO Transacciones (Fecha, Cod_Cliente, Cod_Vendedor, Cod_Metodo_Pago)
    VALUES (GETDATE(), 1, 1, 1);
    
    DECLARE @id_transaccion INT = SCOPE_IDENTITY();

    -- Registrar el detalle con el precio real del catálogo
    INSERT INTO Detalle (cod_transaccion, cod_producto, Cantidad, Precio_unitario)
    VALUES (@id_transaccion, @id_producto, @cantidad_comprada, @precio_lista);

    -- Descontar el stock del producto
    UPDATE Productos
    SET Stock_Disponible = Stock_Disponible - @cantidad_comprada
    WHERE Cod_Producto = @id_producto;

    COMMIT TRANSACTION;
    PRINT 'Prueba Correcta: Venta registrada y stock actualizado con éxito.';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Prueba Correcta: Cancelado por falta de stock.';
END;
GO

-- PRUEBA 2: CASO INCORRECTO (Stock insuficiente -> ROLLBACK)
BEGIN TRANSACTION;

DECLARE @id_prod INT = 1; 
DECLARE @cant_exagerada INT = 9999;
DECLARE @stock_disp INT;

SELECT @stock_disp = Stock_Disponible FROM Productos WHERE Cod_Producto = @id_prod;

IF @stock_disp < @cant_exagerada
BEGIN
    -- Si no hay stock, se aborta la operación
    ROLLBACK TRANSACTION;
    PRINT 'Prueba Incorrecta: Stock insuficiente. Se ejecutó ROLLBACK TRANSACTION. No quedó ningún registro parcial.';
END
ELSE
BEGIN
    INSERT INTO Transacciones (Fecha, Cod_Cliente, Cod_Vendedor, Cod_Metodo_Pago)
    VALUES (GETDATE(), 1, 1, 1);
    COMMIT TRANSACTION;
END;
GO
