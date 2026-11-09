--Procedimientos Almacenados y Funciones
--Script de Demostración y Resultados Obtenidos

USE Byte_Motors;
GO

-- FUNCIÓN: Calcular descuento para clientes frecuentes
CREATE OR ALTER FUNCTION dbo.fn_CalcularDescuentoCliente (@cliente_id INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total_acumulado DECIMAL(12,2);
    
    -- Sumar el monto total de compras del cliente leyendo el histórico de Detalle
    SELECT @total_acumulado = ISNULL(SUM(d.Cantidad * d.Precio_unitario), 0)
    FROM Transacciones t
    JOIN Detalle d ON t.Cod_Transaccion = d.cod_transaccion
    WHERE t.Cod_Cliente = @cliente_id;

    -- Aplicar lógica de descuentos mediante CASE
    RETURN CASE 
        WHEN @total_acumulado > 500000 THEN 10.00
        WHEN @total_acumulado > 200000 THEN 5.00
        ELSE 0.00
    END;
END;
GO
-- PROCEDIMIENTO: Registrar una venta completa
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaCompleta
    @cod_cliente INT,
    @cod_vendedor INT,
    @cod_metodo_pago INT,
    @cod_producto INT,
    @cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Obtener el precio unitario actual desde el catálogo (Productos)
    DECLARE @precio_actual DECIMAL(10,2);

    SELECT @precio_actual = Precio
    FROM Productos
    WHERE Cod_Producto = @cod_producto;

    IF @precio_actual IS NULL
    BEGIN
        RAISERROR('El producto especificado no existe.', 16, 1);
        RETURN;
    END

    -- 2. Registrar encabezado de venta
    INSERT INTO Transacciones (Fecha, Cod_Cliente, Cod_Vendedor, Cod_Metodo_Pago)
    VALUES (GETDATE(), @cod_cliente, @cod_vendedor, @cod_metodo_pago);

    DECLARE @id_venta INT = SCOPE_IDENTITY();

    -- 3. Insertar detalle congelando el precio de lista actual
    INSERT INTO Detalle (cod_transaccion, cod_producto, Cantidad, Precio_unitario)
    VALUES (@id_venta, @cod_producto, @cantidad, @precio_actual);

    -- 4. Actualizar stock del producto
    UPDATE Productos
    SET Stock_Disponible = Stock_Disponible - @cantidad
    WHERE Cod_Producto = @cod_producto;
END;
GO


-- =========================================================
-- PARTE 1: VERIFICACIÓN DE LA FUNCIÓN (dbo.fn_CalcularDescuentoCliente)
-- =========================================================

-- 1. Consulta del acumulado histórico de compras y prueba de la función para todos los clientes
SELECT 
    c.Cod_Cliente,
    c.nombre,
    c.apellido,
    ISNULL(SUM(d.Cantidad * d.Precio_unitario), 0) AS Total_Gastado_Historico,
    dbo.fn_CalcularDescuentoCliente(c.Cod_Cliente) AS Porcentaje_Descuento_Aplicable
FROM Clientes c
LEFT JOIN Transacciones t ON c.Cod_Cliente = t.Cod_Cliente
LEFT JOIN Detalle d ON t.Cod_Transaccion = d.cod_transaccion
GROUP BY c.Cod_Cliente, c.nombre, c.apellido
ORDER BY Total_Gastado_Historico DESC;
GO

/*
 QUÉ DEBEMOS VERIFICAR EN LA FUNCIÓN:
- Si el Total_Gastado_Historico > 500.000, el Porcentaje_Descuento_Aplicable debe ser 10.00.
- Si el Total_Gastado_Historico está entre 200.001 y 500.000, debe ser 5.00.
- Si es <= 200.000 (o 0), debe mostrar 0.00.
*/


-- =========================================================
-- PARTE 2: VERIFICACIÓN DEL PROCEDIMIENTO (dbo.sp_RegistrarVentaCompleta)
--EN ESTE SCRIP VERIFICAMOS CADA CAMBIO REALIZADO POR EL PROCEDIMIENTO dbo.sp_RegistrarVentaCompleta

-- PASO A: Revisar el estado INICIAL del producto antes de vender (Ejemplo: Producto 1)
SELECT Cod_Producto, Descripcion, Precio, Stock_Disponible 
FROM Productos 
WHERE Cod_Producto = 1;
GO

-- PASO B: Ejecutar el procedimiento para registrar una nueva venta
-- (Vendemos 2 unidades del producto 1 al cliente 1 con el vendedor 1)
EXEC dbo.sp_RegistrarVentaCompleta
    @cod_cliente = 1,
    @cod_vendedor = 1,
    @cod_metodo_pago = 1,
    @cod_producto = 1,
    @cantidad = 2;
GO

-- PASO C: Comprobar los RESULTADOS en las 3 tablas afectadas

-- 1. Verificar que se creó el encabezado de la venta en Transacciones (Último registro)
SELECT TOP 1 * 
FROM Transacciones 
ORDER BY Cod_Transaccion DESC;

-- 2. Verificar que se insertó el detalle con el precio congelado del catálogo
SELECT TOP 1 * 
FROM Detalle 
ORDER BY cod_transaccion DESC;

-- 3. Verificar que se descontó el stock del producto en la tabla Productos
SELECT Cod_Producto, Descripcion, Precio, Stock_Disponible 
FROM Productos 
WHERE Cod_Producto = 1;
GO

/*
QUÉ DEBEMOS VERIFICAR EN EL PROCEDIMIENTO:
1. En Transacciones debe aparecer una nueva fila con la fecha/hora actual (GETDATE()).
2. En Detalle debe verse el ID de la transacción recién creada, la cantidad (2) y el precio oficial leído automáticamente de Productos.
3. En Productos, la columna Stock_Disponible del producto 1 debe tener exactamente 2 unidades menos que en el Step A.
*/
