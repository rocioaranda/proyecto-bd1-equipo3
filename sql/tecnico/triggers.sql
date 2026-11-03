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
        -- Como la tabla Productos no tiene columna 'precio' directa sino en detalle, 
        -- simulamos el registro del cambio tomando datos de categoría/stock :
        0.00, -- Precio anterior simulado 
        0.00  -- Precio nuevo simulado
    FROM INSERTED i
    INNER JOIN DELETED d ON i.Cod_Producto = d.Cod_Producto;
END;
GO
