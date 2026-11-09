--4. Seguridad: Permisos y Roles en SQL Server

USE Byte_Motors;
GO

-- 1. Creación de Inicios de Sesión (Logins) y Usuarios de Base de Datos
CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector123*';
GO

CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_lector FOR LOGIN usuario_lector;
GO

-- 2. Asignación de Permisos
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GO

GRANT SELECT ON dbo.Transacciones TO usuario_lector;
GO

GRANT EXECUTE ON dbo.sp_RegistrarVentaCompleta TO usuario_lector;
GO

--=====================================================================================================================================

--Parte 2: Permisos a nivel de roles personalizados SQL

CREATE LOGIN usuario_con_rol WITH PASSWORD = 'Rol123*';
CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'Rol456*';
GO

CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;
CREATE USER usuario_sin_rol FOR LOGIN usuario_sin_rol;
GO

CREATE ROLE rol_consulta_productos;
GO

GRANT SELECT ON dbo.Productos TO rol_consulta_productos;
GO

ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
GO
