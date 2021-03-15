# Lambda Serverless
## Content
- AWS configuration 
- Requrement 
- Example code 

## AWS Configuration
you have to configure AWS CLI first before using the serverless framework.
See this [link](https://github.com/fatchur/AWS-Note/tree/master/CLI/configure) for more detail.


## Requirement 
- create a new directory with a `package.json` file
   ```
   mkdir <you-application-name> && cd <your-application-name>
   npm init -f
   ```

- install a few dependencies
We will use the `serverless-wsgi` plugin for negotiating the API Gateway event type into the WSGI format that Flask expects, and `serverless-python-requirements` plugin for handling our Python packages on deployment.
    ```
    npm install --save-dev serverless-wsgi serverless-python-requirements
    ```

## Folder Structure
- app.py, `main python flask program`
- requirements.txt, `list of python requirements, ex numpy, pandas, etc.`
- serverless.yml, `the serverless deployment configuration`

Also after `npm initialization` and install dependencies, you will got this additional file/folder
- node-modules/
- package.json 

### a. `app.py` format
There is no different format for this file or same with another style of python flask code, for example.
```python
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
def hello():
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

    resp = {}
    return Response(json.dumps(resp), 
                        mimetype='application/json', 
                        headers=headers)
```

### b. `requirements.txt` format
```
numpy==a.x 
pandas
opencv==4.0
```

### c. `serverless.yml` format
```
service: <your-service-name>

# the installed plugin before
plugins:
  - serverless-python-requirements
  - serverless-wsgi

custom:
  wsgi:
    app: app.app
    packRequirements: false
  pythonRequirements:
    dockerizePip: non-linux

provider:
  name: aws
  runtime: python3.6
  stage: dev
  region: us-east-1
  iamRoleStatements:
    #####################
    # allow access of: 
    # - s3 delete, get, put
    # - s3 list
    #####################
    - Effect: "Allow"
      Action:
        - s3:DeleteObject
        - s3:GetObject
        - s3:GetObjectAcl
        - s3:ListBucket
        - s3:PutObject
        - s3:PutObjectAcl
    #####################
    # target resource:
    # s3 bucket
    #####################
      Resource:
        Fn::Join:
          - ""
          - - "arn:aws:s3:::"
            - Ref: ServerlessDeploymentBucket

functions:
  app:
    handler: wsgi.handler
    events:
      - http: ANY /
      - http: 'ANY {proxy+}'
```

## Deploy Your Code
```
export AWS_SDK_LOAD_CONFIG=1
### without aws profile
serverless deploy 
### using AWS profile
serverless deploy --aws-profile <your-role-name>
```

## References
- [flask-python-rest-api-serverless-lambda-dynamodb](https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb)