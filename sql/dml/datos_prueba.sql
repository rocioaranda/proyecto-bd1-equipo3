INSERT INTO Clientes
    (nombre, apellido, domicilio, Nro_Dni, Nro_Contacto, Razon_Social)
VALUES
    ('Emmanuel', 'Luque', 'Av. 3 de Abril 1250', '30111222', '3794123456', NULL),
    ('Maria', 'Gomez', 'Junin 845', '31222333', '3794234567', NULL),
    ('Carlos', 'Rodriguez', 'La Rioja 1520', '32333444', '3794345678', NULL),
    ('Lucia', 'Fernandez', 'Moreno 630', '33444555', '3794456789', NULL),
    ('Diego', 'Martinez', 'España 1120', '34555666', '3794567890', NULL),
    ('Sofia', 'Gonzalez', 'Salta 980', '35666777', '3794678901', NULL),
    ('Matias', 'Lopez', 'Mendoza 430', '36777888', '3794789012', NULL),
    ('Camila', 'Sanchez', 'Belgrano 760', '37888999', '3794890123', NULL),
    ('Pablo', 'Benitez', 'Catamarca 350', '38999000', '3794901234', NULL),
    ('Valeria', 'Sosa', 'San Lorenzo 780', '39111222', '3794012345', NULL);


INSERT INTO Vendedores
    (nombre, apellido, domicilio)
VALUES
    ('Jorge', 'Ramirez', 'Calle Buenos Aires 450'),
    ('Laura', 'Acosta', 'Calle Rivadavia 820'),
    ('Martin', 'Benitez', 'Calle Colon 1150'),
    ('Valentina', 'Diaz', 'Calle San Martin 630'),
    ('Nicolas', 'Torres', 'Calle Pellegrini 920'),
    ('Florencia', 'Ruiz', 'Calle Junin 740'),
    ('Agustin', 'Morales', 'Calle Salta 580'),
    ('Carolina', 'Vega', 'Calle Mendoza 310');





INSERT INTO Proveedores (CUIT) VALUES
('20301234561'), ('20284567892'), ('20329876543'), ('27351112224'),
('20273334445'), ('27365556666'), ('20317778887'), ('27389990008'),
('30711111119'), ('30722222220'), ('30733333331'), ('30744444442'),
('30755555553'), ('30766666664'), ('30777777775'), ('30788888886');


INSERT INTO Proveedor_Persona (Cod_Proveedor, Nombre, Apellido) VALUES
(1, 'Roberto',  'Aguirre'),
(2, 'Silvia',   'Campos'),
(3, 'Hugo',     'Paz'),
(4, 'Laura',    'Ibarra'),
(5, 'Esteban',  'Molina'),
(6, 'Carolina', 'Núñez'),
(7, 'Ricardo',  'Toledo'),
(8, 'Patricia', 'Luna');



INSERT INTO Proveedor_Empresa (Cod_Proveedor, Razon_Social) VALUES
(9,  'Lubricantes del Litoral S.A.'),
(10, 'Frenos Argentinos S.R.L.'),
(11, 'Neumáticos del Nordeste S.A.'),
(12, 'Baterías Norte S.R.L.'),
(13, 'Filtros y Repuestos S.A.'),
(14, 'Iluminación Automotriz S.R.L.'),
(15, 'Suspensiones del Sur S.A.'),
(16, 'Distribuidora Autopartes Central S.R.L.');


INSERT INTO Productos (categoria, marca, Stock_Disponible, Stock_Minimo, cod_Proveedor) VALUES
('Lubricantes',   'Shell',        120, 20,  9),
('Frenos',        'Brembo',       60, 10, 10),
('Neumáticos',    'Pirelli',      40,  8, 11),
('Baterías',      'Bosch',        25,  5, 12),
('Filtros',       'Mann-Filter', 200, 30, 13),
('Iluminación',   'Philips',      80, 15, 14),
('Suspensión',    'Monroe',       30,  6, 15),
('Accesorios',    '3M',           150, 25, 16),
('Encendido',     'NGK',          180, 40,  1),
('Refrigeración', 'Gates',        50, 10,  5);


INSERT INTO Metodo_De_Pago (descripcion, estado) VALUES
('Efectivo',               'ACTIVO'),
('Tarjeta de Débito',      'ACTIVO'),
('Tarjeta de Crédito',     'ACTIVO'),
('Transferencia Bancaria', 'ACTIVO');


INSERT INTO Transacciones (Fecha, Cod_Cliente, Cod_Vendedor, Cod_Metodo_Pago) VALUES
('2026-08-03',  1, 1, 1),
('2026-08-07',  3, 2, 4),
('2026-08-12',  2, 3, 2),
('2026-08-18',  5, 1, 4),   
('2026-08-25',  4, 4, 3),
('2026-09-01',  7, 5, 4),
('2026-09-05',  6, 2, 2),   
('2026-09-10',  8, 6, 1),
('2026-09-16',  9, 7, 3),   
('2026-09-22', 10, 8, 3);


INSERT INTO Detalle (cod_transaccion, cod_producto, Cantidad, Precio_unitario) VALUES
(1,  1, 2,  18500.50),
(1,  5, 1,   8500.00),
(2,  3, 4,  95000.00),
(3,  4, 1, 120000.00),
(3,  9, 4,   3800.50),
(4,  2, 2,  42000.00),
(4,  7, 2,  67000.00),
(5,  6, 2,  15000.75),
(6,  8, 3,   5200.00),
(6,  5, 2,   8500.00),
(7, 10, 1,  22500.00),
(7,  1, 1,  18500.50),
(8,  9, 6,   3800.50),
(9,  3, 2,  95000.00),
(9,  2, 1,  42000.00),
(10, 7, 1,  67000.00),
(10, 4, 1, 120000.00);




