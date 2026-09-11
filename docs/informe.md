# Informe — Proyecto 1, Bases de Datos

**Curso:** Bases de Datos — Ing. Julio Omar Palacio Niño, M.Sc.
**Sistema:** Cafeterías de los servicios de alimentación PUJ

## Integrantes

| Nombre completo | Correo Institucional |
|---|---|
| Pablo Alfonso Jimenez Becerra | jimenezb_p@javeriana.edu.co  |
| Samuel Barrera | ba.samuel@javeriana.edu.co |
| Cristian Almeida | cristian_almeida@javeriana.edu.co |
|  Samuel Alejandro Baron Alba| baronsalejandro@javeriana.edu.co  |

> Cada integrante montó el proyecto completo en su propio usuario.

---

## 1. Creación de tablas (20%)

Script: `sql/01_ddl/01_crear_tablas.sql`

<img width="790" height="856" alt="image" src="https://github.com/user-attachments/assets/05067733-2339-4f0e-8821-d43e91e1285a" />
![Uploading image.png…]()



## 2. Inserción de tuplas (10%)

Scripts: `sql/02_dml/01_edificios.sql` … `05_metas.sql`

(pantallazo de los conteos por tabla, salida de `sql/99_verificacion.sql`)
<img width="797" height="727" alt="image" src="https://github.com/user-attachments/assets/585e7167-8246-43d5-af65-3dcefb6555a4" />




Cumplimiento de los lineamientos obligatorios: *(pantallazo de la verificación)



## 3. Consultas SQL como vistas (70%)

### VISTA_1 — Listado de incumplimientos de metas [10]
*(script + pantallazo de resultados)*

### VISTA_2 — Cobertura de infraestructura [10]
*(script + pantallazo)*

### VISTA_3 — Proyección de comisiones por tipo de contrato [10]
*(script + pantallazo)*

### VISTA_4 — Rendimiento mensual por cafetería [10]
*(script + pantallazo)*

### VISTA_5 — Top de colaboradores sobre el promedio [10]
*(script + pantallazo)*

### VISTA_6 — Cobertura total de edificios [10]
*(script + pantallazo; explicar la interpretación del universo de edificios)*

### VISTA_7 — Colaboradores por edificio y vinculación [20]
*(script + pantallazo; explicar por qué la fila TOTALES no es la suma vertical)*

## 4. Permisos

Script: `sql/04_permisos/01_grants.sql`

*(pantallazo de `SELECT grantee, table_name, privilege FROM user_tab_privs_made WHERE grantee = 'JPALACIO';`)*
