import boto3
from botocore.exceptions import ClientError
from qoaladep.utils.image_utils import encode_image_to_b64
import cv2 
import base64

s3 = boto3.resource('s3')
img =cv2.imread("your-local-image.jpg")
img_b64 = encode_image_to_b64(img)[0]

obj = s3.Object("your-bucket-name", "file-path-ins3.jpg")
obj.put(Body=base64.b64decode(img_b64))

    
