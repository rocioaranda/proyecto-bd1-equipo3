CREATE DATABASE Byte_Motors
GO

USE Byte_Motors;
GO

--Procedemos a crear las tablas (entidades) con sus datos(Atributos) 
--ENTRE LA CUALES SE ENCUENTRAN:
-- 1) Clientes
-- 2) Vendedores
-- 3) Proveedores
-- 4) Proveedor_Persona
-- 5) Proveedor_Empresa
-- 6) Productos
-- 7) Metodo_De_Pago
-- 8) Transacciones
-- 9) Detalle
--PRIMERO CREAMOS LA TABLA DE LOS CLIENTES 


CREATE TABLE Clientes (
    Cod_Cliente INT IDENTITY(1,1) ,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    domicilio VARCHAR(150) NULL,
    Nro_Dni VARCHAR(10) UNIQUE NOT NULL,
    Nro_Contacto VARCHAR(20) NULL,
    Razon_Social VARCHAR(100) NULL,								

    CONSTRAINT PK_Cod_Cliente PRIMARY KEY (Cod_Cliente) --DEFINIMOS SU CLAVE PRIMARIA 
);

SELECT * FROM Clientes

--PRECEDEMOS A CREAR LAS DEMAS TABLAS DE FORMA SIMILAR 

CREATE TABLE Vendedores (
    Cod_Vendedor INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    domicilio VARCHAR(150) NULL,

    CONSTRAINT PK_cod_vendedor PRIMARY KEY (Cod_Vendedor) --DEFINIMOS SU CLAVE PRIMARIA 
);

SELECT * FROM Vendedores




-------------------------------------------------------------------------------------------------------------------------------------------------------------




