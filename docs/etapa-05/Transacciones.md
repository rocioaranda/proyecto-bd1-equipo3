# 2. Manejo de Transacciones

## 2.1. Definición y Objetivo

Una transacción es un conjunto de operaciones SQL que se ejecutan como una única unidad lógica de trabajo. Su objetivo principal es garantizar que todas las operaciones se completen con éxito o, de lo contrario, se deshagan en su totalidad.

Esto asegura el cumplimiento de las propiedades **ACID**:

- **Atomicidad**
- **Consistencia**
- **Aislamiento**
- **Durabilidad**

---

## 2.2. Ventajas y Aplicaciones

- **Integridad referencial y de datos:** Evita que queden registros incompletos o estados inconsistentes en la base de datos.

- **Control de errores complejos:** Una venta típica en el sistema `Byte_Motors` involucra múltiples tablas de forma simultánea (`Transacciones`, `Detalle` y la actualización del stock en `Productos`). Si ocurre un fallo a mitad de camino, la transacción previene que se registre la venta sin descontar el stock o viceversa.

---

## 2.3. Implementación en SQL Server Express

Se implementa mediante instrucciones de control de flujo transaccional en T-SQL:

- **`BEGIN TRANSACTION`:** Inicia formalmente el bloque transaccional.
- **`COMMIT TRANSACTION`:** Confirma y guarda permanentemente los cambios si todas las operaciones fueron exitosas.
- **`ROLLBACK TRANSACTION`:** Revierte por completo todas las modificaciones realizadas desde el inicio de la transacción si se detecta un error o una condición no válida.

---

## 2.4. Caso Concreto Aplicado al Sistema de Ventas de Byte_Motors

- **Escenario:** Un cliente desea comprar una cantidad determinada de un producto automotriz.

- **Lógica de negocio:** El sistema verifica el stock y consulta el precio vigente de lista en `Productos`.

  - Si hay stock suficiente, registra la venta, inserta el detalle con el precio obtenido y descuenta el stock.
  - Si no hay stock suficiente, la transacción ejecuta un `ROLLBACK` total.