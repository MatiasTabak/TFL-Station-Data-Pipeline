BEGIN;

SAVEPOINT inicio_carga;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/estaciones_limpias.csv'
IGNORE
INTO TABLE estaciones_limpias
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(nlc, estacion, lineas, london_underground, elizabeth_line, london_overground, dlr, @v_nocturno)
SET metro_nocturno = NULLIF(@v_nocturno, 'Sin texto');
SAVEPOINT estaciones_ok;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/flujo_pasajeros.csv'
IGNORE
INTO TABLE flujo_pasajeros
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(nlc, anio, @v_flujo)
SET flujo_pasajeros = NULLIF(@v_flujo, -1);
SAVEPOINT flujo_ok;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movimientos_2012.csv'
IGNORE
INTO TABLE movimientos_2012
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(nlc, estacion, entradas_semana, entradas_sabado, entradas_domingo, salidas_semana, salidas_sabado, salidas_domingo, entradas_salidas_anual_millones);
SAVEPOINT doce_ok;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movimientos_2017.csv'
IGNORE
INTO TABLE movimientos_2017
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(nlc, estacion, entradas_semana, entradas_sabado, entradas_domingo, salidas_semana, salidas_sabado, salidas_domingo, entradas_salidas_anual_millones);
SAVEPOINT diecisiete_ok;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movimientos_2021.csv'
IGNORE
INTO TABLE movimientos_2021
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(nlc, estacion, entradas_semana, entradas_sabado, entradas_domingo, salidas_semana, salidas_sabado, salidas_domingo, entradas_salidas_anual_millones);
SAVEPOINT veintiuno_ok;

COMMIT;