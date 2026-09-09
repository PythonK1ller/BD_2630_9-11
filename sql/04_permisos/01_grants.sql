--------------------------------------------------------------------------------
-- Permisos de SELECT sobre todas las tablas y vistas para el usuario JPALACIO
-- (requisito de la seccion "DETALLES DE LA ENTREGA").
--------------------------------------------------------------------------------

-- Tablas
GRANT SELECT ON edificio    TO JPALACIO;
GRANT SELECT ON piso        TO JPALACIO;
GRANT SELECT ON cafeteria   TO JPALACIO;
GRANT SELECT ON colaborador TO JPALACIO;
GRANT SELECT ON meta        TO JPALACIO;

-- Vistas
GRANT SELECT ON vista_1 TO JPALACIO;
GRANT SELECT ON vista_2 TO JPALACIO;
GRANT SELECT ON vista_3 TO JPALACIO;
GRANT SELECT ON vista_4 TO JPALACIO;
GRANT SELECT ON vista_5 TO JPALACIO;
GRANT SELECT ON vista_6 TO JPALACIO;
GRANT SELECT ON vista_7 TO JPALACIO;

-- Verificacion de los permisos otorgados
-- SELECT grantee, table_name, privilege FROM user_tab_privs_made
--  WHERE grantee = 'JPALACIO' ORDER BY table_name;
