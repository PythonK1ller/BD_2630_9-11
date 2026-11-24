--------------------------------------------------------------------------------
-- 00_borrar_tablas.sql
-- Limpia el esquema para poder re-ejecutar el proyecto desde cero.
-- El orden respeta las dependencias de llaves foraneas.
-- Ejecutar SOLO si ya existen objetos previos.
--------------------------------------------------------------------------------

DROP VIEW vista_1;
DROP VIEW vista_2;
DROP VIEW vista_3;
DROP VIEW vista_4;
DROP VIEW vista_5;
DROP VIEW vista_6;
DROP VIEW vista_7;

DROP TABLE meta         CASCADE CONSTRAINTS PURGE;
DROP TABLE cafeteria    CASCADE CONSTRAINTS PURGE;
DROP TABLE piso         CASCADE CONSTRAINTS PURGE;
DROP TABLE edificio     CASCADE CONSTRAINTS PURGE;
DROP TABLE colaborador  CASCADE CONSTRAINTS PURGE;
