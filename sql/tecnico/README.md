# ⚡ Scripts SQL: Mecanismos Técnicos Avanzados (`sql/tecnico/`)

En este directorio se encuentran los scripts T-SQL correspondientes a la **Etapa 5** del proyecto.

---

## 📜 Objetos Técnicos Implementados

1. **Procedimientos y Funciones Almacenadas:** Script para la creación de `sp_RegistrarVentaCompleta` (con obtención automática de precio desde `Productos`) y `fn_CalcularDescuentoCliente`.
2. **Triggers de Auditoría:** Script que define la tabla `auditoria_producto` y el disparador `tr_auditoria_productos` para auditar actualizaciones de precios.
3. **Manejo de Transacciones:** Scripts de prueba para verificar transacciones con `COMMIT` (caso correcto) y `ROLLBACK` (falta de stock).
4. **Seguridad y Permisos:** Script idempotente (`IF NOT EXISTS`) para la administración de `LOGINS`, `USERS`, `ROLES` y permisos `GRANT EXECUTE`.
5. **Optimización con Índices:** Script con prueba masiva ($1.000.000$ de filas) en `VentaHistorica` evaluando índices agrupados y de cobertura.

---

[⬅️ Volver al Menú SQL](../README.md) | [🏠 Volver al Inicio](../../README.md)