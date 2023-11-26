import os
import tflite_runtime.interpreter as tflite
from keras_image_helper import create_preprocessor
import logging
if logging.getLogger().hasHandlers():
    # The Lambda environment pre-configures a handler logging to stderr. If a handler is already configured,
    # `.basicConfig` does not execute. Thus we set the level directly.
    logging.getLogger().setLevel(logging.INFO)
else:
    logging.basicConfig(level=logging.INFO)

MODEL_NAME = os.getenv('MODEL_NAME', 'bees-wasps-v2.tflite')
preprocessor = create_preprocessor('xception', target_size=(150,150))

interpreter = tflite.Interpreter(model_path=MODEL_NAME)
interpreter.allocate_tensors()

input_index = interpreter.get_input_details()[0]['index']
output_index = interpreter.get_output_details()[0]['index']


def predict(url):
    logging.info(f'predict url: "{url}"')
    X = preprocessor.from_url(url)
    interpreter.set_tensor(input_index, X)
    interpreter.invoke()
    preds = interpreter.get_tensor(output_index)
    logging.info(f'prediction: {preds}')
    return float(preds[0,0])


def lambda_handler(event, context):
    url = event['url']
    pred_result = predict(url)
    result = {
        'prediction': pred_result
    }
    logging.info(f'result: {result}')
    return result