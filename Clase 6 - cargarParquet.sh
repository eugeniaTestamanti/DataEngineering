#!/bin/bash
# Script para descargar dataset yellow_tripdata_2021-01.parquet 

# Descargar archivo en esa carpeta con el nombre correcto
wget -O /home/nifi/ingest/yellow_tripdata_2021-01.parquet \
"https://data-engineer-edvai-public.s3.amazonaws.com/yellow_tripdata_2021-01.parquet"
