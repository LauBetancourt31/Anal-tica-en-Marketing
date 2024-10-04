## Carga de librerias#####
import numpy as np
import pandas as pd
import sqlite3 as sql
import plotly.graph_objs as go ### para gráficos
import plotly.express as px
import matplotlib.pyplot as plt
import seaborn as sns
import funciones as fn

##Forma
from IPython.display import display, Markdown
palette_color=['#d4afb9', '#d1cfe2', '#9cadce', '#7ec4cf', '#52b2cf']

##### conectarse a BD #######
conn = sql.connect('Data/db_movies')
cur=conn.cursor()

### para ver las tablas que hay en la base de datos
cur.execute("select name from sqlite_master where type='table' ")
cur.fetchall()

## traer tabla de BD a python ####
movies= pd.read_sql("select *  from movies", conn)
ratings = pd.read_sql('select * from ratings', conn)

# prompt: Genera un código que muestre esas tablas de datos

print("Movies Table:")
display(movies.head())  # Show the first few rows of the movies table

print("\nRatings Table:")
display(ratings.head())  # Show the first few rows of the ratings table

def check_df(dataframe):
    # Dimensiones base general
    display(Markdown('**Dimensiones base general**'))
    display(dataframe.shape)

    # Dimensiones sin duplicados
    display(Markdown('**Dimensiones sin duplicados**'))
    display(dataframe.drop_duplicates().shape)

    # Tipos de datos
    display(Markdown('**Tipos**'))
    display(dataframe.dtypes)

    # Valores nulos
    display(Markdown('**Nulos**'))
    display(dataframe.isnull().sum())

check_df(movies)
check_df(ratings)

### ver el tipo de datos y faltantes
print(movies.info())
print(ratings.info())

# distribución de las calificaciones
#muestra cuántas veces aparece cada calificación, ordenadas de la más frecuente a la menos frecuente.
cr=pd.read_sql(""" select rating,
                    count(*) as conteo
                    from ratings
                    group by rating
                    order by conteo desc""", conn)
cr

data  = go.Bar( x=cr.rating,marker_color=palette_color,y=cr.conteo, text=cr.conteo, textposition="outside")
Layout=go.Layout(title="Count of ratings",xaxis={'title':'Rating'},yaxis={'title':'Count'})
go.Figure(data,Layout)

# Cacular cada usuario cuantas peliculas calificó
rating_users = pd.read_sql(''' select userId,
                                count(*) as cnt_rat
                                from ratings
                                group by userId
                                order by cnt_rat asc
                                ''',conn )

rating_users

plt.hist(rating_users['cnt_rat'], bins=10, color='skyblue', edgecolor='black')
plt.title('Hist frecuencia de número de calificaciones por usuario')
plt.xlabel('Número de calificaciones')
plt.ylabel('Frecuencia')

fig  = px.histogram(rating_users, x= 'cnt_rat', color_discrete_sequence=palette_color, title= 'Histograma frecuencia de número de calificaciones por usuario')
fig.show()

## Descripción ratings
rating_users.describe()

## excluir usuarios con menos de 500 Peliculas calificadas
rating_users2 = pd.read_sql('''select userId,
                                count(*) as cnt_rat
                                from ratings
                                group by userId
                                having cnt_rat <=500
                                order by cnt_rat asc
                                ''',conn )
rating_users2

rating_users2.describe()

fig  = px.histogram(rating_users2, x= 'cnt_rat', title= 'Histograma frecuencia de número de calificaciones por usuario')
fig.show()

### calificacion de cada pelicula
rating_movie = pd.read_sql('''select movieId,
                                count(*) as cnt_rat
                                from ratings
                                group by movieId
                                order by cnt_rat desc
                                ''',conn )

fig  = px.histogram(rating_movie, x= 'cnt_rat', title= 'Histograma frecuencia de número de calificaciones por pelicula')
fig.show()

rating_movie.describe()

####peliculas que tengan más de 10 calificaciones
rating_movie2=pd.read_sql(''' select movieId,
                                count(*) as cnt_rat
                                from ratings
                                group by movieId
                                having cnt_rat >= 10
                                order by cnt_rat desc
                                ''',conn )

fig  = px.histogram(rating_movie2, x= 'cnt_rat', title= 'Histograma frecuencia de número de calificaciones por pelicula')
fig.show()

rating_movie2.describe()

## crear copia de db_books datos originales, nombrarla books2 y procesar books2
conn = sql.connect('Data/db_movies2.db') ### crear cuando no existe el nombre de cd y para conectarse cuando sí existe.
cur = conn.cursor() ###para funciones que ejecutan sql en base de datos

##### consultar trayendo para pandas ###
df_final = pd.read_sql("select * from full_ratings", conn)
df_final

### para ver las tablas que hay en la base de datos
cur.execute("select name from sqlite_master where type='table' ")
cur.fetchall()

