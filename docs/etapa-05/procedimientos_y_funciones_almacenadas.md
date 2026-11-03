# Procedimientos Almacenados y Funciones

## 1. Definición y Objetivo

* **Funciones Almacenadas (*User-Defined Functions - UDFs*):** Son rutinas de programación escritas en T-SQL que aceptan parámetros de entrada, realizan un cálculo u operaciones lógicas, y devuelven un valor (puede ser un valor escalar como un número o una cadena, o bien una tabla). Su objetivo principal es encapsular lógica reutilizable que se integra directamente en consultas SQL (cláusulas `SELECT`, `WHERE`, `HAVING`).

* **Procedimientos Almacenados (*Stored Procedures - SPs*):** Son conjuntos precompilados de instrucciones T-SQL guardados en el servidor de base de datos. Su objetivo es ejecutar tareas complejas de modificación, inserción, eliminación o consulta de datos, permitiendo manejar parámetros de entrada/salida, lógica condicional, control de transacciones (`BEGIN TRAN`, `COMMIT`, `ROLLBACK`) y manejo de errores.

---

## 2. Ventajas y Aplicaciones

* **Rendimiento optimizado:** Se compilan la primera vez que se ejecutan y su plan de ejecución se almacena en caché, reduciendo la sobrecarga de compilación en el motor.
* **Modularidad y Mantenimiento:** Centralizan las reglas de negocio en la base de datos, evitando duplicar código en las aplicaciones cliente.
* **Seguridad y Control de Acceso:** Permiten otorgar permisos de ejecución sobre los procedimientos o funciones sin necesidad de otorgar privilegios directos de lectura o escritura sobre las tablas subyacentes.
* **Reducción del tráfico de red:** En lugar de enviar múltiples consultas separadas desde la aplicación hacia el servidor, se ejecuta una única llamada al procedimiento.

---

## 3. Implementación en SQL Server Express

* Se implementan mediante las sentencias DDL `CREATE FUNCTION` y `CREATE PROCEDURE`.
* Exigen definir explícitamente el tipo de datos de cada parámetro y, en el caso de las funciones, el tipo de dato que retornará la cláusula `RETURNS`.

---

## 4. Caso Concreto Aplicado al Sistema de Ventas de `Byte_Motors`

* **Función (`dbo.fn_CalcularDescuentoCliente`):** Resuelve el problema de negocio de calcular de forma automática el porcentaje de descuento para clientes frecuentes basándose en el monto histórico acumulado de sus compras en el sistema `Byte_Motors`:  
  * Más de $\$500.000$ acumulados: se aplica **10%** de descuento.   
  * Más de $\$200.000$ acumulados: se aplica **5%** de descuento.   
  * Caso contrario: se aplica **0%** de descuento.

* **Procedimiento Almacenado (`dbo.sp_RegistrarVentaCompleta`):** Resuelve el problema de negocio de registrar una venta completa de forma atómica y segura (insertando la cabecera en `Transacciones`, el detalle en `detalle` y actualizando el stock disponible de los productos), evitando que el usuario deba ejecutar múltiples consultas manuales por separado. 

---

## 5. Script de Demostración y Resultados Obtenidos

*(Nota: Este script debe ejecutarse en el motor de base de datos SQL Server)*

```sql
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