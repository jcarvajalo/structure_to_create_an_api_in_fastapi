# Documentation
Hello, I created this script for when i need to build an API with Fastapi, basically this script creates the  directories and standard files to needed to structure a good API in Fastapi.

The sctructure is like that.

``` bash
├── api_example
│   ├── app
│   │   ├── api
│   │   │   ├── config
│   │   │   │   └── db.py
│   │   │   │   └── env.py
│   │   │   ├── models
│   │   │   │   └── example.py
│   │   │   ├── routes
│   │   │   │   └── example.py
│   │   │   ├── schemas
│   │   │   │   └── example.py
│   │   │   └── utils
│   │   │       └── acces_security.py
│   │   │       └── jsonreturn.py
│   │   └── app.py
│   ├── Dockerfile
│   ├── .env
│   └── requirements.txt
```

## Instructions to run the script 
On bash type the next line to execute the script

``` 
> bash api_creator.bash
``` 

Here  you need add two values
 * $name: This value is the name of api and to rename the folder and the files
 * $path: This value is the path where the API folder will be created

After script finish u will see a message indicating that all was right, then you can close the bash

## Once the API is created
Then, you are ready to run the Uvicorn server.

But first, you need to associate the database to your API. In the example the script uses a Mongo Database, so you need to provide a MongoDB URL in the MONGO_CLIENT variable in the .env file.
Once, in the API root folder 

```
/path_to_folder/api_example>
```

type:

```
uvicorn app.app:app --reload
```

This command will raise the localhost server to test your API.

Enjoy creating your API's :)




