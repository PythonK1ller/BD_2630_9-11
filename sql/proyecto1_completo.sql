--------------------------------------------------------------------------------
-- Proyecto 1 - Bases de Datos (PUJ)
-- Sistema de cafeterias para los servicios de alimentacion PUJ
--
-- SCRIPT MAESTRO. Ejecuta el proyecto completo en orden desde SQL*Plus, SQLcl
-- o SQL Developer (F5 / "Run Script"), parado sobre la carpeta sql/:
--
--     SQL> @proyecto1_completo.sql
--
-- La notacion @@ resuelve las rutas de forma relativa a este archivo.
--------------------------------------------------------------------------------

SET DEFINE OFF
SET SERVEROUTPUT ON
SET LINESIZE 200
SET PAGESIZE 100

-- 1. Limpieza (descomentar solo si ya existen objetos de una corrida anterior)
-- @@01_ddl/00_borrar_tablas.sql

-- 2. Creacion del esquema
@@01_ddl/01_crear_tablas.sql

-- 3. Poblamiento (el orden respeta las llaves foraneas)
@@02_dml/01_edificios.sql
@@02_dml/02_pisos.sql
@@02_dml/03_cafeterias.sql
@@02_dml/04_colaboradores.sql
@@02_dml/05_metas.sql
@@02_dml/06_resincronizar_identities.sql

-- 4. Vistas
@@03_vistas/vista_1.sql
@@03_vistas/vista_2.sql
@@03_vistas/vista_3.sql
@@03_vistas/vista_4.sql
@@03_vistas/vista_5.sql
@@03_vistas/vista_6.sql
@@03_vistas/vista_7.sql

-- 5. Permisos
@@04_permisos/01_grants.sql

-- 6. Verificacion rapida
@@99_verificacion.sql
