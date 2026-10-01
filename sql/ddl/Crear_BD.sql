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

CREATE TABLE Proveedores (
    Cod_Proveedor INT IDENTITY(1,1) NOT NULL,
    CUIT VARCHAR(11) NOT NULL UNIQUE,

    CONSTRAINT PK_Cod_Proveedor
        PRIMARY KEY (Cod_Proveedor)
);

CREATE TABLE Proveedor_Persona (
    Cod_Proveedor INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Proveedor_Persona
        PRIMARY KEY (Cod_Proveedor),

    CONSTRAINT FK_Proveedor_Persona_Proveedor
        FOREIGN KEY (Cod_Proveedor)
        REFERENCES Proveedores(Cod_Proveedor)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

CREATE TABLE Proveedor_Empresa (
    Cod_Proveedor INT NOT NULL,
    Razon_Social VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Proveedor_Empresa
        PRIMARY KEY (Cod_Proveedor),

    CONSTRAINT FK_Proveedor_Empresa_Proveedor
        FOREIGN KEY (Cod_Proveedor)
        REFERENCES Proveedores(Cod_Proveedor)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

CREATE TABLE Productos (
    Cod_Producto INT IDENTITY(1,1) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    Stock_Disponible INT NOT NULL CHECK (Stock_disponible >= 0), --PONEMOS LA CONDICION QUE EL STOCK SEA NO NEGATIVO
    Stock_Minimo INT NOT NULL CHECK (Stock_minimo > 0),  --PONEMOS LA CONDICION DE QUE EL STOCK SEA MAYOR A CERO
    cod_Proveedor INT NOT NULL,  --ESTA VA A SER NUESTRA CLAVE FORANEA 

    CONSTRAINT PK_Cod_Producto
        PRIMARY KEY (Cod_Producto), --DEFINIMOS SU CLAVE PRIMARIA 

    CONSTRAINT FK_Productos_Proveedores 
        FOREIGN KEY (cod_Proveedor) 
        REFERENCES Proveedores(cod_Proveedor)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
----------------------------------------------------------------
CREATE TABLE Metodo_De_Pago (
    Cod_Metodo_Pago INT IDENTITY(1,1) ,
    descripcion VARCHAR(50) NOT NULL,

    estado VARCHAR(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO', 'INACTIVO')),

    CONSTRAINT PK_Cod_Metodo_Pago PRIMARY KEY (Cod_Metodo_Pago)
);

CREATE TABLE Transacciones (
    Cod_Transaccion INT IDENTITY(1,1) NOT NULL,
    Fecha DATE NOT NULL ,
    Cod_Cliente INT NOT NULL,
    Cod_Vendedor INT NOT NULL,
    Cod_Metodo_Pago INT NOT NULL,

    CONSTRAINT PK_Cod_Transaccion PRIMARY KEY (Cod_Transaccion), --DEFINIMOS LA CLAVE PRIMARIA DE NUESTRA TABLA

    --LA TABLA 'Transcciones' CONSTA DE TRES CLAVES FORANEAS
    CONSTRAINT FK_Transacciones_Clientes 
        FOREIGN KEY (cod_cliente) 
        REFERENCES Clientes(cod_cliente)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT FK_Transacciones_Vendedores 
        FOREIGN KEY (cod_vendedor) 
        REFERENCES Vendedores(cod_vendedor)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT FK_Transacciones_MetodoPago 
        FOREIGN KEY (cod_metodo_pago) 
        REFERENCES Metodo_De_Pago(cod_metodo_pago)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION

);






