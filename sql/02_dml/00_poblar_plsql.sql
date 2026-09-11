--------------------------------------------------------------------------------
-- Proyecto 1 - Bases de Datos (PUJ)
-- 00_poblar_plsql.sql : poblamiento COMPLETO de las 5 tablas en un solo bloque
--------------------------------------------------------------------------------

SET DEFINE OFF
SET SERVEROUTPUT ON

DECLARE
    TYPE t_texto IS TABLE OF VARCHAR2(255);
    TYPE t_numero IS TABLE OF NUMBER;

    v_edificios t_texto := t_texto(
        'Barón', 'Giraldo', 'Fernando Barón', 'Emilio Arango',
        'José Rafael Arboleda', 'Jesús María Fernández', 'Rafael Arboleda',
        'Pedro Arrupe', 'Angel Valtierra', 'Carlos Ortiz', 'Félix Restrepo',
        'Manuel Briceño', 'Gabriel Giraldo', 'Jorge Hoyos', 'Juan XXIII',
        'Rafael Barrientos', 'Luis Carlos Galán', 'Fernando Barón Norte',
        'Biblioteca Alfonso Borrero', 'Rectoría', 'Ciencias Básicas',
        'Ingeniería', 'Medicina', 'Odontología', 'Enfermería',
        'Ciencias Jurídicas', 'Ciencias Económicas', 'Comunicación y Lenguaje',
        'Filosofía', 'Teología', 'Artes', 'Psicología', 'Arquitectura',
        'Laboratorios Norte', 'Laboratorios Sur', 'Deportes', 'Bienestar',
        'Auditorio Marino Troncoso', 'Centro Ático', 'Parqueadero Central');

    v_caf_nombre t_texto := t_texto(
        'Cafetería Central', 'Cafetería Los Cerezos', 'Cafetería El Jardín',
        'Cafetería La Terraza', 'Cafetería Punto Verde', 'Cafetería Express Norte',
        'Cafetería Biblioteca', 'Cafetería Ingeniería', 'Cafetería Ingeniería 4',
        'Cafetería Medicina', 'Cafetería Deportes', 'Cafetería Ático');
    v_caf_edificio t_numero := t_numero( 1,  1,  2,  4,  6, 12, 19, 22, 22, 23, 36, 39);
    v_caf_piso     t_numero := t_numero( 1,  3,  1,  2,  1,  1,  2,  1,  4,  1,  1,  2);

    v_colaboradores t_texto := t_texto(
        'Ana María Rodríguez', 'Carlos Alberto Pérez', 'Diana Sofía Ramírez',
        'Jorge Enrique Moreno', 'Laura Catalina Gómez', 'Miguel Ángel Torres',
        'Paula Andrea Castro', 'Andrés Felipe Vargas', 'Sandra Milena Ruiz',
        'Julián David Herrera', 'Natalia Restrepo', 'Óscar Iván Suárez',
        'Claudia Patricia León', 'Ricardo Alonso Mejía', 'Mónica Alejandra Peña',
        'Fernando José Cárdenas', 'Adriana Lucía Ospina', 'Camilo Ernesto Rojas',
        'Gloria Esperanza Niño', 'Héctor Mauricio Salazar',
        'Liliana Beatriz Cortés', 'Sebastián Quintero', 'Yolanda Marcela Pineda',
        'Alejandro Bermúdez', 'Verónica Isabel Duarte', 'Nicolás Esteban Guzmán');

    c_fecha_inicio  CONSTANT DATE := DATE '2025-09-01';
    c_fecha_fin     CONSTANT DATE := DATE '2026-02-28';
    c_semilla       CONSTANT NUMBER := 20261;

    v_id_piso    PLS_INTEGER := 0;
    v_num_pisos  PLS_INTEGER;
    v_idpiso     NUMBER;
    v_id_meta    PLS_INTEGER := 0;
    v_fecha      DATE;
    v_paso       PLS_INTEGER;
    v_base       NUMBER;
    v_factor     NUMBER;
    v_real       NUMBER;
    v_mes        PLS_INTEGER;
BEGIN
    DBMS_RANDOM.SEED(c_semilla);

    -- Limpieza previa para evitar ORA-00001 (Duplicados)
    DELETE FROM meta;
    DELETE FROM cafeteria;
    DELETE FROM piso;
    DELETE FROM colaborador;
    DELETE FROM edificio;

    FOR i IN 1 .. v_edificios.COUNT LOOP
        INSERT INTO edificio (id, nombre) VALUES (i, v_edificios(i));
    END LOOP;

    FOR i IN 1 .. v_edificios.COUNT LOOP
        v_num_pisos := CASE MOD(i, 5)
                           WHEN 1 THEN 4
                           WHEN 0 THEN 6
                           ELSE 5
                       END;
        FOR n IN 1 .. v_num_pisos LOOP
            v_id_piso := v_id_piso + 1;
            INSERT INTO piso (id, numeropiso, idedificio)
                 VALUES (v_id_piso, n, i);
        END LOOP;
    END LOOP;

    FOR i IN 1 .. v_caf_nombre.COUNT LOOP
        SELECT id INTO v_idpiso FROM piso
         WHERE idedificio = v_caf_edificio(i) AND numeropiso = v_caf_piso(i);

        INSERT INTO cafeteria (id, nombre, idpiso)
             VALUES (i, v_caf_nombre(i), v_idpiso);
    END LOOP;

    FOR i IN 1 .. v_colaboradores.COUNT LOOP
        INSERT INTO colaborador (id, nombre, tipodocumento, numerodocumento, vinculacion, comision)
             VALUES (i,
                     v_colaboradores(i),
                     CASE WHEN MOD(i, 7) = 0 THEN 'CE' ELSE 'CC' END,
                     -- Se redujo a 8 digitos para evitar desbordamiento
                     10000000 + MOD(i * 12345, 9000000), 
                     CASE WHEN MOD(i, 3) = 0 THEN 'TEMPORAL' ELSE 'PLANTA' END,
                     CASE MOD(i, 4) WHEN 0 THEN 15 WHEN 1 THEN 10 WHEN 2 THEN 8 ELSE 12 END);
    END LOOP;

    FOR c IN 1 .. v_colaboradores.COUNT LOOP
        CONTINUE WHEN c IN (25, 26);
        FOR f IN 1 .. v_caf_nombre.COUNT LOOP
            CONTINUE WHEN c > 5 AND MOD(f + c, 4) <> 0;
            v_paso  := CASE WHEN c <= 5 THEN 24 ELSE 13 END;
            v_fecha := c_fecha_inicio + MOD(c * 3 + f * 5, 7);

            WHILE v_fecha <= c_fecha_fin LOOP
                IF TO_CHAR(v_fecha, 'D', 'NLS_TERRITORY=AMERICA') <> '1' THEN
                    
                    -- Se redujeron los valores base a la mitad para evitar desbordamiento (ORA-06502)
                    v_base := (50 + TRUNC(DBMS_RANDOM.VALUE(0, 400))) * 1000;
                    v_mes  := EXTRACT(MONTH FROM v_fecha);

                    v_factor := CASE
                                    WHEN v_mes IN (11, 2) THEN DBMS_RANDOM.VALUE(0.55, 0.95)
                                    WHEN v_mes IN (9, 1)  THEN DBMS_RANDOM.VALUE(0.70, 1.15)
                                    ELSE                       DBMS_RANDOM.VALUE(0.85, 1.35)
                                END;

                    v_real    := TRUNC(v_base * v_factor / 1000) * 1000;
                    v_id_meta := v_id_meta + 1;

                    INSERT INTO meta (id, fechameta, valormeta, valorreal, idcafeteria, idcolaborador)
                         VALUES (v_id_meta, v_fecha, v_base, v_real, f, c);
                END IF;
                v_fecha := v_fecha + v_paso;
            END LOOP;
        END LOOP;
    END LOOP;

    EXECUTE IMMEDIATE 'ALTER TABLE edificio  MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE))';
    EXECUTE IMMEDIATE 'ALTER TABLE piso        MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE))';
    EXECUTE IMMEDIATE 'ALTER TABLE cafeteria   MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE))';
    EXECUTE IMMEDIATE 'ALTER TABLE colaborador MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE))';
    EXECUTE IMMEDIATE 'ALTER TABLE meta        MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE))';

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Poblamiento terminado:');
    DBMS_OUTPUT.PUT_LINE('  edificios    : ' || v_edificios.COUNT);
    DBMS_OUTPUT.PUT_LINE('  pisos        : ' || v_id_piso);
    DBMS_OUTPUT.PUT_LINE('  cafeterias   : ' || v_caf_nombre.COUNT);
    DBMS_OUTPUT.PUT_LINE('  colaboradores: ' || v_colaboradores.COUNT);
    DBMS_OUTPUT.PUT_LINE('  metas        : ' || v_id_meta);

END;
/
