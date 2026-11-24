--------------------------------------------------------------------------------
-- 99_verificacion.sql
-- Comprueba que el poblamiento cumple los lineamientos obligatorios del
-- enunciado y que las 7 vistas devuelven tuplas. Util para los pantallazos
-- del informe.
--------------------------------------------------------------------------------

PROMPT === Conteo por tabla (esperado: 40 / 200 / 12 / 26 / >=500) ===
SELECT 'EDIFICIO'    AS tabla, COUNT(*) AS registros FROM edificio
UNION ALL SELECT 'PISO',        COUNT(*) FROM piso
UNION ALL SELECT 'CAFETERIA',   COUNT(*) FROM cafeteria
UNION ALL SELECT 'COLABORADOR', COUNT(*) FROM colaborador
UNION ALL SELECT 'META',        COUNT(*) FROM meta;

PROMPT === Periodo cubierto por META (debe ser continuo y >= 6 meses) ===
SELECT MIN(fechameta) AS fecha_inicial,
       MAX(fechameta) AS fecha_final,
       MONTHS_BETWEEN(MAX(fechameta), MIN(fechameta)) AS meses
  FROM meta;

PROMPT === Edificios sin ninguna cafeteria (deben ser >= 2) ===
SELECT COUNT(*) AS edificios_sin_cafeteria
  FROM edificio e
 WHERE NOT EXISTS (SELECT 1 FROM piso p JOIN cafeteria c ON c.idpiso = p.id
                    WHERE p.idedificio = e.id);

PROMPT === Pisos sin ninguna cafeteria (deben ser >= 3) ===
SELECT COUNT(*) AS pisos_sin_cafeteria
  FROM piso p
 WHERE NOT EXISTS (SELECT 1 FROM cafeteria c WHERE c.idpiso = p.id);

PROMPT === Colaboradores con metas en TODAS las cafeterias (deben ser >= 5) ===
SELECT COUNT(*) AS colaboradores_cobertura_total
  FROM ( SELECT m.idcolaborador
           FROM meta m
          GROUP BY m.idcolaborador
         HAVING COUNT(DISTINCT m.idcafeteria) = (SELECT COUNT(*) FROM cafeteria) );

PROMPT === Colaboradores sin ninguna meta (deben ser >= 2) ===
SELECT COUNT(*) AS colaboradores_sin_metas
  FROM colaborador c
 WHERE NOT EXISTS (SELECT 1 FROM meta m WHERE m.idcolaborador = c.id);

PROMPT === Filas devueltas por cada vista (ninguna puede ser 0) ===
SELECT 'VISTA_1' AS vista, COUNT(*) AS filas FROM vista_1
UNION ALL SELECT 'VISTA_2', COUNT(*) FROM vista_2
UNION ALL SELECT 'VISTA_3', COUNT(*) FROM vista_3
UNION ALL SELECT 'VISTA_4', COUNT(*) FROM vista_4
UNION ALL SELECT 'VISTA_5', COUNT(*) FROM vista_5
UNION ALL SELECT 'VISTA_6', COUNT(*) FROM vista_6
UNION ALL SELECT 'VISTA_7', COUNT(*) FROM vista_7;
