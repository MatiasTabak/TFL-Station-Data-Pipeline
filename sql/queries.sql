# ¿Cuál es el flujo total sumado de todas las estaciones que pertenecen a la Elizabeth Line vs las de la London Overground en 2021?
WITH overground AS (
	SELECT 
		SUM(
        COALESCE(entradas_semana, 0) + 
        COALESCE(entradas_sabado, 0) + 
        COALESCE(entradas_domingo, 0) + 
        COALESCE(salidas_semana, 0) + 
        COALESCE(salidas_sabado, 0) + 
        COALESCE(salidas_domingo, 0)) AS flujo_overground
	FROM estaciones_limpias AS e
	INNER JOIN movimientos_2021 AS m ON e.nlc = m.nlc
	WHERE london_overground = 'Yes'
), elizabeth AS (
	SELECT 
		SUM(
        COALESCE(entradas_semana, 0) + 
        COALESCE(entradas_sabado, 0) + 
        COALESCE(entradas_domingo, 0) + 
        COALESCE(salidas_semana, 0) + 
        COALESCE(salidas_sabado, 0) + 
        COALESCE(salidas_domingo, 0)) AS flujo_elizabeth 
	FROM estaciones_limpias AS e
	INNER JOIN movimientos_2021 AS m ON e.nlc = m.nlc
	WHERE elizabeth_line = 'Yes'
)

SELECT 
	FORMAT(flujo_overground, 0) AS overground_flujo,
    FORMAT(flujo_elizabeth, 0) AS elizabeth_flujo
FROM overground
CROSS JOIN elizabeth;

# ¿Qué 10 estaciones recuperaron el mayor porcentaje de su flujo de 2017 en 2021?
SELECT
	f.nlc,
	f.flujo AS 'flujo_2017',
    p.flujo AS 'flujo_2021',
    p.flujo*100/f.flujo AS 'porcentaje_incremento/decremento'
FROM flujo_pasajeros AS f
JOIN flujo_pasajeros AS p ON f.nlc = p.nlc
ORDER BY 4 DESC
LIMIT 10;

# ¿Qué línea de metro mueve más gente en un año base como 2017?
SELECT 
	TRIM(e.lineas) AS lineas_limpias, FORMAT(SUM(f.flujo), 0) AS suma_de_flujo 
FROM flujo_pasajeros AS f
INNER JOIN estaciones_limpias AS e ON f.nlc = e.nlc
WHERE 
	f.anio = 2017
GROUP BY lineas_limpias
ORDER BY SUM(f.flujo) DESC;

# ¿Qué estaciones quedaron por debajo del 40% de su flujo original?
SELECT
	f.nlc,
	f.flujo AS 'flujo_2017',
    p.flujo AS 'flujo_2021',
    p.flujo*100/f.flujo AS 'porcentaje_incremento/decremento'
FROM flujo_pasajeros AS f
JOIN flujo_pasajeros AS p ON f.nlc = p.nlc
WHERE 
	(p.flujo IS NOT NULL AND p.flujo != 0) AND 
    (f.flujo IS NOT NULL AND f.flujo != 0) AND
    p.flujo*100/f.flujo <= 40
ORDER BY 4 DESC;

# ¿Tuvieron las estaciones con servicio nocturno una caída de pasajeros menor que las que no tienen este servicio?
WITH variaciones AS (
	SELECT 
		ROUND(
			100 - SUM(CASE WHEN (e.metro_nocturno = 'Yes') THEN s.flujo ELSE 0 END)*100/
			NULLIF(SUM(CASE WHEN (e.metro_nocturno = 'Yes') THEN f.flujo ELSE 0 END), 0), 2
		) AS caida_nocturna,
		ROUND(
			100 - SUM(CASE WHEN (e.metro_nocturno = 'No') THEN s.flujo ELSE 0 END)*100/
			NULLIF(SUM(CASE WHEN (e.metro_nocturno = 'No') THEN f.flujo ELSE 0 END), 0), 2
		) AS caida_no_nocturna    
	FROM estaciones_limpias AS e
	INNER JOIN flujo_pasajeros AS f ON e.nlc = f.nlc AND f.anio = 2017
	INNER JOIN flujo_pasajeros AS s ON e.nlc = s.nlc AND s.anio = 2021
)

SELECT 
	IF(caida_nocturna < caida_no_nocturna, 'Sí', 'No') AS 
    '¿Tuvieron las estaciones con servicio nocturno una caída de pasajeros menor que las que no tienen este servicio?' 
FROM variaciones;

# ¿Cuál fue la pérdida total de pasajeros en toda la red entre 2017 y 2021?
#Por estaciones
SELECT 
		f.nlc, SUM(f.flujo) AS cantidad_2017, 
		SUM(p.flujo) AS cantidad_2021, 
        SUM(p.flujo) - SUM(f.flujo) AS perdida_pasajeros_por_estacion 
FROM flujo_pasajeros AS f
JOIN flujo_pasajeros AS p ON f.nlc = p.nlc
WHERE f.anio = 2017 AND p.anio = 2021
GROUP BY f.nlc
HAVING perdida_pasajeros_por_estacion IS NOT NULL;

#Total
SELECT 
		SUM(f.flujo) AS cantidad_2017, 
        SUM(p.flujo) AS cantidad_2021, 
        SUM(p.flujo) - SUM(f.flujo) AS perdida_pasajeros_total 
FROM flujo_pasajeros AS f
JOIN flujo_pasajeros AS p ON f.nlc = p.nlc
WHERE f.anio = 2017 AND p.anio = 2021
HAVING perdida_pasajeros_total IS NOT NULL;

# ¿Cuántas estaciones en 2021 tienen menos flujo que hace casi 10 años en los Juegos Olímpicos?
WITH menor_flujo AS (
	SELECT 
		e.estacion, f.flujo AS flujo_olimpico, p.flujo AS flujo_pandemia
	FROM flujo_pasajeros AS f
	INNER JOIN estaciones_limpias AS e ON f.nlc = e.nlc AND f.anio =2012
	INNER JOIN flujo_pasajeros AS p ON f.nlc = p.nlc AND p.anio = 2021
	WHERE p.flujo < f.flujo AND f.flujo > 0 AND p.flujo > 0
)

SELECT 
	COUNT(*) AS 'Estaciones con menor flujo',
    (SELECT COUNT(*) FROM estaciones_limpias) AS 'Cantidad total de estaciones',
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM estaciones_limpias), 2) AS 'Porcentaje afectado %'
FROM menor_flujo;

# ¿Hay algún NLC en la tabla de estaciones que no tenga registros de flujo en ningún año?
SELECT 
	nlc, estacion 
FROM estaciones_limpias
WHERE nlc NOT IN (SELECT DISTINCT nlc FROM flujo_pasajeros);

# Identificar estaciones que hayan crecido más de un 100% de un año a otro (esto suele indicar una reapertura o una nueva conexión de líneas).
WITH crecimiento AS (
    SELECT 
        e.estacion,
        f2.flujo AS flujo_2012,
        f7.flujo AS flujo_2017,
        f1.flujo AS flujo_2021
    FROM estaciones_limpias AS e
    INNER JOIN flujo_pasajeros AS f2 ON e.nlc = f2.nlc AND f2.anio = 2012
    INNER JOIN flujo_pasajeros AS f7 ON e.nlc = f7.nlc AND f7.anio = 2017
    INNER JOIN flujo_pasajeros AS f1 ON e.nlc = f1.nlc AND f1.anio = 2021
)

SELECT * FROM crecimiento
WHERE (flujo_2017/NULLIF(flujo_2012, 0)) > 2 OR (flujo_2021/NULLIF(flujo_2017, 0)) > 2;
