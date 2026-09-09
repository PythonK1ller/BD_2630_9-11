--------------------------------------------------------------------------------
-- VISTA_3 - [10] Proyeccion de comisiones por tipo de contrato
--
-- Total a pagar por comisiones agrupado por vinculacion y ano, mas una fila
-- final con el gran total general.
--
-- La comision es un porcentaje que se paga SOBRE LAS VENTAS REALES:
--     comision = valorreal * (comision / 100)
--
-- Se usa GROUP BY GROUPING SETS y no ROLLUP: ROLLUP agregaria ademas un
-- subtotal por cada vinculacion, y el enunciado solo pide los grupos
-- (vinculacion, ano) y el gran total. GROUPING() se usa en el ORDER BY para
-- forzar que la fila del total quede de ultima.
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vista_3 AS
SELECT NVL(col.vinculacion, 'TOTAL GENERAL')                       AS vinculacion,
       NVL(TO_CHAR(EXTRACT(YEAR FROM met.fechameta)), 'TODOS')     AS anio,
       SUM(met.valorreal * col.comision / 100)                     AS total_comision
  FROM meta        met
  JOIN colaborador col ON col.id = met.idcolaborador
 GROUP BY GROUPING SETS ( (col.vinculacion, EXTRACT(YEAR FROM met.fechameta)),
                          () )
 ORDER BY GROUPING(col.vinculacion),
          col.vinculacion,
          EXTRACT(YEAR FROM met.fechameta);
