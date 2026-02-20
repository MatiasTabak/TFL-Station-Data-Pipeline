#2012

SELECT * FROM estaciones_limpias;

SELECT * FROM flujo_pasajeros;

SELECT * FROM movimientos_año_2012;

#¿Cuáles fueron las 10 estaciones con más flujo en 2012, 2017 y 2021?

SELECT *, ROW_NUMBER() OVER(PARTITION BY Año ORDER BY Flujo_Pasajeros DESC) AS Posicion FROM flujo_pasajeros
WHERE Año IN (2012, 2017, 2021) AND Flujo_Pasajeros != -1
ORDER BY Año;
