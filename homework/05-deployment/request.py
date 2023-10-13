import requests
import os
from absl import flags, app
import json
from urllib.parse import urljoin

flags.DEFINE_string(
    "client",
    help="file path to client data (json file path or structure)",
    default=None,
    required=True)

def load_client_data(client_data:str):
    """
    Load client data from json file or json structure
    """
    client_json = None
    if os.path.isfile(client_data):
        client_json = json.load(open(client_data, "r"))
    else:
        # check if string is json structure
        try:
            client_json = json.loads(client_data)
        except:
            raise ValueError("client data must be a json file or json structure")
    return client_json

def main(argv):    
    client = flags.FLAGS.client
    client_json = load_client_data(client)
    # print(f"client_json: {client_json}")
    host = os.environ.get("APP_HOST")
    port = os.environ.get("APP_PORT")
    url = urljoin(f"http://{host}:{port}", "predict")
    # print(f"url: '{url}'")
    response = requests.post(url, json=client_json).json()
    print(json.dumps(response, indent=2))

# create main routine
if __name__ == "__main__":
    app.run(main)
