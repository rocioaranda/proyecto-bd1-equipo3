USE Byte_Motors;
GO
-- PARTE 1 Y 2: CREACIÓN DE LA TABLA Y CARGA MASIVA (1 Millón de registros)

CREATE TABLE VentaHistorica
(
    id_venta BIGINT IDENTITY(1,1),
    fecha_venta DATE NOT NULL,
    importe DECIMAL(12,2) NOT NULL
);
GO

SET NOCOUNT ON;
GO

WITH Numeros AS
(
    SELECT TOP (1000000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO VentaHistorica(fecha_venta, importe)
SELECT
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1825, '2020-01-01'),
    RAND(CHECKSUM(NEWID())) * 10000
FROM Numeros;
GO

-- Verificar cantidad de registros cargados
SELECT COUNT(*) AS CantidadRegistros FROM VentaHistorica;
GO

-- PARTE 3: CONSULTA SIN ÍNDICES
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT id_venta, fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO

-- PARTE 4: CREACIÓN DE ÍNDICE AGRUPADO SOBRE LA FECHA
CREATE CLUSTERED INDEX IX_VentaHistorica_Fecha
ON VentaHistorica (fecha_venta);
GO

SELECT id_venta, fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO

-- PARTE 5 Y 6: CREACIÓN DE ÍNDICE CON COBERTURA (Nonclustered + INCLUDE)
DROP INDEX IX_VentaHistorica_Fecha ON VentaHistorica;
GO

CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_Cobertura
ON VentaHistorica (fecha_venta)
INCLUDE (importe);
GO

SELECT fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO