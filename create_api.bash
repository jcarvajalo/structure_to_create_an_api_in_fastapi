
echo "Ingrese el nombre de la api"
read name
echo "ingrese la ruta donde se va a crear la api, ejemplo /home/user/Documentos"
read path
cd $path
api_name=api_$name
conda create --name $api_name python=3
conda activate $api_name
echo $api_name

#Directories 
mkdir $api_name
mkdir $api_name/app 
mkdir $api_name/app/api
mkdir $api_name/app/api/config
mkdir $api_name/app/api/models
mkdir $api_name/app/api/schemas 
mkdir $api_name/app/api/routes
mkdir $api_name/app/api/utils

#Install basic libraries 
pip install fastapi==0.63.0
pip install pymongo==4.1.1
pip install uvicorn==0.13.3

#create file requirements
pip freeze > $api_name/requirements.txt

#create docker file
echo """
FROM python:3.9-slim
WORKDIR /app

COPY ./requirements.txt /app/requirements.txt

RUN apt-get update \
    && apt-get install gcc -y \
    && apt-get clean

RUN pip install -r requirements.txt
COPY . /app/
""" > $api_name/Dockerfile



#files
echo """
from fastapi import FastAPI
from app.api.routes.$name import $name
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    openapi_url='/api/v1/$name/openapi.json',
    docs_url='/api/v1/$name/docs',
    title='',
    description='',
    version='0.0.1',
    terms_of_service='',
    contact={
        'name': '',
        'url': '',
        'email': '',
    },
    license_info={
        'name': '',
        'url': '',
    },
    
)

origins = ['*']
app.add_middleware(
 CORSMiddleware,
 allow_origins=origins,
 allow_credentials=True,
 allow_methods=['*'],
 allow_headers=['*'],
)

@app.on_event('startup')
async def startup():
    print('startup')

@app.on_event('shutdown')
async def shutdown():
    print('shutdown')

app.include_router($name, prefix='/api/v1/name')
""" > $api_name/app/app.py



echo """
from pymongo import MongoClient
conn = MongoClient('')   
""" > $api_name/app/api/config/db.py

echo """
from typing import Optional
from pydantic import BaseModel

class $name(BaseModel): 

""" > $api_name/app/api/models/$name.py

echo """
def $name Entity(item) -> dict():
    try:
        return {
           

        }
    except Exception as e:
        return (str(e),item)

def $name sEntity(entity) -> list():
    return [$name Entity(item) for item in entity]

""" > $api_name/app/api/schemas/$name.py

echo """
import secrets
from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBasicCredentials, HTTPBasic

security = HTTPBasic()
API_CREDENTIALS_USERNAME = '' #os.getenv('API_CREDENTIALS_USERNAME')
API_CREDENTIALS_PASSWORD = '' #os.getenv('API_CREDENTIALS_PASSWORD')

def get_current_username(credentials: HTTPBasicCredentials = Depends(security)):
    correct_username = secrets.compare_digest(credentials.username,'jairo')
    correct_password = secrets.compare_digest(credentials.password, 'jairo') 
    if not (correct_username and correct_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Incorrect email or password',
            headers={'WWW-Authenticate': 'Basic'},
        )
    return credentials.username

""" > $api_name/app/api/utils/acces_security.py


echo """
import fastapi
from app.api.schemas.$name import $name 
from app.api.models.$name import $name
from app.api.config.db import conn
from app.api.utils.access_security import get_current_username
from fastapi import APIRouter, Depends, HTTPException, Request, Response,

$name = APIRouter()

@$name.post('/')

@$name.get()

@$name.put()

@$name.delete()
""" > $api_name/app/api/routes/$name.py
