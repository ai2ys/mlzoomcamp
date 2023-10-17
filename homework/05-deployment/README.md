# Solution provided in this folder


## TL;DR

Running the following script, for performing all steps required for this homework assignment. It will build all images and execute all test for retrieving the answers for the homework questions.

```shell
chmod u+x ./homework.sh
./homework.sh
```

> **Prerequisites:** Docker and Docker Compose are installed on the system. The `homework.sh` script has been executed and tested running it from WSL2 on Windows.  

---

## In Detail Description of the Solution

This homework solution makes use of Docker Compose for building the Docker images and running the Docker containers. The `docker-compose.yml` file defines the services and the build process. All dockerfiles are located in the `docker` folder.

Services defined in the `docker-compose.yml` file:

1. `pipenv-generator`
    - This service is used to generate the `Pipfile` and `Pipfile.lock` files. These will be used for building both `flask-app` services (also `flask-app-szvisor`).
1. flask-app
    - This service is used to build the final image for the flask flask-app. It utilizes multi-stage builds to decrease the size of the final image. It will copy the installed Python libraries from the `pipenv` build-stage and the model and DictVectorizer bin file to the final build-stage. It will not need to have `pipenv` installed.
1. flask-app-szvisor
    - It is the same as the `flask-app` except for that it utilizes another model and DictVectorizer bin file for question 6 of the homework
1. test-app
    - This service is used to perform the http post request on the `flask-app` and `flask-app-svizor` services. 

All services (except for `flask-app-szvisor`) are based on `python:3.10.12-slim-bookworm`. Furthermore does this homework solution make use of build stages to decrease the size of the final "serving" image for the  `flask-app` and `flask-app-szvisor`.

There following resources provide guidance on how to use `pipenv` with docker and both approaches are used in this homework solution:

- *Docker containers* by `pipenv´<br>
https://pipenv.pypa.io/en/latest/docker/

    > In general, you should not have Pipenv inside a linux container image, since it is a build tool. If you want to use it to build, and install the run time dependencies for your application, you can use a multistage build for creating a virtual environment with your dependencies. [...]	

- *A perfect way to Dockerize your Pipenv Python application* by Brendan Maginnis<br>
https://sourcery.ai/blog/python-docker/



### Building the docker images

Running `docker compose build` will not build the `pipenv-generator` image, as a profile has been added to this. We do not want to startup this container at runtime, it is just used for generating the `Pipfile` and `Pipfile.lock` as well as building the base image used for the first build-stage `pipenv-deps` in the `flask-app` multi-stage. 
We have to build the `pipenv-generator` image first, before we can build the `flask-app` image. We can do this by running the following command:

- Building the `pipenv-generator` docker image which is a prerequisite for the `flask-app` docker image	 
    ```shell
    docker compose --profile pipenv build pipenv-generator
    ```	

Building all other servives without any defined profiles:

- Building the `flask-app` (`flask-app-szvisor`) services and the `test-app` service
    ```shell
    docker compose build
    ```
- Alternatively each could be build separately using the following commands:
    ```shell	
    docker compose build <service name>
    ```
As we defined `depends_on` for the `test-app` service to depend on the `flask-app` and `flask-app-szvisor` services, it will startup the `flask-app` and `flask-app-svisor` containers automatically when we run the `test-app` container. 
We are running the `test-app` container with the `--rm` flag, so it will be removed after the test is done.

### Running the tests for `flask-app`

There are two options available for executing the http request on the `flask-app` service:

1. Using `curl` for executing the http request
    ```shell	
    echo '<json structure>' \
        | docker compose run -T --rm test-app \
    # or 
    cat '<json file path>' \
        | docker compose run --rm -T test-app
    ```
    - The default command uses `curl` for performing the http-request. This command can be overwritten by passing a different command to the `docker compose run` command.

1. Using `request.py` Python script for executing the http request
    ```shell
    CLIENT='<json structure>'
    docker compose run --rm -T test-app -c "python request.py --client '${CLIENT}'"
    # or
    docker compose run --rm -T test-app -c python request.py <json file path>
    ```

For the `flask-app-szvisor` the commands have to get modified as follows:

- Adding the envrionment variable `APP_HOST=flask-app-szvisor` to the `docker compose run` command
    ```shell
    CLIENT='{"job": "retired", "duration": 445, "poutcome": "success"}'
    docker compose run --rm -T \
        --env APP_HOST=flask-app-svizor test-app \
        -c "python request.py --client '${CLIENT}'"
    ```


Both services `flask-app` and `flask-app-szvisor` will be started automatically the first time we run the `test-app` service, but it will not be restarted when we run the `test-app` service again, because it will run in the background. We can force the `flask-app` and `flask-app-szvisor` services to be stopped and removed by running the following command:

```shell
docker compose down
```

> **Note**: Here `http://localhost:9696` is used as the url for the  `flask-app`. In the `docker-compose.yml` file we defined a link for the `test-app` service to the `app` service, the `flask-app` service will be visible to the `test-app` service using `http://flask-app:9696` instead. 

#### Example for performing the http-request using `curl`

```shell
$ echo '{"job": "retired", "duration": 445, "poutcome": "success"}' | docker compose run --rm -T test-app 2>/dev/null
{
    "loan": true,
    "loan_probability": 0.9019309332297606
}
```

#### Underlying curl commands used

```shell	
echo '<json data>' | \
    curl \
    -X POST \
    -H \"Content-Type: application/json\" \
    -d @- \
    http://localhost:9696/predict 
```

Shorter version doing the same trick

```shell
echo '<json data>' | curl --json @- http://localhost:9696/predict 
```

