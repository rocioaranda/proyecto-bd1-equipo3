# Del modelo lógico al modelo físico

- **Entidad ->** Una tabla (`CREATE TABLE`).
- **Atributo ->** Una columna con tipo de dato y restricciones.
- **Identificador de la entidad ->** Clave primaria; en las entidades principales es `INT IDENTITY(1,1)` autoincremental.
- **Relación 1:N ->** Clave foránea en la tabla del lado "muchos".
- **Relación N:M entre Transacciones y Productos ->** Tabla intermedia `Detalle`, con clave primaria compuesta (`cod_transaccion`, `cod_producto`) y los atributos propios de la relación (`Cantidad`, `Precio_unitario`).
- **Especialización de Proveedor (persona o empresa) ->** Tabla general `Proveedores` y dos tablas hijas, `Proveedor_Persona` y `Proveedor_Empresa`, cuya clave primaria es a la vez clave foránea hacia `Proveedores`.

## Tablas creadas

| N.º | Tabla | Clave primaria | Clave foránea |
|---|---|---|---|
| 1 | Clientes | `Cod_Cliente` | — |
| 2 | Vendedores | `Cod_Vendedor` | — |
| 3 | Proveedores | `Cod_Proveedor` | — |
| 4 | Proveedor_Persona | `Cod_Proveedor` | `Proveedores` |
| 5 | Proveedor_Empresa | `Cod_Proveedor` | `Proveedores` |
| 6 | Productos | `Cod_Producto` | `Proveedores` |
| 7 | Metodo_De_Pago | `Cod_Metodo_Pago` | — |
| 8 | Transacciones | `Cod_Transaccion` | `Clientes`, `Vendedores`, `Metodo_De_Pago` |
| 9 | Detalle | (`cod_transaccion`, `cod_producto`) | `Transacciones`, `Productos` |

## Orden de creación

Una tabla solo puede referenciar a otra que ya existe, por eso el orden de creación sigue las dependencias:

1. **Primero las tablas independientes:** `Clientes`, `Vendedores`, `Proveedores` y `Metodo_De_Pago`.
2. **Después las que dependen de ellas:** `Proveedor_Persona`, `Proveedor_Empresa` y `Productos`.
3. **Luego Transacciones**, que referencia a tres tablas.
4. **Por último Detalle**, que referencia a `Transacciones` y `Productos`.

## Tipos de datos elegidos

| Dato | Tipo | Justificación |
|---|---|---|
| Códigos (claves) | `INT IDENTITY(1,1)` | Numeración automática, única y sin intervención del usuario. |
| Nombres y apellidos | `VARCHAR(50)` | Longitud suficiente para nombres comunes. |
| Domicilio | `VARCHAR(150)` | Admite calle, número y localidad. |
| Nro_Dni | `VARCHAR(10)` | Es un identificador, no se opera aritméticamente; evita perder ceros iniciales. |
| Nro_Contacto | `VARCHAR(20)` | Admite guiones, prefijos y espacios. |
| CUIT | `VARCHAR(11)` | 11 dígitos, almacenados sin guiones. |
| Razon_Social | `VARCHAR(100)` | Los nombres de empresa suelen ser largos. |
| Precio_unitario | `DECIMAL(10,2)` | Un precio puede tener centavos (por ejemplo, 15000.50); `INT` los perdería y `FLOAT` introduciría errores de redondeo. |
| Cantidad, Stock_* | `INT` | Son cantidades enteras. |
| Fecha | `DATE` | Alcanza para registrar el día de la venta. |
| estado | `VARCHAR(20)` | Valores de texto controlados con una restricción `CHECK`. |

## Decisiones de diseño

- **Subtotal:** No se almacena. Se calcula con `Cantidad * Precio_unitario` en las consultas, lo que evita datos redundantes que puedan quedar desactualizados.

- **Eliminación en cascada:** Se aplica solo donde tiene sentido. Si se borra una transacción, se borran sus renglones; si se borra un proveedor, se borra su ficha de persona o empresa. En el resto de las relaciones se impide el borrado.

- **Especialización de proveedores:** Un proveedor es persona o empresa. Se modela con dos tablas hijas que comparten la clave del proveedor.
