### AWS Lambda Layer

#### Create .Zip For Layer Dependency
```
1. Create a folder
2. Go inside you new folder,
3. Install dependency to the current folder `pip3 install <package name> -t .`
4. IN YOUR NEW FOLDER, Crtl + a, then compress as .zip file
3. Upload to AWS s3
```


### Setup the Lmabda Layer
```
1. Go to AWS lambda
2. Select "layer", then "create layer"
3. Fill the layer name
4. Choose "Upload a file from Amazon S3", then fill the s3 url of your .zip file and select runtimes.
5. Clik "create"
```

### Integrate Layer to Lambda Function
```
1. Go to your lambda function
2. Click "LAYER" -> "add a layer"
3. Select "custom layers" -> choose your layer name created before.
4. Cick "add"
```

### Additional Note
```
A. DON'T FORGET to set "PYTHONPATH" as "/opt" in your lmbda variable after adding lmbada layer.
B. Maximum layers per function -> 5
C. Maximum size for all layers -> maximum memory of your lmabda function
D. YOU CAN COMBINE >=2 dependencies into single layer, ex: numpy + pillow + pandas
```

