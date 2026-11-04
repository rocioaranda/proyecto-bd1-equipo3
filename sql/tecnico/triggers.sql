USE Byte_Motors;
GO

-- 1. CREACIÓN DE LA TABLA DE AUDITORÍA DE PRODUCTOS

CREATE TABLE auditoria_producto (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    fecha_cambio DATETIME DEFAULT GETDATE(),
    usuario VARCHAR(100) DEFAULT SYSTEM_USER,
    tipo_operacion VARCHAR(10),
    Cod_Producto INT,
    categoria_anterior VARCHAR(50),
    categoria_nueva VARCHAR(50),
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2)
);
GO


-- 2. CREACIÓN DEL TRIGGER DE AUDITORÍA (UPDATE)

CREATE OR ALTER TRIGGER tr_auditoria_productos
ON Productos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO auditoria_producto (
        tipo_operacion, 
        Cod_Producto, 
        categoria_anterior, 
        categoria_nueva, 
        precio_anterior, 
        precio_nuevo
    )
    SELECT 
        'UPDATE',
        i.Cod_Producto,
        d.categoria,
        i.categoria,
        d.Precio,  -- Valor del precio ANTES de la modificación
        i.Precio   -- Valor del precio NUEVO tras la modificación
    FROM INSERTED i
    INNER JOIN DELETED d ON i.Cod_Producto = d.Cod_Producto;
END;
GO


-- 3.  PRUEBAS
-- A. Ver el estado inicial de un producto
SELECT Cod_Producto, categoria, Precio, Stock_Disponible FROM Productos WHERE Cod_Producto = 1;
GO

-- B. Realizar una actualización (Modificar el precio del producto 1)
UPDATE Productos
SET Precio = 19500.00
WHERE Cod_Producto = 1;
GO

-- C. Consultar la tabla de auditoría para verificar la trazabilidad real
SELECT 
    id_auditoria,
    fecha_cambio,
    usuario,
    tipo_operacion,
    Cod_Producto,
    precio_anterior,
    precio_nuevo
FROM auditoria producto;
GO

