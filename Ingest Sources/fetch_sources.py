import json
import ast
import yaml
import psycopg2
from pathlib import Path
import requests
import os
import gzip
import io
import urllib.request
from datetime import datetime


def download_uncompress(URL, filename, local_directory)
    # downloading file from S3 
    urllib.request.urlretrieve(URL, filename)

    # uncompress the file 
    with gzip.open(filename, 'rb') as f_in
        with open(os.path.join(local_directory, os.path.splitext(filename)[0])+'.json', 'wb') as f_out
            f_out.write(f_in.read())
    # remove the compressed file
    os.remove(filename)
def read_yaml()
    try
        with open(CkiranJetcodeconfiguration.yml, 'r') as f
            return yaml.safe_load(f)
    except FileNotFoundError
        print(Error Configuration file was not found.)
        return False
    except yaml.YAMLError as e
        print(Error Failed while loading configurations)
        print(e)
        return False

def load_raw_data(file_name, table_name, config)


    with open(file_name, 'r') as input_file
        for line in input_file
            #Remove Null character
            line = line.replace(u0000, )
            # Convert each line into a dictionary using ast.literal_eval()
            data_dicts = ast.literal_eval(line) 
            # Convert the list of dictionaries into a JSON formatted string
            json_data = json.dumps(data_dicts)

            #Create PostgreSQL Connection
            try
                conn = psycopg2.connect(host = config['psql']['server'],database = config['psql']['database'],user = config['psql']['username'],password = config['psql']['password'],port = config['psql']['port'])
                cursor = conn.cursor()
                if table_name =='reviews_json'

                    unix_time = json.loads(json_data).get(unixReviewTime, None)
                    review_date = (datetime.fromtimestamp(unix_time).date() if unix_time else None)
                    cursor.execute(fINSERT INTO justeattakeaway.{table_name}(json_data, review_date) VALUES (%s, %s), (json_data,review_date))
                else 
                    cursor.execute(fINSERT INTO justeattakeaway.{table_name}(json_data, review_date) VALUES (%s, %s), (json_data))
                conn.commit()
                cursor.close()
            except psycopg2.Error as e
                 print(f'Error while creating database connection {e}')
config = read_yaml()
download_uncompress(config['source']['product'], 'products.gz',config['destination']['directory'] )
download_uncompress(config['source']['reviews'], 'reviews.gz',config['destination']['directory'] )
load_raw_data(config['unzipped']['product'],'product_json', config) #Load Raw Products data
load_raw_data(config['unzipped']['reviews'],'reviews_json', config) #Load Raw Reviews data

