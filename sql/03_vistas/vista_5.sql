--------------------------------------------------------------------------------
-- VISTA_5 - [10] Top de colaboradores sobre el promedio
--
-- Colaboradores cuyo total historico de ventas reales supera el promedio general
-- de ventas de todos los colaboradores. Se lista el nombre, su total y, como
-- tercera columna, el promedio general para poder contrastar.
--
-- Interpretacion del "promedio general": es el promedio de los TOTALES por
-- colaborador, no el promedio de los registros individuales de META. Por eso se
-- calcula primero el total de cada colaborador (CTE totales) y sobre ese
-- resultado se saca el AVG.
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vista_5 AS
WITH totales AS (
    SELECT col.id                AS id_colaborador,
           col.nombre            AS nombre,
           SUM(met.valorreal)    AS total_ventas_reales
      FROM colaborador col
      JOIN meta        met ON met.idcolaborador = col.id
     GROUP BY col.id, col.nombre
)
SELECT tot.nombre                                        AS colaborador,
       tot.total_ventas_reales                           AS total_ventas_reales,
       (SELECT ROUND(AVG(total_ventas_reales), 2) FROM totales) AS promedio_general
  FROM totales tot
 WHERE tot.total_ventas_reales > (SELECT AVG(total_ventas_reales) FROM totales)
 ORDER BY tot.total_ventas_reales DESC;
