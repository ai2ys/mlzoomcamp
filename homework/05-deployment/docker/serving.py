import pickle
import numpy as np

from flask import Flask, request, jsonify

def predict_single(customer, dv, model):
    X = dv.transform([customer])
    y_pred = model.predict_proba(X)[:, 1]
    return y_pred[0]


model = None
dv = None
with open('/app/model/model1.bin', 'rb') as f:
    model = pickle.load(f)
with open('/app/model/dv.bin', 'rb') as f:
    dv = pickle.load(f)

app = Flask('credit-score')


@app.route('/predict', methods=['POST'])
def predict():
    customer = request.get_json()

    prediction = predict_single(customer, dv, model)
    loan = prediction >= 0.5
    
    result = {
        'loan_probability': float(prediction),
        'loan': bool(loan),
    }

    return jsonify(result)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=9696)


# how can I use curl to do a POST request using a json file?
# curl -X POST -H "Content-Type: application/json" -d @<json file> <url>
# curl -X POST -H "Content-Type: application/json" -d '{"income": 5000, "age": 19, "loan": 0, "income": 0, "income": 0}' http://localhost:9696/predict