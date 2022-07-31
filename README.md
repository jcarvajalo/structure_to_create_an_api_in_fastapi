
## Hello 
I created this script for when i need to build an api with fastapi, basically this script creates the  directories and standard files to needed to structure a good api in fastapi.

The sctructure is like that.

``` bash
├── api_example
│   ├── app
│   │   ├── api
│   │   │   ├── config
│   │   │   │   └── db.py
│   │   │   ├── models
│   │   │   │   └── example.py
│   │   │   ├── routes
│   │   │   │   └── example.py
│   │   │   ├── schemas
│   │   │   │   └── example.py
│   │   │   └── utils
│   │   │       └── acces_security.py
│   │   └── app.py
│   ├── Dockerfile
│   └── requirements.txt

```

## Instruction to run the script 


``` bash 
> bash create_api.bash
here  you need add two values
 * $name: This value is the name of api and to rename the folder and the files
 * $path: This value is the path where the folder will be create
 
``` 




