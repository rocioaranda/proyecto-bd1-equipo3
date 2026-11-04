# Seguridad: Permisos y Roles en SQL Server

## 1. Definición y Objetivo

La seguridad en una base de datos permite controlar de manera estricta qué usuarios pueden acceder a la información y qué operaciones específicas tienen permitido realizar.

Su objetivo principal es proteger los datos sensibles del sistema, evitar modificaciones accidentales o maliciosas y aplicar formalmente el **principio de mínimo privilegio**.

---

## 2. Ventajas y Aplicaciones

- **Protección de datos:** Blindan la información crítica del negocio frente a accesos no autorizados.
- **Control de responsabilidades:** Permiten aislar perfiles (por ejemplo, operarios de ventas, auditores o lectores) según sus tareas cotidianas.
- **Mantenibilidad y reutilización:** La administración mediante roles agrupa permisos comunes, simplificando la gestión de accesos a medida que la base de datos escala.

---

## 3. Implementación en SQL Server Express

Se implementa mediante comandos de administración de seguridad en T-SQL:

- **`CREATE LOGIN` / `CREATE USER`:** Crean las credenciales de acceso al servidor y su respectivo mapeo en la base de datos.
- **`GRANT`:** Otorga permisos específicos (como `SELECT`, `INSERT` o `EXECUTE`) sobre tablas o procedimientos a usuarios o roles.
- **`CREATE ROLE` y `ALTER ROLE`:** Permiten crear roles personalizados y asociarles miembros para agrupar privilegios.

---

## 4. Caso Concreto Aplicado al Sistema de Ventas de Byte_Motors

**Escenario:**

En `Byte_Motors` existen diferentes tipos de usuarios. Por un lado, un administrador con control total (`db_owner`); por otro, un usuario con permisos limitados de lectura sobre productos que no puede alterar tablas directamente, pero que está autorizado a registrar operaciones de manera controlada invocando el procedimiento almacenado de ventas.
