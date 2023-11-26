FROM agrigorev/zoomcamp-bees-wasps:v2 as model
FROM  public.ecr.aws/lambda/python:3.10
RUN pip install keras-image-helper
RUN pip install https://github.com/alexeygrigorev/tflite-aws-lambda/raw/main/tflite/tflite_runtime-2.14.0-cp310-cp310-linux_x86_64.whl

ENV MODEL_NAME=bees-wasps-v2.tflite
COPY --from=model /var/task/${MODEL_NAME} .
COPY lambda.py .

RUN pip install requests Pillow numpy

# <python file title>.lambda_handler
CMD [ "lambda.lambda_handler" ]
