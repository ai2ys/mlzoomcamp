# Following the best practice from the resources below using multi-stage builds
# https://pipenv.pypa.io/en/latest/docker/
# https://sourcery.ai/blog/python-docker/

ARG BASE_IMAGE
FROM ${BASE_IMAGE} as pipenv-deps
ARG VERSION_PIPENV
ARG VERSION_PIP
RUN pip install --upgrade pip==${VERSION_PIP} && pip install --no-cache-dir pipenv==${VERSION_PIPENV} \
    && apt-get update && apt-get install -y --no-install-recommends \
        wget \
    # Cleanup to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

COPY pipenv-pipfile/Pipfile* .

# Set bash as the default shell
RUN PIPENV_VENV_IN_PROJECT=1 pipenv sync

RUN PREFIX=https://raw.githubusercontent.com/DataTalksClub/machine-learning-zoomcamp/master/cohorts/2023/05-deployment/homework \
    && wget ${PREFIX}/model1.bin -P /tmp/model \
    && wget ${PREFIX}/dv.bin -P /tmp/model \
    && echo "8ebfdf20010cfc7f545c43e3b52fc8a1  /tmp/model/model1.bin" | md5sum -c - \
    && echo "924b496a89148b422c74a62dbc92a4fb  /tmp/model/dv.bin" | md5sum -c -

#ARG BASE_IMAGE
FROM ${BASE_IMAGE} as app

WORKDIR /app
COPY --from=pipenv-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"
COPY --from=pipenv-deps /tmp/model/* ./
COPY *.py /app/

ENV MODEL_PATH=/app/model1.bin
ENV DV_PATH=/app/dv.bin

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:9696", "serving:app"] 
EXPOSE 9696