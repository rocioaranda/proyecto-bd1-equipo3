# Normalización de la Base de Datos

## 1FN: Eliminación de grupos repetitivos y garantía de atomicidad

Se cumple en todas las tablas porque:

- **Cada atributo es atómico:** no hay columnas que agrupen varios valores.
- **No hay grupos repetitivos:** la relación N:M entre `Transacciones` y `Productos` se resolvió creando la tabla `Detalle`, con una fila por cada producto incluido en cada transacción (clave compuesta `cod_producto` + `cod_transaccion`).
- **Claves primarias definidas:** cada tabla tiene una clave primaria bien definida que identifica unívocamente cada fila (`cod_cliente`, `cod_vendedor`, `cod_producto`, `cod_transaccion`, `cod_proveedor`, `cod_metodo_pago`, y la clave compuesta de `Detalle`).

Con esto, el modelo ya cumple **Primera Forma Normal (1FN)**.

---

## 2FN: Eliminación de dependencias funcionales parciales en claves compuestas

La 2FN aplica sobre todo a tablas con clave compuesta. En el modelo, la única es:

- **`Detalle`** (PK compuesta: `cod_producto` + `cod_transaccion`)
  - **`Cantidad`**: depende de la combinación completa (cuántas unidades de ese producto se vendieron en esa transacción), no de `cod_producto` ni de `cod_transaccion` por separado.
  - **`Precio_unitario`**: también depende de la combinación, porque representa el precio al momento de esa venta puntual. Si dependiera solo de `cod_producto`, habría dependencia parcial y correspondería moverlo a `Productos`.

Todas las demás tablas tienen clave primaria simple (un solo atributo), por lo que la **2FN** se cumple automáticamente en ellas (no puede haber dependencia parcial si no hay clave compuesta).

---

## 3FN: Eliminación de dependencias transitivas en atributos no clave

Se revisa tabla por tabla que ningún atributo no-clave dependa de otro atributo no-clave:

- **`Transacciones`**: `Fecha` depende directamente de `cod_transaccion`. `cod_cliente`, `cod_vendedor` y `cod_metodo_pago` son FKs, no atributos descriptivos, así que no generan dependencia transitiva.
- **`Clientes`**: `nombre`, `apellido`, `domicilio`, `nro_dni`, `nro_contacto` y `razon_social` dependen todos directamente de `cod_cliente`.
- **`Vendedores`**: `nombre`, `apellido`, `domicilio` dependen directamente de `cod_vendedor`.
- **`Productos`**: `categoria`, `marca`, `Stock_disponible`, `Stock_minimo` dependen directamente de `cod_producto`. `cod_proveedor` es FK.
- **`Proveedores` / `Proveedor_Persona` / `Proveedor_empresa`**: se separó CUIT (común a todo proveedor) de los atributos específicos de persona física (`nombre`, `apellido`) o de empresa (`razon_social`). Esto evita que, por ejemplo, `nombre` y `apellido` queden vacíos o mezclados con `razon_social` en una misma tabla, lo cual generaría redundancia y dependencias mal definidas según el tipo de proveedor.
- **`Metodo_de_pago`**: `descripcion` y `estado` dependen directamente de `cod_metodo_pago`. Esta tabla es justamente un ejemplo clave de 3FN: si `descripcion` y `estado` del método de pago hubieran quedado como atributos sueltos dentro de `Transacciones`, `descripcion` dependería de `cod_metodo_pago` (no de `cod_transaccion`), generando una dependencia transitiva. Al extraerlo en su propia tabla, se elimina esa transitividad.
- **`Detalle`**: `Cantidad` y `Precio_unitario` dependen de la clave compuesta completa, sin depender de ningún otro atributo no-clave.

Con esto, el modelo cumple **Tercera Forma Normal (3FN)**: todos los atributos no-clave dependen únicamente de la clave primaria de su tabla, de forma directa.