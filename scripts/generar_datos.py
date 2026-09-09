#!/usr/bin/env python3
"""
Generador de los scripts de poblamiento del Proyecto 1 de Bases de Datos (PUJ).

Produce los archivos de sql/02_dml/ cumpliendo TODOS los lineamientos del
enunciado:

  * ~40 edificios, ~5 pisos por edificio, 12 cafeterias.
  * 26 colaboradores entre PLANTA y TEMPORAL.
  * Tabla META con mas de 500 registros sobre un periodo continuo de 6 meses
    (2025-09-01 a 2026-02-28) que ademas cruza el cambio de ano, para que la
    consulta 3 (agrupada por ano) devuelva mas de un grupo.
  * Al menos 2 edificios y 3 pisos explicitamente sin cafeteria.
  * 5 colaboradores con metas en absolutamente todas las cafeterias.
  * 2 colaboradores sin ninguna meta registrada.
  * Meses con metas incumplidas (promedio real por debajo del promedio meta).

Uso:  python3 scripts/generar_datos.py
"""

import os
import random
from datetime import date, timedelta

SEMILLA = 20261  # fija para que el poblamiento sea reproducible
random.seed(SEMILLA)

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SALIDA = os.path.join(RAIZ, "sql", "02_dml")

FECHA_INICIO = date(2025, 9, 1)
FECHA_FIN = date(2026, 2, 28)

# ------------------------------------------------------------------ edificios
NOMBRES_EDIFICIOS = [
    "Barón", "Giraldo", "Fernando Barón", "Emilio Arango", "José Rafael Arboleda",
    "Jesús María Fernández", "Rafael Arboleda", "Pedro Arrupe", "Angel Valtierra",
    "Carlos Ortiz", "Félix Restrepo", "Manuel Briceño", "Gabriel Giraldo",
    "Jorge Hoyos", "Juan XXIII", "Rafael Barrientos", "Luis Carlos Galán",
    "Fernando Barón Norte", "Biblioteca Alfonso Borrero", "Rectoría",
    "Ciencias Básicas", "Ingeniería", "Medicina", "Odontología", "Enfermería",
    "Ciencias Jurídicas", "Ciencias Económicas", "Comunicación y Lenguaje",
    "Filosofía", "Teología", "Artes", "Psicología", "Arquitectura",
    "Laboratorios Norte", "Laboratorios Sur", "Deportes", "Bienestar",
    "Auditorio Marino Troncoso", "Centro Ático", "Parqueadero Central",
]

edificios = [(i + 1, n) for i, n in enumerate(NOMBRES_EDIFICIOS)]

# ---------------------------------------------------------------------- pisos
pisos = []            # (id, numeropiso, idedificio)
pisos_por_edificio = {}
pid = 1
for eid, _ in edificios:
    cantidad = random.choice([4, 5, 5, 5, 6])
    ids = []
    for n in range(1, cantidad + 1):
        pisos.append((pid, n, eid))
        ids.append(pid)
        pid += 1
    pisos_por_edificio[eid] = ids

# ----------------------------------------------------------------- cafeterias
# Las 12 cafeterias se ubican en 9 edificios distintos (algunos con dos), lo que
# deja 31 edificios sin cafeteria y garantiza varias filas en la consulta 7.
UBICACIONES = [
    ("Cafetería Central",        1,  1),   # (nombre, idedificio, numeropiso)
    ("Cafetería Los Cerezos",    1,  3),
    ("Cafetería El Jardín",      2,  1),
    ("Cafetería La Terraza",     4,  2),
    ("Cafetería Punto Verde",    6,  1),
    ("Cafetería Express Norte", 12,  1),
    ("Cafetería Biblioteca",    19,  2),
    ("Cafetería Ingeniería",    22,  1),
    ("Cafetería Ingeniería 4",  22,  4),
    ("Cafetería Medicina",      23,  1),
    ("Cafetería Deportes",      36,  1),
    ("Cafetería Ático",         39,  2),
]

mapa_piso = {(np, ed): i for i, np, ed in pisos}
cafeterias = []       # (id, nombre, idpiso, idedificio)
for i, (nombre, ed, np) in enumerate(UBICACIONES, start=1):
    cafeterias.append((i, nombre, mapa_piso[(np, ed)], ed))

# --------------------------------------------------------------- colaboradores
NOMBRES = [
    "Ana María Rodríguez", "Carlos Alberto Pérez", "Diana Sofía Ramírez",
    "Jorge Enrique Moreno", "Laura Catalina Gómez", "Miguel Ángel Torres",
    "Paula Andrea Castro", "Andrés Felipe Vargas", "Sandra Milena Ruiz",
    "Julián David Herrera", "Natalia Restrepo", "Óscar Iván Suárez",
    "Claudia Patricia León", "Ricardo Alonso Mejía", "Mónica Alejandra Peña",
    "Fernando José Cárdenas", "Adriana Lucía Ospina", "Camilo Ernesto Rojas",
    "Gloria Esperanza Niño", "Héctor Mauricio Salazar", "Liliana Beatriz Cortés",
    "Sebastián Quintero", "Yolanda Marcela Pineda", "Alejandro Bermúdez",
    "Verónica Isabel Duarte", "Nicolás Esteban Guzmán",
]
TIPOS_DOC = ["CC", "CE", "TI"]

colaboradores = []    # (id, nombre, tipodoc, numdoc, vinculacion, comision)
for i, nombre in enumerate(NOMBRES, start=1):
    tipo = "CC" if i % 7 else random.choice(["CE", "TI"])
    numdoc = 1000000000 + i * 1234567 % 900000000
    vinculacion = "PLANTA" if i % 3 else "TEMPORAL"
    comision = random.choice([10, 10, 10, 8, 12, 15, 5, 20])
    colaboradores.append((i, nombre, tipo, numdoc, vinculacion, comision))

# 5 colaboradores con metas en TODAS las cafeterias
COBERTURA_TOTAL = [1, 2, 3, 4, 5]
# 2 colaboradores SIN ninguna meta
SIN_METAS = [25, 26]

# ---------------------------------------------------------------------- metas
dias_periodo = (FECHA_FIN - FECHA_INICIO).days + 1
todas_las_fechas = [FECHA_INICIO + timedelta(days=d) for d in range(dias_periodo)]
# Solo dias habiles: las cafeterias no operan domingos
fechas = [f for f in todas_las_fechas if f.weekday() != 6]

metas = []            # (id, fecha, valormeta, valorreal, idcafeteria, idcolaborador)
mid = 1
ids_cafeterias = [c[0] for c in cafeterias]

for cid, _, _, _, vinc, _ in colaboradores:
    if cid in SIN_METAS:
        continue
    if cid in COBERTURA_TOTAL:
        asignadas = ids_cafeterias[:]          # las 12 cafeterias
        fechas_por_cafeteria = 6
    else:
        asignadas = random.sample(ids_cafeterias, random.randint(2, 4))
        fechas_por_cafeteria = random.randint(8, 14)

    for caf in asignadas:
        for f in random.sample(fechas, fechas_por_cafeteria):
            base = random.randint(200, 900) * 1000
            mes = f.month
            # Noviembre y febrero son meses "malos": casi todo se incumple.
            if mes in (11, 2):
                factor = random.uniform(0.55, 0.95)
            elif mes in (9, 1):
                factor = random.uniform(0.70, 1.15)
            else:
                factor = random.uniform(0.85, 1.35)
            real = int(base * factor / 1000) * 1000
            metas.append((mid, f, base, real, caf, cid))
            mid += 1

# La PK natural (idcolaborador, idcafeteria, fechameta) no se puede repetir:
# random.sample ya garantiza fechas distintas dentro de cada par, pero se
# verifica de forma explicita antes de escribir el script.
claves = {(m[5], m[4], m[1]) for m in metas}
assert len(claves) == len(metas), "Hay claves naturales repetidas en META"
assert len(metas) >= 500, f"Solo se generaron {len(metas)} metas"

# ------------------------------------------------------------------ escritura
ENCABEZADO = """--------------------------------------------------------------------------------
-- Proyecto 1 - Bases de Datos (PUJ)
-- {titulo}
-- ARCHIVO GENERADO AUTOMATICAMENTE por scripts/generar_datos.py (semilla {semilla})
--------------------------------------------------------------------------------
"""


def escribir(nombre_archivo, titulo, cuerpo):
    ruta = os.path.join(SALIDA, nombre_archivo)
    with open(ruta, "w", encoding="utf-8") as fh:
        fh.write(ENCABEZADO.format(titulo=titulo, semilla=SEMILLA))
        fh.write(cuerpo)
        fh.write("\nCOMMIT;\n")
    print(f"  {nombre_archivo}")


def esc(texto):
    return texto.replace("'", "''")


# --- edificios
cuerpo = "".join(
    f"INSERT INTO edificio (id, nombre) VALUES ({i}, '{esc(n)}');\n"
    for i, n in edificios
)
cuerpo += (
    "\n-- Edificios SIN cafeteria (requisito explicito del enunciado):\n"
    "--   id 3 'Fernando Barón', id 5 'José Rafael Arboleda', id 7 'Rafael Arboleda',\n"
    "--   y 28 edificios mas. Ver la vista VISTA_2.\n"
)
escribir("01_edificios.sql", "Poblamiento: EDIFICIO", cuerpo)

# --- pisos
cuerpo = "".join(
    f"INSERT INTO piso (id, numeropiso, idedificio) VALUES ({i}, {n}, {e});\n"
    for i, n, e in pisos
)
pisos_con_cafeteria = {c[2] for c in cafeterias}
sin_caf = [p for p in pisos if p[0] not in pisos_con_cafeteria][:3]
cuerpo += "\n-- Pisos SIN cafeteria (requisito explicito), por ejemplo:\n"
for i, n, e in sin_caf:
    cuerpo += f"--   piso id {i} (piso {n} del edificio {e})\n"
escribir("02_pisos.sql", "Poblamiento: PISO", cuerpo)

# --- cafeterias
cuerpo = "".join(
    f"INSERT INTO cafeteria (id, nombre, idpiso) VALUES ({i}, '{esc(n)}', {p});"
    f"  -- edificio {e}\n"
    for i, n, p, e in cafeterias
)
escribir("03_cafeterias.sql", "Poblamiento: CAFETERIA", cuerpo)

# --- colaboradores
cuerpo = "".join(
    "INSERT INTO colaborador (id, nombre, tipodocumento, numerodocumento, "
    f"vinculacion, comision)\n  VALUES ({i}, '{esc(n)}', '{t}', {d}, '{v}', {c});\n"
    for i, n, t, d, v, c in colaboradores
)
cuerpo += (
    "\n-- Colaboradores con metas en TODAS las cafeterias: ids "
    + ", ".join(map(str, COBERTURA_TOTAL))
    + "\n-- Colaboradores SIN ninguna meta registrada: ids "
    + ", ".join(map(str, SIN_METAS))
    + "\n"
)
escribir("04_colaboradores.sql", "Poblamiento: COLABORADOR", cuerpo)

# --- metas
cuerpo = "".join(
    "INSERT INTO meta (id, fechameta, valormeta, valorreal, idcafeteria, idcolaborador)\n"
    f"  VALUES ({i}, DATE '{f.isoformat()}', {vm}, {vr}, {caf}, {col});\n"
    for i, f, vm, vr, caf, col in metas
)
cuerpo += (
    f"\n-- Total de registros: {len(metas)}\n"
    f"-- Periodo continuo: {FECHA_INICIO.isoformat()} a {FECHA_FIN.isoformat()} "
    "(6 meses, cruza el cambio de ano)\n"
    "-- Meses con incumplimiento generalizado: noviembre 2025 y febrero 2026\n"
)
escribir("05_metas.sql", "Poblamiento: META", cuerpo)

# --- resincronizacion de las identities
cuerpo = """-- Al insertar los IDs de forma explicita, la secuencia interna de una columna
-- GENERATED BY DEFAULT AS IDENTITY no avanza y quedaria en 1. Estas sentencias
-- la reposicionan en el maximo valor existente, de modo que cualquier INSERT
-- posterior que omita el id no choque contra la llave primaria.

ALTER TABLE edificio    MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE));
ALTER TABLE piso        MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE));
ALTER TABLE cafeteria   MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE));
ALTER TABLE colaborador MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE));
ALTER TABLE meta        MODIFY (id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE));
"""
escribir("06_resincronizar_identities.sql", "Resincronizacion de IDENTITY", cuerpo)

print(f"\nResumen: {len(edificios)} edificios, {len(pisos)} pisos, "
      f"{len(cafeterias)} cafeterias, {len(colaboradores)} colaboradores, "
      f"{len(metas)} metas.")
