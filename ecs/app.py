from flask import Flask
from flask import request
from flask import Response
from flask_cors import CORS


app = Flask(__name__)
CORS(app)

RESPONSE_HEADERS = {} 
RESPONSE_HEADERS['Access-Control-Allow-Origin'] = '*'
RESPONSE_HEADERS['Access-Control-Allow-Methods'] = 'OPTIONS, GET, POST'
RESPONSE_HEADERS['Access-Control-Allow-Credentials'] = 'true'
RESPONSE_HEADERS['Access-Control-Allow-Headers'] = 'Authorization, Content-Type'
RESPONSE_HEADERS['Content-Type'] = 'application/json' 
CORS_HEADER = {'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'}


@app.route('/test', methods=['POST'])
def process():
    """[summary]
    Returns:
        [type]: [description]
    """  
    # ------------------------------ #
    # set cors header                #
    # Set response header            #
    # ------------------------------ #
    if request.method == 'OPTIONS':
        headers = CORS_HEADER
        return ('', 204, headers)

    headers = RESPONSE_HEADERS
    response = {}

    return response


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8004, debug=True)