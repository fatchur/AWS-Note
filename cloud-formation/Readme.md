# Deploy stack 
```aws cloudformation deploy --template-file sqs.yml --stack-name mlops-rec-sqs-dev --capabilities CAPABILITY_NAMED_IAM```

# update stack 
```aws cloudformation update-stack --stack-name mlops-rec-sqs-dev --template-body file://sqs.yml```

# Delete Stack
```aws cloudformation delete-stack --stack-name mlops-rec-network-dev```