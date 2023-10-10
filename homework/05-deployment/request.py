import requests
import os
from absl import flags, app
import json

flags.DEFINE_string(
    "client",
    help="file path to client data (json file)",
    default=None,
    required=True)


def main(argv):    
    client_file = flags.FLAGS.client
    print(client_file)
    # if client_file is None:
    #     print("Error: client file path not specified")
    #     exit(1)


    url = os.environ.get("APP_HOST")
    client = json.load(open(client_file, "r"))
    response = requests.post(url, json=client).json()
    print(json.dumps(response, indent=2))

# create main routine
if __name__ == "__main__":
    app.run(main)
