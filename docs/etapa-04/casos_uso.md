# Casos de uso

## Caso de uso 1: Emitir comprobante de venta

-   **Actor:** vendedor o encargado de caja.
-   **Objetivo:** entregar al cliente un comprobante con los datos de la
    venta, los productos, los subtotales y el total a pagar.
-   **Precondición:** la venta existe en `Transacciones` y tiene al
    menos un renglón en `Detalle`.
-   **Flujo:** se indica el número de transacción y el sistema devuelve
    el encabezado y los renglones con su subtotal, más el total.
-   **Resultado:** un comprobante con total consistente con la suma de
    sus renglones.

## Caso de uso 2: Informe de ventas por período

-   **Actor:** gerencia.
-   **Objetivo:** evaluar el desempeño de cada vendedor y el rendimiento
    de cada categoría de producto entre dos fechas.
-   **Precondición:** existen ventas registradas dentro del rango
    consultado.
-   **Flujo:** se definen las fechas `@desde` y `@hasta` y se ejecuta la
    consulta por vendedor o por categoría.
-   **Resultado:** un ranking con cantidad de ventas, unidades vendidas
    y monto total.

## Caso de uso 3: Análisis de clientes y productos de alto valor

-   **Actor:** gerencia, marketing y compras.
-   **Objetivo:** detectar los clientes que más gastan y los productos
    que más ingresos generan, junto con su proveedor.
-   **Precondición:** existen ventas registradas.
-   **Flujo:** se ejecuta la consulta, que compara cada cliente o
    producto contra el promedio general.
-   **Resultado:** listas filtradas con solo los casos que superan el
    promedio.
