<div align="center">

# 🚗 Byte Motors - Sistema de Gestión Automotriz 🛠️

</div>

<div align="center">

![Estado](https://img.shields.io/badge/Estado-Etapa_5_Finalizada-success?style=for-the-badge)
![Base de Datos](https://img.shields.io/badge/Base_de_Datos-SQL_Server_Express-blue?style=for-the-badge)
![Materia](https://img.shields.io/badge/Materia-BDI_UNNE-orange?style=for-the-badge)

> Este repositorio contiene el diseño, modelado, implementación, seguridad y optimización de una base de datos relacional en SQL Server orientada a gestionar la operativa comercial de una distribuidora de repuestos y accesorios automotrices.
</div>

---

<div align="center">
  
 ## 🕹️ Navegación Principal del Repositorio
 
</div>

<div align="center">

[![Documentación](https://img.shields.io/badge/📁_Documentación_(docs)-007ACC?style=for-the-badge)](./docs/README.md)
[![Scripts SQL](https://img.shields.io/badge/📁_Scripts_SQL_(sql)-CC292B?style=for-the-badge)](./sql/README.md)

</div>

---

## 🧭 Acceso Directo por Etapas

| Etapa | Descripción | Enlace a Documentación | Enlace a Scripts SQL |
| :--- | :--- | :---: | :---: |
| **Etapa 1** | Requerimientos, Alcance y Reglas de Negocio | [📖 Docs Etapa 1](./docs/etapa-01/README.md) | - |
| **Etapa 2** | Modelado DER, Relacional y Normalización | [📐 Docs Etapa 2](./docs/etapa-02/README.md) | - |
| **Etapa 3** | Implementación del Modelo Físico e Integridad | [⚙️ Docs Etapa 3](./docs/etapa-03/README.md) | [💻 DDL / DML](./sql/README.md) |
| **Etapa 4** | Consultas Comerciales e Informes SQL | [📊 Docs Etapa 4](./docs/etapa-04/README.md) | [🔍 Consultas](./sql/consultas/README.md) |
| **Etapa 5** | SPs, Triggers, Seguridad, Transacciones e Índices | [🚀 Docs Etapa 5](./docs/etapa-05/README.md) | [⚡ Objetos Avanzados](./sql/tecnico/README.md) |

---

## 📖 Descripción del Proyecto

El sistema centraliza la información comercial para facilitar la búsqueda de repuestos, llevar el control exacto de las existencias en depósito, registrar a los clientes y empleados (vendedores), y consolidar las transacciones de venta detallando los artículos, cantidades, precios vigentes de lista y formas de pago.

## 👥 Equipo de Desarrollo

- 👨‍💻 Aranda Rocio
- 👨‍💻 Gonzalez Rodrigo Exequiel
- 👨‍💻 López Fernando
- 👨‍💻 Luque Tourn Emmanuel
- 👨‍💻 Romero Cristian

---

## 🎯 Alcance del Sistema

### ✅ Funcionalidades Incluidas

- **Gestión de inventario y catálogo:** Alta, baja y modificación de productos, precios vigentes, categorías, marcas y proveedores.
- **Control de existencias y stock crítico:** Seguimiento de stock disponible y stock mínimo.
- **Gestión de clientes y vendedores:** Registro de datos filiatorios, de contacto y trazabilidad comercial.
- **Registro de ventas atómico:** Procedimientos almacenados transaccionales que actualizan el stock y registran cabeceras y detalles.
- **Seguridad e integridad:** Administración de permisos con mínimos privilegios, usuarios y roles idempotentes (`IF NOT EXISTS`).
- **Auditoría transparente:** Disparadores (`TRIGGERS`) que auditan automáticamente modificaciones de precios de catálogo en `auditoria_producto`.
- **Optimización de consultas:** Estrategias de indexación agrupada y de cobertura para consultas masivas.

### ❌ Funcionalidades Excluidas

- Módulo de contabilidad avanzada y balances financieros.
- Liquidación de sueldos y salarios del personal.
- Integración con AFIP para facturación electrónica.
- Gestión de servicios de taller mecánico o turnos de reparación.

---

## 📜 Reglas de Negocio (Actualizadas)

### 👤 Registro de Clientes
- **RN.01:** Todo cliente que realice una compra debe estar previamente registrado en el sistema con sus datos básicos.
- **RN.02:** El documento de identidad (DNI/CUIT) debe ser único e irrepetible.
- **RN.15 (Descuentos Frecuentes):** El sistema calcula automáticamente un porcentaje de descuento según el volumen histórico acumulado de compras (> $500.000 -> 10%, > $200.000 -> 5%).

### 📦 Catalogación, Precios y Productos
- **RN.03:** Todo producto pertenece obligatoriamente a una categoría.
- **RN.04:** Todo producto pertenece obligatoriamente a una marca específica.
- **RN.05:** Cada producto debe tener un proveedor asociado para su reposición.
- **RN.16 (Precio de Catálogo Base):** Cada producto en la entidad `Productos` posee una columna `Precio` que define el costo vigente de lista.
- **RN.17 (Auditoría de Modificación de Precios):** Cualquier alteración en el valor del precio de un producto dispara de forma automática un registro histórico en la tabla de auditoría con la fecha, usuario y valores anteriores y nuevos.

### 📊 Control de Stock y Transacciones
- **RN.06:** Cada producto posee un indicador de stock actual (`Stock_Disponible >= 0`).
- **RN.07:** Cada producto posee un límite de stock mínimo (`Stock_Minimo > 0`).
- **RN.08:** El sistema aborta cualquier transacción si la cantidad solicitada supera el stock disponible en depósito mediante un `ROLLBACK`.
- **RN.14:** Al confirmarse una venta mediante `sp_RegistrarVentaCompleta`, se descuenta automáticamente del inventario el stock vendido.

### 💳 Ventas e Inmutabilidad
- **RN.09:** El precio de venta unitario se obtiene dinámicamente de `Productos.Precio` y se congela en `Detalle.Precio_unitario` al momento de la venta.
- **RN.10 (Inmutabilidad del Histórico):** La modificación futura del precio de lista de un producto no altera los importes registrados en ventas anteriores.
- **RN.12 / RN.13:** Cada transacción debe asociarse obligatoriamente a un método de pago válido.

---

## 🚀 Despliegue y Ejecución

Para desplegar la base de datos completa en **SQL Server Express**, siga el orden estricto de los scripts ubicados en la carpeta [`/sql`](./sql/README.md):

1. **Creación del Esquema:** [`sql/ddl/crear_BD.sql`](./sql/ddl/Crear_BD.sql)
2. **Carga de Datos Iniciales:** [`sql/dml/datos_pruebas.sql`](./sql/dml/datos_prueba.sql)
3. **Rutinas y Seguridad Avanzada:** [`sql/tecnico/`](./sql/tecnico/README.md)

---
[⬆️ Volver al inicio](#-byte-motors---sistema-de-gestión-automotriz-)
