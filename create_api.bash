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
echo """FROM python:3.9-slim
WORKDIR /app

COPY ./requirements.txt /app/requirements.txt

RUN apt-get update \
    && apt-get install gcc -y \
    && apt-get clean

RUN pip install -r requirements.txt
COPY . /app/""" > $api_name/Dockerfile

#files
echo """from fastapi import FastAPI
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

app.include_router($name, prefix='/api/v1/$name')""" > $api_name/app/app.py

echo """from pymongo import MongoClient
conn = MongoClient('')""" > $api_name/app/api/config/db.py

echo """from typing import Optional
from pydantic import BaseModel

class ${name^}(BaseModel):
    baseAttribute:str""" > $api_name/app/api/models/$name.py

echo """def ${name}Entity(item) -> dict():
    try:
        return {
           
        }
    except Exception as e:
        return (str(e),item)

def ${name}sEntity(entity) -> list():
    return [${name}Entity(item) for item in entity]""" > $api_name/app/api/schemas/$name.py

echo """import secrets
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
    return credentials.username""" > $api_name/app/api/utils/acces_security.py

echo """import fastapi
from app.api.schemas.$name import ${name}sEntity, ${name}Entity
from app.api.models.$name import ${name^}
from app.api.config.db import conn
from app.api.utils.acces_security import get_current_username
from fastapi import APIRouter, Depends, HTTPException, Request, Response
from bson import ObjectId
from app.api.utils.jsonreturn import *
        
$name = APIRouter()

#Metodos
def post(object,db):
    try:
        object = object.dict()
        object_id  = db.insert_one(object).inserted_id
        object = db.find_one({'_id':object_id})
        object = dict(object)
        object['_id'] = str(object['_id'])
        data_object['message'] = object
        return data_object
    except Exception as e:  
        error['message'] = str(e)
        return error

def get(key,db,id):
    try:
        if(key=='_id'):
            object = db.find_one({f'{key}':ObjectId(id)})
        else:
            object = db.find_one({f'{key}':id})
        if(object!=None):
            object = dict(object)
            object['_id'] = str(object['_id'])
            data_object['message'] = object
            return data_object
        data_object_does_not_exist['message'] = 'the object does not exist'
        return data_object_does_not_exist
    except Exception as e:
        error['message'] = str(e)
        return error

def put(key,db,id,data):
    try:
        if(key=='_id'):
            object = db.find_one({f'{key}':ObjectId(id)})
        else:
            object = db.find_one({f'{key}':id})
        if(object!=None):
            data = dict(data)
            print(object)
            if(key=='_id'):
                db.update_one({f'{key}':ObjectId(id)},{'\$set':data})
                object = db.find_one({f'{key}':ObjectId(id)})
            else:
                db.update_one({f'{key}':id},{'\$set':data})
                object = db.find_one({f'{key}':id})        
            object['_id'] = str(object['_id'])
            data_object['message'] = object 
            return data_object
        data_object_does_not_exist['message'] = 'Object does not exist'
        return data_object_does_not_exist
    except Exception as e:
        error['message'] = str(e)
        return error

def delete(key,db,id):
    try:
        if(key=='_id'):
            object = db.find_one({f'{key}':ObjectId(id)})
        else:
            object = db.find_one({f'{key}':id})
        if(object!=None):
            if(key=='_id'):
                db.delete_one({f'{key}':ObjectId(id)})
            else:
                db.delete_one({f'{key}':id})
            data_object['message'] = 'The Object was deleted'
            return data_object
        data_object_does_not_exist['message'] = 'Object does not exist'
        return data_object_does_not_exist
    except Exception as e:
        error['message'] = str(e)
        return error

@$name.post('/$name/', tags=['$name'])
def post_$name($name:${name^}):
    return post($name,conn.$name.$name)

@$name.get('/$name/{${name}_id}/', tags=['$name'])
def get_$name(${name}_id:str):
    return get('_id',conn.$name.$name,${name}_id)

@$name.put('/$name/{${name}_id}/', tags=['$name'])
def update_$name(${name}_id:str, $name:${name^}):
    return put('_id',conn.$name.$name,${name}_id,$name)
    
@$name.delete('/$name/{${name}_id}/', tags=['$name'])
def delete_$name(${name}_id:str):
    return delete('_id',conn.$name.$name,${name}_id)""" > $api_name/app/api/routes/$name.py

#jsonreturn 
echo """error =  {
    'code':1216,
    'message':''
}

data_object ={
    'code':200,
    'message':{}
}

data_object_exist = {
    'code': 1217,
    'message': ''
}

data_object_does_not_exist = {
    'code': 1217,
    'message': ''
}

data_delete = {
    'code': 200,
    'message': ''
}""" > $api_name/app/api/utils/jsonreturn.py