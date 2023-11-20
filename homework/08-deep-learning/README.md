# Homework 08

The instruction can be found here: 

https://github.com/DataTalksClub/machine-learning-zoomcamp/blob/master/cohorts/2023/08-deep-learning/homework.md

Jupyter notebook containing homework:

[homework.ipynb](homework.ipynb)


## Running the homework notebook

Start the container for running the notebook [`homework.ipynb`](homework.ipynb).
```bash
# cd in to the home work directory
cd homework/08-deep-learning
# start the container (CPU only)
docker compose run --rm --user $(id -u $USER):$(id -g $USER) --service-ports deep-learning

# start the container with GPU support
GPU_ID=<gpu index or UUID> docker compose run --rm --user $(id -u $USER):$(id -g $USER) --service-ports deep-learning
```
