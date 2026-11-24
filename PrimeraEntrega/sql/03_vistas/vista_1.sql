--------------------------------------------------------------------------------
-- VISTA_1 - [10] Listado de incumplimientos de metas
--
-- Colaborador, vinculacion, cafeteria, edificio, fecha, meta, real y la perdida
-- monetaria (meta - real), solo para los registros donde el valor real quedo
-- estrictamente por debajo de la meta.
-- Orden: perdida descendente y luego fecha descendente.
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vista_1 AS
SELECT col.nombre                        AS colaborador,
       col.vinculacion                   AS vinculacion,
       caf.nombre                        AS cafeteria,
       edi.nombre                        AS edificio,
       met.fechameta                     AS fecha_meta,
       met.valormeta                     AS valor_meta,
       met.valorreal                     AS valor_real,
       met.valormeta - met.valorreal     AS perdida_monetaria
  FROM meta         met
  JOIN colaborador  col ON col.id = met.idcolaborador
  JOIN cafeteria    caf ON caf.id = met.idcafeteria
  JOIN piso         pis ON pis.id = caf.idpiso
  JOIN edificio     edi ON edi.id = pis.idedificio
 WHERE met.valorreal < met.valormeta
 ORDER BY perdida_monetaria DESC,
          met.fechameta     DESC;
