# 🎯 Alcance del Sistema - Byte Motors

El presente documento establece los límites operacionales del sistema **Byte Motors**, especificando las capacidades funcionales incluidas en el desarrollo y los módulos excluidos de esta etapa.

---

## ✅ Dentro del Alcance 

1. **Gestión de Inventario:**
   * Alta, baja y modificación de productos.
   * Administración de categorías, marcas y proveedores.

2. **Control de Existencias:**
   * Seguimiento continuo del stock disponible en depósito.
   * Control y alertas sobre límites de stock mínimo.

3. **Gestión de Clientes y Vendedores:**
   * Registro y actualización de datos filiatorios.
   * Administración de datos de contacto operativos.

4. **Registro de Ventas:**
   * Emisión de transacciones con estructura cabecera-detalle.
   * **Cabecera:** Fecha, cliente, vendedor y método de pago.
   * **Líneas de Detalle:** Producto, cantidad y precio unitario aplicado al momento de la venta.

5. **Actualización Automática de Inventario:**
   * Descuento en tiempo real del stock de productos según las líneas de detalle procesadas.

---

## 🚫 Fuera del Alcance 

1. **Módulo de Contabilidad Avanzada:**
   * Generación de balances financieros, libros contables y auditorías impositivas.

2. **Gestión de Recursos Humanos:**
   * Liquidación de sueldos, jornales y salarios del personal.

3. **Integración Fiscal:**
   * Facturación electrónica directa mediante webservices de AFIP / ARCA.

4. **Gestión de Servicios de Taller:**
   * Administración de turnos de reparación, órdenes de trabajo mecánicas o servicios posventa.
