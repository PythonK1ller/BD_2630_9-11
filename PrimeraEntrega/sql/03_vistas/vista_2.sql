--------------------------------------------------------------------------------
-- VISTA_2 - [10] Cobertura de infraestructura
--
-- Cantidad de cafeterias por piso. Los pisos sin cafeteria deben aparecer con 0,
-- por eso el LEFT JOIN va desde PISO hacia CAFETERIA y se cuenta caf.id (no *):
-- COUNT(*) contaria la fila del piso aunque no exista cafeteria y devolveria 1.
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vista_2 AS
SELECT edi.nombre        AS edificio,
       pis.numeropiso    AS numero_piso,
       COUNT(caf.id)     AS total_cafeterias
  FROM edificio   edi
  JOIN piso       pis ON pis.idedificio = edi.id
  LEFT JOIN cafeteria caf ON caf.idpiso = pis.id
 GROUP BY edi.id, edi.nombre, pis.numeropiso
 ORDER BY edi.nombre, pis.numeropiso;
