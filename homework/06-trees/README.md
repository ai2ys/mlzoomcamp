# Homework 06

The instruction can be found here: 

https://github.com/DataTalksClub/machine-learning-zoomcamp/blob/master/cohorts/2023/06-trees/homework.md

Jupyter notebook containing homework:

[homework.ipynb](homework.ipynb)


## Running the homework notebook

> 💡 For details please refer to [../../EnvironmentSetupUsingDocker.md](../../EnvironmentSetupUsingDocker.md)


Use the two commands below to start the container and run the notebook.

1. Start the container from the root directory of this repository using `docker compose run --rm mlzoomcamp`. This will start the container and mount the current directory as a volume in the container. 

1. Afterwards start JupyterLab using the alias `jlab` from the container commandline.

```text
$ ddocker compose run --rm --service-ports mlzoomcamp  
root@mlzoomcamp:/workspace# jlab
```