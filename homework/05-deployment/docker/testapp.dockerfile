ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install --no-install-recommends -y \
        curl \
    # Cleanup to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip \
    && pip install \
        requests \
        absl-py