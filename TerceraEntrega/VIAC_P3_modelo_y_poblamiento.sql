SET DEFINE OFF;
-- VIAC: creación de tablas. Se eliminan las tablas existentes antes de crearlas; respalda los datos antes de ejecutar.
BEGIN
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE LOGS_KARDEX CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE LOGS_EVENTOS_CLINICOS CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE COBRO_SERVICIO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE USO_CUBICULO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE MOTIVO_CLINICO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE EVENTO_CLINICO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE CONTRATO_AFILIACION CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE PACIENTE_ALERGIA CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE PACIENTE_CUIDADOR CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE PERSONAL_TITULO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE PACIENTE CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE PERSONAL CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE CUBICULO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE SERVICIO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE RAZON_SALDO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE PLAN_BIENESTAR CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE CATEGORIA_COBERTURA CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE ALERGIA CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE TITULO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE CUIDADOR_AUTORIZADO CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE TUTOR_PRINCIPAL CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE SEDE CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
END;
/

CREATE TABLE SEDE (
 id_sede NUMBER(3) CONSTRAINT pk_sede PRIMARY KEY,
 nombre_sede VARCHAR2(80) NOT NULL CONSTRAINT uq_sede_nombre UNIQUE,
 ciudad VARCHAR2(60) NOT NULL, direccion VARCHAR2(150) NOT NULL, telefono VARCHAR2(20)
);
CREATE TABLE TUTOR_PRINCIPAL (
 cedula_tutor NUMBER(12) CONSTRAINT pk_tutor PRIMARY KEY,
 nombre_completo VARCHAR2(120) NOT NULL, direccion VARCHAR2(150) NOT NULL,
 correo_electronico VARCHAR2(120) NOT NULL
);
CREATE TABLE PACIENTE (
 codigo_historia_clinica NUMBER(10) CONSTRAINT pk_paciente PRIMARY KEY,
 nombre VARCHAR2(80) NOT NULL, especie VARCHAR2(40) NOT NULL, raza VARCHAR2(60) NOT NULL,
 sexo VARCHAR2(10) NOT NULL CONSTRAINT ck_paciente_sexo CHECK (sexo IN ('Macho','Hembra')),
 fecha_nacimiento DATE NOT NULL, peso_actual NUMBER(7,2) NOT NULL CONSTRAINT ck_paciente_peso CHECK (peso_actual > 0),
 cedula_tutor NUMBER(12) NOT NULL,
 CONSTRAINT fk_paciente_tutor FOREIGN KEY (cedula_tutor) REFERENCES TUTOR_PRINCIPAL(cedula_tutor)
);
CREATE TABLE CUIDADOR_AUTORIZADO (
 cedula_cuidador NUMBER(12) CONSTRAINT pk_cuidador PRIMARY KEY,
 nombre_completo VARCHAR2(120) NOT NULL
);
CREATE TABLE PACIENTE_CUIDADOR (
 codigo_historia_clinica NUMBER(10) NOT NULL, cedula_cuidador NUMBER(12) NOT NULL,
 vinculo VARCHAR2(40) NOT NULL,
 CONSTRAINT pk_paciente_cuidador PRIMARY KEY (codigo_historia_clinica,cedula_cuidador),
 CONSTRAINT fk_pc_paciente FOREIGN KEY (codigo_historia_clinica) REFERENCES PACIENTE(codigo_historia_clinica),
 CONSTRAINT fk_pc_cuidador FOREIGN KEY (cedula_cuidador) REFERENCES CUIDADOR_AUTORIZADO(cedula_cuidador)
);
CREATE TABLE PERSONAL (
 cedula_personal NUMBER(12) CONSTRAINT pk_personal PRIMARY KEY,
 nombre_completo VARCHAR2(120) NOT NULL, cargo VARCHAR2(80) NOT NULL,
 sexo VARCHAR2(12) NOT NULL CONSTRAINT ck_personal_sexo CHECK (sexo IN ('Masculino','Femenino')),
 direccion VARCHAR2(150) NOT NULL, id_sede NUMBER(3) NOT NULL,
 CONSTRAINT fk_personal_sede FOREIGN KEY (id_sede) REFERENCES SEDE(id_sede)
);
CREATE TABLE TITULO (
 nombre_titulo VARCHAR2(100) CONSTRAINT pk_titulo PRIMARY KEY
);
CREATE TABLE PERSONAL_TITULO (
 cedula_personal NUMBER(12) NOT NULL, nombre_titulo VARCHAR2(100) NOT NULL,
 CONSTRAINT pk_personal_titulo PRIMARY KEY (cedula_personal,nombre_titulo),
 CONSTRAINT fk_pt_personal FOREIGN KEY (cedula_personal) REFERENCES PERSONAL(cedula_personal),
 CONSTRAINT fk_pt_titulo FOREIGN KEY (nombre_titulo) REFERENCES TITULO(nombre_titulo)
);
CREATE TABLE ALERGIA (
 nombre_alergia VARCHAR2(100) CONSTRAINT pk_alergia PRIMARY KEY
);
CREATE TABLE PACIENTE_ALERGIA (
 codigo_historia_clinica NUMBER(10) NOT NULL, nombre_alergia VARCHAR2(100) NOT NULL,
 CONSTRAINT pk_paciente_alergia PRIMARY KEY (codigo_historia_clinica,nombre_alergia),
 CONSTRAINT fk_pa_paciente FOREIGN KEY (codigo_historia_clinica) REFERENCES PACIENTE(codigo_historia_clinica),
 CONSTRAINT fk_pa_alergia FOREIGN KEY (nombre_alergia) REFERENCES ALERGIA(nombre_alergia)
);
CREATE TABLE CUBICULO (
 id_cubiculo NUMBER(10) CONSTRAINT pk_cubiculo PRIMARY KEY,
 capacidad VARCHAR2(10) NOT NULL CONSTRAINT ck_cubiculo_capacidad CHECK (capacidad IN ('Pequeño','Mediano','Grande')),
 id_sede NUMBER(3) NOT NULL, CONSTRAINT fk_cubiculo_sede FOREIGN KEY (id_sede) REFERENCES SEDE(id_sede)
);
CREATE TABLE CATEGORIA_COBERTURA (
 id_categoria NUMBER(3) CONSTRAINT pk_categoria PRIMARY KEY,
 nombre_categoria VARCHAR2(80) NOT NULL CONSTRAINT uq_categoria UNIQUE,
 porcentaje_descuento NUMBER(5,2) DEFAULT 0 NOT NULL,
 CONSTRAINT ck_categoria_descuento CHECK (porcentaje_descuento BETWEEN 0 AND 100)
);
CREATE TABLE SERVICIO (
 codigo_servicio NUMBER(6) CONSTRAINT pk_servicio PRIMARY KEY, nombre VARCHAR2(100) NOT NULL,
 descripcion VARCHAR2(200) NOT NULL, id_categoria NUMBER(3) NOT NULL,
 CONSTRAINT fk_servicio_categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_COBERTURA(id_categoria)
);
CREATE TABLE RAZON_SALDO (
 codigo_razon NUMBER(3) CONSTRAINT pk_razon PRIMARY KEY, descripcion VARCHAR2(120) NOT NULL
);
CREATE TABLE PLAN_BIENESTAR (
 id_plan NUMBER(3) CONSTRAINT pk_plan PRIMARY KEY, nombre_plan VARCHAR2(40) NOT NULL CONSTRAINT uq_plan UNIQUE,
 mensualidad NUMBER(12,2) NOT NULL CONSTRAINT ck_plan_mensualidad CHECK (mensualidad >= 0)
);
CREATE TABLE CONTRATO_AFILIACION (
 numero_contrato NUMBER(10) CONSTRAINT pk_contrato PRIMARY KEY,
 codigo_historia_clinica NUMBER(10) NOT NULL, id_plan NUMBER(3) NOT NULL, id_categoria NUMBER(3) NOT NULL,
 valor_maximo_cubierto NUMBER(14,2) NOT NULL CONSTRAINT ck_contrato_max CHECK (valor_maximo_cubierto >= 0),
 activo VARCHAR2(10) DEFAULT 'Activo' NOT NULL CONSTRAINT ck_contrato_activo CHECK (activo IN ('Activo','No activo')),
 numero_contrato_principal NUMBER(10),
 CONSTRAINT fk_contrato_paciente FOREIGN KEY (codigo_historia_clinica) REFERENCES PACIENTE(codigo_historia_clinica),
 CONSTRAINT fk_contrato_plan FOREIGN KEY (id_plan) REFERENCES PLAN_BIENESTAR(id_plan),
 CONSTRAINT fk_contrato_categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_COBERTURA(id_categoria),
 CONSTRAINT fk_contrato_principal FOREIGN KEY (numero_contrato_principal) REFERENCES CONTRATO_AFILIACION(numero_contrato),
 CONSTRAINT ck_contrato_no_self CHECK (numero_contrato_principal IS NULL OR numero_contrato_principal <> numero_contrato)
);
CREATE TABLE EVENTO_CLINICO (
 id_evento NUMBER(10) CONSTRAINT pk_evento PRIMARY KEY, codigo_historia_clinica NUMBER(10) NOT NULL,
 cedula_responsable NUMBER(12) NOT NULL,
 tipo_evento VARCHAR2(20) NOT NULL CONSTRAINT ck_evento_tipo CHECK (tipo_evento IN ('Cita','Examen','Procedimiento','Control')),
 fecha_hora_programada TIMESTAMP NOT NULL, fecha_hora_realizacion TIMESTAMP, id_evento_previo NUMBER(10),
 id_sede NUMBER(3) NOT NULL,
 CONSTRAINT fk_evento_paciente FOREIGN KEY (codigo_historia_clinica) REFERENCES PACIENTE(codigo_historia_clinica),
 CONSTRAINT fk_evento_personal FOREIGN KEY (cedula_responsable) REFERENCES PERSONAL(cedula_personal),
 CONSTRAINT fk_evento_previo FOREIGN KEY (id_evento_previo) REFERENCES EVENTO_CLINICO(id_evento),
 CONSTRAINT fk_evento_sede FOREIGN KEY (id_sede) REFERENCES SEDE(id_sede),
 CONSTRAINT ck_evento_no_self CHECK (id_evento_previo IS NULL OR id_evento_previo <> id_evento)
);
CREATE TABLE MOTIVO_CLINICO (
 id_evento NUMBER(10) NOT NULL, numero_motivo NUMBER(3) NOT NULL, descripcion VARCHAR2(250) NOT NULL,
 CONSTRAINT pk_motivo PRIMARY KEY (id_evento,numero_motivo),
 CONSTRAINT fk_motivo_evento FOREIGN KEY (id_evento) REFERENCES EVENTO_CLINICO(id_evento)
);
CREATE TABLE USO_CUBICULO (
 id_uso_cubiculo NUMBER(10) CONSTRAINT pk_uso PRIMARY KEY, id_evento NUMBER(10) NOT NULL,
 id_cubiculo NUMBER(10) NOT NULL, fecha_hora_inicio TIMESTAMP NOT NULL, fecha_hora_fin TIMESTAMP,
 CONSTRAINT fk_uso_evento FOREIGN KEY (id_evento) REFERENCES EVENTO_CLINICO(id_evento),
 CONSTRAINT fk_uso_cubiculo FOREIGN KEY (id_cubiculo) REFERENCES CUBICULO(id_cubiculo),
 CONSTRAINT ck_uso_fechas CHECK (fecha_hora_fin IS NULL OR fecha_hora_fin > fecha_hora_inicio)
);
CREATE TABLE COBRO_SERVICIO (
 id_cobro NUMBER(10) CONSTRAINT pk_cobro PRIMARY KEY, id_evento NUMBER(10) NOT NULL,
 codigo_servicio NUMBER(6) NOT NULL, cedula_ejecutor NUMBER(12) NOT NULL, numero_contrato NUMBER(10) NOT NULL,
 fecha_realizacion DATE NOT NULL, monto_facturado NUMBER(14,2) NOT NULL CONSTRAINT ck_cobro_facturado CHECK (monto_facturado >= 0),
 monto_cubierto NUMBER(14,2) DEFAULT 0 NOT NULL CONSTRAINT ck_cobro_cubierto CHECK (monto_cubierto >= 0),
 monto_pagado NUMBER(14,2) CONSTRAINT ck_cobro_pagado CHECK (monto_pagado IS NULL OR monto_pagado >= 0),
 saldo_pendiente NUMBER(14,2) DEFAULT 0 NOT NULL CONSTRAINT ck_cobro_saldo CHECK (saldo_pendiente >= 0),
 fecha_pago DATE, codigo_razon NUMBER(3), id_cobro_origen NUMBER(10),
 CONSTRAINT fk_cobro_evento FOREIGN KEY (id_evento) REFERENCES EVENTO_CLINICO(id_evento),
 CONSTRAINT fk_cobro_servicio FOREIGN KEY (codigo_servicio) REFERENCES SERVICIO(codigo_servicio),
 CONSTRAINT fk_cobro_ejecutor FOREIGN KEY (cedula_ejecutor) REFERENCES PERSONAL(cedula_personal),
 CONSTRAINT fk_cobro_contrato FOREIGN KEY (numero_contrato) REFERENCES CONTRATO_AFILIACION(numero_contrato),
 CONSTRAINT fk_cobro_razon FOREIGN KEY (codigo_razon) REFERENCES RAZON_SALDO(codigo_razon),
 CONSTRAINT fk_cobro_origen FOREIGN KEY (id_cobro_origen) REFERENCES COBRO_SERVICIO(id_cobro),
 CONSTRAINT ck_cobro_no_self CHECK (id_cobro_origen IS NULL OR id_cobro_origen <> id_cobro),
 CONSTRAINT ck_cobro_suma CHECK (monto_cubierto + NVL(monto_pagado, 0) <= monto_facturado),
 CONSTRAINT ck_cobro_fecha_pago CHECK (monto_pagado IS NULL OR monto_pagado = 0 OR fecha_pago IS NOT NULL)
);

-- VIAC: inserción de datos de prueba. Ejecutar después del DDL.
INSERT INTO SEDE (id_sede, nombre_sede, ciudad, direccion, telefono) VALUES (1, 'VIAC Bogotá Norte', 'Bogotá', 'Calle 100 # 15-20', '6015550101');
INSERT INTO SEDE (id_sede, nombre_sede, ciudad, direccion, telefono) VALUES (2, 'VIAC Medellín', 'Medellín', 'Carrera 43A # 1-50', '6045550102');
INSERT INTO SEDE (id_sede, nombre_sede, ciudad, direccion, telefono) VALUES (3, 'VIAC Cali', 'Cali', 'Avenida 6N # 28-40', '6025550103');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000001, 'Laura Martínez Luna', 'Calle 72 # 10-12', 'tutor01@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000002, 'Andrés Felipe Gómez Nieto', 'Carrera 15 # 11-15', 'tutor02@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000003, 'Camila Torres Mejía', 'Avenida 19 # 12-18', 'tutor03@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000004, 'Juan Sebastián Ruiz Arias', 'Calle 134 # 13-21', 'tutor04@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000005, 'Valentina Castro Sarmiento', 'Carrera 7 # 14-24', 'tutor05@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000006, 'Daniela Herrera Suárez', 'Calle 26 # 15-27', 'tutor06@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000007, 'Mateo Vargas Luna', 'Carrera 30 # 16-30', 'tutor07@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000008, 'Sofía Ramírez Nieto', 'Calle 93 # 17-33', 'tutor08@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000009, 'Nicolás Pérez Mejía', 'Carrera 11 # 18-36', 'tutor09@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000010, 'Isabella Moreno Arias', 'Avenida 6N # 19-39', 'tutor10@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000011, 'Felipe Sánchez Sarmiento', 'Calle 72 # 20-42', 'tutor11@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000012, 'Mariana Ortiz Suárez', 'Carrera 15 # 21-45', 'tutor12@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000013, 'Samuel Jiménez Luna', 'Avenida 19 # 22-48', 'tutor13@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000014, 'Gabriela Rojas Nieto', 'Calle 134 # 23-51', 'tutor14@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000015, 'David Cárdenas Mejía', 'Carrera 7 # 24-54', 'tutor15@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000016, 'Lucía Acosta Arias', 'Calle 26 # 25-57', 'tutor16@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000017, 'Esteban Silva Sarmiento', 'Carrera 30 # 26-60', 'tutor17@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000018, 'Paula Mendoza Suárez', 'Calle 93 # 27-63', 'tutor18@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000019, 'Martín Beltrán Luna', 'Carrera 11 # 28-66', 'tutor19@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000020, 'Juliana Pineda Nieto', 'Avenida 6N # 29-69', 'tutor20@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000021, 'Alejandro Restrepo Mejía', 'Calle 72 # 30-72', 'tutor21@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000022, 'Manuela Londoño Arias', 'Carrera 15 # 31-75', 'tutor22@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000023, 'Tomás Arango Sarmiento', 'Avenida 19 # 32-78', 'tutor23@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000024, 'Catalina Salazar Suárez', 'Calle 134 # 33-81', 'tutor24@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000025, 'Sebastián Quintero Luna', 'Carrera 7 # 34-84', 'tutor25@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000026, 'Natalia Cifuentes Nieto', 'Calle 26 # 35-87', 'tutor26@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000027, 'Santiago Ospina Mejía', 'Carrera 30 # 36-90', 'tutor27@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000028, 'Antonia Vélez Arias', 'Calle 93 # 37-13', 'tutor28@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000029, 'Miguel Ángel Rincón Sarmiento', 'Carrera 11 # 38-16', 'tutor29@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000030, 'Sara Parra Suárez', 'Avenida 6N # 39-19', 'tutor30@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000031, 'Emilio Bermúdez Luna', 'Calle 72 # 40-22', 'tutor31@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000032, 'Renata Correa Nieto', 'Carrera 15 # 41-25', 'tutor32@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000033, 'Julián Giraldo Mejía', 'Avenida 19 # 42-28', 'tutor33@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000034, 'María José Navarro Arias', 'Calle 134 # 43-31', 'tutor34@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000035, 'Simón Pardo Sarmiento', 'Carrera 7 # 44-34', 'tutor35@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000036, 'Elena Rey Suárez', 'Calle 26 # 45-37', 'tutor36@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000037, 'Pablo Soler Luna', 'Carrera 30 # 46-40', 'tutor37@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000038, 'Victoria Cano Nieto', 'Calle 93 # 47-43', 'tutor38@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000039, 'Diego Nieto Mejía', 'Carrera 11 # 48-46', 'tutor39@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000040, 'Ana María León Arias', 'Avenida 6N # 49-49', 'tutor40@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000041, 'Cristóbal Marín Sarmiento', 'Calle 72 # 50-52', 'tutor41@correo.test');
INSERT INTO TUTOR_PRINCIPAL (cedula_tutor, nombre_completo, direccion, correo_electronico) VALUES (10000042, 'Carolina Solano Suárez', 'Carrera 15 # 51-55', 'tutor42@correo.test');
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700001, 'Luna', 'Perro', 'Golden Retriever', 'Hembra', TO_DATE('2017-01-01', 'YYYY-MM-DD'), 27.3, 10000001);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700002, 'Max', 'Perro', 'Pastor Alemán', 'Macho', TO_DATE('2018-06-08', 'YYYY-MM-DD'), 34.5, 10000001);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700003, 'Milo', 'Perro', 'Border Collie', 'Macho', TO_DATE('2019-11-15', 'YYYY-MM-DD'), 18.3, 10000002);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700004, 'Nala', 'Perro', 'Husky Siberiano', 'Hembra', TO_DATE('2020-04-22', 'YYYY-MM-DD'), 19.5, 10000002);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700005, 'Toby', 'Gato', 'Angora', 'Macho', TO_DATE('2021-09-02', 'YYYY-MM-DD'), 5.52, 10000003);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700006, 'Kira', 'Perro', 'Pastor Alemán', 'Hembra', TO_DATE('2022-02-09', 'YYYY-MM-DD'), 29.8, 10000003);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700007, 'Rocky', 'Perro', 'Border Collie', 'Macho', TO_DATE('2023-07-16', 'YYYY-MM-DD'), 17.22, 10000004);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700008, 'Mía', 'Perro', 'Husky Siberiano', 'Hembra', TO_DATE('2024-12-23', 'YYYY-MM-DD'), 19.59, 10000004);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700009, 'Simba', 'Perro', 'Golden Retriever', 'Macho', TO_DATE('2017-05-03', 'YYYY-MM-DD'), 30.2, 10000005);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700010, 'Coco', 'Gato', 'Criollo', 'Hembra', TO_DATE('2018-10-10', 'YYYY-MM-DD'), 2.67, 10000005);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700011, 'Bruno', 'Perro', 'Border Collie', 'Macho', TO_DATE('2019-03-17', 'YYYY-MM-DD'), 20.4, 10000006);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700012, 'Lola', 'Perro', 'Husky Siberiano', 'Hembra', TO_DATE('2020-08-24', 'YYYY-MM-DD'), 21.8, 10000006);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700013, 'Thor', 'Perro', 'Golden Retriever', 'Macho', TO_DATE('2021-01-04', 'YYYY-MM-DD'), 31.44, 10000007);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700014, 'Kiara', 'Perro', 'Pastor Alemán', 'Hembra', TO_DATE('2022-06-11', 'YYYY-MM-DD'), 33.81, 10000007);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700015, 'Dante', 'Gato', 'Siamés', 'Macho', TO_DATE('2023-11-18', 'YYYY-MM-DD'), 6.82, 10000008);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700016, 'Mora', 'Perro', 'Husky Siberiano', 'Hembra', TO_DATE('2024-04-25', 'YYYY-MM-DD'), 22.6, 10000008);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700017, 'Bongo', 'Perro', 'Golden Retriever', 'Macho', TO_DATE('2017-09-05', 'YYYY-MM-DD'), 29.6, 10000009);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700018, 'Pelusa', 'Perro', 'Pastor Alemán', 'Hembra', TO_DATE('2018-02-12', 'YYYY-MM-DD'), 28.7, 10000009);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700019, 'Manchas', 'Perro', 'Border Collie', 'Macho', TO_DATE('2019-07-19', 'YYYY-MM-DD'), 17.6, 10000010);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700020, 'Rocco', 'Gato', 'Persa', 'Macho', TO_DATE('2020-12-26', 'YYYY-MM-DD'), 3.97, 10000010);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700021, 'Canela', 'Perro', 'Bulldog Francés', 'Hembra', TO_DATE('2021-05-06', 'YYYY-MM-DD'), 13.4, 10000011);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700022, 'Nube', 'Perro', 'Beagle', 'Hembra', TO_DATE('2022-10-13', 'YYYY-MM-DD'), 11.4, 10000011);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700023, 'Otto', 'Perro', 'Shih Tzu', 'Macho', TO_DATE('2023-03-20', 'YYYY-MM-DD'), 6.8, 10000012);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700024, 'Frida', 'Perro', 'Cocker Spaniel', 'Hembra', TO_DATE('2024-08-27', 'YYYY-MM-DD'), 12.6, 10000012);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700025, 'Chispa', 'Gato', 'Bengalí', 'Macho', TO_DATE('2017-01-07', 'YYYY-MM-DD'), 8.12, 10000013);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700026, 'Balú', 'Perro', 'Beagle', 'Macho', TO_DATE('2018-06-14', 'YYYY-MM-DD'), 13.2, 10000013);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700027, 'Pecas', 'Perro', 'Shih Tzu', 'Macho', TO_DATE('2019-11-21', 'YYYY-MM-DD'), 7.4, 10000014);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700028, 'Tango', 'Perro', 'Cocker Spaniel', 'Hembra', TO_DATE('2020-04-01', 'YYYY-MM-DD'), 13.4, 10000014);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700029, 'Maya', 'Perro', 'Bulldog Francés', 'Hembra', TO_DATE('2021-09-08', 'YYYY-MM-DD'), 10.8, 10000015);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700030, 'Tom', 'Gato', 'Ragdoll', 'Macho', TO_DATE('2022-02-15', 'YYYY-MM-DD'), 5.27, 10000015);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700031, 'Olivia', 'Perro', 'Shih Tzu', 'Hembra', TO_DATE('2023-07-22', 'YYYY-MM-DD'), 5.9, 10000016);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700032, 'Zeus', 'Perro', 'Cocker Spaniel', 'Macho', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 14.1, 10000016);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700033, 'Pipa', 'Perro', 'Bulldog Francés', 'Hembra', TO_DATE('2017-05-09', 'YYYY-MM-DD'), 9.6, 10000017);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700034, 'Cleo', 'Perro', 'Beagle', 'Hembra', TO_DATE('2018-10-16', 'YYYY-MM-DD'), 10.3, 10000017);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700035, 'Nacho', 'Gato', 'Angora', 'Macho', TO_DATE('2019-03-23', 'YYYY-MM-DD'), 2.42, 10000018);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700036, 'Duna', 'Perro', 'Cocker Spaniel', 'Hembra', TO_DATE('2020-08-03', 'YYYY-MM-DD'), 11.95, 10000018);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700037, 'Bowie', 'Perro', 'Bulldog Francés', 'Macho', TO_DATE('2021-01-10', 'YYYY-MM-DD'), 12.9, 10000019);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700038, 'Mochi', 'Perro', 'Beagle', 'Hembra', TO_DATE('2022-06-17', 'YYYY-MM-DD'), 10.9, 10000020);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700039, 'Tita', 'Perro', 'Shih Tzu', 'Hembra', TO_DATE('2023-11-24', 'YYYY-MM-DD'), 5.6, 10000021);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700040, 'Apolo', 'Gato', 'Criollo', 'Macho', TO_DATE('2024-04-04', 'YYYY-MM-DD'), 6.57, 10000022);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700041, 'Gala', 'Perro', 'Criollo', 'Hembra', TO_DATE('2017-09-11', 'YYYY-MM-DD'), 23.8, 10000023);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700042, 'Rita', 'Perro', 'Poodle', 'Hembra', TO_DATE('2018-02-18', 'YYYY-MM-DD'), 26.17, 10000024);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700043, 'Nico', 'Perro', 'Schnauzer', 'Macho', TO_DATE('2019-07-25', 'YYYY-MM-DD'), 16.8, 10000025);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700044, 'Koda', 'Perro', 'Labrador Retriever', 'Hembra', TO_DATE('2020-12-05', 'YYYY-MM-DD'), 30.91, 10000026);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700045, 'Trufa', 'Gato', 'Persa', 'Macho', TO_DATE('2021-05-12', 'YYYY-MM-DD'), 3.72, 10000027);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700046, 'Bimba', 'Perro', 'Poodle', 'Hembra', TO_DATE('2022-10-19', 'YYYY-MM-DD'), 27.4, 10000028);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700047, 'Salem', 'Perro', 'Schnauzer', 'Macho', TO_DATE('2023-03-26', 'YYYY-MM-DD'), 18.2, 10000029);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700048, 'Pongo', 'Perro', 'Labrador Retriever', 'Macho', TO_DATE('2024-08-06', 'YYYY-MM-DD'), 31.6, 10000030);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700049, 'Mango', 'Perro', 'Criollo', 'Macho', TO_DATE('2017-01-13', 'YYYY-MM-DD'), 5.76, 10000031);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700050, 'Atenea', 'Gato', 'Maine Coon', 'Hembra', TO_DATE('2018-06-20', 'YYYY-MM-DD'), 7.87, 10000032);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700051, 'Félix', 'Perro', 'Schnauzer', 'Macho', TO_DATE('2019-11-27', 'YYYY-MM-DD'), 15.3, 10000033);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700052, 'Sasha', 'Perro', 'Labrador Retriever', 'Hembra', TO_DATE('2020-04-07', 'YYYY-MM-DD'), 28.9, 10000034);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700053, 'Lichi', 'Perro', 'Criollo', 'Macho', TO_DATE('2021-09-14', 'YYYY-MM-DD'), 15.24, 10000035);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700054, 'Ciro', 'Perro', 'Poodle', 'Macho', TO_DATE('2022-02-21', 'YYYY-MM-DD'), 22.8, 10000036);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700055, 'Tina', 'Gato', 'Bengalí', 'Hembra', TO_DATE('2023-07-01', 'YYYY-MM-DD'), 5.02, 10000037);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700056, 'Gus', 'Perro', 'Labrador Retriever', 'Macho', TO_DATE('2024-12-08', 'YYYY-MM-DD'), 33.2, 10000038);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700057, 'Uma', 'Perro', 'Criollo', 'Hembra', TO_DATE('2017-05-15', 'YYYY-MM-DD'), 24.72, 10000039);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700058, 'Paco', 'Perro', 'Poodle', 'Macho', TO_DATE('2018-10-22', 'YYYY-MM-DD'), 27.09, 10000040);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700059, 'Miel', 'Perro', 'Schnauzer', 'Macho', TO_DATE('2019-03-02', 'YYYY-MM-DD'), 17.4, 10000041);
INSERT INTO PACIENTE (codigo_historia_clinica, nombre, especie, raza, sexo, fecha_nacimiento, peso_actual, cedula_tutor) VALUES (700060, 'Boris', 'Gato', 'Ragdoll', 'Macho', TO_DATE('2020-08-09', 'YYYY-MM-DD'), 9.17, 10000042);
INSERT INTO TITULO (nombre_titulo) VALUES ('Médico Veterinario');
INSERT INTO TITULO (nombre_titulo) VALUES ('Especialista en Cirugía Veterinaria');
INSERT INTO TITULO (nombre_titulo) VALUES ('Especialista en Medicina Interna');
INSERT INTO TITULO (nombre_titulo) VALUES ('Especialista en Diagnóstico por Imagen');
INSERT INTO TITULO (nombre_titulo) VALUES ('Especialista en Dermatología Veterinaria');
INSERT INTO TITULO (nombre_titulo) VALUES ('Enfermería Veterinaria');
INSERT INTO TITULO (nombre_titulo) VALUES ('Bacteriología Clínica');
INSERT INTO TITULO (nombre_titulo) VALUES ('Anestesiología Veterinaria');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Polen');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Ácaros del polvo');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Picadura de pulga');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Proteína de pollo');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Proteína de res');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Lácteos');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Trigo');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Soja');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Penicilina');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Sulfonamidas');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Clorhexidina');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Látex');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Picadura de abeja');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Camarón');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Huevo');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Ciertos conservantes');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Césped');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Moho');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('Polvo ambiental');
INSERT INTO ALERGIA (nombre_alergia) VALUES ('AINE específico');
INSERT INTO CATEGORIA_COBERTURA (id_categoria, nombre_categoria, porcentaje_descuento) VALUES (1, 'Consulta externa', 15);
INSERT INTO CATEGORIA_COBERTURA (id_categoria, nombre_categoria, porcentaje_descuento) VALUES (2, 'Diagnóstico', 20);
INSERT INTO CATEGORIA_COBERTURA (id_categoria, nombre_categoria, porcentaje_descuento) VALUES (3, 'Cirugía', 25);
INSERT INTO CATEGORIA_COBERTURA (id_categoria, nombre_categoria, porcentaje_descuento) VALUES (4, 'Hospitalización', 20);
INSERT INTO CATEGORIA_COBERTURA (id_categoria, nombre_categoria, porcentaje_descuento) VALUES (5, 'Farmacia', 10);
INSERT INTO CATEGORIA_COBERTURA (id_categoria, nombre_categoria, porcentaje_descuento) VALUES (6, 'Prevención', 30);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1001, 'Consulta general', 'Valoración clínica integral', 1);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1002, 'Consulta especializada', 'Valoración por especialista', 1);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1003, 'Hemograma', 'Análisis hematológico', 2);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1004, 'Perfil bioquímico', 'Panel de química sanguínea', 2);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1005, 'Radiografía', 'Estudio radiográfico', 2);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1006, 'Ecografía', 'Estudio ecográfico', 2);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1007, 'Cirugía de tejidos blandos', 'Procedimiento quirúrgico', 3);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1008, 'Anestesia', 'Servicio anestésico', 3);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1009, 'Día de hospitalización', 'Estancia en cubículo', 4);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1010, 'Curación', 'Limpieza y manejo de herida', 4);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1011, 'Medicamento aplicado', 'Medicamento administrado por personal clínico', 5);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1012, 'Vacunación', 'Aplicación de vacuna', 6);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1013, 'Desparasitación', 'Tratamiento antiparasitario', 6);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1014, 'Control posoperatorio', 'Seguimiento tras cirugía', 1);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1015, 'Prueba dermatológica', 'Prueba de alergia o piel', 2);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1016, 'Fluidoterapia', 'Administración de fluidos', 4);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1017, 'Perfil renal', 'Evaluación renal', 2);
INSERT INTO SERVICIO (codigo_servicio, nombre, descripcion, id_categoria) VALUES (1018, 'Microchip', 'Identificación electrónica', 6);
INSERT INTO RAZON_SALDO (codigo_razon, descripcion) VALUES (1, 'Pago pendiente por acuerdo con el tutor');
INSERT INTO RAZON_SALDO (codigo_razon, descripcion) VALUES (2, 'Diferencia no cubierta por el plan');
INSERT INTO RAZON_SALDO (codigo_razon, descripcion) VALUES (3, 'Pendiente de validación del asegurador');
INSERT INTO RAZON_SALDO (codigo_razon, descripcion) VALUES (4, 'Dificultad económica reportada por el tutor');
INSERT INTO RAZON_SALDO (codigo_razon, descripcion) VALUES (5, 'Servicio excluido de la cobertura');
INSERT INTO RAZON_SALDO (codigo_razon, descripcion) VALUES (6, 'Pago parcial en proceso');
INSERT INTO RAZON_SALDO (codigo_razon, descripcion) VALUES (7, 'Pendiente de conciliación administrativa');
INSERT INTO PLAN_BIENESTAR (id_plan, nombre_plan, mensualidad) VALUES (1, 'Plan Cachorro', 85000);
INSERT INTO PLAN_BIENESTAR (id_plan, nombre_plan, mensualidad) VALUES (2, 'Plan Integral', 145000);
INSERT INTO PLAN_BIENESTAR (id_plan, nombre_plan, mensualidad) VALUES (3, 'Plan Senior', 165000);
INSERT INTO PLAN_BIENESTAR (id_plan, nombre_plan, mensualidad) VALUES (4, 'Plan Premium', 235000);
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000001, 'María Fernanda Moreno Mejía', 'Médico veterinario', 'Femenino', 'Calle 80 # 20-13', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000001, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000001, 'Especialista en Diagnóstico por Imagen');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000002, 'Carlos Andrés Sánchez Patiño', 'Médico veterinario', 'Masculino', 'Carrera 12 # 21-14', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000002, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000002, 'Especialista en Cirugía Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000003, 'Diana Marcela Ortiz Lozano', 'Médico veterinario especialista', 'Femenino', 'Calle 45 # 22-15', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000003, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000003, 'Especialista en Medicina Interna');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000004, 'Jorge Iván Jiménez Cardona', 'Médico veterinario', 'Masculino', 'Avenida 30 # 23-16', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000004, 'Médico Veterinario');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000005, 'Paola Andrea Rojas Guerra', 'Enfermero veterinario', 'Femenino', 'Calle 80 # 24-17', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000005, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000006, 'Ricardo José Cárdenas Bernal', 'Enfermero veterinario', 'Masculino', 'Carrera 12 # 25-18', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000006, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000007, 'Andrea Carolina Acosta Osorio', 'Auxiliar clínico', 'Femenino', 'Calle 45 # 26-19', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000007, 'Bacteriología Clínica');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000008, 'Felipe Santiago Silva Arias', 'Médico veterinario especialista', 'Masculino', 'Avenida 30 # 27-20', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000008, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000008, 'Anestesiología Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000009, 'Laura Camila Mendoza Bautista', 'Enfermero veterinario', 'Femenino', 'Calle 80 # 28-21', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000009, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000010, 'Óscar Mauricio Beltrán Rueda', 'Coordinador clínico', 'Masculino', 'Carrera 12 # 29-22', 1);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000010, 'Médico Veterinario');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000011, 'Natalia Isabel Pineda Acero', 'Médico veterinario', 'Femenino', 'Calle 80 # 20-16', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000011, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000011, 'Especialista en Medicina Interna');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000012, 'Juan Pablo Restrepo Téllez', 'Médico veterinario', 'Masculino', 'Carrera 12 # 21-17', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000012, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000012, 'Especialista en Diagnóstico por Imagen');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000013, 'Claudia Patricia Londoño Fajardo', 'Médico veterinario especialista', 'Femenino', 'Calle 45 # 22-18', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000013, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000013, 'Anestesiología Veterinaria');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000013, 'Especialista en Dermatología Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000014, 'Sergio Alejandro Arango Bohórquez', 'Médico veterinario', 'Masculino', 'Avenida 30 # 23-19', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000014, 'Médico Veterinario');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000015, 'Valeria Sofía Salazar Sarmiento', 'Enfermero veterinario', 'Femenino', 'Calle 80 # 24-20', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000015, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000016, 'Miguel Eduardo Quintero Valencia', 'Enfermero veterinario', 'Masculino', 'Carrera 12 # 25-21', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000016, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000017, 'Luisa Fernanda Cifuentes Molina', 'Auxiliar clínico', 'Femenino', 'Calle 45 # 26-22', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000017, 'Bacteriología Clínica');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000018, 'David Esteban Ospina Castaño', 'Médico veterinario especialista', 'Masculino', 'Avenida 30 # 27-23', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000018, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000018, 'Especialista en Cirugía Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000019, 'Catalina María Vélez Palacios', 'Enfermero veterinario', 'Femenino', 'Calle 80 # 28-24', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000019, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000020, 'Tomás Enrique Rincón Duarte', 'Coordinador clínico', 'Masculino', 'Carrera 12 # 29-25', 2);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000020, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000021, 'Juliana Andrea Parra Peña', 'Médico veterinario', 'Femenino', 'Calle 80 # 20-19', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000021, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000021, 'Anestesiología Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000022, 'Samuel David Bermúdez Suárez', 'Médico veterinario', 'Masculino', 'Carrera 12 # 21-20', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000022, 'Médico Veterinario');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000023, 'Isabel Cristina Correa Barrera', 'Médico veterinario especialista', 'Femenino', 'Calle 45 # 22-21', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000023, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000023, 'Especialista en Cirugía Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000024, 'Manuel Felipe Giraldo Porras', 'Médico veterinario', 'Masculino', 'Avenida 30 # 23-22', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000024, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000024, 'Especialista en Dermatología Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000025, 'Sara Valentina Navarro Zamora', 'Enfermero veterinario', 'Femenino', 'Calle 80 # 24-23', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000025, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000026, 'Daniel Enrique Pardo Rojas', 'Enfermero veterinario', 'Masculino', 'Carrera 12 # 25-24', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000026, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000027, 'Gabriela Inés Rey Pardo', 'Auxiliar clínico', 'Femenino', 'Calle 45 # 26-25', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000027, 'Bacteriología Clínica');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000028, 'Andrés Mauricio Soler Díaz', 'Médico veterinario especialista', 'Masculino', 'Avenida 30 # 27-26', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000028, 'Médico Veterinario');
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000028, 'Especialista en Diagnóstico por Imagen');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000029, 'Mónica Alejandra Cano Luna', 'Enfermero veterinario', 'Femenino', 'Calle 80 # 28-27', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000029, 'Enfermería Veterinaria');
INSERT INTO PERSONAL (cedula_personal, nombre_completo, cargo, sexo, direccion, id_sede) VALUES (20000030, 'Sebastián Nicolás Nieto León', 'Coordinador clínico', 'Masculino', 'Carrera 12 # 29-28', 3);
INSERT INTO PERSONAL_TITULO (cedula_personal, nombre_titulo) VALUES (20000030, 'Médico Veterinario');
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300101, 'Pequeño', 1);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300102, 'Pequeño', 1);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300103, 'Mediano', 1);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300104, 'Mediano', 1);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300105, 'Grande', 1);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300106, 'Grande', 1);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300201, 'Pequeño', 2);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300202, 'Pequeño', 2);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300203, 'Mediano', 2);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300204, 'Mediano', 2);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300205, 'Grande', 2);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300206, 'Grande', 2);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300301, 'Pequeño', 3);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300302, 'Pequeño', 3);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300303, 'Mediano', 3);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300304, 'Mediano', 3);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300305, 'Grande', 3);
INSERT INTO CUBICULO (id_cubiculo, capacidad, id_sede) VALUES (300306, 'Grande', 3);
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000001, 'Ana Gómez');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000003, 'María Torres');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000004, 'Sebastián Ruiz');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000006, 'Felipe Herrera');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000007, 'Valeria Vargas');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000009, 'Sara Pérez');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000010, 'Emilio Cárdenas');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000013, 'Paula Beltrán');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000015, 'Renata Quintero');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000016, 'Tomás Londoño');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000018, 'Julián Restrepo');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000019, 'Mónica Vélez');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000021, 'Elena Pardo');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000022, 'Pablo Salazar');
INSERT INTO CUIDADOR_AUTORIZADO (cedula_cuidador, nombre_completo) VALUES (30000024, 'Nicolás Rincón');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700002, 30000004, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700003, 30000007, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700004, 30000010, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700005, 30000013, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700006, 30000016, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700008, 30000022, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700008, 30000003, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700009, 30000001, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700010, 30000004, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700011, 30000007, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700012, 30000010, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700014, 30000016, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700015, 30000019, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700015, 30000024, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700016, 30000022, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700017, 30000001, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700018, 30000004, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700020, 30000010, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700021, 30000013, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700022, 30000016, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700022, 30000021, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700023, 30000019, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700024, 30000022, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700026, 30000004, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700027, 30000007, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700028, 30000010, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700029, 30000013, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700029, 30000018, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700030, 30000016, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700032, 30000022, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700033, 30000001, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700034, 30000004, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700035, 30000007, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700036, 30000010, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700036, 30000015, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700038, 30000016, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700039, 30000019, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700040, 30000022, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700041, 30000001, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700042, 30000004, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700044, 30000010, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700045, 30000013, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700046, 30000016, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700047, 30000019, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700048, 30000022, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700050, 30000004, 'Amigo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700050, 30000009, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700051, 30000007, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700052, 30000010, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700053, 30000013, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700054, 30000016, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700056, 30000022, 'Cónyuge');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700057, 30000001, 'Hijo/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700057, 30000006, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700058, 30000004, 'Paseador/a');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700059, 30000007, 'Familiar');
INSERT INTO PACIENTE_CUIDADOR (codigo_historia_clinica, cedula_cuidador, vinculo) VALUES (700060, 30000010, 'Amigo/a');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700002, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700003, 'Trigo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700003, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700004, 'Sulfonamidas');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700004, 'Césped');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700004, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700005, 'Picadura de abeja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700006, 'Ciertos conservantes');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700006, 'Picadura de pulga');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700008, 'Ácaros del polvo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700008, 'Penicilina');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700008, 'Ciertos conservantes');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700009, 'Proteína de res');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700009, 'Látex');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700010, 'Soja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700012, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700013, 'Césped');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700013, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700014, 'AINE específico');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700014, 'Trigo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700014, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700015, 'Picadura de pulga');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700016, 'Lácteos');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700016, 'Picadura de abeja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700018, 'Látex');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700018, 'Polvo ambiental');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700018, 'Lácteos');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700019, 'Huevo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700019, 'Ácaros del polvo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700020, 'Moho');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700022, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700023, 'Trigo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700023, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700024, 'Sulfonamidas');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700024, 'Césped');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700024, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700025, 'Picadura de abeja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700026, 'Ciertos conservantes');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700026, 'Picadura de pulga');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700028, 'Ácaros del polvo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700028, 'Penicilina');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700028, 'Ciertos conservantes');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700029, 'Proteína de res');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700029, 'Látex');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700030, 'Soja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700032, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700033, 'Césped');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700033, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700034, 'AINE específico');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700034, 'Trigo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700034, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700035, 'Picadura de pulga');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700036, 'Lácteos');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700036, 'Picadura de abeja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700038, 'Látex');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700038, 'Polvo ambiental');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700038, 'Lácteos');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700039, 'Huevo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700039, 'Ácaros del polvo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700040, 'Moho');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700042, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700043, 'Trigo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700043, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700044, 'Sulfonamidas');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700044, 'Césped');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700044, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700045, 'Picadura de abeja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700046, 'Ciertos conservantes');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700046, 'Picadura de pulga');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700048, 'Ácaros del polvo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700048, 'Penicilina');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700048, 'Ciertos conservantes');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700049, 'Proteína de res');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700049, 'Látex');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700050, 'Soja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700052, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700053, 'Césped');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700053, 'Proteína de pollo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700054, 'AINE específico');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700054, 'Trigo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700054, 'Camarón');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700055, 'Picadura de pulga');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700056, 'Lácteos');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700056, 'Picadura de abeja');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700058, 'Látex');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700058, 'Polvo ambiental');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700058, 'Lácteos');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700059, 'Huevo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700059, 'Ácaros del polvo');
INSERT INTO PACIENTE_ALERGIA (codigo_historia_clinica, nombre_alergia) VALUES (700060, 'Moho');
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000001, 700001, 1, 1, 250000, 'No activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000002, 700001, 2, 1, 500000, 'No activo', 50000001);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000003, 700002, 2, 2, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000004, 700003, 3, 3, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000005, 700004, 4, 4, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000006, 700005, 2, 5, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000007, 700006, 2, 6, 80000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000008, 700006, 4, 6, 100000, 'Activo', 50000007);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000009, 700007, 4, 1, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000010, 700008, 4, 2, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000011, 700009, 3, 3, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000012, 700010, 2, 4, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000013, 700011, 3, 5, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000014, 700011, 4, 5, 500000, 'Activo', 50000013);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000015, 700012, 4, 6, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000016, 700012, 2, 6, 750000, 'Activo', 50000015);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000017, 700013, 2, 1, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000018, 700014, 2, 2, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000019, 700015, 4, 3, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000020, 700016, 4, 4, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000021, 700016, 1, 4, 500000, 'Activo', 50000020);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000022, 700017, 3, 5, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000023, 700018, 2, 6, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000024, 700019, 3, 1, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000025, 700020, 4, 2, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000026, 700021, 2, 3, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000027, 700021, 2, 3, 500000, 'Activo', 50000026);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000028, 700022, 2, 4, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000029, 700023, 4, 5, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000030, 700023, 4, 1, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000031, 700024, 4, 6, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000032, 700025, 3, 1, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000033, 700026, 2, 2, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000034, 700026, 3, 2, 500000, 'No activo', 50000033);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000035, 700027, 3, 3, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000036, 700028, 4, 4, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000037, 700029, 2, 5, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000038, 700030, 2, 6, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000039, 700031, 4, 1, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000040, 700031, 4, 1, 500000, 'Activo', 50000039);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000041, 700032, 4, 2, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000042, 700033, 3, 3, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000043, 700034, 2, 4, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000044, 700034, 3, 4, 2000000, 'Activo', 50000043);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000045, 700035, 3, 5, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000046, 700036, 4, 6, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000047, 700036, 2, 6, 500000, 'Activo', 50000046);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000048, 700037, 2, 1, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000049, 700038, 2, 2, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000050, 700039, 4, 3, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000051, 700040, 4, 4, 2000000, 'No activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000052, 700041, 3, 5, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000053, 700041, 2, 5, 500000, 'Activo', 50000052);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000054, 700042, 2, 6, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000055, 700043, 3, 1, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000056, 700044, 4, 2, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000057, 700045, 2, 3, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000058, 700045, 2, 3, 250000, 'Activo', 50000057);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000059, 700046, 2, 4, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000060, 700046, 4, 4, 500000, 'Activo', 50000059);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000061, 700047, 4, 5, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000062, 700048, 4, 6, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000063, 700049, 3, 1, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000064, 700050, 2, 2, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000065, 700051, 3, 3, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000066, 700051, 4, 3, 500000, 'Activo', 50000065);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000067, 700052, 4, 4, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000068, 700053, 1, 5, 750000, 'No activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000069, 700054, 2, 6, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000070, 700055, 4, 1, 2000000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000071, 700056, 4, 2, 250000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000072, 700056, 1, 4, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000073, 700057, 3, 3, 500000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000074, 700058, 2, 4, 750000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000075, 700059, 3, 5, 1200000, 'Activo', NULL);
INSERT INTO CONTRATO_AFILIACION (numero_contrato, codigo_historia_clinica, id_plan, id_categoria, valor_maximo_cubierto, activo, numero_contrato_principal) VALUES (50000076, 700060, 4, 6, 2000000, 'Activo', NULL);
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000001, 700002, 20000001, 'Cita', TO_TIMESTAMP('2026-08-02 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-02 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000001, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000001, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000046, 700002, 20000003, 'Examen', TO_TIMESTAMP('2026-08-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-11 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000001, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000046, 1, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000046, 2, 'Descartar alteración renal o hepática');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000002, 700004, 20000003, 'Examen', TO_TIMESTAMP('2026-08-04 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-04 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000002, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000002, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000002, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000003, 700006, 20000002, 'Procedimiento', TO_TIMESTAMP('2026-08-06 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-06 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000003, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000003, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000003, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000003, 4, 'Definir manejo anestésico y control del dolor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000004, 700008, 20000007, 'Control', TO_TIMESTAMP('2026-08-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-08 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000004, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000004, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000005, 700010, 20000004, 'Cita', TO_TIMESTAMP('2026-08-10 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-10 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000005, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000005, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000005, 3, 'Actualización de vacunas y prevención');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000006, 700012, 20000001, 'Examen', TO_TIMESTAMP('2026-08-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-12 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000006, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000006, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000006, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000006, 4, 'Confirmar hallazgos de laboratorio');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000007, 700014, 20000003, 'Procedimiento', TO_TIMESTAMP('2026-08-14 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-14 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000007, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000007, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000008, 700016, 20000005, 'Control', TO_TIMESTAMP('2026-08-16 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-16 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000008, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000008, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000008, 3, 'Revisar tolerancia a medicamentos');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000009, 700018, 20000001, 'Cita', TO_TIMESTAMP('2026-08-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-18 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000009, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000009, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000009, 3, 'Actualización de vacunas y prevención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000009, 4, 'Evaluación de dolor referido por el tutor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000010, 700020, 20000009, 'Examen', TO_TIMESTAMP('2026-08-20 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-20 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000010, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000010, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000011, 700002, 20000001, 'Procedimiento', TO_TIMESTAMP('2026-08-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-22 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000046, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000011, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000011, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000011, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000047, 700002, 20000001, 'Control', TO_TIMESTAMP('2026-08-29 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-29 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000011, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000047, 1, 'Evaluar cicatrización y movilidad');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000047, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000012, 700004, 20000003, 'Control', TO_TIMESTAMP('2026-08-24 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 60000002, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000012, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000012, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000012, 3, 'Revisar tolerancia a medicamentos');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000012, 4, 'Evaluar cicatrización y movilidad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000013, 700006, 20000004, 'Cita', TO_TIMESTAMP('2026-08-26 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-26 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000003, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000013, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000013, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000014, 700008, 20000007, 'Examen', TO_TIMESTAMP('2026-08-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-28 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000004, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000014, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000014, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000014, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000015, 700010, 20000002, 'Procedimiento', TO_TIMESTAMP('2026-08-30 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-30 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000005, 1);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000015, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000015, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000015, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000015, 4, 'Definir manejo anestésico y control del dolor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000016, 700023, 20000011, 'Cita', TO_TIMESTAMP('2026-08-27 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-27 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000016, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000016, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000017, 700025, 20000013, 'Examen', TO_TIMESTAMP('2026-08-29 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-29 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000017, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000017, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000017, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000018, 700027, 20000018, 'Procedimiento', TO_TIMESTAMP('2026-08-31 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-31 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000018, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000018, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000018, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000018, 4, 'Definir manejo anestésico y control del dolor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000019, 700029, 20000017, 'Control', TO_TIMESTAMP('2026-09-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-02 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000019, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000019, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000020, 700031, 20000012, 'Cita', TO_TIMESTAMP('2026-09-04 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-04 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000020, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000020, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000020, 3, 'Actualización de vacunas y prevención');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000021, 700033, 20000018, 'Procedimiento', TO_TIMESTAMP('2026-09-06 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-06 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000021, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000021, 2, 'Definir manejo anestésico y control del dolor');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000021, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000021, 4, 'Reducir riesgo de infección posoperatoria');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000022, 700035, 20000013, 'Procedimiento', TO_TIMESTAMP('2026-09-08 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-08 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000022, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000022, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000023, 700037, 20000015, 'Control', TO_TIMESTAMP('2026-09-10 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-10 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000023, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000023, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000023, 3, 'Revisar tolerancia a medicamentos');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000024, 700039, 20000018, 'Procedimiento', TO_TIMESTAMP('2026-09-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-12 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000024, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000024, 2, 'Definir manejo anestésico y control del dolor');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000024, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000024, 4, 'Reducir riesgo de infección posoperatoria');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000025, 700021, 20000018, 'Procedimiento', TO_TIMESTAMP('2026-09-14 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-14 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000025, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000025, 2, 'Definir manejo anestésico y control del dolor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000026, 700023, 20000011, 'Procedimiento', TO_TIMESTAMP('2026-09-16 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-16 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000016, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000026, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000026, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000026, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000027, 700025, 20000013, 'Control', TO_TIMESTAMP('2026-09-18 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-18 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000017, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000027, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000027, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000027, 3, 'Revisar tolerancia a medicamentos');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000027, 4, 'Evaluar cicatrización y movilidad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000028, 700027, 20000012, 'Cita', TO_TIMESTAMP('2026-09-20 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-20 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000018, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000028, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000028, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000029, 700029, 20000017, 'Examen', TO_TIMESTAMP('2026-09-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-22 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000019, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000029, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000029, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000029, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000030, 700031, 20000018, 'Procedimiento', TO_TIMESTAMP('2026-09-24 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-24 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000020, 2);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000030, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000030, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000030, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000030, 4, 'Definir manejo anestésico y control del dolor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000031, 700044, 20000021, 'Cita', TO_TIMESTAMP('2026-09-21 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-21 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000031, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000031, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000032, 700046, 20000023, 'Examen', TO_TIMESTAMP('2026-09-23 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-23 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000032, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000032, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000032, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000033, 700048, 20000023, 'Procedimiento', TO_TIMESTAMP('2026-09-25 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-25 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000033, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000033, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000033, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000033, 4, 'Definir manejo anestésico y control del dolor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000034, 700050, 20000027, 'Control', TO_TIMESTAMP('2026-09-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-27 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000034, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000034, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000035, 700052, 20000022, 'Cita', TO_TIMESTAMP('2026-09-29 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-29 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000035, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000035, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000035, 3, 'Actualización de vacunas y prevención');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000036, 700054, 20000021, 'Examen', TO_TIMESTAMP('2026-10-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-01 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000036, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000036, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000036, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000036, 4, 'Confirmar hallazgos de laboratorio');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000037, 700056, 20000023, 'Procedimiento', TO_TIMESTAMP('2026-10-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-03 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000037, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000037, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000038, 700058, 20000025, 'Control', TO_TIMESTAMP('2026-10-05 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-05 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000038, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000038, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000038, 3, 'Revisar tolerancia a medicamentos');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000039, 700060, 20000024, 'Cita', TO_TIMESTAMP('2026-10-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-07 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000039, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000039, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000039, 3, 'Actualización de vacunas y prevención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000039, 4, 'Evaluación de dolor referido por el tutor');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000040, 700042, 20000029, 'Examen', TO_TIMESTAMP('2026-10-09 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-09 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000040, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000040, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000041, 700044, 20000021, 'Procedimiento', TO_TIMESTAMP('2026-10-11 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-11 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000031, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000041, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000041, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000041, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000042, 700046, 20000023, 'Control', TO_TIMESTAMP('2026-10-13 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-13 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000032, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000042, 1, 'Ajustar indicaciones de cuidado en casa');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000042, 2, 'Verificar evolución desde la atención anterior');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000042, 3, 'Revisar tolerancia a medicamentos');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000042, 4, 'Evaluar cicatrización y movilidad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000043, 700048, 20000022, 'Cita', TO_TIMESTAMP('2026-10-15 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-15 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000033, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000043, 1, 'Valoración del estado general y antecedentes');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000043, 2, 'Revisión de apetito, hidratación y actividad');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000044, 700050, 20000027, 'Examen', TO_TIMESTAMP('2026-10-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-17 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000034, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000044, 1, 'Descartar alteración renal o hepática');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000044, 2, 'Caracterizar lesión observada en consulta');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000044, 3, 'Evaluar respuesta a tratamiento previo');
INSERT INTO EVENTO_CLINICO (id_evento, codigo_historia_clinica, cedula_responsable, tipo_evento, fecha_hora_programada, fecha_hora_realizacion, id_evento_previo, id_sede) VALUES (60000045, 700052, 20000023, 'Procedimiento', TO_TIMESTAMP('2026-10-19 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-19 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), 60000035, 3);
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000045, 1, 'Vigilar signos vitales durante intervención');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000045, 2, 'Reducir riesgo de infección posoperatoria');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000045, 3, 'Resolver lesión o condición diagnosticada');
INSERT INTO MOTIVO_CLINICO (id_evento, numero_motivo, descripcion) VALUES (60000045, 4, 'Definir manejo anestésico y control del dolor');
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000002, 60000003, 300106, TO_TIMESTAMP('2026-08-06 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-06 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000003, 60000007, 300105, TO_TIMESTAMP('2026-08-14 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-14 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000005, 60000011, 300105, TO_TIMESTAMP('2026-08-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000006, 60000015, 300102, TO_TIMESTAMP('2026-08-30 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-30 21:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000007, 60000018, 300201, TO_TIMESTAMP('2026-08-31 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-08-31 20:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000009, 60000022, 300202, TO_TIMESTAMP('2026-09-08 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-08 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000010, 60000026, 300201, TO_TIMESTAMP('2026-09-16 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000012, 60000030, 300202, TO_TIMESTAMP('2026-09-24 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000013, 60000033, 300305, TO_TIMESTAMP('2026-09-25 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-09-25 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000014, 60000037, 300305, TO_TIMESTAMP('2026-10-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-03 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000015, 60000041, 300306, TO_TIMESTAMP('2026-10-11 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO USO_CUBICULO (id_uso_cubiculo, id_evento, id_cubiculo, fecha_hora_inicio, fecha_hora_fin) VALUES (80000016, 60000045, 300305, TO_TIMESTAMP('2026-10-19 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-10-19 21:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000001, 60000001, 1003, 20000001, 50000003, TO_DATE('2026-08-02', 'YYYY-MM-DD'), 63000, 63000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000002, 60000001, 1004, 20000001, 50000003, TO_DATE('2026-08-02', 'YYYY-MM-DD'), 165000, 0, 165000, TO_DATE('2026-08-03', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000003, 60000002, 1010, 20000003, 50000005, TO_DATE('2026-08-04', 'YYYY-MM-DD'), 86000, 0, 86000, TO_DATE('2026-08-05', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000004, 60000003, 1018, 20000005, 50000007, TO_DATE('2026-08-06', 'YYYY-MM-DD'), 105000, 52000, 53000, TO_DATE('2026-08-07', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000005, 60000005, 1010, 20000009, 50000012, TO_DATE('2026-08-10', 'YYYY-MM-DD'), 90000, 0, 30000, TO_DATE('2026-08-12', 'YYYY-MM-DD'), 1, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000006, 60000006, 1018, 20000001, 50000015, TO_DATE('2026-08-12', 'YYYY-MM-DD'), 90000, 22000, 22000, TO_DATE('2026-08-14', 'YYYY-MM-DD'), 4, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000007, 60000007, 1003, 20000003, 50000018, TO_DATE('2026-08-14', 'YYYY-MM-DD'), 77000, 0, 0, NULL, 5, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000008, 60000007, 1004, 20000003, 50000018, TO_DATE('2026-08-14', 'YYYY-MM-DD'), 142000, 142000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000009, 60000008, 1010, 20000005, 50000020, TO_DATE('2026-08-16', 'YYYY-MM-DD'), 94000, 94000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000010, 60000009, 1018, 20000007, 50000023, TO_DATE('2026-08-18', 'YYYY-MM-DD'), 100000, 0, 100000, TO_DATE('2026-08-19', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000011, 60000010, 1006, 20000001, 50000025, TO_DATE('2026-08-20', 'YYYY-MM-DD'), 180000, 90000, 90000, TO_DATE('2026-08-21', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000012, 60000010, 1015, 20000009, 50000025, TO_DATE('2026-08-20', 'YYYY-MM-DD'), 198000, 99000, 0, NULL, 2, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000013, 60000011, 1015, 20000001, 50000003, TO_DATE('2026-08-22', 'YYYY-MM-DD'), 171000, 86000, 0, NULL, 2, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000014, 60000013, 1012, 20000005, 50000007, TO_DATE('2026-08-26', 'YYYY-MM-DD'), 116000, 29000, 29000, TO_DATE('2026-08-28', 'YYYY-MM-DD'), 4, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000015, 60000013, 1004, 20000005, 50000008, TO_DATE('2026-08-26', 'YYYY-MM-DD'), 150000, 0, 0, NULL, 5, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000016, 60000014, 1004, 20000007, 50000010, TO_DATE('2026-08-28', 'YYYY-MM-DD'), 135000, 0, 0, NULL, 5, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000017, 60000015, 1016, 20000009, 50000012, TO_DATE('2026-08-30', 'YYYY-MM-DD'), 231000, 231000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000018, 60000016, 1011, 20000015, 50000029, TO_DATE('2026-08-27', 'YYYY-MM-DD'), 57000, 0, 57000, TO_DATE('2026-08-28', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000019, 60000016, 1002, 20000011, 50000030, TO_DATE('2026-08-27', 'YYYY-MM-DD'), 189000, 94000, 95000, TO_DATE('2026-08-28', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000020, 60000017, 1002, 20000013, 50000032, TO_DATE('2026-08-29', 'YYYY-MM-DD'), 180000, 90000, 90000, TO_DATE('2026-08-30', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000021, 60000018, 1008, 20000013, 50000035, TO_DATE('2026-08-31', 'YYYY-MM-DD'), 405000, 202000, 0, NULL, 2, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000022, 60000019, 1011, 20000016, 50000037, TO_DATE('2026-09-02', 'YYYY-MM-DD'), 66000, 0, 22000, TO_DATE('2026-09-04', 'YYYY-MM-DD'), 1, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000023, 60000019, 1011, 20000016, 50000037, TO_DATE('2026-09-02', 'YYYY-MM-DD'), 57000, 14000, 14000, TO_DATE('2026-09-04', 'YYYY-MM-DD'), 4, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000024, 60000021, 1007, 20000018, 50000042, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 1470000, 0, 0, NULL, 5, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000025, 60000022, 1011, 20000015, 50000045, TO_DATE('2026-09-08', 'YYYY-MM-DD'), 60000, 60000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000026, 60000022, 1011, 20000015, 50000045, TO_DATE('2026-09-08', 'YYYY-MM-DD'), 54000, 0, 54000, TO_DATE('2026-09-09', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000027, 60000023, 1002, 20000013, 50000048, TO_DATE('2026-09-10', 'YYYY-MM-DD'), 198000, 0, 198000, TO_DATE('2026-09-11', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000028, 60000024, 1008, 20000013, 50000050, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 428000, 214000, 214000, TO_DATE('2026-09-13', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000029, 60000025, 1007, 20000018, 50000026, TO_DATE('2026-09-14', 'YYYY-MM-DD'), 1470000, 250000, 0, NULL, 2, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000030, 60000025, 1011, 20000019, 50000027, TO_DATE('2026-09-14', 'YYYY-MM-DD'), 60000, 0, 20000, TO_DATE('2026-09-16', 'YYYY-MM-DD'), 1, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000031, 60000026, 1011, 20000019, 50000029, TO_DATE('2026-09-16', 'YYYY-MM-DD'), 54000, 0, 18000, TO_DATE('2026-09-18', 'YYYY-MM-DD'), 1, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000032, 60000027, 1014, 20000013, 50000032, TO_DATE('2026-09-18', 'YYYY-MM-DD'), 99000, 25000, 25000, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 4, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000033, 60000029, 1011, 20000016, 50000037, TO_DATE('2026-09-22', 'YYYY-MM-DD'), 57000, 57000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000034, 60000030, 1016, 20000018, 50000039, TO_DATE('2026-09-24', 'YYYY-MM-DD'), 220000, 0, 220000, TO_DATE('2026-09-25', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000035, 60000031, 1003, 20000021, 50000056, TO_DATE('2026-09-21', 'YYYY-MM-DD'), 70000, 35000, 35000, TO_DATE('2026-09-22', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000036, 60000031, 1004, 20000021, 50000056, TO_DATE('2026-09-21', 'YYYY-MM-DD'), 135000, 68000, 0, NULL, 2, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000037, 60000032, 1010, 20000023, 50000059, TO_DATE('2026-09-23', 'YYYY-MM-DD'), 99000, 50000, 0, NULL, 2, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000038, 60000033, 1018, 20000025, 50000062, TO_DATE('2026-09-25', 'YYYY-MM-DD'), 95000, 0, 32000, TO_DATE('2026-09-27', 'YYYY-MM-DD'), 1, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000039, 60000034, 1006, 20000028, 50000064, TO_DATE('2026-09-27', 'YYYY-MM-DD'), 210000, 52000, 52000, TO_DATE('2026-09-29', 'YYYY-MM-DD'), 4, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000040, 60000034, 1015, 20000027, 50000064, TO_DATE('2026-09-27', 'YYYY-MM-DD'), 180000, 0, 0, NULL, 5, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000041, 60000035, 1010, 20000029, 50000067, TO_DATE('2026-09-29', 'YYYY-MM-DD'), 81000, 0, 0, NULL, 5, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000042, 60000037, 1003, 20000023, 50000071, TO_DATE('2026-10-03', 'YYYY-MM-DD'), 77000, 0, 77000, TO_DATE('2026-10-04', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000043, 60000037, 1010, 20000023, 50000072, TO_DATE('2026-10-03', 'YYYY-MM-DD'), 86000, 43000, 43000, TO_DATE('2026-10-04', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000044, 60000038, 1010, 20000025, 50000074, TO_DATE('2026-10-05', 'YYYY-MM-DD'), 94000, 47000, 47000, TO_DATE('2026-10-06', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000045, 60000039, 1018, 20000027, 50000076, TO_DATE('2026-10-07', 'YYYY-MM-DD'), 100000, 50000, 0, NULL, 2, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000046, 60000040, 1012, 20000029, 50000054, TO_DATE('2026-10-09', 'YYYY-MM-DD'), 99000, 0, 33000, TO_DATE('2026-10-11', 'YYYY-MM-DD'), 1, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000047, 60000040, 1013, 20000029, 50000054, TO_DATE('2026-10-09', 'YYYY-MM-DD'), 66000, 16000, 16000, TO_DATE('2026-10-11', 'YYYY-MM-DD'), 4, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000048, 60000041, 1015, 20000021, 50000056, TO_DATE('2026-10-11', 'YYYY-MM-DD'), 171000, 43000, 43000, TO_DATE('2026-10-13', 'YYYY-MM-DD'), 4, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000049, 60000042, 1016, 20000023, 50000059, TO_DATE('2026-10-13', 'YYYY-MM-DD'), 220000, 0, 0, NULL, 5, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000050, 60000043, 1012, 20000025, 50000062, TO_DATE('2026-10-15', 'YYYY-MM-DD'), 110000, 110000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000051, 60000043, 1013, 20000025, 50000062, TO_DATE('2026-10-15', 'YYYY-MM-DD'), 54000, 0, 54000, TO_DATE('2026-10-16', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000052, 60000045, 1016, 20000029, 50000067, TO_DATE('2026-10-19', 'YYYY-MM-DD'), 231000, 116000, 115000, TO_DATE('2026-10-20', 'YYYY-MM-DD'), NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000053, 60000003, 1012, 20000005, 50000007, TO_DATE('2026-08-06', 'YYYY-MM-DD'), 80000, 80000, 0, NULL, NULL, NULL);
INSERT INTO COBRO_SERVICIO (id_cobro, id_evento, codigo_servicio, cedula_ejecutor, numero_contrato, fecha_realizacion, monto_facturado, monto_cubierto, monto_pagado, fecha_pago, codigo_razon, id_cobro_origen) VALUES (90000054, 60000003, 1012, 20000005, 50000008, TO_DATE('2026-08-06', 'YYYY-MM-DD'), 40000, 30000, 10000, TO_DATE('2026-08-07', 'YYYY-MM-DD'), NULL, 90000053);
-- Inicialización del saldo físico para los cobros históricos.
-- En el modelo VIAC, el saldo pendiente descuenta tanto la cobertura del plan
-- (monto_cubierto) como los pagos realizados por el tutor (monto_pagado).
UPDATE COBRO_SERVICIO
   SET saldo_pendiente = monto_facturado - monto_cubierto - NVL(monto_pagado, 0);

COMMIT;
