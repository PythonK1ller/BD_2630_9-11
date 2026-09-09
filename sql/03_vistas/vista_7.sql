--------------------------------------------------------------------------------
-- VISTA_7 - [20] Colaboradores por edificio y tipo de vinculacion
--
--   Edificio | Colaboradores de planta | Colaboradores temporales | Total
--   Barón    |            3            |            2             |   5
--   Giraldo  |            4            |            2             |   6
--   ...
--   Totales  |            7            |            4             |  11
--
-- Un colaborador "esta" en un edificio si tiene al menos una meta registrada en
-- alguna cafeteria ubicada en ese edificio. Se cuenta DISTINCT sobre col.id
-- porque un mismo colaborador tiene muchas metas en el mismo edificio y no debe
-- contarse varias veces.
--
-- La tabulacion cruzada se arma con COUNT(DISTINCT CASE WHEN ...): el CASE deja
-- NULL cuando la vinculacion no corresponde y COUNT ignora los NULL.
--
-- OJO con la fila de totales: al ser un COUNT DISTINCT global, un colaborador
-- que trabaja en dos edificios se cuenta UNA sola vez. Por eso la fila "TOTALES"
-- puede ser menor que la suma vertical de las filas anteriores. Es el
-- comportamiento correcto (son colaboradores distintos, no una sumatoria).
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vista_7 AS
SELECT NVL(edi.nombre, 'TOTALES')                                              AS edificio,
       COUNT(DISTINCT CASE WHEN col.vinculacion = 'PLANTA'   THEN col.id END)  AS colaboradores_planta,
       COUNT(DISTINCT CASE WHEN col.vinculacion = 'TEMPORAL' THEN col.id END)  AS colaboradores_temporales,
       COUNT(DISTINCT col.id)                                                  AS total
  FROM edificio    edi
  JOIN piso        pis ON pis.idedificio   = edi.id
  JOIN cafeteria   caf ON caf.idpiso       = pis.id
  JOIN meta        met ON met.idcafeteria  = caf.id
  JOIN colaborador col ON col.id           = met.idcolaborador
 GROUP BY GROUPING SETS ( (edi.id, edi.nombre), () )
 ORDER BY GROUPING(edi.nombre),
          edi.nombre;
