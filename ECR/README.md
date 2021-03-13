## How To Upload Docker Image In AWS ECR


### Sagemaker NOTE
```
- AWS region used: us-east-1 (North virginia)
- AWS singapore region not supported yet for sagemaker autoscaling
```

### From Docker Image to ECR
```
# build docker image
docker build -t <image-name>:<version>

# login to ecr
---------------
aws ecr get-login-password --region us-east-1 --<your aws profile> \
    | docker login \
        --password-stdin \
        --username AWS \
        <aws user id>.dkr.ecr.us-east-1.amazonaws.com/<ecr repository name>


# tag the image
---------------
docker tag <image name>:<version> <aws user id>.dkr.ecr.us-east-1.amazonaws.com/<ecr repository name>:<version>

# push the image
---------------
docker push <aws user id>.dkr.ecr.us-east-1.amazonaws.com/<ecr repository name>:<version>
```

### Additional info
```
# set region to north virginia
--------------
export AWS_DEFAULT_REGION=us-east-1
export repository=<ecr-repository-name>

# ERROR PERMISSION in accesing docker json when login to ECR
- sudo su
then login to ECR
```

### References
1. (AWS ECR from authentication to push image ) https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html

