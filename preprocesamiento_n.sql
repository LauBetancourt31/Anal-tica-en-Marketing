----procesamientos---

--- Crear tabla con usuarios que han calificado más de 50 películas y menos de 1000 ---
drop table if exists usuarios_sel;

create table usuarios_sel as
SELECT userId as user_id, count(*) as cnt_rat
from ratings
group by userId
having cnt_rat > 30 and cnt_rat <= 800
order by cnt_rat desc;

--- Crear tabla con películas que han sido vistas por más de 50 usuarios ---
drop table if exists movies_sel;

create table movies_sel as
SELECT movieId, count(*) as cnt_rat
from ratings
group by movieId
having cnt_rat > 30
order by cnt_rat desc;

-----modificación de movies ----
DROP TABLE IF EXISTS movies_m;

CREATE TABLE movies_m AS
SELECT movieId AS movie_id,
       title AS movie_title,
       genres AS movie_genres,
       CAST(SUBSTR(title, INSTR(title, '(') + 1, 4) AS INTEGER) AS movie_year,  -- Extraer el año desde los paréntesis
       TRIM(SUBSTR(title, 1, INSTR(title, '(') - 1)) AS clean_title  -- Limpiar el título
FROM movies
WHERE INSTR(title, '(') > 0 AND INSTR(title, ')') > 0;

--- Crear tablas filtradas de películas, usuarios y calificaciones ---

--- Tabla de calificaciones filtrada (ratings_final) ---
DROP TABLE IF EXISTS ratings_final;

CREATE TABLE ratings_final AS
SELECT a.userId AS user_id,
       a.movieId AS movie_id,
       a.rating AS rating,
       a.timestamp AS timestamp
FROM ratings a
INNER JOIN movies_sel b ON a."movieId" = b."movieId"
INNER JOIN usuarios_sel c ON a.userId = c.user_id;

--- Crear tabla completa (full_ratings) ---
DROP TABLE IF EXISTS full_ratings;

CREATE TABLE full_ratings AS
SELECT a.*,
       c.movie_title AS movie_title,
       c.movie_genres AS movie_genres,
       c.clean_title AS clean_title,
       c.movie_year AS movie_year
FROM ratings_final a
INNER JOIN movies_m c ON a.movie_id = c.movie_id;

---- Crear tabla con fecha nueva ----
DROP TABLE IF EXISTS f_ratings;

CREATE TABLE f_ratings AS
SELECT *,
       STRFTIME('%Y-%m-%d', timestamp, 'unixepoch') AS fecha_nueva
FROM full_ratings;