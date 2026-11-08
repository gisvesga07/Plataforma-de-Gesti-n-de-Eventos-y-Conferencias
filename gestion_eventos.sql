/* =====================================================================
   PROYECTO FINAL - BASES DE DATOS RELACIONALES (UIS)
   Plataforma de gestión de eventos y conferencias
   Motor: MySQL  |  Herramienta: MySQL Workbench

   CONTENIDO:
     PARTE 1. DDL - Creación del esquema (CREATE DATABASE / CREATE TABLE)
     PARTE 2. DML - Carga de datos (INSERT, mínimo 5 registros por tabla)
     PARTE 3. DML - Diez consultas (SELECT) pertinentes con el tema
   ===================================================================== */


/* =====================================================================
   PARTE 1. DDL - ESQUEMA
   ===================================================================== */

DROP DATABASE IF EXISTS gestion_eventos;
CREATE DATABASE gestion_eventos;
USE gestion_eventos;

CREATE TABLE ESPACIO (
    codigo_espacio VARCHAR(20)  NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    ubicacion      VARCHAR(150) NOT NULL,
    aforo_max      INTEGER      NOT NULL,
    PRIMARY KEY (codigo_espacio),
    CONSTRAINT ck_espacio_aforo CHECK (aforo_max > 0)
);

CREATE TABLE EVENTO (
    codigo_evento  VARCHAR(20)  NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    tipo           VARCHAR(50)  NOT NULL,
    fecha          DATE         NOT NULL,
    hora_inicio    TIME         NOT NULL,
    hora_fin       TIME         NOT NULL,
    codigo_espacio VARCHAR(20)  NOT NULL,
    PRIMARY KEY (codigo_evento),
    FOREIGN KEY (codigo_espacio) REFERENCES ESPACIO(codigo_espacio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_evento_horas CHECK (hora_fin > hora_inicio)
);

CREATE TABLE USUARIO (
    id_usuario     VARCHAR(20)  NOT NULL,
    correo         VARCHAR(100) UNIQUE NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20),
    fecha_registro DATE         NOT NULL,
    PRIMARY KEY (id_usuario)
);

/* Especialización de USUARIO: id_usuario es PK y FK a la vez */
CREATE TABLE USUARIO_ESTANDAR (
    id_usuario VARCHAR(20) NOT NULL,
    edad       INTEGER     NOT NULL,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_estandar_edad CHECK (edad >= 0)
);

CREATE TABLE USUARIO_VIP (
    id_usuario VARCHAR(20)  NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SERVICIO (
    codigo_servicio INTEGER AUTO_INCREMENT,
    tipo            VARCHAR(50) NOT NULL,
    descripcion     VARCHAR(200),
    PRIMARY KEY (codigo_servicio)
);

CREATE TABLE ENTRADA (
    codigo_entrada VARCHAR(20)   NOT NULL,
    tipo           VARCHAR(50)   NOT NULL,
    precio         DECIMAL(10,2) NOT NULL,
    codigo_evento  VARCHAR(20)   NOT NULL,
    PRIMARY KEY (codigo_entrada),
    FOREIGN KEY (codigo_evento) REFERENCES EVENTO(codigo_evento)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_entrada_precio CHECK (precio >= 0)
);

/* Relación N:M entre ENTRADA y SERVICIO (clave primaria compuesta) */
CREATE TABLE ENTRADA_SERVICIO (
    codigo_entrada  VARCHAR(20) NOT NULL,
    codigo_servicio INTEGER     NOT NULL,
    cantidad        INTEGER     NOT NULL,
    PRIMARY KEY (codigo_entrada, codigo_servicio),
    FOREIGN KEY (codigo_entrada) REFERENCES ENTRADA(codigo_entrada)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (codigo_servicio) REFERENCES SERVICIO(codigo_servicio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_es_cantidad CHECK (cantidad > 0)
);

/* Relación N:M entre ENTRADA y USUARIO (clave primaria compuesta) */
CREATE TABLE COMPRA (
    codigo_entrada VARCHAR(20)   NOT NULL,
    id_usuario     VARCHAR(20)   NOT NULL,
    fecha_compra   DATETIME      NOT NULL,
    monto_pagado   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (codigo_entrada, id_usuario),
    FOREIGN KEY (codigo_entrada) REFERENCES ENTRADA(codigo_entrada)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_compra_monto CHECK (monto_pagado >= 0)
);

/* Relación N:M entre USUARIO y EVENTO (un usuario evalúa un evento una vez) */
CREATE TABLE EVALUACION (
    id_evaluacion INTEGER AUTO_INCREMENT,
    id_usuario    VARCHAR(20) NOT NULL,
    codigo_evento VARCHAR(20) NOT NULL,
    calificacion  INTEGER     NOT NULL,
    comentario    TEXT,
    PRIMARY KEY (id_evaluacion),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (codigo_evento) REFERENCES EVENTO(codigo_evento)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_evaluacion UNIQUE (id_usuario, codigo_evento),
    CONSTRAINT ck_eval_calificacion CHECK (calificacion BETWEEN 1 AND 5)
);


/* =====================================================================
   PARTE 2. DML - CARGA DE DATOS
   El orden respeta la integridad referencial: primero las tablas padre.
   ===================================================================== */

/* ---------- ESPACIO (5 registros) ---------- */
INSERT INTO ESPACIO VALUES ('ESP001', 'Auditorio Principal',    'Campus Central, Bucaramanga',           500);
INSERT INTO ESPACIO VALUES ('ESP002', 'Sala de Conferencias A', 'Edificio Tecnológico, Bucaramanga',     120);
INSERT INTO ESPACIO VALUES ('ESP003', 'Salón Santander',        'Centro de Convenciones, Floridablanca', 300);
INSERT INTO ESPACIO VALUES ('ESP004', 'Terraza Panorámica',     'Km 3 Vía Piedecuesta, Piedecuesta',      80);
INSERT INTO ESPACIO VALUES ('ESP005', 'Coliseo Cubierto',       'Zona Deportiva, Girón',                1200);

/* ---------- EVENTO (6 registros) ---------- */
INSERT INTO EVENTO VALUES ('EV001', 'Congreso de Ciencia de Datos 2026', 'Congreso',    '2026-09-12', '08:00:00', '17:00:00', 'ESP001');
INSERT INTO EVENTO VALUES ('EV002', 'Taller de Machine Learning',        'Taller',      '2026-09-26', '09:00:00', '13:00:00', 'ESP002');
INSERT INTO EVENTO VALUES ('EV003', 'Feria Tecnológica Santander',       'Feria',       '2026-10-10', '10:00:00', '20:00:00', 'ESP005');
INSERT INTO EVENTO VALUES ('EV004', 'Panel de Inteligencia Artificial',  'Panel',       '2026-10-24', '14:00:00', '18:00:00', 'ESP003');
INSERT INTO EVENTO VALUES ('EV005', 'Hackathon UIS 2026',                'Competencia', '2026-11-21', '08:00:00', '20:00:00', 'ESP003');
INSERT INTO EVENTO VALUES ('EV006', 'Cena de Gala Anual',                'Social',      '2026-12-05', '19:00:00', '23:30:00', 'ESP004');

/* ---------- USUARIO (12 registros: 7 estándar + 5 VIP) ---------- */
INSERT INTO USUARIO VALUES ('USR001', 'carlos.gomez@example.com',    'Carlos Gómez',    '3101234567', '2026-01-15');
INSERT INTO USUARIO VALUES ('USR002', 'laura.martinez@example.com',  'Laura Martínez',  '3112345678', '2026-02-03');
INSERT INTO USUARIO VALUES ('USR003', 'andres.rojas@example.com',    'Andrés Rojas',    '3123456789', '2026-02-20');
INSERT INTO USUARIO VALUES ('USR004', 'valentina.perez@example.com', 'Valentina Pérez', '3134567890', '2026-03-11');
INSERT INTO USUARIO VALUES ('USR005', 'santiago.diaz@example.com',   'Santiago Díaz',   '3145678901', '2026-03-28');
INSERT INTO USUARIO VALUES ('USR006', 'mariana.castro@example.com',  'Mariana Castro',  '3156789012', '2026-04-09');
INSERT INTO USUARIO VALUES ('USR007', 'felipe.ortiz@example.com',    'Felipe Ortiz',    NULL,         '2026-04-30');
INSERT INTO USUARIO VALUES ('USR008', 'camila.herrera@example.com',  'Camila Herrera',  '3178901234', '2026-05-14');
INSERT INTO USUARIO VALUES ('USR009', 'julian.vargas@example.com',   'Julián Vargas',   '3189012345', '2026-06-02');
INSERT INTO USUARIO VALUES ('USR010', 'daniela.suarez@example.com',  'Daniela Suárez',  '3190123456', '2026-06-25');
INSERT INTO USUARIO VALUES ('USR011', 'sebastian.mora@example.com',  'Sebastián Mora',  '3201234567', '2026-07-08');
INSERT INTO USUARIO VALUES ('USR012', 'paula.ramirez@example.com',   'Paula Ramírez',   '3212345678', '2026-07-19');

/* ---------- USUARIO_ESTANDAR (7 registros) ---------- */
INSERT INTO USUARIO_ESTANDAR VALUES ('USR001', 22);
INSERT INTO USUARIO_ESTANDAR VALUES ('USR002', 25);
INSERT INTO USUARIO_ESTANDAR VALUES ('USR003', 31);
INSERT INTO USUARIO_ESTANDAR VALUES ('USR004', 19);
INSERT INTO USUARIO_ESTANDAR VALUES ('USR005', 28);
INSERT INTO USUARIO_ESTANDAR VALUES ('USR006', 35);
INSERT INTO USUARIO_ESTANDAR VALUES ('USR007', 40);

/* ---------- USUARIO_VIP (5 registros) - contraseña guardada como hash SHA-256 ---------- */
INSERT INTO USUARIO_VIP VALUES ('USR008', SHA2('clave_vip_008', 256));
INSERT INTO USUARIO_VIP VALUES ('USR009', SHA2('clave_vip_009', 256));
INSERT INTO USUARIO_VIP VALUES ('USR010', SHA2('clave_vip_010', 256));
INSERT INTO USUARIO_VIP VALUES ('USR011', SHA2('clave_vip_011', 256));
INSERT INTO USUARIO_VIP VALUES ('USR012', SHA2('clave_vip_012', 256));

/* ---------- SERVICIO (6 registros) ---------- */
INSERT INTO SERVICIO VALUES (1, 'Alimentación',  'Acceso al buffet');
INSERT INTO SERVICIO VALUES (2, 'Zona Premium',  'Acceso a zona premium con asientos preferenciales');
INSERT INTO SERVICIO VALUES (3, 'Material',      'Kit de materiales y memorias del evento');
INSERT INTO SERVICIO VALUES (4, 'Certificación', 'Certificado digital de asistencia');
INSERT INTO SERVICIO VALUES (5, 'Parqueadero',   'Parqueadero cubierto durante el evento');
INSERT INTO SERVICIO VALUES (6, 'Networking',    'Cóctel de networking con expositores');

/* ---------- ENTRADA (12 registros: General y VIP por cada evento) ---------- */
INSERT INTO ENTRADA VALUES ('ENT001', 'General',  80000.00, 'EV001');
INSERT INTO ENTRADA VALUES ('ENT002', 'VIP',     180000.00, 'EV001');
INSERT INTO ENTRADA VALUES ('ENT003', 'General',  60000.00, 'EV002');
INSERT INTO ENTRADA VALUES ('ENT004', 'VIP',     120000.00, 'EV002');
INSERT INTO ENTRADA VALUES ('ENT005', 'General',  20000.00, 'EV003');
INSERT INTO ENTRADA VALUES ('ENT006', 'VIP',      70000.00, 'EV003');
INSERT INTO ENTRADA VALUES ('ENT007', 'General',  50000.00, 'EV004');
INSERT INTO ENTRADA VALUES ('ENT008', 'VIP',     110000.00, 'EV004');
INSERT INTO ENTRADA VALUES ('ENT009', 'General',  30000.00, 'EV005');
INSERT INTO ENTRADA VALUES ('ENT010', 'VIP',      90000.00, 'EV005');
INSERT INTO ENTRADA VALUES ('ENT011', 'General', 150000.00, 'EV006');
INSERT INTO ENTRADA VALUES ('ENT012', 'VIP',     280000.00, 'EV006');

/* ---------- ENTRADA_SERVICIO (33 registros) ---------- */
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT001', 3, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT001', 4, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT002', 1, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT002', 2, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT002', 3, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT002', 4, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT002', 5, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT002', 6, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT003', 3, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT003', 4, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT004', 1, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT004', 3, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT004', 4, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT004', 6, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT005', 3, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT006', 1, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT006', 2, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT006', 5, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT007', 4, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT008', 1, 2);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT008', 2, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT008', 6, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT009', 1, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT009', 4, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT010', 1, 2);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT010', 2, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT010', 3, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT010', 4, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT011', 1, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT012', 1, 2);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT012', 2, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT012', 5, 1);
INSERT INTO ENTRADA_SERVICIO VALUES ('ENT012', 6, 1);

/* ---------- COMPRA (25 registros) - los usuarios VIP pagan con 10% de descuento ---------- */
INSERT INTO COMPRA VALUES ('ENT001', 'USR001', '2026-08-15 10:20:00',  80000.00);
INSERT INTO COMPRA VALUES ('ENT001', 'USR002', '2026-08-16 14:05:00',  80000.00);
INSERT INTO COMPRA VALUES ('ENT001', 'USR003', '2026-08-20 09:30:00',  80000.00);
INSERT INTO COMPRA VALUES ('ENT002', 'USR008', '2026-08-18 16:45:00', 162000.00);
INSERT INTO COMPRA VALUES ('ENT002', 'USR009', '2026-08-19 11:00:00', 162000.00);
INSERT INTO COMPRA VALUES ('ENT003', 'USR004', '2026-09-01 13:15:00',  60000.00);
INSERT INTO COMPRA VALUES ('ENT003', 'USR005', '2026-09-03 18:40:00',  60000.00);
INSERT INTO COMPRA VALUES ('ENT004', 'USR010', '2026-09-05 12:00:00', 108000.00);
INSERT INTO COMPRA VALUES ('ENT005', 'USR001', '2026-09-28 15:10:00',  20000.00);
INSERT INTO COMPRA VALUES ('ENT005', 'USR006', '2026-09-30 10:00:00',  20000.00);
INSERT INTO COMPRA VALUES ('ENT005', 'USR007', '2026-10-01 17:25:00',  20000.00);
INSERT INTO COMPRA VALUES ('ENT006', 'USR011', '2026-09-29 09:50:00',  63000.00);
INSERT INTO COMPRA VALUES ('ENT006', 'USR008', '2026-10-02 20:10:00',  63000.00);
INSERT INTO COMPRA VALUES ('ENT007', 'USR002', '2026-10-10 08:30:00',  50000.00);
INSERT INTO COMPRA VALUES ('ENT007', 'USR003', '2026-10-12 19:00:00',  50000.00);
INSERT INTO COMPRA VALUES ('ENT007', 'USR006', '2026-10-14 12:40:00',  50000.00);
INSERT INTO COMPRA VALUES ('ENT008', 'USR009', '2026-10-11 14:20:00',  99000.00);
INSERT INTO COMPRA VALUES ('ENT008', 'USR012', '2026-10-13 16:00:00',  99000.00);
INSERT INTO COMPRA VALUES ('ENT009', 'USR004', '2026-10-25 10:10:00',  30000.00);
INSERT INTO COMPRA VALUES ('ENT009', 'USR005', '2026-10-26 11:30:00',  30000.00);
INSERT INTO COMPRA VALUES ('ENT010', 'USR010', '2026-10-27 09:00:00',  81000.00);
INSERT INTO COMPRA VALUES ('ENT010', 'USR011', '2026-10-28 13:45:00',  81000.00);
INSERT INTO COMPRA VALUES ('ENT011', 'USR007', '2026-11-02 10:00:00', 150000.00);
INSERT INTO COMPRA VALUES ('ENT012', 'USR012', '2026-11-03 15:30:00', 252000.00);
INSERT INTO COMPRA VALUES ('ENT012', 'USR008', '2026-11-04 18:20:00', 252000.00);

/* ---------- EVALUACION (11 registros) - solo de eventos ya realizados ----------
   Se indican las columnas (id_evaluacion es AUTO_INCREMENT y comentario puede ser NULL) */
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR001', 'EV001', 5, 'Excelente organización y ponentes de alto nivel');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR002', 'EV001', 4, 'Muy buen contenido, el sonido podría mejorar');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR008', 'EV001', 5, 'La zona premium valió la pena');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR004', 'EV002', 4, 'Taller práctico y bien explicado');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR005', 'EV002', 3, 'Faltó tiempo para los ejercicios');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR010', 'EV002', 5, 'Material de excelente calidad');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR006', 'EV003', 3, 'Mucha gente y poca señalización');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR011', 'EV003', 4, 'Buena variedad de stands');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion)
VALUES ('USR003', 'EV004', 5);
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR009', 'EV004', 4, 'Panel interesante con buen moderador');
INSERT INTO EVALUACION (id_usuario, codigo_evento, calificacion, comentario)
VALUES ('USR002', 'EV004', 4, 'Buen debate sobre ética en IA');


/* =====================================================================
   PARTE 3. DML - DIEZ CONSULTAS
   ===================================================================== */

/* ---------------------------------------------------------------------
   C1. INNER JOIN + ORDER BY
   Agenda de eventos con el nombre y la ubicación de su espacio.
   --------------------------------------------------------------------- */
SELECT e.codigo_evento, e.nombre AS evento, e.tipo, e.fecha,
       e.hora_inicio, e.hora_fin, es.nombre AS espacio, es.ubicacion
FROM EVENTO AS e
INNER JOIN ESPACIO AS es
ON e.codigo_espacio = es.codigo_espacio
ORDER BY e.fecha;

/* ---------------------------------------------------------------------
   C2. JOIN + ORDER BY ... DESC + LIMIT
   Las dos entradas de mayor precio con el evento al que pertenecen.
   --------------------------------------------------------------------- */
SELECT en.codigo_entrada, e.nombre AS evento, en.tipo, en.precio
FROM ENTRADA AS en
INNER JOIN EVENTO AS e
ON en.codigo_evento = e.codigo_evento
ORDER BY en.precio DESC
LIMIT 2;

/* ---------------------------------------------------------------------
   C3. DISTINCT + JOIN de tres tablas
   Servicios (sin repetir) que se incluyen en las entradas tipo VIP.
   --------------------------------------------------------------------- */
SELECT DISTINCT s.codigo_servicio, s.tipo, s.descripcion
FROM SERVICIO AS s
INNER JOIN ENTRADA_SERVICIO AS es
ON s.codigo_servicio = es.codigo_servicio
INNER JOIN ENTRADA AS en
ON es.codigo_entrada = en.codigo_entrada
WHERE en.tipo = 'VIP'
ORDER BY s.codigo_servicio;

/* ---------------------------------------------------------------------
   C4. BETWEEN
   Entradas cuyo precio está entre 50.000 y 120.000 (inclusive).
   --------------------------------------------------------------------- */
SELECT en.codigo_entrada, e.nombre AS evento, en.tipo, en.precio
FROM ENTRADA AS en
INNER JOIN EVENTO AS e
ON en.codigo_evento = e.codigo_evento
WHERE en.precio BETWEEN 50000 AND 120000
ORDER BY en.precio;

/* ---------------------------------------------------------------------
   C5. IN + LIKE + OR
   Eventos que son talleres o paneles, o cuyo nombre contiene "Datos".
   --------------------------------------------------------------------- */
SELECT e.codigo_evento, e.nombre, e.tipo, e.fecha
FROM EVENTO AS e
WHERE e.tipo IN ('Taller', 'Panel')
   OR e.nombre LIKE '%Datos%'
ORDER BY e.fecha;

/* ---------------------------------------------------------------------
   C6. JOIN de tres tablas + GROUP BY + COUNT y SUM
   Entradas vendidas e ingresos totales de cada evento.
   --------------------------------------------------------------------- */
SELECT e.codigo_evento, e.nombre AS evento,
       COUNT(c.id_usuario)  AS entradas_vendidas,
       SUM(c.monto_pagado)  AS ingresos_totales
FROM EVENTO AS e
LEFT JOIN ENTRADA AS en
ON e.codigo_evento = en.codigo_evento
LEFT JOIN COMPRA AS c
ON en.codigo_entrada = c.codigo_entrada
GROUP BY e.codigo_evento, e.nombre
ORDER BY ingresos_totales DESC;

/* ---------------------------------------------------------------------
   C7. Control de aforo: operadores aritméticos + GROUP BY
   Porcentaje de ocupación = entradas vendidas / aforo máximo del espacio.
   --------------------------------------------------------------------- */
SELECT e.nombre AS evento, es.nombre AS espacio, es.aforo_max,
       COUNT(c.id_usuario) AS entradas_vendidas,
       ROUND(COUNT(c.id_usuario) / es.aforo_max * 100, 2) AS porcentaje_ocupacion
FROM EVENTO AS e
INNER JOIN ESPACIO AS es
ON e.codigo_espacio = es.codigo_espacio
LEFT JOIN ENTRADA AS en
ON e.codigo_evento = en.codigo_evento
LEFT JOIN COMPRA AS c
ON en.codigo_entrada = c.codigo_entrada
GROUP BY e.codigo_evento, e.nombre, es.nombre, es.aforo_max
ORDER BY porcentaje_ocupacion DESC;

/* ---------------------------------------------------------------------
   C8. GROUP BY + HAVING + AVG
   Eventos con calificación promedio mayor o igual a 4.
   --------------------------------------------------------------------- */
SELECT e.nombre AS evento,
       COUNT(ev.id_evaluacion)        AS total_evaluaciones,
       ROUND(AVG(ev.calificacion), 2) AS calificacion_promedio
FROM EVENTO AS e
INNER JOIN EVALUACION AS ev
ON e.codigo_evento = ev.codigo_evento
GROUP BY e.codigo_evento, e.nombre
HAVING AVG(ev.calificacion) >= 4
ORDER BY calificacion_promedio DESC;

/* ---------------------------------------------------------------------
   C9. LEFT JOIN ... WHERE B.key IS NULL
   Eventos que todavía no tienen ninguna evaluación.
   --------------------------------------------------------------------- */
SELECT e.codigo_evento, e.nombre, e.fecha
FROM EVENTO AS e
LEFT JOIN EVALUACION AS ev
ON e.codigo_evento = ev.codigo_evento
WHERE ev.codigo_evento IS NULL
ORDER BY e.fecha;

/* ---------------------------------------------------------------------
   C10. EXISTS (subconsulta) + especialización de usuario
   Usuarios estándar que compraron alguna entrada del evento EV001.
   --------------------------------------------------------------------- */
SELECT u.id_usuario, u.nombre, ue.edad
FROM USUARIO AS u
INNER JOIN USUARIO_ESTANDAR AS ue
ON u.id_usuario = ue.id_usuario
WHERE EXISTS (SELECT *
              FROM COMPRA AS c
              INNER JOIN ENTRADA AS en
              ON c.codigo_entrada = en.codigo_entrada
              WHERE c.id_usuario = u.id_usuario
                AND en.codigo_evento = 'EV001')
ORDER BY u.nombre;
