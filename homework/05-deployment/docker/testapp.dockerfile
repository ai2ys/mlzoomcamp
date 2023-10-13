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

ENV APP_PORT=9696
ENV APP_HOST=localhost
ENV APP_URL=http://${APP_HOST}:${APP_PORT}
ENV FUNCTION_NAME=predict

ENTRYPOINT [ "/bin/bash" ]
#CMD ["-c", "curl -X POST -H \"Content-Type: application/json\" -d @- ${APP_URL}/${FUNCTION_NAME} 2>/dev/null | python -m json.tool"]
#CMD ["-c", "curl -X POST -H \"Content-Type: application/json\" -d @- ${APP_URL}/${FUNCTION_NAME} | python -m json.tool"]