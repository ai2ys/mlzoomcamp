ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ARG VERSION_PIPENV
ARG VERSION_PIP
RUN pip install --upgrade pip==${VERSION_PIP} && \
    pip install --no-cache-dir pipenv==${VERSION_PIPENV}

# # create Pipfile and Pipfile.lock
# RUN pipenv lock --clear

WORKDIR /workspace
COPY pipenv-generator-requirements.txt requirements.txt
# create Pipfile and Pipfile.lock based on requirements.txt
RUN pipenv install --requirements requirements.txt

ENTRYPOINT [ "/bin/bash" ]
# Copy the Pipfile and Pipfile.lock to your host
CMD ["-c", "cp /workspace/Pipfile* /host"]