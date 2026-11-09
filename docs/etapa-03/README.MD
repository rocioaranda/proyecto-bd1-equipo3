
# ⚙️ Etapa 03: Implementación del Modelo Físico

En esta etapa se documenta cómo el modelo lógico derivado de la Etapa 2 fue llevado formalmente al Motor **SQL Server Express**, garantizando restricciones de integridad relacional.

---

## 📋 Puntos Clave de la Implementación

1. **Creación de Tablas:** Mapeo de claves primarias (`IDENTITY`) y claves foráneas (`FOREIGN KEY`).
2. **Restricciones de Integridad:** Aplicación de cláusulas `CHECK` (stock positivo, precios `>= 0`) y claves únicas `UNIQUE` (DNI/CUIT).
3. **Evolución del Esquema:** Adición de la columna `Descripcion` y la columna clave `Precio` a la tabla `Productos`.

---

[⬅️ Volver a Documentación General](../README.md) | [🏠 Volver al Inicio](../../README.md)
