/* 
1) Análisis de recuperación post-pandemia

1. El Ranking de Resiliencia: ¿Qué 10 estaciones recuperaron el mayor porcentaje de su flujo de 2017 en 2021?
2. Las más golpeadas: ¿Qué estaciones quedaron por debajo del 40% de su flujo original?
3. Análisis de Valor Absoluto: ¿Cuál fue la pérdida total de pasajeros en toda la red entre 2017 y 2021?
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

SELECT * FROM flujo_pasajeros;

 /*
 2) Impacto de infraestructura y red
 
1.Predominio de Redes: ¿Cuál es el flujo total sumado de todas las estaciones que pertenecen a la Elizabeth Line vs las de la London Overground en 2021?
2.Efecto "Night Tube": ¿Tuvieron las estaciones con servicio nocturno (metro_nocturno = 'Yes') una caída de pasajeros menor que las que no tienen este servicio?
3.Líneas más concurridas: ¿Qué línea de metro (buscando en la columna lineas con LIKE) mueve más gente en un año base como 2017?
 */

#2.1

#2.2

#2.3

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