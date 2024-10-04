--- Procesamiento ---

--- Crear tabla con usuarios que han calificado más de 50 películas y menos de 1000 ---
drop table if exists usuarios_sel;

create table usuarios_sel as
select "userId" as user_id, count(*) as cnt_rat
from ratings
group by "userId"
having cnt_rat > 50 and cnt_rat <= 1000
order by cnt_rat desc;

--- Crear tabla con películas que han sido vistas por más de 50 usuarios ---
drop table if exists movies_sel;

create table movies_sel as
select "movieId", count(*) as cnt_rat
from ratings
group by "movieId"
having cnt_rat > 50
order by cnt_rat desc;

--- Crear tablas filtradas de películas, usuarios y calificaciones ---

--- Tabla de calificaciones filtrada (ratings_final) ---
DROP TABLE IF EXISTS ratings_final;

CREATE TABLE ratings_final AS
SELECT a.userId AS user_id,
       a."movieId" AS movie_id,
       a.rating AS rating
FROM ratings a
INNER JOIN movies_sel b ON a."movieId" = b."movieId"
INNER JOIN usuarios_sel c ON a.userId = c.user_id;


--- Tabla de películas final (movies_final) ---
drop table if exists movies_final;

create table movies_final as
select a."movieId" as movie_id,
       a.title as movie_title,
       a.genres as movie_genres
from movies a
inner join movies_sel b on a."movieId" = b."movieId";

--- Crear tabla completa (full_ratings) ---
drop table if exists full_ratings;

create table full_ratings as
select a.*,
       c.movie_title,
       c.movie_genres
from ratings_final a
inner join movies_final c on a.movie_id = c.movie_id;

--- Consulta final: obtener las 10 películas con mejor promedio de calificaciones vistas por al menos 50 usuarios ---
---select c.movie_title,
--       avg(a.movie_rating) as avg_rating,
---       count(*) as num_ratings
--from full_ratings a
---group by c.movie_title
--having num_ratings >= 50
---order by avg_rating desc
---limit 10;
