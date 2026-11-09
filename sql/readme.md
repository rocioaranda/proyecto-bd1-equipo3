# 📁 Sección de Scripts SQL (`sql/`)

Esta carpeta contiene todos los scripts ejecutables en SQL Server Express para construir, poblar, consultar y optimizar la base de datos **Byte Motors**.

---

## 🧭 Estructura del Directorio SQL

```
sql/
├── ddl/          --> Scripts de definición de estructura (CREATE TABLE, ALTER TABLE)
├── dml/          --> Scripts de carga y actualización de datos (INSERT, UPDATE)
├── consultas/    --> Consultas de reporte y análisis comercial (SELECT, JOIN, GROUP BY)
└── tecnico/      --> Procedimientos, Funciones, Triggers, Seguridad e Índices
```

---

## 🚀 Orden Recomendado de Ejecución

1. [📌 **DDL:** `sql/ddl/crear_BD.sql`](./ddl/crear_BD.sql) (Crea la BD y la estructura de tablas)
2. [📌 **DML:** `sql/dml/datos_pruebas.sql`](./dml/datos_pruebas.sql) (Pobla las tablas con datos y precios)
3. [📌 **TÉCNICO:** `sql/tecnico/`](./tecnico/README.md) (Compila SPs, Triggers y la Seguridad del sistema)
4. [📌 **CONSULTAS:** `sql/consultas/`](./consultas/README.md) (Ejecuta las consultas y reportes de prueba)

---

[⬅️ Volver al README Principal](../README.md)
