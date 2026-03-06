/* 
1) Análisis de recuperación post-pandemia

1. ¿Qué 10 estaciones recuperaron el mayor porcentaje de su flujo de 2017 en 2021?
2. ¿Qué estaciones quedaron por debajo del 40% de su flujo original?
3. ¿Cuál fue la pérdida total de pasajeros en toda la red entre 2017 y 2021?
 */

#1.1

SELECT
	f.nlc,
	f.flujo AS 'flujo_2017',
    p.flujo AS 'flujo_2021',
    p.flujo*100/f.flujo AS 'porcentaje_incremento/decremento'
FROM flujo_pasajeros AS f
JOIN flujo_pasajeros AS p ON f.nlc = p.nlc
ORDER BY 4 DESC
LIMIT 10;

#1.2

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

#1.3

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

 /*
 2) Impacto de infraestructura y red
 
1. ¿Cuál es el flujo total sumado de todas las estaciones que pertenecen a la Elizabeth Line vs las de la London Overground en 2021?
2. ¿Tuvieron las estaciones con servicio nocturno una caída de pasajeros menor que las que no tienen este servicio?
3. ¿Qué línea de metro (buscando en la columna lineas con LIKE) mueve más gente en un año base como 2017?
 */

#2.1

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

#2.2

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

#2.3

SELECT * FROM movimientos_2017;

/*
3) Hitos históricos

1. El pico Olímpico: Comparar 2011 vs 2012. ¿Hubo estaciones específicas (cercanas a estadios) que crecieron más de un 20% en ese año?
2. 2012 vs 2021: ¿Cuántas estaciones hoy en día (2021) tienen menos flujo que hace casi 10 años en los Juegos Olímpicos?
 */
 
#3.1

#3.2

/*
4) Consultas Técnicas

1. Estaciones "Fantasma": ¿Hay algún NLC en la tabla de estaciones que no tenga registros de flujo en ningún año?
2. Crecimiento Atípico: Identificar estaciones que hayan crecido más de un 100% de un año a otro (esto suele indicar una reapertura o una nueva conexión de líneas).
*/

#4.1

#4.2