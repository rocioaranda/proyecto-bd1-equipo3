# Informe de decisiones de diseño del proyecto

## Etapa 1 – EDR inicial
- **Decisión:** Se definieron las entidades principales (Transacciones, Clientes, Vendedores, Proveedores, Productos, Detalle) y sus relaciones básicas.  
- **Justificación:** Era necesario contar con un modelo conceptual inicial que representara el negocio de ventas de repuestos automotores.  
- **Resultado:** Se obtuvo un primer diagrama E-R que sirvió como base, aunque con redundancias en la entidad Proveedores.

---

## Etapa 2 – Primer diagrama relacional
- **Decisión:** Se transformó el EDR inicial en tablas relacionales, manteniendo una sola tabla de Proveedores con atributos mezclados (nombre, apellido, razón social, CUIT).  
- **Justificación:** Se buscaba una primera traducción rápida al modelo relacional.  
- **Resultado:** Se evidenció redundancia y dificultad para representar correctamente proveedores personas y empresas.

---

## Etapa 3 – Rediseño con especialización
- **Decisión:** Se introdujo la **superclase Proveedor** y los subtipos **Proveedor_Persona** y **Proveedor_Empresa**.  
- **Justificación:** Evitar redundancia y reflejar con claridad que un proveedor puede ser persona física o empresa, pero no ambos.  
- **Resultado:** El EDR se ajustó con especialización, y en el modelo relacional se probó primero solo el caso de proveedor persona.

---

## Etapa 4 – Diagrama relacional definitivo
- **Decisión:** Se implementaron las tres tablas: `Proveedor` (atributos comunes), `Proveedor_Persona` y `Proveedor_Empresa` (atributos específicos).  
- **Justificación:** Cumplir con las reglas de normalización y asegurar integridad mediante PK/FK compartido.  
- **Resultado:** El modelo relacional quedó alineado con el EDR corregido, con relaciones hacia Productos apuntando a la tabla padre Proveedor.  
- **Nota:** Se discutió la necesidad de reglas de negocio (campo `tipo_proveedor` o triggers) para garantizar la disyunción.

---

## Etapa 5 – Normalización (1FN, 2FN, 3FN)
- **Decisión:** Se verificó que todas las tablas cumplen con las formas normales:  
  - **1FN:** Eliminación de grupos repetitivos y garantía de atomicidad.  
  - **2FN:** Eliminación de dependencias parciales en la tabla Detalle.  
  - **3FN:** Eliminación de dependencias transitivas, especialmente separando Método de Pago y especializando Proveedores.  
- **Justificación:** Asegurar que cada atributo dependa únicamente de la clave primaria de su tabla.  
- **Resultado:** El modelo final cumple con 3FN, evitando redundancias y dependencias incorrectas.

---

## Conclusión
Las decisiones de diseño tomadas a lo largo del proyecto muestran su evolució:
1. De un modelo inicial con redundancias.  
2. A un modelo relacional especialización de proveedores.  
3. Esquema normalizado en 3FN.  


