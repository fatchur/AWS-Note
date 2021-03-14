# Sagemaker Single Model Deployment 

## Contents
- Deployment via jupyter notebook
- Deployment via lambda API request


## 1. Jupyter noebook 
Requirements:
``` 
#install sagemaker python
pip3 install --upgrade sagemaker
```

### 1.1 Tensorflow
* python code: 
    ```
    ######################
    #   Deployment code  #
    ######################
    import sagemaker
    from sagemaker.tensorflow.model import TensorFlowModel
   
    sess = sagemaker.Session()
    role = sagemaker.get_execution_role()

    model = TensorFlowModel(model_data='s3://<bucket>/<path-to>/model.tar.gz', 
                            role=role,
                            framework_version='1.15')
    predictor = model.deploy(initial_instance_count=1, 
                            instance_type='ml.c5.large', 
                            endpoint_name="endpooint-name")

    
    ######################
    #  Model Test code   #
    ######################
    from sagemaker.tensorFlow.model import TensorFlowPredictor

    input = {"instances": [{"input": {"b64": <img_b64>}}]}
    endpoint = predictor.endpoint_name ## predictor --> from deployment
    model_predictor = TensorFlowPredictor(endpoint)
    result = model_predictor.predict(input)
    ```



* note:
    ```
    model format: tar.gz file    
    folder structure:    
    role: sagemaker and s3 full access
    ```

### 1.2 XGboost
### 1.3 Sklean
### 1.4 Pytorch


## 2. Lambda API Request Deployment


## References: 
1. Tensorflow on sagemaker (https://sagemaker.readthedocs.io/en/stable/frameworks/tensorflow/sagemaker.tensorflow.html)



