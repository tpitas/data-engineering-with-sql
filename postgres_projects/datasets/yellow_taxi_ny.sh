#!/bin/sh

# download the yellow taxi trip records dataset of october 2022 and rename it as NY2022_10.parquet 
# from taxi and limousine NY https://www.nyc.gov/site/tlc/about/data.page
wget -O NY2022_10.parquet https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2022-01.parquet

# downlaod the taxi zone Maps and Lookup Tables
wget https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv

# for data dictionary refer to 
# https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf