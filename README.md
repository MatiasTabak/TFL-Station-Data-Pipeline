# **Análisis de Movilidad: TfL London Stations (2012-2021)**

Este proyecto analiza la evolución del flujo de pasajeros en la red de transporte de Londres (Transport for London), comparando tres años distintivos: el 2012, debido a que Londres fue sede de los Juegos Olímpicos de dicho año; el 2017, debido a un año del inicio del funcionamiento del metro nocturno, y como la sociedad le ha dado uso y movimiento; y el 2021, un año del inicio de la pandemia, la nueva realidad post-confinamiento, y como es que se adaptó el sistema a ello.

---

# **Estructura del Proyecto**

El análisis está dado por un proceso de ingeniería de datos (Python + Pandas), seguido de una fase de consultas análiticas (SQL).

- data/: Contiene los archivos CSV crudos y procesados. En los procesados se cuenta con:
     - estaciones_limpias.csv: Es el catáogo de estaciones (ya normalizado en 3FN).
     - flujo_pasajeros.csv: El cual determina, para cada NLC y su año, el flujo de pasajeros en dicho año.
 - movimientos_año_20xx.csv: Son los datos de flujo anual con detalles de movimientos semanales.

- notebooks/: El archivo data_work.ipynb con todo el proceso de limpieza en Python/Pandas.

- sql/: Scripts para la creación de la base de datos y consultas de negocio.

---

# **Desafios de Limpieza y Normalización**

Una de las cuestiones más necesarias de trabajar y estructurar fue la estandarización de los datos anuales, ya que TfL cambio el formato de reporte entre 2012 y 2021, por lo que se unificó el formato de los archivos 2012, 2017 y 2021 con un tratado particular para cada uno de ellos.

- Unificación de calendarios: En 2021, los datos semanales estaban desglosados. Los cuales se realizó una unificación manual para reconstruir el bloque de entradas por semana (y no distinguiendo los viernes) que contaban los años anteriores.

- Modelo Relacional: Se dio una estructura en la cual el campo NLC (National Location Code) toma el rol de clave primaria para conectar el catálogo de estaciones con las tablas de hechos de movimientos.

---

# **Preguntas de Negocio Respondidas**

Con la base de datos cargada en MySQL, el proyecto responde a consultas tales como: ¿Qué estaciones lideraron la recuperación de flujo postpandema?, ¿Cómo varió el uso de las lineas de "Night Tube" entre 2017 y 2021?, ¿Cual fue el crecimiento porcentual de estaciones clave durante Londres 2012?, entre otras consultas.
