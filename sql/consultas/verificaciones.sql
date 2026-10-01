-- verificación: cantidad de registros por tabla

SELECT 'Clientes' AS Tabla, COUNT(*) AS Registros FROM Clientes
UNION ALL SELECT 'Vendedores',         COUNT(*) FROM Vendedores
UNION ALL SELECT 'Proveedores',        COUNT(*) FROM Proveedores
UNION ALL SELECT 'Proveedor_Persona', COUNT(*) FROM Proveedor_Persona
UNION ALL SELECT 'Proveedor_Empresa', COUNT(*) FROM Proveedor_Empresa
UNION ALL SELECT 'Productos',         COUNT(*) FROM Productos
UNION ALL SELECT 'Metodo_De_Pago',    COUNT(*) FROM Metodo_De_Pago
UNION ALL SELECT 'Transacciones',     COUNT(*) FROM Transacciones
UNION ALL SELECT 'Detalle',           COUNT(*) FROM Detalle;

--Verificación de registros 

SELECT * FROM Clientes;
SELECT * FROM Vendedores;
SELECT * FROM Proveedores;
SELECT * FROM Proveedor_Persona;
SELECT * FROM Proveedor_Empresa;
SELECT * FROM Productos;
SELECT * FROM Metodo_De_Pago;
SELECT * FROM Transacciones;
SELECT * FROM Detalle;


