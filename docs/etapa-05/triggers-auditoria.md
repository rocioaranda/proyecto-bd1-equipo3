# Triggers 

## 1. Definición y Objetivo

Los **triggers** (*disparadores*) son procedimientos almacenados especiales que se ejecutan de manera automática en el servidor de base de datos cuando ocurre un evento DML específico sobre una tabla, tales como `INSERT`, `UPDATE` o `DELETE`. 

Su objetivo principal es garantizar la integridad de las reglas de negocio complejas y mantener un registro detallado de trazabilidad y auditoría sobre los cambios en los datos.   

---

## 2. Ventajas y Aplicaciones

* **Trazabilidad y Control:** Permiten responder de forma exacta a preguntas críticas de seguridad y auditoría, tales como:
  * ¿Quién modificó un precio?
  * ¿Cuándo se eliminó un producto?
  * ¿Qué valor tenía el registro antes de la modificación?  
* **Automatización transparente:** Se ejecutan a nivel de motor de base de datos de forma independiente a la aplicación cliente, evitando que los usuarios puedan omitir registros de control de cambios.
* **Seguridad y auditoría interna:** Ideales para almacenar copias históricas de modificaciones en tablas sensibles (como precios de productos, stock crítico o datos de clientes).

---

## 3. Implementación en SQL Server Express 

* Se implementan mediante la instrucción `CREATE TRIGGER`.
* Hacen uso de dos tablas virtuales y temporales creadas internamente por el motor durante la ejecución del evento:
  * **`DELETED`:** Almacena las copias de las filas afectadas por las operaciones `DELETE` o `UPDATE` (contiene los valores anteriores).  
  * **`INSERTED`:** Almacena las copias de las filas afectadas por las operaciones `INSERT` o `UPDATE` (contiene los valores nuevos).

---

## 4. Caso Concreto Aplicado al Sistema de Ventas de Byte_Motors

**Escenario:** En el sistema de ventas **Byte_Motors**, la modificación del precio o de los datos de un producto es una operación crítica. Para llevar un control estricto de cualquier cambio, implementaremos una tabla de auditoría llamada `auditoria_producto` que registre automáticamente:
* La fecha de la modificación.
* La operación realizada.
* El producto afectado.
* Los valores anterior y nuevo del precio unitario o datos relevantes.
