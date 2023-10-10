# Stage for installing Python dependencies
ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS pipenv
RUN pip install --upgrade pip && pip install --no-cache-dir pipenv \
    && apt-get update && apt-get install -y --no-install-recommends \
        wget \
    # Cleanup to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
COPY Pipfile* .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv sync

RUN PREFIX=https://raw.githubusercontent.com/DataTalksClub/machine-learning-zoomcamp/master/cohorts/2023/05-deployment/homework \
    && wget ${PREFIX}/model1.bin -P /tmp/model \
    && wget ${PREFIX}/dv.bin -P /tmp/model \
    && echo "8ebfdf20010cfc7f545c43e3b52fc8a1  /tmp/model/model1.bin" | md5sum -c - \
    && echo "924b496a89148b422c74a62dbc92a4fb  /tmp/model/dv.bin" | md5sum -c -

