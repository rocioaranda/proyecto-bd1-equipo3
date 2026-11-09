# 5\. Optimización de consultas a través de índices

## 1\. Definición y objetivo

Los índices son estructuras que SQL Server utiliza para localizar información de forma más eficiente, operando de manera similar al índice alfabético de un libro.

Su objetivo principal es evitar que el motor de base de datos deba recorrer la totalidad de una tabla (*Table Scan*) al procesar consultas sobre grandes volúmenes de datos.



## 2\. Ventajas y aplicaciones

* Mejoran el rendimiento de las consultas de búsqueda.
* Reducen los tiempos de respuesta en tablas con una alta cantidad de registros.
* Disminuyen la cantidad de lecturas lógicas ejecutadas por el motor.
* Optimizan los filtros aplicados por fechas, códigos, clientes o productos.
* Facilitan la escalabilidad del sistema.



**Consideración:** Los índices consumen espacio en disco y pueden afectar levemente el rendimiento de las operaciones `INSERT`, `UPDATE` y `DELETE`, porque deben mantenerse actualizados.



## 3\. Implementación en SQL Server Express

Se implementan mediante instrucciones DDL específicas del motor:

* `CREATE CLUSTERED INDEX`: organiza y reordena físicamente las filas de la tabla en función de la columna clave.
* `CREATE NONCLUSTERED INDEX ... INCLUDE (...)`: crea un índice no agrupado que incluye columnas adicionales para cubrir la consulta sin requerir accesos complementarios a la tabla.



## 4\. Caso concreto aplicado al sistema de ventas de Byte\_Motors

**Escenario:** El sistema registra operaciones comerciales de forma masiva en una tabla histórica denominada `VentaHistorica`.

La empresa necesita optimizar la velocidad de análisis y filtrado de las ventas efectuadas en determinados rangos de tiempo, sobre un volumen superior a un millón de registros.

