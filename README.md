# 🚗 Byte Motors - Sistema de Gestión Automotriz 🛠️

![Estado](https://img.shields.io/badge/Estado-En_Desarrollo-success?style=for-the-badge)
![Base de Datos](https://img.shields.io/badge/Base_de_Datos-Relacional-blue?style=for-the-badge)
![Materia](https://img.shields.io/badge/Materia-BDI_UNNE-orange?style=for-the-badge)

> **Nota del proyecto:** Este repositorio contiene el diseño e implementación de una base de datos relacional orientada a optimizar la gestión operativa de una casa comercializadora de repuestos y accesorios del rubro automotriz.

---

### 🕹️ Navegación del Proyecto
<div align="center">

[![Descripción](https://img.shields.io/badge/📖_Descripción-2b3137?style=for-the-badge)](#descripcion)
[![Equipo](https://img.shields.io/badge/👥_Equipo-2b3137?style=for-the-badge)](#equipo)
[![Alcance](https://img.shields.io/badge/🎯_Alcance-2b3137?style=for-the-badge)](#alcance)
[![Reglas](https://img.shields.io/badge/📜_Reglas_de_Negocio-2b3137?style=for-the-badge)](#reglas)
[![Despliegue](https://img.shields.io/badge/🚀_Despliegue-2b3137?style=for-the-badge)](#despliegue)

</div>

---

## <a name="descripcion"></a>📖 Descripción del Proyecto
El sistema centraliza la información comercial para facilitar la búsqueda de repuestos, llevar el control exacto de las existencias en depósito, registrar a los clientes y empleados (vendedores), y consolidar las transacciones de venta detallando los artículos, cantidades, precios y formas de pago.

## <a name="equipo"></a>👥 Equipo de Desarrollo
El equipo **"Byte Motors"** está integrado por:
* 👨‍💻 Aranda Rocio
* 👨‍💻 Gonzalez Rodrigo Exequiel
* 👨‍💻 Lopez Fernando
* 👨‍💻 Luque Tourn Emmanuel
* 👨‍💻 Romero Cristian

## <a name="alcance"></a>🎯 Alcance del Sistema
A continuación se detalla qué funciones abarca el sistema y cuáles quedan excluidas para esta etapa del proyecto:

```diff
+ FUNCIONALIDADES INCLUIDAS (Dentro del alcance)
+ Gestión de inventario: Alta, baja y modificación de productos, categorías, marcas y proveedores.
+ Control de existencias: Seguimiento del stock disponible y stock mínimo.
+ Gestión de clientes y vendedores: Registro de datos filiatorios y de contacto.
+ Registro de ventas: Transacciones con detalle de cabecera y líneas de detalle.
+ Actualización de inventario: Actualización automática de stock tras cada venta.

- FUNCIONALIDADES EXCLUIDAS (Fuera del alcance)
- Módulo de contabilidad avanzada y balances financieros.
- Liquidación de sueldos y salarios del personal.
- Integración con AFIP para facturación electrónica.
- Gestión de servicios de taller mecánico o turnos de reparación.

📜 Reglas de Negocio (RN)
👤 Registro de Clientes
RN.01: Todo cliente que realice una compra debe estar previamente registrado en el sistema con sus datos básicos (DNI/CUIT, Nombre/Razón Social, Teléfono y Dirección).

RN.02: El documento de identidad debe ser único e irrepetible.

📦 Catalogación y Registro de Productos
RN.03: Todo producto pertenece de manera obligatoria a una categoría.

RN.04: Todo producto pertenece de manera obligatoria a una marca específica.

RN.05: Con cada producto debe registrarse un proveedor asociado para su reposición.

📊 Control de Stock
RN.06: Cada producto posee un indicador de stock actual.

RN.07: Cada producto posee un límite de stock mínimo.

RN.08: El sistema debe evitar el registro de ventas si la cantidad solicitada supera el stock disponible en depósito.

RN.14: Al confirmarse una venta, el sistema descuenta automáticamente del inventario las cantidades vendidas.

💳 Ventas y Pagos
RN.09: El precio de venta unitario se copia al detalle de la venta en el momento exacto en que se efectúa la transacción.

RN.10 (Inmutabilidad): La alteración futura del precio de lista de un producto no debe modificar los importes registrados en ventas pasadas.

RN.12 / RN.13: Cada transacción debe asociarse obligatoriamente a un método de pago válido; no se puede registrar una venta sin definir su forma de pago.
