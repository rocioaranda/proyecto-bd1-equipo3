Las pruebas se dividen en cuatro grupos:
 
1. Verificación de la estructura.
2. Verificación de los datos cargados.
3. Pruebas negativas (inserciones y borrados que deben fallar).
4. Pruebas de borrado en cascada.

## 1. Verificación de la estructura
 
### 1.1 Tablas creadas
 
```sql
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
```
 
**Resultado esperado:** 9 tablas (`Clientes`, `Vendedores`, `Proveedores`, `Proveedor_Persona`, `Proveedor_Empresa`, `Productos`, `Metodo_De_Pago`, `Transacciones`, `Detalle`).

### 1.2 Claves foráneas y sus reglas
 
```sql
SELECT fk.name                              AS Clave_Foranea,
       OBJECT_NAME(fk.parent_object_id)     AS Tabla_Hija,
       OBJECT_NAME(fk.referenced_object_id) AS Tabla_Padre,
       fk.delete_referential_action_desc    AS On_Delete,
       fk.update_referential_action_desc    AS On_Update
FROM sys.foreign_keys fk
ORDER BY Tabla_Hija;
```
 
**Resultado esperado:** 8 filas. `On_Delete` es `CASCADE` en `FK_Proveedor_Persona_Proveedor`, `FK_Proveedor_Empresa_Proveedor` y `FK_Detalle_Transacciones`, y `NO_ACTION` en las otras cinco. `On_Update` es `NO_ACTION` en las ocho.
 
### 1.3 Restricciones `CHECK`
 
```sql
SELECT OBJECT_NAME(parent_object_id) AS Tabla, name AS Restriccion, definition
FROM sys.check_constraints;
```
 
**Resultado esperado:** 5 filas, correspondientes a `Stock_Disponible`, `Stock_Minimo`, `Cantidad`, `Precio_unitario` y `estado`.
 
### 1.4 Restricciones `UNIQUE` y claves primarias
 
```sql
SELECT OBJECT_NAME(parent_object_id) AS Tabla, name AS Restriccion, type_desc
FROM sys.key_constraints
ORDER BY type_desc, Tabla;
```
 
**Resultado esperado:** 9 claves primarias y 2 restricciones `UNIQUE` (`Nro_Dni` en `Clientes` y `CUIT` en `Proveedores`).
 
## 2. Verificación de los datos cargados
 
### 2.1 Cantidad de registros por tabla
 
```sql
SELECT 'Clientes' AS Tabla, COUNT(*) AS Registros FROM Clientes
UNION ALL SELECT 'Vendedores',        COUNT(*) FROM Vendedores
UNION ALL SELECT 'Proveedores',       COUNT(*) FROM Proveedores
UNION ALL SELECT 'Proveedor_Persona', COUNT(*) FROM Proveedor_Persona
UNION ALL SELECT 'Proveedor_Empresa', COUNT(*) FROM Proveedor_Empresa
UNION ALL SELECT 'Productos',         COUNT(*) FROM Productos
UNION ALL SELECT 'Metodo_De_Pago',    COUNT(*) FROM Metodo_De_Pago
UNION ALL SELECT 'Transacciones',     COUNT(*) FROM Transacciones
UNION ALL SELECT 'Detalle',           COUNT(*) FROM Detalle;
```
 
**Resultado esperado:**
 
| Tabla | Registros |
|---|---|
| Clientes | 10 |
| Vendedores | 8 |
| Proveedores | 16 |
| Proveedor_Persona | 8 |
| Proveedor_Empresa | 8 |
| Productos | 10 |
| Metodo_De_Pago | 4 |
| Transacciones | 10 |
| Detalle | 17 |
 
### 2.2 Búsqueda de registros huérfanos
 
Estas consultas deben devolver **0 filas**: no hay hijos sin padre.
 
```sql
-- Renglones de detalle sin transacción
SELECT d.* FROM Detalle d
LEFT JOIN Transacciones t ON t.Cod_Transaccion = d.cod_transaccion
WHERE t.Cod_Transaccion IS NULL;
 
-- Renglones de detalle sin producto
SELECT d.* FROM Detalle d
LEFT JOIN Productos p ON p.Cod_Producto = d.cod_producto
WHERE p.Cod_Producto IS NULL;
 
-- Transacciones sin cliente, vendedor o método de pago
SELECT t.* FROM Transacciones t
LEFT JOIN Clientes c       ON c.Cod_Cliente      = t.Cod_Cliente
LEFT JOIN Vendedores v     ON v.Cod_Vendedor     = t.Cod_Vendedor
LEFT JOIN Metodo_De_Pago m ON m.Cod_Metodo_Pago  = t.Cod_Metodo_Pago
WHERE c.Cod_Cliente IS NULL OR v.Cod_Vendedor IS NULL OR m.Cod_Metodo_Pago IS NULL;
```
 
### 2.3 Coherencia de la especialización de proveedores
 
Cada proveedor debe figurar en **exactamente una** de las dos tablas hijas. La consulta debe devolver **0 filas**:
 
```sql
SELECT pr.Cod_Proveedor
FROM Proveedores pr
LEFT JOIN Proveedor_Persona pp ON pp.Cod_Proveedor = pr.Cod_Proveedor
LEFT JOIN Proveedor_Empresa pe ON pe.Cod_Proveedor = pr.Cod_Proveedor
WHERE (pp.Cod_Proveedor IS NULL AND pe.Cod_Proveedor IS NULL)
   OR (pp.Cod_Proveedor IS NOT NULL AND pe.Cod_Proveedor IS NOT NULL);
```
 
### 2.4 Coherencia de stock y de importes
 
```sql
-- Productos por debajo del stock mínimo (esperado: 0 filas con los datos de prueba)
SELECT * FROM Productos WHERE Stock_Disponible < Stock_Minimo;
 
-- Total general vendido (esperado: 1324108.00)
SELECT SUM(Cantidad * Precio_unitario) AS Total_General FROM Detalle;
```
 
## 3. Pruebas negativas
 
Cada una de estas sentencias **debe fallar**. Que la base muestre el error es el resultado correcto: significa que la restricción funciona. 
 
| Nº | Qué se prueba | Sentencia | Error esperado |
|---|---|---|---|
| 1 | `UNIQUE` en DNI | `INSERT INTO Clientes (nombre, apellido, Nro_Dni) VALUES ('Test','Test','30111222');` | Msg 2627: violación de la restricción `UNIQUE` |
| 2 | `UNIQUE` en CUIT | `INSERT INTO Proveedores (CUIT) VALUES ('20301234561');` | Msg 2627: violación de la restricción `UNIQUE` |
| 3 | `NOT NULL` | `INSERT INTO Clientes (nombre, apellido, Nro_Dni) VALUES (NULL,'Test','99999999');` | Msg 515: no se puede insertar `NULL` en `nombre` |
| 4 | `CHECK` de stock negativo | `INSERT INTO Productos (categoria, marca, Stock_Disponible, Stock_Minimo, cod_Proveedor) VALUES ('Test','Test',-1,5,1);` | Msg 547: conflicto con `CHECK` |
| 5 | `CHECK` de stock mínimo | `INSERT INTO Productos (categoria, marca, Stock_Disponible, Stock_Minimo, cod_Proveedor) VALUES ('Test','Test',10,0,1);` | Msg 547: conflicto con `CHECK` |
| 6 | `CHECK` de cantidad | `INSERT INTO Detalle (cod_transaccion, cod_producto, Cantidad, Precio_unitario) VALUES (1,2,0,100.00);` | Msg 547: conflicto con `CHECK` |
| 7 | `CHECK` de precio | `INSERT INTO Detalle (cod_transaccion, cod_producto, Cantidad, Precio_unitario) VALUES (1,2,1,-50.00);` | Msg 547: conflicto con `CHECK` |
| 8 | `CHECK` de estado | `INSERT INTO Metodo_De_Pago (descripcion, estado) VALUES ('Prueba','OTRO');` | Msg 547: conflicto con `CHECK` |
| 9 | `PRIMARY KEY` compuesta | `INSERT INTO Detalle (cod_transaccion, cod_producto, Cantidad, Precio_unitario) VALUES (1,1,1,100.00);` | Msg 2627: violación de la clave primaria (el producto 1 ya está en la venta 1) |
| 10 | `FOREIGN KEY`: cliente inexistente | `INSERT INTO Transacciones (Fecha, Cod_Cliente, Cod_Vendedor, Cod_Metodo_Pago) VALUES ('2026-10-01',999,1,1);` | Msg 547: conflicto con `FK_Transacciones_Clientes` |
| 11 | `FOREIGN KEY`: proveedor inexistente | `INSERT INTO Productos (categoria, marca, Stock_Disponible, Stock_Minimo, cod_Proveedor) VALUES ('Test','Test',10,5,999);` | Msg 547: conflicto con `FK_Productos_Proveedores` |
| 12 | `NO ACTION`: borrar un cliente con ventas | `DELETE FROM Clientes WHERE Cod_Cliente = 1;` | Msg 547: conflicto con `FK_Transacciones_Clientes` |
| 13 | `NO ACTION`: borrar un producto vendido | `DELETE FROM Productos WHERE Cod_Producto = 1;` | Msg 547: conflicto con `FK_Detalle_Productos` |
| 14 | `NO ACTION`: borrar un proveedor con productos | `DELETE FROM Proveedores WHERE Cod_Proveedor = 9;` | Msg 547: conflicto con `FK_Productos_Proveedores` |
 

## 4. Pruebas de borrado en cascada
 
Estas pruebas se ejecutan dentro de una transacción que se revierte al final, para no perder datos.
 
### 4.1 Borrar una venta elimina sus renglones
 
```sql
BEGIN TRAN;
 
SELECT COUNT(*) AS Renglones_Antes FROM Detalle WHERE cod_transaccion = 1;   -- esperado: 2
DELETE FROM Transacciones WHERE Cod_Transaccion = 1;
SELECT COUNT(*) AS Renglones_Despues FROM Detalle WHERE cod_transaccion = 1; -- esperado: 0
 
ROLLBACK;
```
 
### 4.2 Borrar un proveedor elimina su ficha
 
El proveedor 2 no tiene productos asociados, por lo que se puede borrar.
 
```sql
BEGIN TRAN;
 
SELECT COUNT(*) AS Fichas_Antes FROM Proveedor_Persona WHERE Cod_Proveedor = 2;   -- esperado: 1
DELETE FROM Proveedores WHERE Cod_Proveedor = 2;
SELECT COUNT(*) AS Fichas_Despues FROM Proveedor_Persona WHERE Cod_Proveedor = 2; -- esperado: 0
 
ROLLBACK;
```
