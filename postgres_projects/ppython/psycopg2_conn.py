#!/usr/bin/env python

# importing packages
import psycopg2

# forming connection
connection = psycopg2.connect(
    host='localhost',  # host on which the database is running
    port='5433', # port number
    database='taxiny01-23',  # name of the database to connect to
    user='postgres',  # username to connect with
    password='pita'  # password associated with your username
)

connection.autocommit = True

# creating a cursor
cursor = connection.cursor()

# list of rows to be inserted
sql = ''' select tpep_pickup_datetime::date, tpep_dropoff_datetime::date,
    trip_distance, "dolocationid",fare_amount, total_amount
    from taxi_yellow.ny2022oct
    where tpep_pickup_datetime::date = '2022-01-01'
    order by total_amount desc;'''

# executing sql statement
cursor.execute(sql)
print('Table successfully listed')

# executing sql statement
cursor.execute(sql)

# fetching rows
for i in cursor.fetchall():
	print(i)

# committing changes
connection.commit()

# closing connection
connection.close()