# Comprobante de venta

Cada vez que se concreta una venta, el cliente necesita un comprobante que muestre quién vendió, quién compró, cómo pagó, qué productos se llevó y cuánto debe abonar. La información está repartida en seis tablas, y la consulta la consolida en un solo resultado.

## Estrategia SQL

**Tablas involucradas:** `Transacciones`, `Clientes`, `Vendedores`, `Metodo_De_Pago`, `Detalle` y `Productos`.

### Técnicas utilizadas

- **`INNER JOIN`:** une el encabezado (`Transacciones`) con cada entidad relacionada mediante sus claves foráneas. Se usa `INNER JOIN` porque todas las FK son `NOT NULL`, por lo que toda venta tiene cliente, vendedor, método de pago y al menos un renglón.
- **Subtotal por renglón:** se calcula con la expresión `Cantidad * Precio_unitario`, sin guardarlo en la tabla. Así se evita redundancia y el dato nunca queda desactualizado.
- **Total acumulado:** se obtiene con la función de ventana `SUM(...) OVER (ORDER BY cod_producto ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`, que suma los subtotales renglón a renglón.
- **Total final (consulta 1.b):** se usa `GROUP BY cod_transaccion` con `SUM` y `COUNT` sobre `Detalle`.
- **Parámetro:** la variable `cod_transaccion` permite emitir el comprobante de cualquier venta sin modificar la consulta.
- **`ISNULL`:** se aplica sobre `Razon_Social`, que admite `NULL`, para mostrar un guion cuando el cliente no tiene ese dato.

Como `Productos` no tiene un campo de nombre, el producto se identifica concatenando `categoria` y `marca`.
