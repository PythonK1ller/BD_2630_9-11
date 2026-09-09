--------------------------------------------------------------------------------
-- VISTA_4 - [10] Rendimiento mensual por cafeteria
--
-- Ano, mes, cafeteria y promedio de ventas reales diarias, mostrando unicamente
-- las combinaciones (cafeteria, ano, mes) donde ese promedio supero el promedio
-- de las metas propuestas para el mismo mes.
--
-- La comparacion entre los dos promedios va en HAVING porque involucra dos
-- funciones de agregacion del mismo grupo; no puede ir en WHERE.
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vista_4 AS
SELECT EXTRACT(YEAR  FROM met.fechameta)  AS anio,
       EXTRACT(MONTH FROM met.fechameta)  AS mes,
       caf.nombre                         AS cafeteria,
       ROUND(AVG(met.valorreal), 2)       AS promedio_ventas_reales,
       ROUND(AVG(met.valormeta), 2)       AS promedio_metas
  FROM meta      met
  JOIN cafeteria caf ON caf.id = met.idcafeteria
 GROUP BY EXTRACT(YEAR FROM met.fechameta),
          EXTRACT(MONTH FROM met.fechameta),
          caf.id,
          caf.nombre
HAVING AVG(met.valorreal) > AVG(met.valormeta)
 ORDER BY anio, mes, cafeteria;
