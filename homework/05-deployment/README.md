# Instructions for using the docker-compose.yml file

This homework solution makes use of build stages to decrease the size of the final "serving" image for the flask app.

The service `pipenv` defined in the `docker-compose.yml` file is used to build the base image and the pipenv image, it installs all python libraries defined in the `Pipfile`. The `serving` service is used to build the final image for the flask app and it copies the installed libraries from the `pipenv` image and it will not need to have `pipenv` installed.

There is a third service that is used for performing the http post request on the flask app, it is called `test_app`.

Running `docker compose build` will not build the `pipenv` image, as a profile has been added to this. We do not want to startup this container at runtime, it is just for building. But therefore we can also not use the `depends_on` keyword in the `docker-compose.yml` file, as this would try startup the container at runtime and also requires it at build time.

The build process is as follows:

1. Building the pipenv image which is a prerequisite for the serving image	 
    ```shell
    docker compoose --profile pipenv build pipenv
    ```	

1. Building the serving image and the test_app image
    ```shell
    docker compose build
    ```

As we defined `depends_on` for the test_app service, it will startup the flask app automatically when we run the test_app service. We are running the test_app service with the `--rm` flag, so it will be removed after the test is done. The flask service will be started automatically the first time we run the test_app service, but it will not be restarted when we run the test_app service again, because it will run in the background. We can force the flask service to stop by running the following command:

```shell
docker compose down
```

We can now predict the score for different clients (json data) using the following command.


1. Using a string containing json data
    ```shell 
    echo '<json structure>' | docker compose run --rm -T test_app
    ``` 

    Example
    ```shell
    $ echo '{"job": "retired", "duration": 445, "poutcome": "success"}' | docker compose run --rm -T test_app 2>/dev/null
    {
        "loan": true,
        "loan_probability": 0.9019309332297606
    }
    ```

1. Using a file containing json data and piping it to the default command using curl
    ```shell 
    cat '<json file path>' | docker compose run --rm -T test_app
    ``` 

1. Using a file containing json data passing overwritung the default command running a python script
    ```shell 
    docker compose run --rm -T test_app -c python request.py <json file file>
    ``` 


## Underlying curl commands used

```shell	
cat <json file path> | \
    curl \
    -X POST \
    -H \"Content-Type: application/json\" \
    -d @- \
    http://localhost:9696/predict 
```

