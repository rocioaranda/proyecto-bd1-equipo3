# 📋 Reglas de Negocio - Byte Motors

Las siguientes reglas de negocio definen las restricciones, automatizaciones y políticas operativas que rigen el comportamiento de la base de datos relacional del sistema **Byte Motors**.

---

## 👥 Registro de Clientes

* **RN.01 - Registro Obligatorio:** Todo cliente que realice una compra debe estar previamente registrado en el sistema con sus datos básicos (DNI/CUIT, Nombre/Razón Social, Teléfono y Dirección).
* **RN.02 - Identificación Única:** El documento de identidad (DNI/CUIT) debe ser único e irrepetible en la base de datos.

---

## 📦 Catalogación y Registro de Productos

* **RN.03 - Categorización Obligatoria:** Todo producto pertenece de manera obligatoria a una categoría específica (ej. Frenos, Motor, Electricidad).
* **RN.04 - Marca Obligatoria:** Todo producto pertenece de manera obligatoria a una marca específica.
* **RN.05 - Proveedor Asociado:** Con cada producto debe registrarse un proveedor asociado para la posterior reposición del artículo.

---

## 📊 Control de Stock

* **RN.06 - Indicador de Stock Actual:** Cada producto posee un indicador de stock actual disponible.
* **RN.07 - Umbral de Stock Mínimo:** Cada producto posee un límite de stock mínimo para control de alerta de reposición.
* **RN.08 - Validación de Existencias:** El sistema debe evitar el registro de ventas si la cantidad solicitada supera el stock disponible en depósito.

---

## 💰 Historial e Inmutabilidad de Precios Unitarios

* **RN.09 - Copia de Precio en Venta:** El precio de venta unitario de cada producto debe ser copiado al detalle de la venta en el momento exacto en que se efectúa la transacción.
* **RN.10 - Inmutabilidad Histórica:** La alteración o actualización futura del precio de lista de un producto no debe modificar los importes registrados en las ventas pasadas.

---

## 💳 Métodos de Pago

* **RN.11 - Registro de Formas de Pago:** Definición e independización de los métodos de pago aceptados en el sistema.
* **RN.12 - Asociación Obligatoria:** Cada transacción de venta debe asociarse de manera obligatoria a un método de pago válido (ej. Efectivo, Tarjeta de Débito, Tarjeta de Crédito, Transferencia Bancaria).
* **RN.13 - Restricción de Venta:** Una venta no puede registrarse sin definir explícitamente su forma de pago.

---

## 🔄 Automatización de Inventario

* **RN.14 - Descuento Automático de Stock:** Al confirmarse y guardarse una transacción de venta, el sistema debe descontar automáticamente del inventario las cantidades vendidas de cada producto incluido en el detalle.
