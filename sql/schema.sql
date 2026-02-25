CREATE DATABASE IF NOT EXISTS TfL_stations_SQL
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE TfL_stations_SQL;

CREATE TABLE IF NOT EXISTS estaciones_limpias (
	nlc INT NOT NULL,
	estacion VARCHAR(255),
	lineas VARCHAR(255),
	london_underground ENUM('Yes', 'No'),
	elizabeth_line ENUM('Yes', 'No'), 
	london_overground ENUM('Yes', 'No'),
	dlr ENUM('Yes', 'No'),
	metro_nocturno ENUM('Yes', 'No'), #'Sin texto' será tratado como null
    
    PRIMARY KEY (nlc, lineas)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS flujo_pasajeros (
	nlc INT NOT NULL,
    anio INT,
    flujo BIGINT,
    
    CONSTRAINT fk_estaciones_flujo
    FOREIGN KEY (nlc) REFERENCES estaciones_limpias(nlc),
    PRIMARY KEY (nlc, anio)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS movimientos_2012 (
	nlc INT NOT NULL,
    estacion VARCHAR(255),
    entradas_semana INT,
    entradas_sabado INT,
    entradas_domingo INT,
    salidas_semana INT,
    salidas_sabado INT,
    salidas_domingo INT,
    entradas_salidas_anual_millones DECIMAL(10, 2),
    
    CONSTRAINT fk_estaciones_2012
    FOREIGN KEY (nlc) REFERENCES estaciones_limpias(nlc)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS movimientos_2017 (
	nlc INT NOT NULL,
    estacion VARCHAR(255),
    entradas_semana INT,
    entradas_sabado INT,
    entradas_domingo INT,
    salidas_semana INT,
    salidas_sabado INT,
    salidas_domingo INT,
    entradas_salidas_anual_millones DECIMAL(10, 2),
    
    CONSTRAINT fk_estaciones_2017
    FOREIGN KEY (nlc) REFERENCES estaciones_limpias(nlc)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS movimientos_2021 (
	nlc INT NOT NULL,
    estacion VARCHAR(255),
    entradas_semana INT,
    entradas_sabado INT,
    entradas_domingo INT,
    salidas_semana INT,
    salidas_sabado INT,
    salidas_domingo INT,
    entradas_salidas_anual_millones DECIMAL(10, 2),
    
    CONSTRAINT fk_estaciones_2021
    FOREIGN KEY (nlc) REFERENCES estaciones_limpias(nlc)
) ENGINE = InnoDB;