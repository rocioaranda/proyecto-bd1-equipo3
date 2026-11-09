# 🚀 Etapa 05: Mecanismos Técnicos Avanzados SGBD

Esta etapa detalla la implementación de componentes avanzados en SQL Server para potenciar la seguridad, automación y rendimiento de **Byte Motors**.

---

## 📚 Contenido de la Etapa

1. **Procedimientos y Funciones Almacenadas:** Rutina `sp_RegistrarVentaCompleta` (registro de ventas dinámico) y `fn_CalcularDescuentoCliente`.
2. **Triggers de Auditoría:** Disparador `tr_auditoria_productos` para registrar automáticamente cambios de precios en `auditoria_producto`.
3. **Manejo de Transacciones:** Control ACID mediante `BEGIN TRAN`, `COMMIT` y `ROLLBACK` frente a falta de stock.
4. **Seguridad y Roles:** Implementación idempotente de `LOGIN`, `USER` y `ROLE` bajo el principio de mínimo privilegio.
5. **Optimización mediante Índices:** Medición de tiempos y lecturas con índices agrupados y de cobertura sobre `VentaHistorica`.

---

[⬅️ Volver a Documentación General](../README.md) | [🏠 Volver al Inicio](../../README.md)