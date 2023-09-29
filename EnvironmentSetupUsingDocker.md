# Environment Setup using Docker

## Info for Docker beginners

If you are new to Docker you could either try it out with [GitHub Codespaces](https://github.com/features/codespaces) as it comes with `Docker` and the `Docker Compose Plugin` pre-installed. Just launch GitHub Codespace for this repository.

On your local system Or you could try out installing [Docker Desktop](https://www.docker.com/products/docker-desktop/) on you local system (available for Windows, MacOS and Linux). The installer for Docker Desktop should also include the Docker Compose Plugin.


I am using Docker on the following systems.

- Docker Desktop 
    - Windows 11 host with WSL2 (Windows Subsystem for Linux 2)
    - Intel based MacOS (Monterey) host 
- Docker Engine without Docker Desktop (https://docs.docker.com/engine/install/ubuntu/)
    - Ubuntu 20.04 host
- GitHub Codespaces (free instances) 

ℹ️ Remark for Linux Users: If you have a headless Linux system will probably want to install [Docker Engine](https://docs.docker.com/engine/install/) without Docker Desktop.  

More information about Containers:

- https://www.docker.com/resources/what-container/


---

## Getting started with Docker in this repository

In this folder you will find the following files belonging to the Docker image. Using it requires having installed Docker and the Docker-Compose-Plugin.

- [docker-compose.yml](docker-compose.yml) - used for building the Docker image and starting up the Docker container 
    - [docker/dockerfile](docker/dockerfile) - containing the instructions for the Docker image
    - [docker/requirements.txt](docker/requirements.txt) - containing the Python libraries to install


---

ℹ️ Usually I would specify the versions of the Python libraries to get installed explicitly in the `requirements.txt`, but the [instructions for setting up the environment](https://github.com/DataTalksClub/machine-learning-zoomcamp/blob/master/01-intro/06-environment.md) state that the latest available versions of NumPy, Pandas and Scikit-Learn should get installed.

---

## Building the 🐳 Docker image

In the terminal change the current directory to the following and build the Docker image using the following command.

```bash
docker compose build
```

This will build the image following the instructions of the `docker-compose.yml` file.

## Starting the 🐳 Docker container

The following command will start a `bash` in the container.

```bash
docker compose run --rm --service-ports mlzoomcamp
```

Which will look like this.

```shell
$ docker compose run --rm --service-ports mlzoomcamp
[+] Creating 1/0
 ✔ Network ml-zoomcamp_default  Created            0.0s 
root@mlzoomcamp:/workspace# 
```

Use the alias `jlab` for starting JupyterLab from commandline.

```bash
root@mlzoomcamp:/workspace# jlab
```

Stop the container by closing the shell or terminal window.

```bash
root@mlzoomcamp:/workspace# exit
$
```

### Specifying another port for Jupyter Lab

There are two options available for changing the Jupyter notebook port, if required. The default port being used is `8888`.

1. Changing the `PORT_JNB` value in the [`.env`](.env) file.

1. Overwrite the value of `PORT_JNB` at container startup.

    ```bash
    PORT_JNB=<port of choice> docker compose run \
        --rm \
        --service-ports \
        mlzoomcamp
    ```


