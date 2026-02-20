#¿Cuáles fueron las 10 estaciones con más flujo en 2012, 2017 y 2021?

WITH Mayor_Flujo AS (
	SELECT *, RANK() OVER(PARTITION BY Año ORDER BY Flujo_Pasajeros DESC) AS Posicion FROM flujo_pasajeros
    WHERE Flujo_Pasajeros != -1
)

SELECT * FROM Mayor_Flujo
WHERE Año IN (2012, 2017, 2021) AND Posicion <= 10
ORDER BY Año;

#Si sumamos el flujo de todas las estaciones de la línea 'Central' vs 'Victoria', ¿cuál mueve más gente en 2017?

SELECT * FROM estaciones_limpias AS e
JOIN movimientos_año_2017 AS m
ON e.NLC = m.NLC;
 
