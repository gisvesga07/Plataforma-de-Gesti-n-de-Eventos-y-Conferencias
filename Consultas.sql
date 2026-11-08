

/* C1. INNER JOIN + ORDER BY
   Agenda de eventos con el nombre y la ubicación de su espacio.*/
SELECT e.codigo_evento, e.nombre AS evento, e.tipo, e.fecha,
       e.hora_inicio, e.hora_fin, es.nombre AS espacio, es.ubicacion
FROM EVENTO AS e
INNER JOIN ESPACIO AS es
ON e.codigo_espacio = es.codigo_espacio
ORDER BY e.fecha;

/*C2. JOIN + ORDER BY ... DESC + LIMIT
   Las dos entradas de mayor precio con el evento al que pertenecen.*/
SELECT en.codigo_entrada, e.nombre AS evento, en.tipo, en.precio
FROM ENTRADA AS en
INNER JOIN EVENTO AS e
ON en.codigo_evento = e.codigo_evento
ORDER BY en.precio DESC
LIMIT 2;

/* C3. DISTINCT + JOIN de tres tablas
   Servicios (sin repetir) que se incluyen en las entradas tipo VIP.*/
SELECT DISTINCT s.codigo_servicio, s.tipo, s.descripcion
FROM SERVICIO AS s
INNER JOIN ENTRADA_SERVICIO AS es
ON s.codigo_servicio = es.codigo_servicio
INNER JOIN ENTRADA AS en
ON es.codigo_entrada = en.codigo_entrada
WHERE en.tipo = 'VIP'
ORDER BY s.codigo_servicio;

/* C4. BETWEEN
   Entradas cuyo precio está entre 50.000 y 120.000 (inclusive).*/
SELECT en.codigo_entrada, e.nombre AS evento, en.tipo, en.precio
FROM ENTRADA AS en
INNER JOIN EVENTO AS e
ON en.codigo_evento = e.codigo_evento
WHERE en.precio BETWEEN 50000 AND 120000
ORDER BY en.precio;

/* C5. IN + LIKE + OR
   Eventos que son talleres o paneles, o cuyo nombre contiene "Datos".*/
SELECT e.codigo_evento, e.nombre, e.tipo, e.fecha
FROM EVENTO AS e
WHERE e.tipo IN ('Taller', 'Panel')
   OR e.nombre LIKE '%Datos%'
ORDER BY e.fecha;

/* C6. JOIN de tres tablas + GROUP BY + COUNT y SUM
   Entradas vendidas e ingresos totales de cada evento.*/
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

/*C7. Control de aforo: operadores aritméticos + GROUP BY
   Porcentaje de ocupación = entradas vendidas / aforo máximo del espacio.*/
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

/* C8. GROUP BY + HAVING + AVG
   Eventos con calificación promedio mayor o igual a 4.*/
SELECT e.nombre AS evento,
       COUNT(ev.id_evaluacion)        AS total_evaluaciones,
       ROUND(AVG(ev.calificacion), 2) AS calificacion_promedio
FROM EVENTO AS e
INNER JOIN EVALUACION AS ev
ON e.codigo_evento = ev.codigo_evento
GROUP BY e.codigo_evento, e.nombre
HAVING AVG(ev.calificacion) >= 4
ORDER BY calificacion_promedio DESC;

/* C9. LEFT JOIN ... WHERE B.key IS NULL
   Eventos que todavía no tienen ninguna evaluación.*/
SELECT e.codigo_evento, e.nombre, e.fecha
FROM EVENTO AS e
LEFT JOIN EVALUACION AS ev
ON e.codigo_evento = ev.codigo_evento
WHERE ev.codigo_evento IS NULL
ORDER BY e.fecha;

/* C10. EXISTS (subconsulta) + especialización de usuario
   Usuarios estándar que compraron alguna entrada del evento EV001. */
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