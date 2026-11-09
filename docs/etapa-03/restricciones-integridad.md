## 1. Integridad de entidad: claves primarias
 
Todas las tablas tienen clave primaria, lo que garantiza que cada fila sea única e identificable.
 
| Tabla | Clave primaria | Tipo |
|---|---|---|
| `Clientes` | `Cod_Cliente` | Simple, autoincremental |
| `Vendedores` | `Cod_Vendedor` | Simple, autoincremental |
| `Proveedores` | `Cod_Proveedor` | Simple, autoincremental |
| `Proveedor_Persona` | `Cod_Proveedor` | Simple, a la vez clave foránea |
| `Proveedor_Empresa` | `Cod_Proveedor` | Simple, a la vez clave foránea |
| `Productos` | `Cod_Producto` | Simple, autoincremental |
| `Metodo_De_Pago` | `Cod_Metodo_Pago` | Simple, autoincremental |
| `Transacciones` | `Cod_Transaccion` | Simple, autoincremental |
| `Detalle` | `(cod_transaccion, cod_producto)` | Compuesta: un producto no puede repetirse dentro de la misma venta |
 
## 2. Integridad referencial: claves foráneas
 
La base tiene 8 claves foráneas. Cada una impide registrar una fila que apunte a un registro inexistente.
 
| Clave foránea | Tabla hija | Tabla padre | `ON DELETE` | `ON UPDATE` |
|---|---|---|---|---|
| `FK_Proveedor_Persona_Proveedor` | `Proveedor_Persona` | `Proveedores` | `CASCADE` | `NO ACTION` |
| `FK_Proveedor_Empresa_Proveedor` | `Proveedor_Empresa` | `Proveedores` | `CASCADE` | `NO ACTION` |
| `FK_Productos_Proveedores` | `Productos` | `Proveedores` | `NO ACTION` | `NO ACTION` |
| `FK_Transacciones_Clientes` | `Transacciones` | `Clientes` | `NO ACTION` | `NO ACTION` |
| `FK_Transacciones_Vendedores` | `Transacciones` | `Vendedores` | `NO ACTION` | `NO ACTION` |
| `FK_Transacciones_MetodoPago` | `Transacciones` | `Metodo_De_Pago` | `NO ACTION` | `NO ACTION` |
| `FK_Detalle_Productos` | `Detalle` | `Productos` | `NO ACTION` | `NO ACTION` |
| `FK_Detalle_Transacciones` | `Detalle` | `Transacciones` | `CASCADE` | `NO ACTION` |
 
### Justificación de las reglas de borrado
 
**`ON DELETE CASCADE`** se usó donde la fila hija no tiene sentido sin su padre:
 
- `Detalle` → `Transacciones`: los renglones de una venta no existen sin la venta. Al borrar la transacción se borran sus renglones.
- `Proveedor_Persona` y `Proveedor_Empresa` → `Proveedores`: son la ficha complementaria del proveedor. Al borrar el proveedor se borra su ficha.
**`ON DELETE NO ACTION`** se usó donde borrar el padre destruiría información histórica:
 
- No se puede borrar un **cliente** o un **vendedor** con ventas registradas.
- No se puede borrar un **método de pago** que ya fue usado. Para dejar de ofrecerlo se lo marca como `INACTIVO`.
- No se puede borrar un **producto** que figura en alguna venta.
- No se puede borrar un **proveedor** que tenga productos asociados.
**`ON UPDATE NO ACTION`** en todas las relaciones: las claves son numéricas autogeneradas y no se modifican, por lo que no se necesita propagar cambios.
 
## 3. Integridad de dominio: restricciones de columna
 
### `UNIQUE`
 
| Tabla | Columna | Motivo |
|---|---|---|
| `Clientes` | `Nro_Dni` | No puede haber dos clientes con el mismo DNI |
| `Proveedores` | `CUIT` | No puede haber dos proveedores con el mismo CUIT |
 
### `CHECK`
 
| Tabla | Columna | Regla | Motivo |
|---|---|---|---|
| `Productos` | `Stock_Disponible` | `>= 0` | El stock no puede ser negativo |
| `Productos` | `Stock_Minimo` | `> 0` | Todo producto debe tener un umbral de reposición |
| `Detalle` | `Cantidad` | `> 0` | No se puede vender cero o menos unidades |
| `Detalle` | `Precio_unitario` | `> 0` | El precio debe ser positivo |
| `Metodo_De_Pago` | `estado` | `IN ('ACTIVO','INACTIVO')` | Solo se admiten esos dos valores |
 
### `DEFAULT`
 
| Tabla | Columna | Valor | Motivo |
|---|---|---|---|
| `Metodo_De_Pago` | `estado` | `'ACTIVO'` | Un método nuevo se habilita por defecto |
 
### `NOT NULL`
 
Los datos que no pueden faltar se declararon obligatorios:
 
| Tabla | Columnas obligatorias |
|---|---|
| `Clientes` | `nombre`, `apellido`, `Nro_Dni` |
| `Vendedores` | `nombre`, `apellido` |
| `Proveedores` | `CUIT` |
| `Proveedor_Persona` | `Nombre`, `Apellido` |
| `Proveedor_Empresa` | `Razon_Social` |
| `Productos` | `categoria`, `marca`, `Stock_Disponible`, `Stock_Minimo`, `cod_Proveedor` |
| `Metodo_De_Pago` | `descripcion` |
| `Transacciones` | `Fecha`, `Cod_Cliente`, `Cod_Vendedor`, `Cod_Metodo_Pago` |
| `Detalle` | `Cantidad`, `Precio_unitario` |
 
Quedan como opcionales (`NULL`) los datos que pueden no existir: `domicilio`, `Nro_Contacto` y `Razon_Social` en `Clientes`, y `domicilio` en `Vendedores`. `Razon_Social` es opcional porque un cliente puede ser una persona física.