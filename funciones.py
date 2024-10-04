def ejecutar_sql (nombre_archivo, cur):
    sql_file=open(nombre_archivo)
    sql_as_string=sql_file.read()
    sql_file.close
    cur.executescript(sql_as_string)
    
def ejecutar_sql2(nombre_archivo, cur):
       sql_file = open(nombre_archivo)
       sql_as_string = sql_file.read()
       sql_file.close()
       print(sql_as_string) # Add this line to print the SQL script
       cur.executescript(sql_as_string)