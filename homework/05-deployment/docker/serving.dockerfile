# Stage for the final runtime image
ARG PIPENV_IMAGE
ARG BASE_IMAGE

FROM ${PIPENV_IMAGE} AS pipenv

FROM ${BASE_IMAGE} as app

WORKDIR /app
COPY --from=pipenv /.venv /.venv
ENV PATH="/.venv/bin:$PATH"
COPY --from=pipenv /tmp/model/* ./model/
COPY *.py /app/

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:9696", "serving:app"] 
EXPOSE 9696