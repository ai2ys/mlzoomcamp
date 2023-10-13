## Homework

In this homework, we will use Bank credit scoring dataset from [here](https://www.kaggle.com/datasets/kapturovalexander/bank-credit-scoring/data).

> **Note**: sometimes your answer doesn't match one of the options exactly. That's fine. 
Select the option that's closest to your solution.

> **Note**: we recommend using python 3.10 in this homework.


## Question 1

* Install Pipenv
* What's the version of pipenv you installed?
* Use `--version` to find out

---

### Solving 1

Building the base and pipenv docker images
```shell
$ cd homework/05-deployment
$ docker compose --profile pipenv build pipenv-generator
```

Checking the pipenv cersion
```shell
$ docker compose --profile pipenv run --rm -it pipenv-generator
pipenv, version 2023.10.3
```

### Answer 1

`2023.10.3`

---

## Question 2

* Use Pipenv to install Scikit-Learn version 1.3.1
* What's the first hash for scikit-learn you get in Pipfile.lock?

> **Note**: you should create an empty folder for homework
and do it there. 

---

### Solving 2


```shell
$ docker compose build
$ grep -A 3 scikit-learn docker/pipenv-pipfile/Pipfile.lock \
    | sed -n '/sha256/p' \
    | head -n 1 \
    | sed 's/.*\([a-f0-9]\{64\}\).*/\1/'
0c275a06c5190c5ce00af0acbb61c06374087949f643ef32d355ece12c4db043

```
### Answer 2

`0c275a06c5190c5ce00af0acbb61c06374087949f643ef32d355ece12c4db043`

---

## Models

We've prepared a dictionary vectorizer and a model.

They were trained (roughly) using this code:

```python
features = ['job','duration', 'poutcome']
dicts = df[features].to_dict(orient='records')

dv = DictVectorizer(sparse=False)
X = dv.fit_transform(dicts)

model = LogisticRegression().fit(X, y)
```

> **Note**: You don't need to train the model. This code is just for your reference.

And then saved with Pickle. Download them:

* [DictVectorizer](https://github.com/DataTalksClub/machine-learning-zoomcamp/tree/master/cohorts/2023/05-deployment/homework/dv.bin?raw=true)
* [LogisticRegression](https://github.com/DataTalksClub/machine-learning-zoomcamp/tree/master/cohorts/2023/05-deployment/homework/model1.bin?raw=true)

With `wget`:

```bash
PREFIX=https://raw.githubusercontent.com/DataTalksClub/machine-learning-zoomcamp/master/cohorts/2023/05-deployment/homework
wget $PREFIX/model1.bin
wget $PREFIX/dv.bin
```

## Question 3

Let's use these models!

* Write a script for loading these models with pickle
* Score this client:

```json
{"job": "retired", "duration": 445, "poutcome": "success"}
```

What's the probability that this client will get a credit? 

* 0.162
* 0.392
* 0.652
* 0.902

If you're getting errors when unpickling the files, check their checksum:

```bash
$ md5sum model1.bin dv.bin
3f57f3ebfdf57a9e1368dcd0f28a4a14  model1.bin
6b7cded86a52af7e81859647fa3a5c2e  dv.bin
```


---

### Solution 3

Has to get updated
```shell
md5sum model1.bin dv.bin
8ebfdf20010cfc7f545c43e3b52fc8a1  model1.bin
924b496a89148b422c74a62dbc92a4fb  dv.bin
```

Bulding all other docker images
```shell
docker compose build 
```

```shell
$ echo '{"job": "retired", "duration": 445, "poutcome": "success"}' \
    | docker compose run -T --rm test-app 2>/dev/null
{
    "loan": true,
    "loan_probability": 0.9019309332297606
}
```

### Answer 3
    
`0.902`

---


## Question 4

Now let's serve this model as a web service

* Install Flask and gunicorn (or waitress, if you're on Windows)
* Write Flask code for serving the model
* Now score this client using `requests`:

```python
url = "YOUR_URL"
client = {"job": "unknown", "duration": 270, "poutcome": "failure"}
requests.post(url, json=client).json()
```

What's the probability that this client will get a credit?

* 0.140
* 0.440
* 0.645
* 0.845

---

### Solution 4

```shell
$ CLIENT='{"job": "unknown", "duration": 270, "poutcome": "failure"}'
$ docker compose run --rm test-app -c "python request.py --client '${CLIENT}'" 2>/dev/null
{
  "loan": false,
  "loan_probability": 0.13968947052356817
}
```

### Answer 4

`0.140`

---


## Docker

Install [Docker](https://github.com/DataTalksClub/machine-learning-zoomcamp/blob/master/05-deployment/06-docker.md). 
We will use it for the next two questions.

For these questions, we prepared a base image: `svizor/zoomcamp-model:3.10.12-slim`. 
You'll need to use it (see Question 5 for an example).

This image is based on `python:3.10.12-slim` and has a logistic regression model 
(a different one) as well a dictionary vectorizer inside. 

This is how the Dockerfile for this image looks like:

```docker 
FROM python:3.10.12-slim
WORKDIR /app
COPY ["model2.bin", "dv.bin", "./"]
```

We already built it and then pushed it to [`svizor/zoomcamp-model:3.10.12-slim`](https://hub.docker.com/r/svizor/zoomcamp-model).

> **Note**: You don't need to build this docker image, it's just for your reference.


## Question 5

Download the base image `svizor/zoomcamp-model:3.10.12-slim`. You can easily make it by using [docker pull](https://docs.docker.com/engine/reference/commandline/pull/) command.

So what's the size of this base image?

* 47 MB
* 147 MB
* 374 MB
* 574 MB

You can get this information when running `docker images` - it'll be in the "SIZE" column.

---

### Solving 5

```shell
$ docker pull svizor/zoomcamp-model:3.10.12-slim
$ docker images --format "{{.Size}}" svizor/zoomcamp-model:3.10.12-slim 
147MB
```

### Answer 5

`147MB`

---


## Dockerfile

Now create your own Dockerfile based on the image we prepared.

It should start like that:

```docker
FROM svizor/zoomcamp-model:3.10.12-slim
# add your stuff here
```

Now complete it:

* Install all the dependencies form the Pipenv file
* Copy your Flask script
* Run it with Gunicorn 

After that, you can build your docker image.


## Question 6

Let's run your docker container!

After running it, score this client once again:

```python
url = "YOUR_URL"
client = {"job": "retired", "duration": 445, "poutcome": "success"}
requests.post(url, json=client).json()
```

What's the probability that this client will get a credit now?

* 0.168
* 0.530
* 0.730
* 0.968

---

### Solution 6

```shell
$ CLIENT='{"job": "retired", "duration": 445, "poutcome": "success"}'
$ docker compose run --rm -T \
  --env APP_HOST=flask-app-svizor test-app -c "python request.py --client '${CLIENT}'" \
  2>/dev/null
{
  "loan": true,
  "loan_probability": 0.726936946355423
}

### Answer 6

`0.730`

---

## Submit the results

- Submit your results here: https://forms.gle/gfruq6FGoLass3Ff9
- If your answer doesn't match options exactly, select the closest one.
- You can submit your solution multiple times. In this case, only the last submission will be used


## Deadline

The deadline for submitting is October 16 (Monday), 23:00 CET. After that the form will be closed.

