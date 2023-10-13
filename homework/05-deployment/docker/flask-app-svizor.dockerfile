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

FROM svizor/zoomcamp-model:3.10.12-slim as runtime

WORKDIR /app
COPY --from=pipenv-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"
COPY *.py /app/

ENV MODEL_PATH=/app/model2.bin
ENV DV_PATH=/app/dv.bin

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:9696", "serving:app"] 
EXPOSE 9696