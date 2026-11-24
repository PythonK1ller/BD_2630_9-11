--------------------------------------------------------------------------------
-- VISTA_6 - [10] Cobertura total de edificios
--
-- Colaboradores con registros de metas en cafeterias de todos los edificios.
--
-- IMPORTANTE (decision de diseno):
-- El enunciado exige, en la seccion de insercion de datos, que existan al menos
-- dos edificios SIN ninguna cafeteria asociada. Si "todos los edificios" se
-- interpretara literalmente como los 40 registros de EDIFICIO, ningun
-- colaborador podria cumplirlo jamas (no hay cafeteria alli donde tener una
-- meta) y la vista quedaria vacia, contradiciendo la nota final "asegurese que
-- todas las consultas tengan tuplas de resultado".
--
-- Por eso el universo de comparacion son los edificios QUE TIENEN AL MENOS UNA
-- CAFETERIA: es la unica lectura bajo la cual la consulta es satisfacible.
-- La subconsulta escalar calcula ese universo de forma dinamica, sin constantes
-- quemadas, de modo que la vista sigue siendo correcta si cambian los datos.
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vista_6 AS
SELECT col.nombre           AS colaborador,
       col.numerodocumento  AS numero_documento
  FROM colaborador col
  JOIN meta        met ON met.idcolaborador = col.id
  JOIN cafeteria   caf ON caf.id = met.idcafeteria
  JOIN piso        pis ON pis.id = caf.idpiso
 GROUP BY col.id, col.nombre, col.numerodocumento
HAVING COUNT(DISTINCT pis.idedificio) = ( SELECT COUNT(DISTINCT pis2.idedificio)
                                            FROM cafeteria caf2
                                            JOIN piso      pis2 ON pis2.id = caf2.idpiso )
 ORDER BY col.nombre;
