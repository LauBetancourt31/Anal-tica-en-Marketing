----procesamientos---

---crear tabla con usuarios con más de 50 libros leídos y menos de 1000

drop table if exists usuarios_sel;

create table usuarios_sel as 

select "userId" as user_id, count(*) as cnt_rat
from ratings
group by "userId"
having cnt_rat >50 and cnt_rat <= 500
order by cnt_rat desc ;

---crear tabla con peliculas que han sido vistas por más de 50 usuarios
drop table if exists movies_sel;



create table movies_sel as select movieId,
                         count(*) as cnt_rat
                         from ratings
                         group by movieId
                         having cnt_rat >50
                         order by cnt_rat desc ;

-------crear tablas filtradas de movies, usuarios y calificaciones ----

drop table if exists ratings_final;

create table ratings_final as
select a."userId"as user_id,
       a. "movieId" as movie_id,
       a."rating" as rating
from ratings a 
inner join movies_sel b on a.movieId =b.movieId
inner join usuarios_sel c on a."userId" =c.user_id;

drop table if exists full_ratings;

---crear tabla completa ----
create table full_ratings as
select a.*,
       c."title" as movie_title,
       c."genres" as movie_genres,
       c."title" as movie_clean_title,
       c."year" as movie_year
from ratings_final a
inner join movies c on a."movieId" =c.movie_id;

SELECT * FROM full_ratings;