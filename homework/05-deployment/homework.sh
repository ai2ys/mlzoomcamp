#!/bin/bash

# set -ex

# change directory to the directory of the script
pushd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null

# make variable accessible in this script
source .env

# create the output file
OUTPUT_FILE=./homework_output.txt
# create empty file (overwrite if exists)
:> ${OUTPUT_FILE}

# creating the Pipfile and Pipfile.lock
# 1. building the pipenv-generator image
docker compose --profile pipenv build pipenv-generator
# 2. running the pipenv-generator container for copying the Pipfile and Pipfile.lock
docker compose --profile pipenv run --rm -it pipenv-generator

# building the flask app and the test app
docker compose build

## Question 1
echo "Question 1" >> ${OUTPUT_FILE}
docker compose --profile pipenv run --rm pipenv-generator -c "pipenv --version" >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}

## Question 2
echo "Question 2" >> ${OUTPUT_FILE}
# grep -A 2 'scikit-learn' docker/pipenv-pipfile/Pipfile.lock \
#     | sed -n '3p' \
#     | tr -d '[:space:]' \
#     && echo >> ${OUTPUT_FILE}
grep -A 3 scikit-learn docker/pipenv-pipfile/Pipfile.lock \
    | sed -n '/sha256/p' \
    | head -n 1 \
    | sed 's/.*\([a-f0-9]\{64\}\).*/\1/' \
    >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}

## Question 3
echo "Question 3" >> ${OUTPUT_FILE}
echo '{"job": "retired", "duration": 445, "poutcome": "success"}' \
    | docker compose run -T --rm test-app \
    >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}

## Question 4
echo "Question 4" >> ${OUTPUT_FILE}
CLIENT='{"job": "unknown", "duration": 270, "poutcome": "failure"}'
docker compose run --rm -T test-app -c "python request.py --client '${CLIENT}'" >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}

## Question 5
echo "Question 5" >> ${OUTPUT_FILE}
docker pull svizor/zoomcamp-model:3.10.12-slim
docker images --format "{{.Size}}" svizor/zoomcamp-model:3.10.12-slim >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}

## Question 6
echo "Question 6" >> ${OUTPUT_FILE}
CLIENT='{"job": "retired", "duration": 445, "poutcome": "success"}'
docker compose run --rm -T --env APP_HOST=flask-app-svizor test-app -c "python request.py --client '${CLIENT}'" >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}

# echo "Removing all running containers
docker compose down
# set +x

echo "------------"
echo "- Homework -"
echo "------------"
cat ${OUTPUT_FILE}

