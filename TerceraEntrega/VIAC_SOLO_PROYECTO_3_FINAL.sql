SET DEFINE OFF;

-- ============================================================
-- LIMPIEZA PREVIA DE OBJETOS DEL PROYECTO 3 (para re-ejecución segura)
-- ============================================================
BEGIN
  BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_EVENTO_CLINICO'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_USO_CUBICULO'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_COBRO_SERVICIO'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE LOGS_EVENTOS_CLINICOS CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE LOGS_KARDEX CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
END;
/

-- ============================================================
-- SECUENCIAS
-- ============================================================
CREATE SEQUENCE SEQ_EVENTO_CLINICO
    START WITH 60000048
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE SEQ_USO_CUBICULO
    START WITH 80000017
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE SEQ_COBRO_SERVICIO
    START WITH 90000055
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


-- ============================================================
-- PROCEDIMIENTOS
-- ============================================================
CREATE OR REPLACE PROCEDURE PR_ADMISION_VETERINARIA (
    p_codigo_historia_clinica IN  PACIENTE.codigo_historia_clinica%TYPE,
    p_cedula_ingresa          IN  NUMBER,
    p_cedula_medico           IN  PERSONAL.cedula_personal%TYPE,
    p_tipo_evento             IN  EVENTO_CLINICO.tipo_evento%TYPE,
    p_fecha_programada        IN  EVENTO_CLINICO.fecha_hora_programada%TYPE,
    p_id_cubiculo             IN  CUBICULO.id_cubiculo%TYPE,
    p_id_evento_generado      OUT EVENTO_CLINICO.id_evento%TYPE
) AS
    v_cedula_tutor  PACIENTE.cedula_tutor%TYPE;
    v_id_sede       PERSONAL.id_sede%TYPE;
    v_id_sede_cub   CUBICULO.id_sede%TYPE;
    v_es_medico     NUMBER(1);
    v_es_ingresante NUMBER(1);
BEGIN
    BEGIN
        SELECT cedula_tutor
          INTO v_cedula_tutor
          FROM PACIENTE
         WHERE codigo_historia_clinica = p_codigo_historia_clinica;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'El paciente indicado no existe.');
    END;

    SELECT CASE
             WHEN p_cedula_ingresa = v_cedula_tutor THEN 1
             WHEN EXISTS (
                    SELECT 1
                      FROM PACIENTE_CUIDADOR pc
                     WHERE pc.codigo_historia_clinica = p_codigo_historia_clinica
                       AND pc.cedula_cuidador = p_cedula_ingresa
                  ) THEN 1
             ELSE 0
           END
      INTO v_es_ingresante
      FROM DUAL;

    IF v_es_ingresante = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'La persona que ingresa no es el tutor principal ni un cuidador autorizado del paciente.'
        );
    END IF;

    BEGIN
        SELECT id_sede,
               CASE
                 WHEN LOWER(TRIM(cargo)) LIKE 'médico veterinario%' THEN 1
                 ELSE 0
               END
          INTO v_id_sede, v_es_medico
          FROM PERSONAL
         WHERE cedula_personal = p_cedula_medico;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'El médico responsable no existe en PERSONAL.');
    END;

    IF v_es_medico = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'El responsable indicado no tiene cargo de médico veterinario.');
    END IF;

    IF p_tipo_evento IS NULL
       OR p_tipo_evento NOT IN ('Cita', 'Examen', 'Procedimiento', 'Control') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Tipo de evento no válido.');
    END IF;

    IF p_fecha_programada IS NULL THEN
        RAISE_APPLICATION_ERROR(-20006, 'La fecha programada es obligatoria.');
    END IF;

    IF p_id_cubiculo IS NOT NULL THEN
        BEGIN
            SELECT id_sede
              INTO v_id_sede_cub
              FROM CUBICULO
             WHERE id_cubiculo = p_id_cubiculo;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20007, 'El cubículo indicado no existe.');
        END;

        IF v_id_sede_cub <> v_id_sede THEN
            RAISE_APPLICATION_ERROR(
                -20008,
                'El cubículo debe pertenecer a la misma sede del médico responsable.'
            );
        END IF;
    END IF;

    p_id_evento_generado := SEQ_EVENTO_CLINICO.NEXTVAL;

    INSERT INTO EVENTO_CLINICO (
        id_evento,
        codigo_historia_clinica,
        cedula_responsable,
        tipo_evento,
        fecha_hora_programada,
        fecha_hora_realizacion,
        id_evento_previo,
        id_sede
    ) VALUES (
        p_id_evento_generado,
        p_codigo_historia_clinica,
        p_cedula_medico,
        p_tipo_evento,
        p_fecha_programada,
        NULL,
        NULL,
        v_id_sede
    );

    IF p_id_cubiculo IS NOT NULL THEN
        INSERT INTO USO_CUBICULO (
            id_uso_cubiculo,
            id_evento,
            id_cubiculo,
            fecha_hora_inicio,
            fecha_hora_fin
        ) VALUES (
            SEQ_USO_CUBICULO.NEXTVAL,
            p_id_evento_generado,
            p_id_cubiculo,
            p_fecha_programada,
            NULL
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END PR_ADMISION_VETERINARIA;
/


-- ============================================================
-- FUNCIONES
-- ============================================================
CREATE OR REPLACE FUNCTION FN_VALIDAR_PESO_CUBICULO (
    p_codigo_historia_clinica IN PACIENTE.codigo_historia_clinica%TYPE,
    p_id_cubiculo             IN CUBICULO.id_cubiculo%TYPE
) RETURN BOOLEAN
IS
    v_peso               PACIENTE.peso_actual%TYPE;
    v_capacidad          CUBICULO.capacidad%TYPE;
    v_categoria_paciente NUMBER;
    v_categoria_cubiculo NUMBER;
BEGIN
    SELECT peso_actual INTO v_peso
      FROM PACIENTE
     WHERE codigo_historia_clinica = p_codigo_historia_clinica;

    SELECT capacidad INTO v_capacidad
      FROM CUBICULO
     WHERE id_cubiculo = p_id_cubiculo;

    v_categoria_paciente := CASE
        WHEN v_peso <= 10 THEN 1
        WHEN v_peso <= 25 THEN 2
        ELSE 3
    END;

    v_categoria_cubiculo := CASE v_capacidad
        WHEN 'Pequeño' THEN 1
        WHEN 'Mediano' THEN 2
        WHEN 'Grande'  THEN 3
    END;

    RETURN v_categoria_paciente > v_categoria_cubiculo;
END FN_VALIDAR_PESO_CUBICULO;
/

CREATE OR REPLACE FUNCTION FN_DISPONIBILIDAD_PLAN (
    p_numero_contrato IN CONTRATO_AFILIACION.numero_contrato%TYPE
) RETURN NUMBER
IS
    v_maximo    CONTRATO_AFILIACION.valor_maximo_cubierto%TYPE;
    v_utilizado NUMBER(14,2);
BEGIN
    SELECT valor_maximo_cubierto
      INTO v_maximo
      FROM CONTRATO_AFILIACION
     WHERE numero_contrato = p_numero_contrato;

    SELECT NVL(SUM(monto_cubierto), 0)
      INTO v_utilizado
      FROM COBRO_SERVICIO
     WHERE numero_contrato = p_numero_contrato;

    RETURN v_maximo - v_utilizado;
END FN_DISPONIBILIDAD_PLAN;
/

CREATE OR REPLACE FUNCTION FN_DEUDA_VIGENTE (
    p_id_cobro IN COBRO_SERVICIO.id_cobro%TYPE
) RETURN NUMBER
IS
    v_deuda NUMBER(14,2);
BEGIN
    SELECT monto_facturado - monto_cubierto - NVL(monto_pagado, 0)
      INTO v_deuda
      FROM COBRO_SERVICIO
     WHERE id_cobro = p_id_cobro;

    RETURN v_deuda;
END FN_DEUDA_VIGENTE;
/

CREATE OR REPLACE FUNCTION FN_HISTORIAL_DERIVADOS (
    p_id_evento IN EVENTO_CLINICO.id_evento%TYPE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_total
      FROM EVENTO_CLINICO
     START WITH id_evento_previo = p_id_evento
   CONNECT BY PRIOR id_evento = id_evento_previo;

    RETURN v_total;
END FN_HISTORIAL_DERIVADOS;
/


-- ============================================================
-- PROCEDIMIENTOS DE KARDEX, PAGOS Y SALDOS
-- ============================================================
CREATE OR REPLACE PROCEDURE PR_REGISTRO_KARDEX (
    p_id_evento         IN  EVENTO_CLINICO.id_evento%TYPE,
    p_numero_contrato   IN  CONTRATO_AFILIACION.numero_contrato%TYPE,
    p_codigo_servicio   IN  SERVICIO.codigo_servicio%TYPE,
    p_cedula_ejecutor   IN  PERSONAL.cedula_personal%TYPE,
    p_monto_facturado   IN  COBRO_SERVICIO.monto_facturado%TYPE,
    p_id_cobro_generado OUT COBRO_SERVICIO.id_cobro%TYPE
) AS
    v_paciente_evento   EVENTO_CLINICO.codigo_historia_clinica%TYPE;
    v_paciente_contrato CONTRATO_AFILIACION.codigo_historia_clinica%TYPE;
    v_cargo             PERSONAL.cargo%TYPE;
BEGIN
    BEGIN
        SELECT codigo_historia_clinica
          INTO v_paciente_evento
          FROM EVENTO_CLINICO
         WHERE id_evento = p_id_evento;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20100, 'El evento clínico indicado no existe.');
    END;

    BEGIN
        SELECT codigo_historia_clinica
          INTO v_paciente_contrato
          FROM CONTRATO_AFILIACION
         WHERE numero_contrato = p_numero_contrato;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20104, 'El contrato de afiliación indicado no existe.');
    END;

    IF v_paciente_evento <> v_paciente_contrato THEN
        RAISE_APPLICATION_ERROR(-20101, 'El contrato no pertenece al paciente del evento.');
    END IF;

    BEGIN
        SELECT cargo
          INTO v_cargo
          FROM PERSONAL
         WHERE cedula_personal = p_cedula_ejecutor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20105, 'El personal ejecutor indicado no existe.');
    END;

    IF LOWER(v_cargo) NOT LIKE 'enfermer%' THEN
        RAISE_APPLICATION_ERROR(-20102, 'El ejecutor debe pertenecer al personal de enfermería.');
    END IF;

    IF p_monto_facturado IS NULL OR p_monto_facturado < 0 THEN
        RAISE_APPLICATION_ERROR(-20103, 'El monto facturado debe ser mayor o igual a cero.');
    END IF;

    p_id_cobro_generado := SEQ_COBRO_SERVICIO.NEXTVAL;

    INSERT INTO COBRO_SERVICIO (
        id_cobro, id_evento, codigo_servicio, cedula_ejecutor,
        numero_contrato, fecha_realizacion, monto_facturado,
        monto_cubierto, monto_pagado, saldo_pendiente,
        fecha_pago, codigo_razon, id_cobro_origen
    ) VALUES (
        p_id_cobro_generado, p_id_evento, p_codigo_servicio, p_cedula_ejecutor,
        p_numero_contrato, SYSDATE, p_monto_facturado,
        0, NULL, p_monto_facturado,
        NULL, NULL, NULL
    );
END PR_REGISTRO_KARDEX;
/

CREATE OR REPLACE PROCEDURE PR_LIQUIDACION_PAGO (
    p_id_cobro     IN COBRO_SERVICIO.id_cobro%TYPE,
    p_monto_pagado IN COBRO_SERVICIO.monto_pagado%TYPE,
    p_fecha_pago   IN COBRO_SERVICIO.fecha_pago%TYPE,
    p_codigo_razon IN COBRO_SERVICIO.codigo_razon%TYPE DEFAULT NULL
) AS
    v_facturado COBRO_SERVICIO.monto_facturado%TYPE;
    v_cubierto  COBRO_SERVICIO.monto_cubierto%TYPE;
    v_pagado    COBRO_SERVICIO.monto_pagado%TYPE;
    v_saldo     NUMBER(14,2);
BEGIN
    BEGIN
        SELECT monto_facturado, monto_cubierto, NVL(monto_pagado, 0)
          INTO v_facturado, v_cubierto, v_pagado
          FROM COBRO_SERVICIO
         WHERE id_cobro = p_id_cobro
           FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20109, 'El cobro indicado no existe.');
    END;

    IF p_monto_pagado IS NULL OR p_monto_pagado <= 0 THEN
        RAISE_APPLICATION_ERROR(-20110, 'El monto del pago debe ser positivo.');
    END IF;
    IF p_fecha_pago IS NULL THEN
        RAISE_APPLICATION_ERROR(-20111, 'La fecha del pago es obligatoria.');
    END IF;
    IF v_pagado > 0 THEN
        RAISE_APPLICATION_ERROR(-20112, 'El cobro ya tiene un pago registrado.');
    END IF;

    v_saldo := v_facturado - v_cubierto - v_pagado;
    IF p_monto_pagado > v_saldo THEN
        RAISE_APPLICATION_ERROR(-20113, 'El pago supera el saldo pendiente del cobro.');
    END IF;

    UPDATE COBRO_SERVICIO
       SET monto_pagado = p_monto_pagado,
           fecha_pago   = p_fecha_pago,
           codigo_razon = p_codigo_razon
     WHERE id_cobro = p_id_cobro;
END PR_LIQUIDACION_PAGO;
/

CREATE OR REPLACE PROCEDURE PR_ACTUALIZAR_SALDO_COBRO (
    p_id_cobro IN COBRO_SERVICIO.id_cobro%TYPE
) AS
BEGIN
    UPDATE COBRO_SERVICIO
       SET saldo_pendiente = monto_facturado - monto_cubierto - NVL(monto_pagado, 0)
     WHERE id_cobro = p_id_cobro;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20120, 'El cobro indicado no existe.');
    END IF;
END PR_ACTUALIZAR_SALDO_COBRO;
/

CREATE OR REPLACE PROCEDURE PR_ACTUALIZAR_SALDO_MASIVO AS
BEGIN
    UPDATE COBRO_SERVICIO
       SET saldo_pendiente = monto_facturado - monto_cubierto - NVL(monto_pagado, 0);
END PR_ACTUALIZAR_SALDO_MASIVO;
/


-- ============================================================
-- TABLAS DE AUDITORÍA
-- ============================================================
CREATE TABLE LOGS_EVENTOS_CLINICOS (
    id_log         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_cambio   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    usuario_bd     VARCHAR2(128) NOT NULL,
    operacion      VARCHAR2(10) NOT NULL,
    valor_anterior CLOB,
    valor_nuevo    CLOB
);

CREATE TABLE LOGS_KARDEX (
    id_log         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_cambio   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    usuario_bd     VARCHAR2(128) NOT NULL,
    operacion      VARCHAR2(10) NOT NULL,
    valor_anterior CLOB,
    valor_nuevo    CLOB
);


-- ============================================================
-- TRIGGERS
-- ============================================================
CREATE OR REPLACE TRIGGER TR_SEGURIDAD_CUBICULO
BEFORE INSERT OR UPDATE ON EVENTO_CLINICO
FOR EACH ROW
DECLARE
    v_id_cubiculo USO_CUBICULO.id_cubiculo%TYPE;
BEGIN
    BEGIN
        SELECT id_cubiculo
          INTO v_id_cubiculo
          FROM USO_CUBICULO
         WHERE id_evento = :NEW.id_evento
           AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_id_cubiculo := NULL;
    END;

    IF v_id_cubiculo IS NOT NULL AND
       FN_VALIDAR_PESO_CUBICULO(:NEW.codigo_historia_clinica, v_id_cubiculo) THEN
        RAISE_APPLICATION_ERROR(-20130, 'El peso del paciente supera la capacidad del cubículo.');
    END IF;
END TR_SEGURIDAD_CUBICULO;
/

CREATE OR REPLACE TRIGGER TR_VALIDAR_USO_CUBICULO
BEFORE INSERT OR UPDATE ON USO_CUBICULO
FOR EACH ROW
DECLARE
    v_codigo_historia PACIENTE.codigo_historia_clinica%TYPE;
BEGIN
    SELECT codigo_historia_clinica
      INTO v_codigo_historia
      FROM EVENTO_CLINICO
     WHERE id_evento = :NEW.id_evento;

    IF FN_VALIDAR_PESO_CUBICULO(v_codigo_historia, :NEW.id_cubiculo) THEN
        RAISE_APPLICATION_ERROR(-20131, 'El peso del paciente supera la capacidad del cubículo.');
    END IF;
END TR_VALIDAR_USO_CUBICULO;
/

-- Compound Trigger para evitar error ORA-04091 (tabla mutante) al insertar en EVENTO_CLINICO
CREATE OR REPLACE TRIGGER TR_CONTROL_POSTQUIRURGICO_AUTO
FOR UPDATE ON EVENTO_CLINICO
COMPOUND TRIGGER

    TYPE t_control_rec IS RECORD (
        codigo_historia_clinica EVENTO_CLINICO.codigo_historia_clinica%TYPE,
        cedula_responsable      EVENTO_CLINICO.cedula_responsable%TYPE,
        fecha_realizacion       EVENTO_CLINICO.fecha_hora_realizacion%TYPE,
        id_evento_previo        EVENTO_CLINICO.id_evento%TYPE,
        id_sede                 EVENTO_CLINICO.id_sede%TYPE
    );
    TYPE t_control_tab IS TABLE OF t_control_rec INDEX BY PLS_INTEGER;
    g_controles t_control_tab;

    AFTER EACH ROW IS
        v_idx PLS_INTEGER;
    BEGIN
        IF :NEW.tipo_evento = 'Procedimiento'
           AND :OLD.fecha_hora_realizacion IS NULL
           AND :NEW.fecha_hora_realizacion IS NOT NULL THEN
            v_idx := g_controles.COUNT + 1;
            g_controles(v_idx).codigo_historia_clinica := :NEW.codigo_historia_clinica;
            g_controles(v_idx).cedula_responsable      := :NEW.cedula_responsable;
            g_controles(v_idx).fecha_realizacion       := :NEW.fecha_hora_realizacion;
            g_controles(v_idx).id_evento_previo        := :NEW.id_evento;
            g_controles(v_idx).id_sede                 := :NEW.id_sede;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. g_controles.COUNT LOOP
            INSERT INTO EVENTO_CLINICO (
                id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento,
                fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede
            ) VALUES (
                SEQ_EVENTO_CLINICO.NEXTVAL,
                g_controles(i).codigo_historia_clinica,
                g_controles(i).cedula_responsable,
                'Control',
                g_controles(i).fecha_realizacion + INTERVAL '8' DAY,
                NULL,
                g_controles(i).id_evento_previo,
                g_controles(i).id_sede
            );
        END LOOP;
        g_controles.DELETE;
    END AFTER STATEMENT;

END TR_CONTROL_POSTQUIRURGICO_AUTO;
/

CREATE OR REPLACE TRIGGER TR_AUDIT_EVENTOS
AFTER INSERT OR UPDATE OR DELETE ON EVENTO_CLINICO
FOR EACH ROW
DECLARE
    v_old       CLOB;
    v_new       CLOB;
    v_operacion VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
    ELSE
        v_operacion := 'DELETE';
    END IF;

    IF UPDATING OR DELETING THEN
        v_old := 'id_evento=' || :OLD.id_evento ||
                 '; paciente=' || :OLD.codigo_historia_clinica ||
                 '; responsable=' || :OLD.cedula_responsable ||
                 '; tipo=' || :OLD.tipo_evento ||
                 '; programada=' || TO_CHAR(:OLD.fecha_hora_programada, 'YYYY-MM-DD HH24:MI:SS') ||
                 '; realizada=' || TO_CHAR(:OLD.fecha_hora_realizacion, 'YYYY-MM-DD HH24:MI:SS') ||
                 '; previo=' || :OLD.id_evento_previo ||
                 '; sede=' || :OLD.id_sede;
    END IF;

    IF INSERTING OR UPDATING THEN
        v_new := 'id_evento=' || :NEW.id_evento ||
                 '; paciente=' || :NEW.codigo_historia_clinica ||
                 '; responsable=' || :NEW.cedula_responsable ||
                 '; tipo=' || :NEW.tipo_evento ||
                 '; programada=' || TO_CHAR(:NEW.fecha_hora_programada, 'YYYY-MM-DD HH24:MI:SS') ||
                 '; realizada=' || TO_CHAR(:NEW.fecha_hora_realizacion, 'YYYY-MM-DD HH24:MI:SS') ||
                 '; previo=' || :NEW.id_evento_previo ||
                 '; sede=' || :NEW.id_sede;
    END IF;

    INSERT INTO LOGS_EVENTOS_CLINICOS
        (usuario_bd, operacion, valor_anterior, valor_nuevo)
    VALUES
        (SYS_CONTEXT('USERENV','SESSION_USER'), v_operacion, v_old, v_new);
END TR_AUDIT_EVENTOS;
/

CREATE OR REPLACE TRIGGER TR_AUDIT_KARDEX
AFTER INSERT OR UPDATE OR DELETE ON COBRO_SERVICIO
FOR EACH ROW
DECLARE
    v_old       CLOB;
    v_new       CLOB;
    v_operacion VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
    ELSE
        v_operacion := 'DELETE';
    END IF;

    IF UPDATING OR DELETING THEN
        v_old := 'id_cobro=' || :OLD.id_cobro ||
                 '; evento=' || :OLD.id_evento ||
                 '; servicio=' || :OLD.codigo_servicio ||
                 '; ejecutor=' || :OLD.cedula_ejecutor ||
                 '; contrato=' || :OLD.numero_contrato ||
                 '; facturado=' || :OLD.monto_facturado ||
                 '; cubierto=' || :OLD.monto_cubierto ||
                 '; pagado=' || :OLD.monto_pagado ||
                 '; saldo=' || :OLD.saldo_pendiente ||
                 '; fecha_pago=' || TO_CHAR(:OLD.fecha_pago, 'YYYY-MM-DD');
    END IF;

    IF INSERTING OR UPDATING THEN
        v_new := 'id_cobro=' || :NEW.id_cobro ||
                 '; evento=' || :NEW.id_evento ||
                 '; servicio=' || :NEW.codigo_servicio ||
                 '; ejecutor=' || :NEW.cedula_ejecutor ||
                 '; contrato=' || :NEW.numero_contrato ||
                 '; facturado=' || :NEW.monto_facturado ||
                 '; cubierto=' || :NEW.monto_cubierto ||
                 '; pagado=' || :NEW.monto_pagado ||
                 '; saldo=' || :NEW.saldo_pendiente ||
                 '; fecha_pago=' || TO_CHAR(:NEW.fecha_pago, 'YYYY-MM-DD');
    END IF;

    INSERT INTO LOGS_KARDEX
        (usuario_bd, operacion, valor_anterior, valor_nuevo)
    VALUES
        (SYS_CONTEXT('USERENV','SESSION_USER'), v_operacion, v_old, v_new);
END TR_AUDIT_KARDEX;
/

CREATE OR REPLACE TRIGGER TR_APLICAR_DESCUENTO_PLAN
BEFORE INSERT ON COBRO_SERVICIO
FOR EACH ROW
DECLARE
    v_porcentaje CATEGORIA_COBERTURA.porcentaje_descuento%TYPE;
BEGIN
    SELECT cc.porcentaje_descuento
      INTO v_porcentaje
      FROM CONTRATO_AFILIACION ca
      JOIN CATEGORIA_COBERTURA cc ON cc.id_categoria = ca.id_categoria
     WHERE ca.numero_contrato = :NEW.numero_contrato;

    :NEW.monto_facturado := ROUND(:NEW.monto_facturado * (1 - v_porcentaje / 100), 2);
END TR_APLICAR_DESCUENTO_PLAN;
/

CREATE OR REPLACE TRIGGER TR_CALCULO_SALDO_AUTOMATICO
BEFORE INSERT OR UPDATE OF monto_facturado, monto_cubierto, monto_pagado
ON COBRO_SERVICIO
FOR EACH ROW
FOLLOWS TR_APLICAR_DESCUENTO_PLAN
BEGIN
    :NEW.saldo_pendiente := :NEW.monto_facturado - :NEW.monto_cubierto - NVL(:NEW.monto_pagado, 0);
END TR_CALCULO_SALDO_AUTOMATICO;
/
