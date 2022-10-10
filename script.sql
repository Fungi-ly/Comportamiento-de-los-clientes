/*
DROP DATABASE comportamientocl;
CREATE DATABASE comportamientocl;

-- Me conecto a la base de datos
\c comportamientocl

psql -U julio comportamientocl < unidad2.sql */

\set AUTOCOMMIT off

--2 El cliente usuario01 ha realizado la siguiente compra:
--  * producto: producto9
--  * cantidad: 5
--  * fecha: fecha del sistema

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha) VALUES (33, 1, '2022-02-16');
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (9, 33, 5);
UPDATE producto SET stock = stock - 5 WHERE id = 9;
ROLLBACK;

-- Verificar stock actualizado
SELECT * FROM producto;

--3 El cliente usuario02 ha realizado la siguiente compra:
-- * producto: producto1, producto 2, producto 8
-- * cantidad: 3 de cada producto
-- * fecha: fecha del sistema

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha) VALUES (33, 2, '2022-02-16');

--Ingresar compra producto1 
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (1, 33, 3);
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto1';
SAVEPOINT checkpoint1;

--Ingresar compra producto2
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (2, 33, 3);
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto2';
SAVEPOINT checkpoint2;

--Ingresar compra producto8
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (8, 33, 3);
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto8';
ROLLBACK TO checkpoint2;

--4 Realizar las siguientes consultas
--a) Deshabilitar el AUTOCOMMIT
\set AUTOCOMMIT off

--b) Insertar un nuevo cliente
BEGIN TRANSACTION;
INSERT INTO cliente (id, nombre, email) VALUES (11, 'usuario011', 'usuario011@gmail.com');

SAVEPOINT nuevo_cliente;

--c) Confirmar que fue agregado en la tabla cliente
SELECT * FROM cliente WHERE id = 11;

--d) Realizar un ROLLBACK
ROLLBACK to nuevo_cliente;

--e) Confirmar que se restauró la información, sin considerar la inserción del punto b
SELECT * FROM cliente WHERE id = 11;

--f) Habilitar de nuevo el AUTOCOMMIT
\set AUTOCOMMIT on 