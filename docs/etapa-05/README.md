# ⚙️ Etapa 05: Mecanismos Técnicos Avanzados y Seguridad

Esta etapa aborda los aspectos técnicos y arquitectónicos avanzados de la base de datos de **Byte_Motors**, enfocándose en la automatización de reglas de negocio, la integridad de datos, la seguridad de accesos y la optimización de consultas.

---

## 📚 Documentos de la Etapa

- [⚙️ Procedimientos Almacenados y Funciones](./procedimientos_y_funciones_almacenadas.md): Encapsulamiento de reglas de negocio, cálculo de descuentos para clientes frecuentes (`fn_CalcularDescuentoCliente`) y registro atómico de ventas (`sp_RegistrarVentaCompleta`).
- [🔄 Manejo de Transacciones](./Transacciones.md): Control de propiedades ACID (`BEGIN TRAN`, `COMMIT`, `ROLLBACK`) para garantizar operaciones completas y seguras en la actualización de stock e historiales.
- [🔔 Triggers y Auditoría](./triggers-auditoria.md): Disparadores automáticos sobre eventos DML e implementación de la tabla `auditoria_producto` para el control de cambios de precios y stock.
- [🔒 Seguridad: Permisos y Roles](./Seguridad.md): Gestión de `LOGINS`, `USERS`, roles personalizados (`rol_consulta_productos`) y aplicación del principio de mínimo privilegio.
- [⚡ Optimización de Consultas e Índices](./optimizacion_consultas_indices.md): Estrategias de índices agrupados y no agrupados (`CLUSTERED` / `NONCLUSTERED`) para mejorar el tiempo de respuesta sobre grandes volúmenes de datos.

---

[⬅️ Volver a Documentación General](../README.md) | [🏠 Volver al Inicio](../../README.md)
