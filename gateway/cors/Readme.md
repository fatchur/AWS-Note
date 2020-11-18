### API GATEWAY CORS CONFIGURATION


#### A. Create Gateway Stage
```
1. On the gateway deploy section, click "stage"
2. Click "create"
3. Fill the stage name
4. Choose "enable automatic deployment" or Not
5. "create"
```


#### B. Set The CORS configuration
After creating a stage, you can apply CORS sonfiguration to the selected stage.
```
1. From the "develop" section, choose "CORS"
2. Fill the CORS configuration
3. Click "deploy" on certain stage (IF the stage is not set for automatic deployment)
```

The CORS parametes are:
1. `Access-Control-Allow-Origin`: *
2. `Access-Control-Allow-Methods`: `OPTION`, and your HTTP method
3. `Access-Control-Max-Age`: 300s
4. `Access-Control-Allow-Headers`: 
    ```
    access-control-allow-origin
    content-type
    content-length
    content-type,x-amz-date,authorization,x-api-key,x-amz-security-token
    ```


#### C. Gateway CORS Setup in Lambda
```
API type: http
Cross-origin resource sharing (CORS): Yes
stage: <the stage of gateway used for this lambda>
```