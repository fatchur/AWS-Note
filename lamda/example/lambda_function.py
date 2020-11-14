import io
import re
import sys
import json
import math
from io import BytesIO
from yourpackage.folder.filename import class_a


RESPONSE_HEADERS = {} 
RESPONSE_HEADERS['Access-Control-Allow-Origin'] = '*'
RESPONSE_HEADERS['Access-Control-Allow-Credentials'] = 'false'
RESPONSE_HEADERS['Access-Control-Allow-Headers'] = 'Authorization, Content-Type'
RESPONSE_HEADERS['Access-Control-Allow-Methods'] = 'GET, POST, PUT'
RESPONSE_HEADERS['Content-Type'] = 'application/json' 

CORS_HEADER = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, GET',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'}


def lambda_handler(event, context):
    """[summary]

    Args:
        event ([type]): [description]
        context ([type]): [description]

    Returns:
        [type]: [description]
    """    
    # ----------------------------
    # CORS handling
    # Response for option method
    # ----------------------------
    http_method = event['requestContext']['http']['method']
    if http_method == 'OPTIONS': 
        return {
        'statusCode': 204,
        'headers': CORS_HEADER}
        
    payload = json.loads(event["body"])
    param1 = payload["param1"]
    param2 = payload["param2"]
    param3 = payload["param3"]
    val1, val2 = do_something(param1, param2, param3)
    
    response = {}
    response["status"] = 200
    response["data"] = {}
    response["data"]["key1"] = val1
    response["data"]["key2"] = val2
    
    return {
        'statusCode': 200,
        'headers': RESPONSE_HEADERS,
        'body': json.dumps(response)
    }
